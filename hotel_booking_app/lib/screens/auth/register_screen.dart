import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  final Future<bool> Function(String name, String email, String password, String phone)? onRegister;

  const RegisterScreen({super.key, this.onRegister});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _localErrorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _localErrorMessage = null;
    });

    try {
      if (widget.onRegister != null) {
        final success = await widget.onRegister!(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _phoneController.text.trim(),
        );
        if (success && mounted) {
          context.go('/main');
        }
      } else {
        final success = await ref.read(authProvider.notifier).register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          phone: _phoneController.text.trim(),
        );
        if (success && mounted) {
          context.go('/main');
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

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final errorMessage = _localErrorMessage ?? authState.errorMessage;
    final isSubmitting = _isLoading || authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tạo Tài Khoản Mới',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Điền thông tin để bắt đầu đặt phòng khách sạn',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),

                if (errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.errorContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            errorMessage,
                            style: const TextStyle(color: AppColors.error, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Full Name
                CustomTextField(
                  label: 'Họ và tên',
                  hint: 'Nguyễn Văn An',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Vui lòng nhập họ tên!';
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Email
                CustomTextField(
                  label: 'Địa chỉ Email',
                  hint: 'nguyenvana@gmail.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Vui lòng nhập email!';
                    if (!val.contains('@')) return 'Email không hợp lệ!';
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Phone
                CustomTextField(
                  label: 'Số điện thoại',
                  hint: '0912345678',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Vui lòng nhập số điện thoại!';
                    if (val.trim().length < 9) return 'Số điện thoại không hợp lệ!';
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Password
                CustomTextField(
                  label: 'Mật khẩu',
                  hint: 'Tối thiểu 6 ký tự',
                  controller: _passwordController,
                  isPassword: true,
                  prefixIcon: Icons.lock_outline,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Vui lòng nhập mật khẩu!';
                    if (val.length < 6) return 'Mật khẩu tối thiểu 6 ký tự!';
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // Submit button
                CustomButton(
                  text: 'Đăng Ký Tài Khoản',
                  isLoading: isSubmitting,
                  onPressed: _handleSubmit,
                ),
                const SizedBox(height: 20),

                // Back to Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Đã có tài khoản? ',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: const Text(
                        'Đăng nhập ngay',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
