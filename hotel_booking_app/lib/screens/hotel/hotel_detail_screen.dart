import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/hotel_model.dart';
import '../../models/room_model.dart';
import '../../providers/hotel_provider.dart';
import '../../providers/room_provider.dart';
import '../../widgets/hotel/room_card.dart';

class HotelDetailScreen extends ConsumerStatefulWidget {
  final int hotelId;
  final HotelModel? hotel;
  final List<RoomModel>? rooms;

  const HotelDetailScreen({
    super.key,
    required this.hotelId,
    this.hotel,
    this.rooms,
  });

  @override
  ConsumerState<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends ConsumerState<HotelDetailScreen> {
  int _currentImageIndex = 0;
  bool _isFavorite = false;
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  final GlobalKey _roomsKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _scrollToRooms() {
    if (_roomsKey.currentContext != null) {
      Scrollable.ensureVisible(
        _roomsKey.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hotelDetailAsync = ref.watch(hotelDetailProvider(widget.hotelId));
    final roomsAsync = ref.watch(hotelRoomsProvider(widget.hotelId));

    final hotel = hotelDetailAsync.asData?.value ?? widget.hotel ?? _sampleHotelDetail;
    final rooms = roomsAsync.asData?.value ?? widget.rooms ?? _sampleRooms;
    final images = hotel.fullImageUrls;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Main Scrollable Content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Image Header (Bounded & Safe)
                SizedBox(
                  height: 290,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: images.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final url = images[index].trim();
                          return CachedNetworkImage(
                            imageUrl: url.isNotEmpty ? url : hotel.fullPrimaryImageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            placeholder: (context, url) => Container(
                              color: AppColors.border,
                              child: const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppColors.border,
                              child: const Icon(Icons.broken_image, size: 48, color: AppColors.textMuted),
                            ),
                          );
                        },
                      ),

                      // Top dark gradient overlay for button contrast
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 90,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withAlpha(120),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Bottom gradient overlay for dots & badge
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 60,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withAlpha(120),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Carousel dots indicator
                      if (images.length > 1)
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(images.length, (index) {
                              final isSelected = _currentImageIndex == index;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                width: isSelected ? 20 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary : Colors.white70,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              );
                            }),
                          ),
                        ),

