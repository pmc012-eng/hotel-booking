import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../widgets/common/custom_button.dart';

class BookingSuccessScreen extends StatelessWidget {
  final String bookingCode;
  final String hotelName;
  final double totalPrice;

  const BookingSuccessScreen({
    super.key,
    required this.bookingCode,
    required this.hotelName,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppColors.successContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 64,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Đặt Phòng Thành Công!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Cảm ơn bạn đã lựa chọn dịch vụ của chúng tôi.\nThông tin xác nhận đã được gửi đến email của bạn.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 32),

              // Booking Code Box
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    const Text(
                      'MÃ ĐẶT PHÒNG',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary, letterSpacing: 1),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          bookingCode,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, size: 20, color: AppColors.primary),
                          tooltip: 'Sao chép mã',
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: bookingCode));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Đã sao chép mã đặt phòng vào bộ nhớ tạm!'),
                                duration: Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const Divider(height: 24, color: AppColors.divider),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Khách sạn:', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        Expanded(
                          child: Text(
                            hotelName,
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tổng tiền:', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        Text(
                          CurrencyFormatter.formatVND(totalPrice),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),

              CustomButton(
                text: 'Xem Đơn Đặt Của Tôi',
                onPressed: () => context.go('/main?tab=2'),
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Về Trang Chủ',
                isOutlined: true,
                onPressed: () => context.go('/main'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
