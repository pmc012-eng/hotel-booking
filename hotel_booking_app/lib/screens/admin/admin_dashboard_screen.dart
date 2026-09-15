import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/admin_stats_model.dart';
import '../../providers/admin_provider.dart';
import '../../widgets/booking/status_badge.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminStatsProvider);
    final stats = statsAsync.asData?.value ?? _sampleStats;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bảng Điều Khiển Quản Trị'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(adminStatsProvider),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(adminStatsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E3A8A), AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tổng Doanh Thu',
                          style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(40),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.trending_up, color: Colors.greenAccent, size: 16),
                              SizedBox(width: 4),
                              Text('+18.5%', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      CurrencyFormatter.formatVND(stats.revenue),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Doanh thu từ các đơn phòng đã xác nhận & hoàn thành',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // KPI Grid Cards
              Row(
                children: [
                  Expanded(
                    child: _buildKpiCard(
                      icon: Icons.confirmation_number_outlined,
                      iconColor: AppColors.primary,
                      title: 'Tổng Đơn',
                      value: '${stats.totalBookings}',
                      subtitle: '${stats.completedBookings} hoàn thành',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildKpiCard(
                      icon: Icons.hotel_rounded,
                      iconColor: AppColors.warning,
                      title: 'Khách Sạn',
                      value: '${stats.totalHotels}',
                      subtitle: 'Đang hoạt động',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildKpiCard(
                      icon: Icons.meeting_room_outlined,
                      iconColor: AppColors.success,
                      title: 'Phòng Trống',
                      value: '${stats.availableRooms}/${stats.totalRooms}',
                      subtitle: '${stats.maintenanceRooms} phòng bảo trì',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildKpiCard(
                      icon: Icons.group_outlined,
                      iconColor: const Color(0xFF8B5CF6),
                      title: 'Người Dùng',
                      value: '${stats.totalUsers}',
                      subtitle: 'Tài khoản khách',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Menu quản lý chức năng
              const Text(
                'Quản Lý Chức Năng',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildManagementTile(
                      icon: Icons.book_online_rounded,
                      iconColor: AppColors.primary,
                      title: 'Quản lý Đơn Đặt Phòng',
                      subtitle: 'Xem danh sách, duyệt hoàn thành hoặc hủy đơn',
                      badgeCount: stats.confirmedBookings,
                      onTap: () => context.push('/admin/bookings'),
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _buildManagementTile(
                      icon: Icons.domain_rounded,
                      iconColor: AppColors.warning,
                      title: 'Quản lý Khách Sạn',
                      subtitle: 'Thêm mới, sửa thông tin, xóa khách sạn',
                      onTap: () => context.push('/admin/hotels'),
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _buildManagementTile(
                      icon: Icons.door_front_door_rounded,
                      iconColor: AppColors.success,
                      title: 'Quản lý Phòng Khách Sạn',
                      subtitle: 'Chuyển đổi trạng thái phòng sẵn sàng / bảo trì',
                      onTap: () => context.push('/admin/rooms'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Đơn đặt phòng mới nhất
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Đơn Đặt Phòng Mới Nhất',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  TextButton(
                    onPressed: () => context.push('/admin/bookings'),
                    child: const Text('Xem tất cả', style: TextStyle(color: AppColors.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (stats.recentBookings.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Center(
                    child: Text('Chưa có đơn đặt phòng nào gần đây', style: TextStyle(color: AppColors.textSecondary)),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: stats.recentBookings.length,
                  itemBuilder: (context, index) {
                    final item = stats.recentBookings[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border, width: 0.8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.receipt_long, color: AppColors.primary, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.bookingCode,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                                    ),
                                    StatusBadge(status: item.status),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${item.guestName} • ${item.hotelName}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Phòng ${item.roomNumber} • ${CurrencyFormatter.formatVND(item.totalPrice)}',
                                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    int? badgeCount,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withAlpha(25),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Row(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          if (badgeCount != null && badgeCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$badgeCount',
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
      onTap: onTap,
    );
  }

  static final AdminStatsModel _sampleStats = AdminStatsModel(
    revenue: 13300000,
    totalBookings: 5,
    confirmedBookings: 2,
    completedBookings: 1,
    cancelledBookings: 2,
    totalHotels: 10,
    totalRooms: 47,
    availableRooms: 47,
    maintenanceRooms: 0,
    totalUsers: 4,
    recentBookings: [
      AdminRecentBookingModel(
        id: 1,
        bookingCode: 'HB-2026-0001',
        guestName: 'Nguyễn Văn An',
        checkIn: '2026-09-20',
        checkOut: '2026-09-23',
        totalPrice: 4050000,
        status: 'CONFIRMED',
        hotelName: 'The Oriental Jade Hotel',
        roomNumber: '201',
      ),
    ],
  );
}
