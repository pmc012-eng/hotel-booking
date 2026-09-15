import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/booking_model.dart';
import '../../providers/admin_provider.dart';
import '../../widgets/booking/status_badge.dart';
import '../../widgets/common/empty_state_view.dart';

class AdminBookingManageScreen extends ConsumerStatefulWidget {
  const AdminBookingManageScreen({super.key});

  @override
  ConsumerState<AdminBookingManageScreen> createState() => _AdminBookingManageScreenState();
}

class _AdminBookingManageScreenState extends ConsumerState<AdminBookingManageScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _updateStatus(int bookingId, String newStatus, String actionName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Xác nhận $actionName?'),
          content: Text('Bạn có chắc chắn muốn chuyển trạng thái đơn đặt phòng này sang "$newStatus"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: newStatus == 'CANCELLED' ? AppColors.error : AppColors.primary,
              ),
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      final success = await ref.read(adminActionProvider.notifier).updateBookingStatus(bookingId, newStatus);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Đã cập nhật trạng thái đơn thành công!' : 'Cập nhật trạng thái thất bại!',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(adminBookingsProvider(null));
    final bookings = bookingsAsync.asData?.value ?? [];

    List<BookingModel> filterList(String? status) {
      if (status == null || status == 'ALL') return bookings;
      return bookings.where((b) => b.status == status).toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Quản Lý Đơn Đặt Phòng'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Tất cả'),
            Tab(text: 'Chờ check-in'),
            Tab(text: 'Hoàn thành'),
            Tab(text: 'Đã hủy'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(adminBookingsProvider);
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildList(filterList('ALL')),
            _buildList(filterList('CONFIRMED')),
            _buildList(filterList('COMPLETED')),
            _buildList(filterList('CANCELLED')),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<BookingModel> list) {
    if (list.isEmpty) {
      return const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: 450,
          child: EmptyStateView(
            icon: Icons.calendar_today_outlined,
            title: 'Không có đơn đặt phòng nào',
            message: 'Các đơn đặt phòng khớp với trạng thái đã chọn sẽ hiển thị ở đây.',
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
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 0.8),
            boxShadow: const [
              BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: Offset(0, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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

              // Thông tin khách & Khách sạn
              Text(
                booking.hotelName ?? 'Khách sạn',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 4),
              Text(
                'Khách hàng: ${booking.guestName} (${booking.guestPhone})',
                style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
              ),
              Text(
                'Phòng: ${booking.roomTypeName ?? "Tiêu chuẩn"} • Phòng ${booking.roomNumber ?? ""}',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 6),
              Text(
                'Lưu trú: ${DateFormatter.formatDate(DateFormatter.parse(booking.checkIn))} → ${DateFormatter.formatDate(DateFormatter.parse(booking.checkOut))}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 10),

              // Tổng tiền & nút duyệt
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    CurrencyFormatter.formatVND(booking.totalPrice),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                  ),
                  if (booking.isConfirmed)
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () => _updateStatus(booking.id, 'CANCELLED', 'Hủy đơn phòng'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(color: AppColors.error),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            visualDensity: VisualDensity.compact,
                          ),
                          child: const Text('Hủy đơn', style: TextStyle(fontSize: 12)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _updateStatus(booking.id, 'COMPLETED', 'Duyệt hoàn thành'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            visualDensity: VisualDensity.compact,
                          ),
                          child: const Text('Hoàn tất', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
