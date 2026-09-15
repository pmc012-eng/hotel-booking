import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String? initialName;
  final String? initialPhone;
  final Future<bool> Function(String name, String phone)? onSave;

  const EditProfileScreen({
    super.key,
    this.initialName,
    this.initialPhone,
    this.onSave,
  });

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _nameController = TextEditingController(text: widget.initialName ?? user?.name ?? 'Nguyễn Văn An');
    _phoneController = TextEditingController(text: widget.initialPhone ?? user?.phone ?? '0912345678');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (widget.onSave != null) {
        await widget.onSave!(_nameController.text.trim(), _phoneController.text.trim());
      } else {
        await ref.read(authProvider.notifier).updateProfile(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật hồ sơ thành công!')),
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
        title: const Text('Chỉnh Sửa Hồ Sơ'),
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
              children: [
                Center(
                  child: Stack(
                    children: [
                      const CircleAvatar(
                        radius: 46,
                        backgroundColor: AppColors.primaryContainer,
                        child: Icon(Icons.person, size: 50, color: AppColors.primary),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.primary,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                CustomTextField(
                  label: 'Họ và tên',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Vui lòng nhập họ tên!' : null,
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: 'Số điện thoại',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Vui lòng nhập số điện thoại!' : null,
                ),
                const SizedBox(height: 36),

                CustomButton(
                  text: 'Lưu Thay Đổi',
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
