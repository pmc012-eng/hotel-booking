import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../core/network/api_client.dart';
import '../../providers/auth_provider.dart';
import '../../services/storage_service.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final Future<bool> Function(String email, String password)? onLogin;

  const LoginScreen({super.key, this.onLogin});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _localErrorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillSampleUser() {
    setState(() {
      _emailController.text = 'user1@gmail.com';
      _passwordController.text = 'user123';
      _localErrorMessage = null;
    });
  }

  void _fillSampleAdmin() {
    setState(() {
      _emailController.text = 'admin@hotelbooking.com';
      _passwordController.text = 'admin123';
      _localErrorMessage = null;
    });
  }

  Future<void> _showServerConfigDialog(BuildContext context) async {
    final hostController = TextEditingController(text: AppConstants.serverHost);
    String? pingResult;
    bool isPinging = false;
    bool isSuccess = false;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          Future<void> checkConnection() async {
            final host = hostController.text.trim();
            if (host.isEmpty) return;

            setDialogState(() {
              isPinging = true;
              pingResult = null;
            });

            try {
              final dio = Dio(
                BaseOptions(
                  connectTimeout: const Duration(seconds: 4),
                  receiveTimeout: const Duration(seconds: 4),
                ),
              );
              final res = await dio.get('http://$host:5000/api/health');
              setDialogState(() {
                isPinging = false;
                isSuccess = true;
                final serverStatus = res.data is Map ? (res.data['data']?['server'] ?? 'Online') : 'Online';
                pingResult = '✅ Kết nối thành công! Server: $serverStatus';
              });
            } catch (err) {
              setDialogState(() {
                isPinging = false;
                isSuccess = false;
                pingResult = '❌ Không thể kết nối tới http://$host:5000: $err';
              });
            }
          }

          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.settings_ethernet, color: AppColors.primary),
                SizedBox(width: 8),
                Text('Cấu Hình IP Máy Chủ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chọn hoặc nhập IP máy tính đang chạy Backend Node.js (cổng 5000):',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: hostController,
                    decoration: InputDecoration(
                      labelText: 'IP hoặc Hostname',
                      hintText: '192.168.88.176',
                      prefixIcon: const Icon(Icons.lan_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Gợi ý nhanh:',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      ActionChip(
                        label: const Text('192.168.88.176 (Wi-Fi)', style: TextStyle(fontSize: 11)),
                        onPressed: () {
                          hostController.text = '192.168.88.176';
                          checkConnection();
                        },
                      ),
                      ActionChip(
                        label: const Text('localhost (Cáp USB)', style: TextStyle(fontSize: 11)),
                        onPressed: () {
                          hostController.text = 'localhost';
                          checkConnection();
                        },
                      ),
                      ActionChip(
                        label: const Text('10.0.2.2 (Máy ảo)', style: TextStyle(fontSize: 11)),
                        onPressed: () {
                          hostController.text = '10.0.2.2';
                          checkConnection();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: isPinging ? null : checkConnection,
                      icon: isPinging
                          ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.wifi_find_rounded, size: 16),
                      label: Text(isPinging ? 'Đang kiểm tra...' : 'Kiểm tra kết nối (Ping Test)'),
                    ),
                  ),
                  if (pingResult != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSuccess ? Colors.green.shade50 : AppColors.errorContainer,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: isSuccess ? Colors.green : AppColors.error),
                      ),
                      child: Text(
                        pingResult!,
                        style: TextStyle(
                          fontSize: 11,
                          color: isSuccess ? Colors.green.shade800 : AppColors.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final newHost = hostController.text.trim();
                  if (newHost.isNotEmpty) {
                    await StorageService.saveServerHost(newHost);
                    apiClient.updateBaseUrl(newHost);
                    if (!ctx.mounted) return;
                    Navigator.of(ctx).pop();
                    if (!mounted) return;
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã cập nhật IP máy chủ: $newHost:5000')),
                    );
                  }
                },
                child: const Text('Lưu & Áp Dụng'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _localErrorMessage = null;
    });

    try {
      if (widget.onLogin != null) {
        final success = await widget.onLogin!(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        if (success && mounted) {
          context.go('/main');
        }
      } else {
        final success = await ref.read(authProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.hotel_rounded,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'Chào Mừng Trở Lại!',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Đăng nhập để tiếp tục đặt phòng và quản lý chuyến đi',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 16),

                // Chip hiển thị & đổi IP Backend máy chủ
                Center(
                  child: ActionChip(
                    avatar: const Icon(Icons.dns_outlined, size: 16, color: AppColors.primary),
                    label: Text(
                      'Máy chủ: ${AppConstants.serverHost}:5000',
                      style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                    onPressed: () => _showServerConfigDialog(context),
                    backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.3),
                    side: const BorderSide(color: AppColors.primary, width: 0.8),
                    tooltip: 'Bấm để đổi hoặc kiểm tra kết nối IP máy chủ',
                  ),
                ),
                const SizedBox(height: 20),

                // Điền tài khoản mẫu demo nhanh
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Điền tài khoản mẫu demo đồ án:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _fillSampleUser,
                              icon: const Icon(Icons.person_outline, size: 16),
                              label: const Text('User demo', style: TextStyle(fontSize: 12)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                side: const BorderSide(color: AppColors.primary),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _fillSampleAdmin,
                              icon: const Icon(Icons.admin_panel_settings_outlined, size: 16),
                              label: const Text('Admin demo', style: TextStyle(fontSize: 12)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                side: const BorderSide(color: AppColors.warning),
                                foregroundColor: AppColors.warning,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                if (errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.errorContainer,
                      borderRadius: BorderRadius.circular(10),
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
                                style: const TextStyle(color: AppColors.error, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _showServerConfigDialog(context),
                          child: const Row(
                            children: [
                              Icon(Icons.settings_ethernet, size: 15, color: AppColors.primary),
                              SizedBox(width: 4),
                              Text(
                                'Kiểm tra hoặc đổi IP máy chủ Backend tại đây',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Email
                CustomTextField(
                  label: 'Email',
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
                const SizedBox(height: 20),

                // Password
                CustomTextField(
                  label: 'Mật khẩu',
                  hint: '••••••••',
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
                  text: 'Đăng Nhập',
                  isLoading: isSubmitting,
                  onPressed: _handleSubmit,
                ),
                const SizedBox(height: 24),

                // Link to Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Chưa có tài khoản? ',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/register'),
                      child: const Text(
                        'Đăng ký ngay',
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
