import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    String label;

    switch (status.toUpperCase()) {
      case 'CONFIRMED':
        bg = AppColors.successContainer;
        text = AppColors.success;
        label = 'Đã xác nhận';
        break;
      case 'PENDING':
        bg = AppColors.warningContainer;
        text = AppColors.warning;
        label = 'Chờ xử lý';
        break;
      case 'COMPLETED':
        bg = AppColors.primaryContainer;
        text = AppColors.primary;
        label = 'Đã hoàn thành';
        break;
      case 'CANCELLED':
        bg = AppColors.errorContainer;
        text = AppColors.error;
        label = 'Đã hủy';
        break;
      default:
        bg = AppColors.border;
        text = AppColors.textSecondary;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
