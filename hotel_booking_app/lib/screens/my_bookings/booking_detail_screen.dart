import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/booking_model.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/booking/status_badge.dart';
import '../../widgets/common/custom_button.dart';

class BookingDetailScreen extends ConsumerStatefulWidget {
  final int bookingId;
  final BookingModel? initialBooking;
  final Future<bool> Function(int bookingId)? onCancelBooking;

  const BookingDetailScreen({
    super.key,
    required this.bookingId,
    this.initialBooking,
    this.onCancelBooking,
  });

  @override
  ConsumerState<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends ConsumerState<BookingDetailScreen> {
  BookingModel? _localBooking;
  bool _isCancelling = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialBooking != null) {
      _localBooking = widget.initialBooking;
    }
  }

  Future<void> _showCancelDialog(BookingModel currentBooking) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận hủy phòng?'),
          content: const Text(
            'Bạn có chắc chắn muốn hủy đơn đặt phòng này không? Sau khi hủy, phòng sẽ được giải phóng cho người khác.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Giữ lại đơn'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                minimumSize: const Size(100, 38),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Hủy phòng'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      setState(() {
        _isCancelling = true;
      });

      try {
        bool success = false;
        if (widget.onCancelBooking != null) {
          success = await widget.onCancelBooking!(currentBooking.id);
        } else {
          success = await ref.read(bookingActionProvider.notifier).cancelBooking(currentBooking.id);
        }

        if (success && mounted) {
          setState(() {
            _localBooking = BookingModel(
              id: currentBooking.id,
              bookingCode: currentBooking.bookingCode,
              userId: currentBooking.userId,
              roomId: currentBooking.roomId,
              checkIn: currentBooking.checkIn,
              checkOut: currentBooking.checkOut,
              guestName: currentBooking.guestName,
              guestPhone: currentBooking.guestPhone,
              guestEmail: currentBooking.guestEmail,
              totalPrice: currentBooking.totalPrice,
              status: 'CANCELLED',
              hotelName: currentBooking.hotelName,
              hotelAddress: currentBooking.hotelAddress,
              hotelCity: currentBooking.hotelCity,
              hotelImage: currentBooking.hotelImage,
              roomTypeName: currentBooking.roomTypeName,
              roomNumber: currentBooking.roomNumber,
              numberOfNights: currentBooking.numberOfNights,
            );
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã hủy đơn đặt phòng thành công!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isCancelling = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingDetailAsync = ref.watch(bookingDetailProvider(widget.bookingId));
    final booking = _localBooking ?? bookingDetailAsync.asData?.value ?? _fallbackBooking;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Chi Tiết Đơn Đặt Phòng'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Mã đặt phòng', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              booking.bookingCode,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: booking.bookingCode));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Đã sao chép mã đặt phòng!'),
                                    duration: Duration(seconds: 1),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              child: const Icon(Icons.copy_rounded, size: 16, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    StatusBadge(status: booking.status),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Hotel Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: booking.fullHotelImageUrl,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: AppColors.border),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.border,
                          child: const Icon(Icons.broken_image, color: AppColors.textMuted),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      booking.hotelName ?? 'Khách sạn',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${booking.hotelAddress ?? ""}, ${_bookingCity(booking)}',
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Room & Dates Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Chi tiết phòng & Ngày ở', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    _buildRow('Loại phòng', booking.roomTypeName ?? 'Tiêu chuẩn'),
                    const SizedBox(height: 8),
                    _buildRow('Số phòng', 'Phòng ${booking.roomNumber ?? ""}'),
                    const SizedBox(height: 8),
                    _buildRow('Nhận phòng', DateFormatter.formatDate(DateFormatter.parse(booking.checkIn))),
                    const SizedBox(height: 8),
                    _buildRow('Trả phòng', DateFormatter.formatDate(DateFormatter.parse(booking.checkOut))),
                    const SizedBox(height: 8),
                    _buildRow('Số đêm lưu trú', '${booking.numberOfNights} đêm'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Guest info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Thông tin khách', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    _buildRow('Người đặt', booking.guestName),
                    const SizedBox(height: 8),
                    _buildRow('Điện thoại', booking.guestPhone),
                    const SizedBox(height: 8),
                    _buildRow('Email', booking.guestEmail),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Price Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tổng thanh toán', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    Text(
                      CurrencyFormatter.formatVND(booking.totalPrice),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Cancel Button (Chỉ hiển thị nếu trạng thái là CONFIRMED)
              if (booking.isConfirmed) ...[
                CustomButton(
                  text: 'Hủy Đơn Đặt Phòng Này',
                  isOutlined: true,
                  backgroundColor: AppColors.error,
                  textColor: AppColors.error,
                  isLoading: _isCancelling,
                  onPressed: () => _showCancelDialog(booking),
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _bookingCity(BookingModel booking) => booking.hotelCity ?? "";

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ],
    );
  }

  BookingModel get _fallbackBooking => BookingModel(
        id: widget.bookingId,
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
        hotelAddress: '94 Hàng Trống, Quận Hoàn Kiếm',
        hotelCity: 'Hà Nội',
        hotelImage: '/uploads/hotel_1.jpg',
        roomTypeName: 'Deluxe City View',
        roomNumber: '201',
        numberOfNights: 3,
      );
}
