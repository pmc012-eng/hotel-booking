import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/hotel_model.dart';
import '../../models/room_model.dart';
import '../../providers/admin_provider.dart';
import '../../providers/hotel_provider.dart';
import '../../providers/room_provider.dart';
import '../../widgets/admin/add_room_bottom_sheet.dart';
import '../../widgets/common/empty_state_view.dart';

class AdminRoomManageScreen extends ConsumerStatefulWidget {
  final int? initialHotelId;
  const AdminRoomManageScreen({super.key, this.initialHotelId});

  @override
  ConsumerState<AdminRoomManageScreen> createState() => _AdminRoomManageScreenState();
}

class _AdminRoomManageScreenState extends ConsumerState<AdminRoomManageScreen> {
  int? _selectedHotelId;

  @override
  void initState() {
    super.initState();
    _selectedHotelId = widget.initialHotelId;
  }

  Future<void> _toggleRoomStatus(RoomModel room) async {
    final nextStatus = room.status == 'AVAILABLE' ? 'MAINTENANCE' : 'AVAILABLE';
    final actionText = nextStatus == 'MAINTENANCE' ? 'chuyển sang Bảo trì' : 'kích hoạt Sẵn sàng';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Xác nhận $actionText?'),
          content: Text(
            'Phòng ${room.roomNumber} sẽ được chuyển trạng thái sang "$nextStatus".',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      final success = await ref
          .read(adminActionProvider.notifier)
          .updateRoomStatus(room.id, room.hotelId, nextStatus);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Đã đổi trạng thái phòng thành $nextStatus!' : 'Đổi trạng thái phòng thất bại!',
            ),
          ),
        );
      }
    }
  }

  Future<void> _deleteRoom(RoomModel room) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Xác nhận xóa phòng?'),
          content: Text(
            'Bạn có chắc chắn muốn xóa phòng ${room.roomNumber} (${room.roomTypeName ?? "Phòng tiêu chuẩn"})? Hành động này không thể hoàn tác.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Xóa Phòng'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      final success = await ref
          .read(adminActionProvider.notifier)
          .deleteRoom(room.id, room.hotelId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Đã xóa phòng ${room.roomNumber} thành công!' : 'Xóa phòng thất bại!',
            ),
          ),
        );
      }
    }
  }

  Future<void> _openAddRoomModal(List<HotelModel> hotels) async {
    if (hotels.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chưa có khách sạn nào trên hệ thống để thêm phòng!')),
      );
      return;
    }
    final created = await AddRoomBottomSheet.show(
      context,
      hotels: hotels,
      initialHotelId: _selectedHotelId,
    );
    if (created == true && _selectedHotelId != null) {
      ref.invalidate(hotelRoomsProvider(_selectedHotelId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final hotelsAsync = ref.watch(allHotelsProvider);
    final hotels = hotelsAsync.asData?.value ?? [];

    if (_selectedHotelId == null && hotels.isNotEmpty) {
      _selectedHotelId = hotels.first.id;
    }

    final roomsAsync = _selectedHotelId != null
        ? ref.watch(hotelRoomsProvider(_selectedHotelId!))
        : null;
    final rooms = roomsAsync?.asData?.value ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Quản Lý Phòng Khách Sạn'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 24),
            tooltip: 'Thêm phòng mới',
            onPressed: () => _openAddRoomModal(hotels),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddRoomModal(hotels),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Thêm Phòng Mới', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Dropdown chọn khách sạn
          if (hotels.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.surface,
              child: DropdownButtonFormField<int>(
                initialValue: _selectedHotelId,
                decoration: const InputDecoration(
                  labelText: 'Chọn khách sạn quản lý phòng',
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                isExpanded: true,
                items: hotels.map((HotelModel h) {
                  return DropdownMenuItem<int>(
                    value: h.id,
                    child: Text(
                      '${h.name} (${h.city})',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedHotelId = val;
                  });
                },
              ),
            ),

          const Divider(height: 1, color: AppColors.divider),

          // Header số lượng phòng
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng cộng: ${rooms.length} phòng',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textSecondary),
                ),
                Text(
                  'Sẵn sàng: ${rooms.where((r) => r.status == "AVAILABLE").length}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.success),
                ),
              ],
            ),
          ),

          // Danh sách phòng
          Expanded(
            child: _selectedHotelId == null
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(hotelRoomsProvider(_selectedHotelId!));
                    },
                    child: rooms.isEmpty
                        ? const Center(
                            child: EmptyStateView(
                              icon: Icons.meeting_room_outlined,
                              title: 'Khách sạn chưa có phòng',
                              message: 'Vui lòng kiểm tra lại cấu hình phòng của khách sạn.',
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: rooms.length,
                            itemBuilder: (context, index) {
                              final room = rooms[index];
                              final isAvailable = room.status == 'AVAILABLE';

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isAvailable ? AppColors.border : AppColors.warning.withAlpha(120),
                                    width: 0.8,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: isAvailable ? AppColors.primaryContainer : AppColors.warningContainer,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Text(
                                          room.roomNumber,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: isAvailable ? AppColors.primary : AppColors.warning,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            room.roomTypeName ?? 'Phòng tiêu chuẩn',
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Sức chứa: ${room.capacity} người • ${CurrencyFormatter.formatVND(room.price)}/đêm',
                                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: isAvailable
                                                  ? AppColors.success.withAlpha(25)
                                                  : AppColors.warning.withAlpha(25),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              isAvailable ? 'SẴN SÀNG ĐÓN KHÁCH' : 'ĐANG BẢO TRÌ',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: isAvailable ? AppColors.success : AppColors.warning,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Switch(
                                          value: isAvailable,
                                          activeThumbColor: AppColors.primary,
                                          onChanged: (val) => _toggleRoomStatus(room),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          tooltip: 'Xóa phòng',
                                          onPressed: () => _deleteRoom(room),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}
