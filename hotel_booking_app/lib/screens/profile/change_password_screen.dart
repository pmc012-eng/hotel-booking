import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  final Future<bool> Function(String oldPassword, String newPassword)? onChangePassword;

  const ChangePasswordScreen({super.key, this.onChangePassword});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu xác nhận không khớp!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.onChangePassword != null) {
        await widget.onChangePassword!(
          _oldPasswordController.text,
          _newPasswordController.text,
        );
      } else {
        await ref.read(authProvider.notifier).changePassword(
          oldPassword: _oldPasswordController.text,
          newPassword: _newPasswordController.text,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đổi mật khẩu thành công!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Đổi Mật Khẩu'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bảo Mật Tài Khoản',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Mật khẩu mới phải chứa tối thiểu 6 ký tự để đảm bảo an toàn.',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 28),

                CustomTextField(
                  label: 'Mật khẩu hiện tại',
                  hint: '••••••••',
                  controller: _oldPasswordController,
                  isPassword: true,
                  prefixIcon: Icons.lock_outline,
                  validator: (v) => v == null || v.isEmpty ? 'Vui lòng nhập mật khẩu hiện tại!' : null,
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: 'Mật khẩu mới',
                  hint: 'Tối thiểu 6 ký tự',
                  controller: _newPasswordController,
                  isPassword: true,
                  prefixIcon: Icons.lock_reset_outlined,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Vui lòng nhập mật khẩu mới!';
                    if (v.length < 6) return 'Mật khẩu mới phải có ít nhất 6 ký tự!';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: 'Xác nhận mật khẩu mới',
                  hint: 'Nhập lại mật khẩu mới',
                  controller: _confirmPasswordController,
                  isPassword: true,
                  prefixIcon: Icons.lock_clock_outlined,
                  validator: (v) => v == null || v.isEmpty ? 'Vui lòng xác nhận mật khẩu!' : null,
                ),
                const SizedBox(height: 36),

                CustomButton(
                  text: 'Cập Nhật Mật Khẩu',
                  isLoading: _isLoading,
                  onPressed: _handleSave,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
