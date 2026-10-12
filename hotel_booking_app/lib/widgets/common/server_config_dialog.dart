import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../../services/storage_service.dart';

class ServerConfigDialog {
  static Future<void> show(BuildContext context, {VoidCallback? onUpdated}) async {
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
                pingResult = '❌ Không thể kết nối tới http://$host:5000\nChi tiết: $err\n\n💡 Mẹo khắc phục:\n1. Nếu cắm cáp USB: Chạy lệnh `adb reverse tcp:5000 tcp:5000` trên máy tính rồi chọn "localhost".\n2. Nếu dùng Wi-Fi: Đảm bảo điện thoại và laptop cùng kết nối 1 mạng Wi-Fi (hoặc phát Wi-Fi từ điện thoại cho laptop).';
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
                      hintText: '192.168.13.62',
                      prefixIcon: const Icon(Icons.lan_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Gợi ý cấu hình nhanh:',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.wifi_tethering, size: 14),
                        label: const Text('192.168.13.62 (Hotspot điện thoại)', style: TextStyle(fontSize: 11)),
                        onPressed: () {
                          hostController.text = '192.168.13.62';
                          checkConnection();
                        },
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.home, size: 14),
                        label: const Text('192.168.88.176 (Wi-Fi nhà)', style: TextStyle(fontSize: 11)),
                        onPressed: () {
                          hostController.text = '192.168.88.176';
                          checkConnection();
                        },
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.usb, size: 14),
                        label: const Text('localhost (Cáp USB - Rất ổn định)', style: TextStyle(fontSize: 11)),
                        onPressed: () {
                          hostController.text = 'localhost';
                          checkConnection();
                        },
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.phone_android, size: 14),
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
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSuccess ? Colors.green.shade50 : AppColors.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isSuccess ? Colors.green : AppColors.error),
                      ),
                      child: Text(
                        pingResult!,
                        style: TextStyle(
                          fontSize: 11,
                          color: isSuccess ? Colors.green.shade800 : AppColors.error,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
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
                    onUpdated?.call();
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
}
