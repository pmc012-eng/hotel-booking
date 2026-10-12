import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';

class ImageUploadPickerBox extends StatelessWidget {
  final String label;
  final File? selectedFile;
  final String? imageUrl;
  final bool isLoading;
  final Function(ImageSource source) onPickImage;
  final VoidCallback? onRemove;
  final double height;

  const ImageUploadPickerBox({
    super.key,
    required this.label,
    this.selectedFile,
    this.imageUrl,
    this.isLoading = false,
    required this.onPickImage,
    this.onRemove,
    this.height = 140,
  });

  void _showSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tải ảnh $label',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.photo_camera_rounded, color: AppColors.primary),
                ),
                title: const Text('Chụp ảnh mới (Camera)', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Mở máy ảnh điện thoại để chụp ảnh'),
                onTap: () {
                  Navigator.pop(ctx);
                  onPickImage(ImageSource.camera);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.photo_library_rounded, color: AppColors.primary),
                ),
                title: const Text('Chọn từ Thư viện ảnh (Gallery)', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Chọn ảnh có sẵn từ bộ nhớ thiết bị'),
                onTap: () {
                  Navigator.pop(ctx);
                  onPickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = selectedFile != null || (imageUrl != null && imageUrl!.trim().isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (hasImage && onRemove != null && !isLoading)
              GestureDetector(
                onTap: onRemove,
                child: const Text(
                  'Xóa ảnh',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: isLoading ? null : () => _showSourceSheet(context),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasImage ? AppColors.primary.withAlpha(80) : AppColors.border,
                width: hasImage ? 1.5 : 1.2,
                style: BorderStyle.solid,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (selectedFile != null)
                    Image.file(
                      selectedFile!,
                      fit: BoxFit.cover,
                    )
                  else if (imageUrl != null && imageUrl!.trim().isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (ctx, url) => Container(
                        color: AppColors.border,
                        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                      errorWidget: (ctx, url, err) => Container(
                        color: AppColors.border,
                        child: const Icon(Icons.broken_image, color: AppColors.textMuted),
                      ),
                    )
                  else
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(20),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_photo_alternate_rounded,
                            size: 28,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tải ảnh lên từ điện thoại',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Chụp từ Camera hoặc chọn từ Thư viện',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),

                  // Overlay loading khi đang tải ảnh
                  if (isLoading)
                    Container(
                      color: Colors.black54,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Đang tải ảnh lên...',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                  // Nút camera ở góc khi đã có ảnh
                  if (hasImage && !isLoading)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(160),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.camera_alt, size: 14, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'Đổi ảnh',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
