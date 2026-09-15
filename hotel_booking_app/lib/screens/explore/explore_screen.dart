import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../models/hotel_model.dart';
import '../../providers/hotel_provider.dart';
import '../../widgets/hotel/hotel_card.dart';
import '../../widgets/common/empty_state_view.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  final List<HotelModel>? initialHotels;
  final Function(String search, String city, int? star)? onFilterChanged;

  const ExploreScreen({
    super.key,
    this.initialHotels,
    this.onFilterChanged,
  });

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final _searchController = TextEditingController();
  String _selectedCity = 'Tất cả';
  int? _selectedStar;
  List<HotelModel>? _customHotels;

  @override
  void initState() {
    super.initState();
    if (widget.initialHotels != null) {
      _customHotels = widget.initialHotels;
    }
  }

  @override
  void didUpdateWidget(ExploreScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialHotels != null) {
      _customHotels = widget.initialHotels!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilter(String search, String city, int? star) {
    setState(() {
      _selectedCity = city;
      _selectedStar = star;
    });

    // Cập nhật StateProvider của Riverpod để tự gọi API
    ref.read(hotelFilterProvider.notifier).state = HotelFilterState(
      search: search.trim(),
      city: city,
      star: star,
    );

    if (widget.onFilterChanged != null) {
      widget.onFilterChanged!(search, city, star);
    }
  }

  void _openFilterBottomSheet() {
    String tempCity = _selectedCity;
    int? tempStar = _selectedStar;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Bộ lọc tìm kiếm',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            tempCity = 'Tất cả';
                            tempStar = null;
                          });
                        },
                        child: const Text('Đặt lại'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // City Filter
                  const Text('Thành phố', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Tất cả', 'Hà Nội', 'Đà Nẵng', 'Hồ Chí Minh', 'Nha Trang', 'Đà Lạt', 'Phú Quốc']
                        .map((city) {
                      final isSelected = tempCity == city;
                      return ChoiceChip(
                        label: Text(city),
                        selected: isSelected,
                        onSelected: (selected) {
                          setModalState(() {
                            tempCity = city;
                          });
                        },
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Star Rating
                  const Text('Hạng khách sạn (Số sao)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 10),
                  Row(
                    children: [null, 3, 4, 5].map((star) {
                      final isSelected = tempStar == star;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (star != null) ...[
                                const Icon(Icons.star_rounded, size: 16, color: AppColors.star),
                                const SizedBox(width: 4),
                              ],
                              Text(star == null ? 'Tất cả' : '$star sao'),
                            ],
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setModalState(() {
                              tempStar = star;
                            });
                          },
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontSize: 13,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  // Apply button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _applyFilter(_searchController.text, tempCity, tempStar);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Áp dụng bộ lọc', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<HotelModel> list;

    if (_customHotels != null) {
      final query = _searchController.text.toLowerCase().trim();
      list = _customHotels!.where((h) {
        final matchQuery = query.isEmpty ||
            h.name.toLowerCase().contains(query) ||
            h.address.toLowerCase().contains(query) ||
            h.city.toLowerCase().contains(query);

        final matchCity = _selectedCity == 'Tất cả' || h.city == _selectedCity;
        final matchStar = _selectedStar == null || h.star == _selectedStar;

        return matchQuery && matchCity && matchStar;
      }).toList();
    } else {
      final searchResultAsync = ref.watch(searchHotelsProvider);
      list = searchResultAsync.asData?.value ?? _sampleExploreHotels;
      // Client-side quick filter nếu đang hiển thị cache fallback
      if (searchResultAsync.asData?.value == null) {
        final query = _searchController.text.toLowerCase().trim();
        list = list.where((h) {
          final matchQuery = query.isEmpty ||
              h.name.toLowerCase().contains(query) ||
              h.address.toLowerCase().contains(query) ||
              h.city.toLowerCase().contains(query);

          final matchCity = _selectedCity == 'Tất cả' || h.city == _selectedCity;
          final matchStar = _selectedStar == null || h.star == _selectedStar;

          return matchQuery && matchCity && matchStar;
        }).toList();
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Khám Phá Khách Sạn'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(searchHotelsProvider);
          },
          child: Column(
            children: [
              // Search & Filter header bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onSubmitted: (val) => _applyFilter(val, _selectedCity, _selectedStar),
                        onChanged: (val) {
                          setState(() {});
                          // Gửi filter lên Riverpod
                          ref.read(hotelFilterProvider.notifier).state =
                              ref.read(hotelFilterProvider).copyWith(search: val.trim());
                        },
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm tên, địa chỉ...',
                          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    _applyFilter('', _selectedCity, _selectedStar);
                                  },
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: (_selectedCity != 'Tất cả' || _selectedStar != null)
                            ? AppColors.primary
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: (_selectedCity != 'Tất cả' || _selectedStar != null)
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.tune_rounded,
                          color: (_selectedCity != 'Tất cả' || _selectedStar != null)
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                        onPressed: _openFilterBottomSheet,
                      ),
                    ),
                  ],
                ),
              ),

              // Active filters tags
              if (_selectedCity != 'Tất cả' || _selectedStar != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Text('Đang lọc: ', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      if (_selectedCity != 'Tất cả')
                        Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: Chip(
                            label: Text(_selectedCity, style: const TextStyle(fontSize: 11)),
                            onDeleted: () => _applyFilter(_searchController.text, 'Tất cả', _selectedStar),
                            deleteIconColor: AppColors.textSecondary,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      if (_selectedStar != null)
                        Chip(
                          label: Text('$_selectedStar sao', style: const TextStyle(fontSize: 11)),
                          onDeleted: () => _applyFilter(_searchController.text, _selectedCity, null),
                          deleteIconColor: AppColors.textSecondary,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // Results count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Text(
                      'Tìm thấy ${list.length} khách sạn',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Hotel list or empty
              Expanded(
                child: list.isEmpty
                    ? EmptyStateView(
                        icon: Icons.search_off_rounded,
                        title: 'Không tìm thấy khách sạn',
                        message: 'Không có khách sạn nào khớp với tiêu chí tìm kiếm hoặc bộ lọc của bạn.',
                        buttonText: 'Xóa bộ lọc',
                        onButtonPressed: () {
                          _searchController.clear();
                          _applyFilter('', 'Tất cả', null);
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final hotel = list[index];
                          return HotelCard(
                            hotel: hotel,
                            onTap: () => context.push('/hotel/${hotel.id}', extra: hotel),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static final List<HotelModel> _sampleExploreHotels = [
    HotelModel(
      id: 1,
      name: 'The Oriental Jade Hotel',
      address: '94 Hàng Trống, Quận Hoàn Kiếm',
      city: 'Hà Nội',
      star: 5,
      rating: 4.9,
      minPrice: 1350000,
      primaryImage: '/uploads/hotel_1.jpg',
      reviewCount: 24,
    ),
    HotelModel(
      id: 2,
      name: 'Sofitel Legend Metropole',
      address: '15 Ngô Quyền, Quận Hoàn Kiếm',
      city: 'Hà Nội',
      star: 5,
      rating: 4.9,
      minPrice: 3200000,
      primaryImage: '/uploads/hotel_2.jpg',
      reviewCount: 42,
    ),
    HotelModel(
      id: 3,
      name: 'TMS Hotel Da Nang Beach',
      address: '292 Võ Nguyên Giáp, Quận Sơn Trà',
      city: 'Đà Nẵng',
      star: 5,
      rating: 4.8,
      minPrice: 1850000,
      primaryImage: '/uploads/hotel_3.jpg',
      reviewCount: 38,
    ),
    HotelModel(
      id: 4,
      name: 'Sala Danang Beach Hotel',
      address: '36 Lâm Hoành, Quận Sơn Trà',
      city: 'Đà Nẵng',
      star: 4,
      rating: 4.7,
      minPrice: 950000,
      primaryImage: '/uploads/hotel_4.jpg',
      reviewCount: 19,
    ),
    HotelModel(
      id: 5,
      name: 'The Reverie Saigon',
      address: '22-36 Nguyễn Huệ, Quận 1',
      city: 'Hồ Chí Minh',
      star: 5,
      rating: 4.9,
      minPrice: 3800000,
      primaryImage: '/uploads/hotel_5.jpg',
      reviewCount: 52,
    ),
    HotelModel(
      id: 6,
      name: 'Hotel Nikko Saigon',
      address: '235 Nguyễn Văn Cừ, Quận 1',
      city: 'Hồ Chí Minh',
      star: 5,
      rating: 4.8,
      minPrice: 1950000,
      primaryImage: '/uploads/hotel_6.jpg',
      reviewCount: 35,
    ),
    HotelModel(
      id: 7,
      name: 'Vinpearl Resort & Spa Nha Trang Bay',
      address: 'Đảo Hòn Tre, Vĩnh Nguyên',
      city: 'Nha Trang',
      star: 5,
      rating: 4.8,
      minPrice: 1750000,
      primaryImage: '/uploads/hotel_7.jpg',
      reviewCount: 47,
    ),
    HotelModel(
      id: 8,
      name: 'InterContinental Nha Trang',
      address: '32-34 Trần Phú, Lộc Thọ',
      city: 'Nha Trang',
      star: 5,
      rating: 4.9,
      minPrice: 2150000,
      primaryImage: '/uploads/hotel_8.jpg',
      reviewCount: 60,
    ),
    HotelModel(
      id: 9,
      name: 'Dalat Edensee Lake Resort',
      address: 'Hồ Tuyền Lâm, Phường 4',
      city: 'Đà Lạt',
      star: 5,
      rating: 4.8,
      minPrice: 1650000,
      primaryImage: '/uploads/hotel_9.jpg',
      reviewCount: 29,
    ),
    HotelModel(
      id: 10,
      name: 'Premier Village Phu Quoc Resort',
      address: 'Mũi Ông Đội, An Thới',
      city: 'Phú Quốc',
      star: 5,
      rating: 4.9,
      minPrice: 4900000,
      primaryImage: '/uploads/hotel_10.jpg',
      reviewCount: 65,
    ),
  ];
}
