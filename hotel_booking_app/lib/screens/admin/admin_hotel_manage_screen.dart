import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/hotel_model.dart';
import '../../providers/admin_provider.dart';
import '../../providers/hotel_provider.dart';
import '../../widgets/admin/add_room_bottom_sheet.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/image_upload_picker_box.dart';

class AdminHotelManageScreen extends ConsumerStatefulWidget {
  const AdminHotelManageScreen({super.key});

  @override
  ConsumerState<AdminHotelManageScreen> createState() => _AdminHotelManageScreenState();
}

class _AdminHotelManageScreenState extends ConsumerState<AdminHotelManageScreen> {
  void _openAddHotelModal() {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final cityController = TextEditingController(text: 'Hà Nội');
    final starController = TextEditingController(text: '5');
    final minPriceController = TextEditingController(text: '1500000');
    final descController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    File? pickedHotelImage;
    String? uploadedImageUrl;
    bool isUploadingImage = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            Future<void> handlePickImage(ImageSource source) async {
              try {
                final picker = ImagePicker();
                final picked = await picker.pickImage(
                  source: source,
                  maxWidth: 1600,
                  maxHeight: 1200,
                  imageQuality: 85,
                );
                if (picked == null) return;
                final file = File(picked.path);
                setModalState(() {
                  pickedHotelImage = file;
                  isUploadingImage = true;
                });
                final url = await ref.read(adminActionProvider.notifier).uploadImage(file, type: 'hotel');
                setModalState(() {
                  isUploadingImage = false;
                  if (url != null) uploadedImageUrl = url;
                });
              } catch (e) {
                setModalState(() => isUploadingImage = false);
              }
            }

            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Thêm Khách Sạn Mới',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(ctx),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Khung tải ảnh khách sạn từ điện thoại
                        ImageUploadPickerBox(
                          label: 'Ảnh đại diện khách sạn (Từ điện thoại)',
                          selectedFile: pickedHotelImage,
                          imageUrl: uploadedImageUrl,
                          isLoading: isUploadingImage,
                          onPickImage: handlePickImage,
                          onRemove: () {
                            setModalState(() {
                              pickedHotelImage = null;
                              uploadedImageUrl = null;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          label: 'Tên khách sạn',
                          controller: nameController,
                          validator: (v) => v == null || v.trim().isEmpty ? 'Nhập tên khách sạn!' : null,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          label: 'Địa chỉ',
                          controller: addressController,
                          validator: (v) => v == null || v.trim().isEmpty ? 'Nhập địa chỉ!' : null,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: 'Thành phố',
                                controller: cityController,
                                validator: (v) => v == null || v.trim().isEmpty ? 'Nhập thành phố!' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomTextField(
                                label: 'Số sao (1 - 5)',
                                controller: starController,
                                keyboardType: TextInputType.number,
                                validator: (v) {
                                  final star = int.tryParse(v ?? '');
                                  if (star == null || star < 1 || star > 5) return '1 đến 5 sao';
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          label: 'Giá tối thiểu / đêm (VND)',
                          controller: minPriceController,
                          keyboardType: TextInputType.number,
                          validator: (v) => double.tryParse(v ?? '') == null ? 'Nhập giá hợp lệ' : null,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          label: 'Mô tả ngắn',
                          controller: descController,
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          text: 'Tạo Khách Sạn',
                          isLoading: isUploadingImage,
                          onPressed: () async {
                            if (!formKey.currentState!.validate()) return;
                            Navigator.pop(ctx);

                            final hotelData = <String, dynamic>{
                              'name': nameController.text.trim(),
                              'address': addressController.text.trim(),
                              'city': cityController.text.trim(),
                              'star': int.parse(starController.text.trim()),
                              'minPrice': double.parse(minPriceController.text.trim()),
                              'description': descController.text.trim(),
                            };

                            if (uploadedImageUrl != null) {
                              hotelData['images'] = [uploadedImageUrl];
                              hotelData['primaryImage'] = uploadedImageUrl;
                            }

                            final hotel = await ref.read(adminActionProvider.notifier).createHotel(hotelData);

                            if (mounted && hotel != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Đã thêm khách sạn "${hotel.name}" thành công!')),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _deleteHotel(HotelModel hotel) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Xác nhận xóa khách sạn?'),
          content: Text(
            'Bạn có chắc chắn muốn xóa "${hotel.name}"? Mọi dữ liệu phòng và đơn liên quan sẽ bị ảnh hưởng.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text('Xóa vĩnh viễn'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      final success = await ref.read(adminActionProvider.notifier).deleteHotel(hotel.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Đã xóa khách sạn thành công!' : 'Xóa khách sạn thất bại!',
            ),
          ),
        );
      }
    }
  }

  Future<void> _openAddRoomModal(HotelModel hotel, List<HotelModel> allHotels) async {
    final created = await AddRoomBottomSheet.show(
      context,
      hotels: allHotels,
      initialHotelId: hotel.id,
    );
    if (created == true) {
      ref.invalidate(allHotelsProvider);
      ref.invalidate(featuredHotelsProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hotelsAsync = ref.watch(allHotelsProvider);
    final hotels = hotelsAsync.asData?.value ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Quản Lý Khách Sạn'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/admin');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddHotelModal,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Thêm Khách Sạn', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(allHotelsProvider);
        },
        child: hotels.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: hotels.length,
                itemBuilder: (context, index) {
                  final hotel = hotels[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border, width: 0.8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                hotel.fullPrimaryImageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, e, s) => Container(
                                  width: 80,
                                  height: 80,
                                  color: AppColors.border,
                                  child: const Icon(Icons.hotel, color: AppColors.textMuted),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hotel.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${hotel.address}, ${hotel.city}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.star_rounded, size: 16, color: AppColors.star),
                                      const SizedBox(width: 2),
                                      Text('${hotel.star} sao', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                      const Spacer(),
                                      Text(
                                        CurrencyFormatter.formatVND(hotel.minPrice),
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                              tooltip: 'Xóa khách sạn',
                              onPressed: () => _deleteHotel(hotel),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(height: 1, color: AppColors.border),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              icon: const Icon(Icons.meeting_room_outlined, size: 16),
                              label: const Text('Quản lý phòng', style: TextStyle(fontSize: 12)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                minimumSize: const Size(0, 32),
                              ),
                              onPressed: () => context.push('/admin/rooms', extra: hotel.id),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.add, size: 16, color: Colors.white),
                              label: const Text('Thêm phòng', style: TextStyle(fontSize: 12, color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                minimumSize: const Size(0, 32),
                              ),
                              onPressed: () => _openAddRoomModal(hotel, hotels),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
