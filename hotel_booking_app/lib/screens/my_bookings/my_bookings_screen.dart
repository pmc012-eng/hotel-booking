import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/booking_model.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/booking/status_badge.dart';
import '../../widgets/common/empty_state_view.dart';

class MyBookingsScreen extends ConsumerStatefulWidget {
  final List<BookingModel>? initialBookings;

  const MyBookingsScreen({super.key, this.initialBookings});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(myBookingsProvider(null));
    final bookings = widget.initialBookings ?? bookingsAsync.asData?.value ?? _sampleBookings;

    List<BookingModel> getByStatus(String status) {
      return bookings.where((b) => b.status == status).toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Đơn Đặt Phòng Của Tôi'),
        automaticallyImplyLeading: false,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.of(context).pop();
                  } else {
                    context.go('/main');
                  }
                },
              )
            : null,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: 'Sắp tới'),
            Tab(text: 'Hoàn thành'),
            Tab(text: 'Đã hủy'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(myBookingsProvider);
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildBookingList(getByStatus('CONFIRMED'), 'Không có đơn đặt sắp tới', 'Hãy khám phá và đặt phòng cho kỳ nghỉ sắp tới của bạn!'),
            _buildBookingList(getByStatus('COMPLETED'), 'Chưa có chuyến đi hoàn thành', 'Các chuyến đi bạn đã hoàn tất sẽ được lưu trữ tại đây.'),
            _buildBookingList(getByStatus('CANCELLED'), 'Không có đơn bị hủy', 'Danh sách các đơn đặt phòng đã hủy sẽ hiển thị ở đây.'),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingList(List<BookingModel> list, String emptyTitle, String emptyMsg) {
    if (list.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: 450,
          child: EmptyStateView(
            icon: Icons.calendar_today_outlined,
            title: emptyTitle,
            message: emptyMsg,
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final booking = list[index];
        return _buildBookingCard(booking);
      },
    );
  }

  Widget _buildBookingCard(BookingModel booking) {
    return GestureDetector(
      onTap: () => context.push('/booking/detail/${booking.id}', extra: booking),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 0.8),
          boxShadow: const [
            BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 3)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Mã đơn + Huy hiệu trạng thái
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    booking.bookingCode,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
                  ),
                  StatusBadge(status: booking.status),
                ],
              ),
              const Divider(height: 20, color: AppColors.divider),

              // Info Row: Ảnh + Tên KS
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: booking.fullHotelImageUrl,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: AppColors.border),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.border,
                        child: const Icon(Icons.broken_image, size: 24, color: AppColors.textMuted),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.hotelName ?? 'Khách sạn',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${booking.roomTypeName ?? "Phòng tiêu chuẩn"} • Phòng ${booking.roomNumber ?? ""}',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textSecondary),
                            const SizedBox(width: 2),
                            Text(
                              booking.hotelCity ?? '',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Date Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${DateFormatter.formatDate(DateFormatter.parse(booking.checkIn))} - ${DateFormatter.formatDate(DateFormatter.parse(booking.checkOut))}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                    Text(
                      '${booking.numberOfNights} đêm',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Total Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tổng thanh toán', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  Text(
                    CurrencyFormatter.formatVND(booking.totalPrice),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static final List<BookingModel> _sampleBookings = [
    BookingModel(
      id: 1,
      bookingCode: 'HB-2026-0001',
      userId: 1,
      roomId: 1,
      checkIn: '2026-09-20',
      checkOut: '2026-09-23',
      guestName: 'Nguyễn Văn An',
      guestPhone: '0912345678',
      guestEmail: 'user1@gmail.com',
      totalPrice: 4050000,
      status: 'CONFIRMED',
      hotelName: 'The Oriental Jade Hotel',
      hotelCity: 'Hà Nội',
      hotelImage: '/uploads/hotel_1.jpg',
      roomTypeName: 'Deluxe City View',
      roomNumber: '201',
      numberOfNights: 3,
    ),
    BookingModel(
      id: 2,
      bookingCode: 'HB-2026-0002',
      userId: 1,
      roomId: 2,
      checkIn: '2026-08-10',
      checkOut: '2026-08-12',
      guestName: 'Nguyễn Văn An',
      guestPhone: '0912345678',
      guestEmail: 'user1@gmail.com',
      totalPrice: 5200000,
      status: 'COMPLETED',
      hotelName: 'TMS Hotel Da Nang Beach',
      hotelCity: 'Đà Nẵng',
      hotelImage: '/uploads/hotel_3.jpg',
      roomTypeName: 'Premier Ocean Front',
      roomNumber: '1201',
      numberOfNights: 2,
    ),
  ];
}