                      // Image counter badge (e.g. 1/3)
                      if (images.length > 1)
                        Positioned(
                          bottom: 14,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_currentImageIndex + 1}/${images.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Hotel Details Container
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stars and Rating summary
                      Row(
                        children: [
                          Row(
                            children: List.generate(
                              hotel.star.clamp(1, 5),
                              (index) => const Icon(Icons.star_rounded, size: 18, color: AppColors.star),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${hotel.star.clamp(1, 5)} sao',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Hotel Name
                      Text(
                        hotel.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Address
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on, size: 16, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${hotel.address}, ${hotel.city}',
                              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Rating Card
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                hotel.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Rất tốt & Tuyệt vời',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'Dựa trên ${hotel.reviewCount > 0 ? hotel.reviewCount : 24} đánh giá xác thực',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Description
                      const Text(
                        'Giới thiệu khách sạn',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        hotel.description ?? 'Khách sạn cao cấp với tiện nghi hiện đại và dịch vụ hàng đầu.',
                        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
                      ),
                      const SizedBox(height: 24),

                      // Amenities
                      const Text(
                        'Tiện nghi phổ biến',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 12),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final itemWidth = (constraints.maxWidth - 24) / 3;
                          return Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              _buildAmenityCard(Icons.wifi, 'Wifi miễn phí', itemWidth),
                              _buildAmenityCard(Icons.pool, 'Hồ bơi vô cực', itemWidth),
                              _buildAmenityCard(Icons.restaurant, 'Nhà hàng buffet', itemWidth),
                              _buildAmenityCard(Icons.local_parking, 'Bãi đỗ xe', itemWidth),
                              _buildAmenityCard(Icons.fitness_center, 'Phòng Gym', itemWidth),
                              _buildAmenityCard(Icons.spa, 'Dịch vụ Spa', itemWidth),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 32),

                      // Room Selection Section Header
                      Container(
                        key: _roomsKey,
                        child: const Text(
                          'Danh sách phòng còn trống',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Chọn loại phòng phù hợp với chuyến đi của bạn:',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),

                      // Rooms List
                      if (roomsAsync.isLoading && widget.rooms == null)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          alignment: Alignment.center,
                          child: const Column(
                            children: [
                              CircularProgressIndicator(color: AppColors.primary),
                              SizedBox(height: 12),
                              Text('Đang tải danh sách phòng...', style: TextStyle(color: AppColors.textSecondary)),
                            ],
                          ),
                        )
                      else if (rooms.isEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          alignment: Alignment.center,
                          child: const Column(
                            children: [
                              Icon(Icons.meeting_room_outlined, size: 44, color: AppColors.textMuted),
                              SizedBox(height: 8),
                              Text(
                                'Hiện chưa có phòng trống tại khách sạn này',
                                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: rooms.length,
                          itemBuilder: (context, index) {
                            final room = rooms[index];
                            return RoomCard(
                              room: room,
                              onSelect: () {
                                context.push(
                                  '/booking/create',
                                  extra: {
                                    'hotel': hotel,
                                    'room': room,
                                  },
                                );
                              },
                            );
                          },
                        ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating Top Navigation Bar (Always visible & clickable)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary),
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.of(context).pop();
                          } else {
                            context.go('/main');
                          }
                        },
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: IconButton(
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                          color: _isFavorite ? AppColors.error : AppColors.textPrimary,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _isFavorite ? 'Đã lưu vào danh sách yêu thích!' : 'Đã bỏ khỏi danh sách yêu thích',
                              ),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(0, -3)),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Giá chỉ từ', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    Text(
                      CurrencyFormatter.formatVND(hotel.minPrice),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _scrollToRooms,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(150, 48),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Chọn phòng ngay', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmenityCard(IconData icon, String label, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: AppColors.primary),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  static final HotelModel _sampleHotelDetail = HotelModel(
    id: 1,
    name: 'The Oriental Jade Hotel',
    address: '94 Hàng Trống, Quận Hoàn Kiếm',
    city: 'Hà Nội',
    star: 5,
    rating: 4.9,
    minPrice: 1350000,
    primaryImage: '/uploads/hotel_1.jpg',
    images: ['/uploads/hotel_1.jpg', '/uploads/hotel_2.jpg'],
    description:
        'Khách sạn boutique sang trọng nằm ngay trung tâm phố cổ Hà Nội, cách Hồ Hoàn Kiếm chỉ vài bước chân. Tầm nhìn panorama ngắm trọn thủ đô thơ mộng, hồ bơi vô cực trên tầng thượng và dịch vụ chuẩn quốc tế.',
    reviewCount: 24,
  );

  static final List<RoomModel> _sampleRooms = [
    RoomModel(
      id: 1,
      hotelId: 1,
      roomTypeId: 1,
      roomNumber: '201',
      roomTypeName: 'Deluxe City View',
      capacity: 2,
      price: 1350000,
      imageUrl: '/uploads/room_1.jpg',
      amenities: ['Wifi tốc độ cao', 'Điều hòa 2 chiều', 'TV 55 inch', 'Bồn tắm sang trọng', 'Bữa sáng buffet'],
      status: 'AVAILABLE',
      hotelName: 'The Oriental Jade Hotel',
    ),
    RoomModel(
      id: 2,
      hotelId: 1,
      roomTypeId: 2,
      roomNumber: '501',
      roomTypeName: 'Grand Suite Lake View',
      capacity: 2,
      price: 2600000,
      imageUrl: '/uploads/room_2.jpg',
      amenities: ['View Hồ Gươm', 'Bồn tắm sục Jacuzzi', 'Máy pha cà phê Nespresso', 'Rượu vang chào mừng'],
      status: 'AVAILABLE',
      hotelName: 'The Oriental Jade Hotel',
    ),
  ];
}
