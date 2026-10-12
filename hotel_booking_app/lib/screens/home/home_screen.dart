import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../models/hotel_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/hotel_provider.dart';
import '../../widgets/hotel/hotel_card.dart';
import '../../widgets/hotel/hotel_horizontal_card.dart';
import '../../widgets/hotel/hotel_category_chip.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final VoidCallback? onExploreMore;
  final List<HotelModel>? featuredHotels;
  final List<HotelModel>? recommendedHotels;
  final String? userName;
  final String? userAvatar;

  const HomeScreen({
    super.key,
    this.onExploreMore,
    this.featuredHotels,
    this.recommendedHotels,
    this.userName,
    this.userAvatar,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectedCity = 'Tất cả';

  final List<String> _cities = [
    'Tất cả',
    'Hà Nội',
    'Đà Nẵng',
    'Hồ Chí Minh',
    'Nha Trang',
    'Đà Lạt',
    'Phú Quốc',
  ];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final featuredAsync = ref.watch(featuredHotelsProvider);
    final allHotelsAsync = ref.watch(allHotelsProvider);

    final featured = widget.featuredHotels ?? featuredAsync.asData?.value ?? _sampleFeaturedHotels;
    final recommended = widget.recommendedHotels ?? allHotelsAsync.asData?.value ?? _sampleRecommendedHotels;

    final displayName = widget.userName ?? user?.name ?? 'Khách du lịch';
    final avatarUrl = user?.fullAvatarUrl ?? widget.userAvatar;

    final filteredHotels = _selectedCity == 'Tất cả'
        ? recommended
        : recommended.where((h) => h.city == _selectedCity).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(featuredHotelsProvider);
            ref.invalidate(allHotelsProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Lời chào & Avatar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.primaryContainer,
                        backgroundImage: avatarUrl != null
                            ? CachedNetworkImageProvider(avatarUrl)
                            : null,
                        child: avatarUrl == null
                            ? const Icon(Icons.person, color: AppColors.primary)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Xin chào, 👋',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              displayName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Search Bar bấm vào để mở Explore
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      if (widget.onExploreMore != null) {
                        widget.onExploreMore!();
                      } else {
                        context.push('/explore');
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
                          SizedBox(width: 12),
                          Text(
                            'Tìm khách sạn, điểm đến...',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.tune_rounded, color: AppColors.textSecondary, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Categories Chips (Thành phố du lịch)
                SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _cities.length,
                    itemBuilder: (context, index) {
                      final city = _cities[index];
                      return HotelCategoryChip(
                        label: city,
                        isSelected: _selectedCity == city,
                        onTap: () {
                          setState(() {
                            _selectedCity = city;
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 28),

                // Section: Khách sạn nổi bật (Horizontal Carousel)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Khách sạn nổi bật',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (widget.onExploreMore != null) {
                            widget.onExploreMore!();
                          } else {
                            context.push('/explore');
                          }
                        },
                        child: const Text(
                          'Xem tất cả',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                SizedBox(
                  height: 255,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: featured.length,
                    itemBuilder: (context, index) {
                      final hotel = featured[index];
                      return HotelHorizontalCard(
                        hotel: hotel,
                        onTap: () => context.push('/hotel/${hotel.id}', extra: hotel),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 28),

                // Section: Đề xuất cho bạn (Vertical List)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedCity == 'Tất cả' ? 'Đề xuất cho bạn' : 'Khách sạn tại $_selectedCity',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${filteredHotels.length} kết quả',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredHotels.length,
                    itemBuilder: (context, index) {
                      final hotel = filteredHotels[index];
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
      ),
    );
  }

  static final List<HotelModel> _sampleFeaturedHotels = [
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
  ];

  static final List<HotelModel> _sampleRecommendedHotels = [
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
  ];
}
