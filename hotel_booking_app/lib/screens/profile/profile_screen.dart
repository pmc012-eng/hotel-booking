import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final UserModel? user;
  final VoidCallback? onLogout;

  const ProfileScreen({super.key, this.user, this.onLogout});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất khỏi tài khoản này không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text('Đăng xuất'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      if (widget.onLogout != null) {
        widget.onLogout!();
      } else {
        await ref.read(authProvider.notifier).logout();
      }

      if (mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final user = widget.user ?? currentUser ?? _sampleUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tài Khoản Cá Nhân'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              // User Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(0, 3)),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.primaryContainer,
                      backgroundImage: user.avatar != null ? NetworkImage(user.avatar!) : null,
                      child: user.avatar == null ? const Icon(Icons.person, size: 36, color: AppColors.primary) : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  user.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: user.isAdmin ? AppColors.warningContainer : AppColors.primaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  user.role,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: user.isAdmin ? AppColors.warning : AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                          if (user.phone != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              user.phone!,
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Settings Group
              _buildMenuSection(
                'Cài đặt tài khoản',
                [
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    title: 'Chỉnh sửa thông tin',
                    subtitle: 'Cập nhật họ tên, số điện thoại',
                    onTap: () => context.push('/profile/edit'),
                  ),
                  _buildMenuItem(
                    icon: Icons.lock_outline,
                    title: 'Đổi mật khẩu',
                    subtitle: 'Bảo mật tài khoản',
                    onTap: () => context.push('/profile/change-password'),
                  ),
                  _buildMenuItem(
                    icon: Icons.history_rounded,
                    title: 'Lịch sử đặt phòng',
                    subtitle: 'Xem toàn bộ các chuyến đi',
                    onTap: () => context.push('/my-bookings'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Admin Section (Nếu là Admin)
              if (user.isAdmin) ...[
                _buildMenuSection(
                  'Quản trị viên (Admin Area)',
                  [
                    _buildMenuItem(
                      icon: Icons.dashboard_outlined,
                      title: 'Bảng điều khiển Admin',
                      subtitle: 'Thống kê doanh thu, khách sạn, phòng',
                      iconColor: AppColors.warning,
                      onTap: () => context.push('/admin'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],

              // Logout Button
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.errorContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                    ),
                    title: const Text(
                      'Đăng xuất',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.error, fontSize: 15),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.error),
                    onTap: _handleLogout,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            child: Column(children: items),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.primary).withAlpha(30),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor ?? AppColors.primary, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
      onTap: onTap,
    );
  }

  static final UserModel _sampleUser = UserModel(
    id: 1,
    name: 'Nguyễn Văn An',
    email: 'user1@gmail.com',
    phone: '0912345678',
    role: 'ADMIN',
    avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
  );
}
