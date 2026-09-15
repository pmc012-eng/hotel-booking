import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/hotel_model.dart';
import '../../models/room_model.dart';
import '../../providers/booking_provider.dart';

class BookingSummaryScreen extends ConsumerStatefulWidget {
  final HotelModel hotel;
  final RoomModel room;
  final DateTime checkIn;
  final DateTime checkOut;
  final String guestName;
  final String guestPhone;
  final String guestEmail;
  final String? notes;
  final String paymentMethod;
  final int numberOfNights;
  final double totalPrice;
  final Future<String?> Function()? onConfirmBooking;

  const BookingSummaryScreen({
    super.key,
    required this.hotel,
    required this.room,
    required this.checkIn,
    required this.checkOut,
    required this.guestName,
    required this.guestPhone,
    required this.guestEmail,
    this.notes,
    required this.paymentMethod,
    required this.numberOfNights,
    required this.totalPrice,
    this.onConfirmBooking,
  });

  @override
  ConsumerState<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends ConsumerState<BookingSummaryScreen> {
  bool _isLoading = false;
  String? _localErrorMessage;

  Future<void> _handleConfirm() async {
    setState(() {
      _isLoading = true;
      _localErrorMessage = null;
    });

    try {
      if (widget.onConfirmBooking != null) {
        final result = await widget.onConfirmBooking!();
        final bookingCode = result ?? 'HB-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
        if (mounted) {
          context.go(
            '/booking/success',
            extra: {
              'bookingCode': bookingCode,
              'hotelName': widget.hotel.name,
              'totalPrice': widget.totalPrice,
            },
          );
        }
      } else {
        final booking = await ref.read(bookingActionProvider.notifier).createBooking(
          roomId: widget.room.id,
          checkIn: widget.checkIn.toIso8601String().split('T')[0],
          checkOut: widget.checkOut.toIso8601String().split('T')[0],
          guestName: widget.guestName,
          guestPhone: widget.guestPhone,
          guestEmail: widget.guestEmail,
          paymentMethod: widget.paymentMethod,
        );

        if (booking != null && mounted) {
          context.go(
            '/booking/success',
            extra: {
              'bookingCode': booking.bookingCode,
              'hotelName': widget.hotel.name,
              'totalPrice': booking.totalPrice,
            },
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _localErrorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String get _paymentMethodTitle {
    switch (widget.paymentMethod) {
      case 'PAY_AT_HOTEL':
        return 'Thanh toán tại khách sạn';
      case 'BANK_TRANSFER':
        return 'Chuyển khoản Ngân hàng / QR Pay';
      case 'CREDIT_CARD':
        return 'Thẻ tín dụng / Ghi nợ quốc tế';
      default:
        return 'Thanh toán tại khách sạn';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingActionState = ref.watch(bookingActionProvider);
    final errorMessage = _localErrorMessage ?? bookingActionState.errorMessage;
    final isSubmitting = _isLoading || bookingActionState.isLoading;

    final isAuthError = errorMessage != null &&
        (errorMessage.toLowerCase().contains('đăng nhập') || errorMessage.toLowerCase().contains('unauthorized') || errorMessage.toLowerCase().contains('401'));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Xác Nhận Đặt Phòng'),
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
              // Step Indicator
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Bước 2 / 2',
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Kiểm tra & Hoàn tất đơn đặt',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.error.withAlpha(100)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              errorMessage,
                              style: const TextStyle(color: AppColors.error, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      if (isAuthError) ...[
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => context.push('/login'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(120, 36),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Đăng nhập ngay', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                ),
              ],

              // Card Khách sạn & Phòng
              Container(
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
                    Text(
                      widget.hotel.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${widget.hotel.address}, ${widget.hotel.city}',
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24, color: AppColors.divider),
                    _buildRow('Loại phòng', widget.room.roomTypeName ?? 'Tiêu chuẩn'),
                    const SizedBox(height: 8),
                    _buildRow('Số phòng', 'Phòng ${widget.room.roomNumber}'),
                    const SizedBox(height: 8),
                    _buildRow('Sức chứa', 'Tối đa ${widget.room.capacity} khách'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Card Thời gian lưu trú
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 0.8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Thời gian lưu trú', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    _buildRow('Nhận phòng (Check-in)', '${DateFormatter.formatDate(widget.checkIn)} (từ 14:00)'),
                    const SizedBox(height: 8),
                    _buildRow('Trả phòng (Check-out)', '${DateFormatter.formatDate(widget.checkOut)} (trước 12:00)'),
                    const SizedBox(height: 8),
                    _buildRow('Tổng số đêm lưu trú', '${widget.numberOfNights} đêm'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Card Thông tin khách & Thanh toán
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 0.8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Thông tin người nhận phòng', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    _buildRow('Họ và tên', widget.guestName),
                    const SizedBox(height: 8),
                    _buildRow('Số điện thoại', widget.guestPhone),
                    const SizedBox(height: 8),
                    _buildRow('Email nhận vé', widget.guestEmail),
                    const SizedBox(height: 8),
                    _buildRow('Phương thức', _paymentMethodTitle),
                    if (widget.notes != null && widget.notes!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _buildRow('Yêu cầu đặc biệt', widget.notes!),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Chi tiết giá tiền
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 0.8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Chi tiết thanh toán', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    _buildRow(
                      'Giá phòng x ${widget.numberOfNights} đêm',
                      CurrencyFormatter.formatVND(widget.totalPrice),
                    ),
                    const SizedBox(height: 8),
                    _buildRow('Thuế VAT & Phí dịch vụ', 'Đã bao gồm'),
                    const Divider(height: 24, color: AppColors.divider),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tổng thanh toán',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        ),
                        Text(
                          CurrencyFormatter.formatVND(widget.totalPrice),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Guarantee Note
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withAlpha(120),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.verified_user_outlined, color: AppColors.primary, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Cam kết giữ phòng 100% • Miễn phí hủy trước ngày nhận phòng 24h.',
                        style: TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
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
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tổng tiền', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    Text(
                      CurrencyFormatter.formatVND(widget.totalPrice),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              ElevatedButton(
                onPressed: isSubmitting ? null : _handleConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(170, 48),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                      )
                    : const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline, size: 18),
                          SizedBox(width: 6),
                          Text('Xác Nhận Đặt', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
