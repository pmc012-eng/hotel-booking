import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../models/hotel_model.dart';
import '../../providers/admin_provider.dart';
import '../common/custom_button.dart';
import '../common/custom_text_field.dart';
import '../common/image_upload_picker_box.dart';

class AddRoomBottomSheet extends ConsumerStatefulWidget {
  final List<HotelModel> hotels;
  final int? initialHotelId;

  const AddRoomBottomSheet({
    super.key,
    required this.hotels,
    this.initialHotelId,
  });

  static Future<bool?> show(
    BuildContext context, {
    required List<HotelModel> hotels,
    int? initialHotelId,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddRoomBottomSheet(
        hotels: hotels,
        initialHotelId: initialHotelId,
      ),
    );
  }

  @override
  ConsumerState<AddRoomBottomSheet> createState() => _AddRoomBottomSheetState();
}

class _AddRoomBottomSheetState extends ConsumerState<AddRoomBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late int? _hotelId;

  final _roomNumberCtrl = TextEditingController();
  final _roomTypeCtrl = TextEditingController(text: 'Phòng Tiêu Chuẩn');
  final _priceCtrl = TextEditingController(text: '1200000');
  int _capacity = 2;
  String _status = 'AVAILABLE';
  final List<String> _selectedAmenities = [
    'Wifi miễn phí',
    'Điều hòa 2 chiều',
    'TV thông minh',
  ];

  File? _pickedRoomImage;
  String? _uploadedImageUrl;
  bool _isUploadingImage = false;

  final List<String> _roomTypeSuggestions = [
    'Phòng Tiêu Chuẩn (Standard)',
    'Deluxe City View',
    'Grand Suite Lake View',
    'Family VIP Room',
  ];

  final List<String> _allAmenities = [
    'Wifi miễn phí',
    'Điều hòa 2 chiều',
    'TV thông minh',
    'Bồn tắm nằm',
    'View đẹp',
    'Ban công',
    'Bữa sáng buffet',
    'Minibar',
  ];

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _hotelId = widget.initialHotelId ?? (widget.hotels.isNotEmpty ? widget.hotels.first.id : null);
  }

  @override
  void dispose() {
    _roomNumberCtrl.dispose();
    _roomTypeCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _handlePickRoomImage(ImageSource source) async {
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
      setState(() {
        _pickedRoomImage = file;
        _isUploadingImage = true;
      });

      final uploadedUrl = await ref.read(adminActionProvider.notifier).uploadImage(file, type: 'room');
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
          if (uploadedUrl != null) {
            _uploadedImageUrl = uploadedUrl;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isUploadingImage = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải ảnh: ${e.toString()}'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_hotelId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn khách sạn để thêm phòng!')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final roomData = {
      'hotelId': _hotelId,
      'roomNumber': _roomNumberCtrl.text.trim(),
      'roomTypeName': _roomTypeCtrl.text.trim(),
      'price': double.tryParse(_priceCtrl.text.replaceAll('.', '').trim()) ?? 1200000,
      'capacity': _capacity,
      'status': _status,
      'amenities': _selectedAmenities,
      if (_uploadedImageUrl != null) 'imageUrl': _uploadedImageUrl,
    };

    final result = await ref.read(adminActionProvider.notifier).createRoom(roomData);

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (result != null) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.success,
            content: Text('Đã thêm phòng "${result.roomNumber}" thành công!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.error,
            content: Text('Thêm phòng thất bại! Vui lòng kiểm tra lại.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: bottomInset > 0 ? bottomInset + 16 : 24,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thanh kéo drag handle
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tiêu đề
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.add_home_work_rounded, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thêm Phòng Khách Sạn',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Cấu hình thông tin số phòng, loại phòng và đơn giá',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // 1. Chọn khách sạn
              const Text(
                'Khách sạn áp dụng *',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<int>(
                initialValue: _hotelId,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                isExpanded: true,
                items: widget.hotels.map((h) {
                  return DropdownMenuItem<int>(
                    value: h.id,
                    child: Text(
                      '${h.name} (${h.city})',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() => _hotelId = val);
                },
                validator: (v) => v == null ? 'Vui lòng chọn khách sạn' : null,
              ),
              const SizedBox(height: 16),

              // 2. Số phòng và Sức chứa
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: CustomTextField(
                      label: 'Số phòng *',
                      hint: 'VD: 101, 202, VIP-1',
                      controller: _roomNumberCtrl,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Nhập số phòng!' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sức chứa *',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<int>(
                          initialValue: _capacity,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          items: [1, 2, 3, 4, 5, 6].map((c) {
                            return DropdownMenuItem(value: c, child: Text('$c người'));
                          }).toList(),
                          onChanged: (v) {
                            if (v != null) setState(() => _capacity = v);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 3. Tên / Loại phòng
              CustomTextField(
                label: 'Tên loại phòng *',
                hint: 'VD: Deluxe City View',
                controller: _roomTypeCtrl,
                validator: (v) => v == null || v.trim().isEmpty ? 'Nhập tên loại phòng!' : null,
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _roomTypeSuggestions.map((sug) {
                  return InkWell(
                    onTap: () {
                      setState(() => _roomTypeCtrl.text = sug);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        border: Border.all(color: AppColors.border, width: 0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        sug,
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // 4. Giá phòng / đêm
              CustomTextField(
                label: 'Giá phòng / đêm (VND) *',
                hint: 'VD: 1500000',
                controller: _priceCtrl,
                keyboardType: TextInputType.number,
                validator: (v) {
                  final val = double.tryParse((v ?? '').replaceAll('.', '').trim());
                  if (val == null || val <= 0) return 'Nhập giá phòng hợp lệ (> 0đ)';
                  return null;
                },
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                children: [
                  {'label': '800k', 'val': '800000'},
                  {'label': '1.2tr', 'val': '1200000'},
                  {'label': '1.5tr', 'val': '1500000'},
                  {'label': '2.0tr', 'val': '2000000'},
                  {'label': '3.0tr', 'val': '3000000'},
                ].map((item) {
                  return ActionChip(
                    label: Text(item['label']!, style: const TextStyle(fontSize: 11)),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      setState(() => _priceCtrl.text = item['val']!);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // 4b. Ảnh phòng chụp từ điện thoại
              ImageUploadPickerBox(
                label: 'Ảnh chụp phòng (Tải từ điện thoại)',
                selectedFile: _pickedRoomImage,
                imageUrl: _uploadedImageUrl,
                isLoading: _isUploadingImage,
                onPickImage: _handlePickRoomImage,
                onRemove: () {
                  setState(() {
                    _pickedRoomImage = null;
                    _uploadedImageUrl = null;
                  });
                },
              ),
              const SizedBox(height: 16),

              // 5. Trạng thái phòng
              const Text(
                'Trạng thái ban đầu',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('Sẵn sàng đón khách'),
                    selected: _status == 'AVAILABLE',
                    selectedColor: AppColors.successContainer,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _status == 'AVAILABLE' ? AppColors.success : AppColors.textSecondary,
                    ),
                    onSelected: (sel) {
                      if (sel) setState(() => _status = 'AVAILABLE');
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Đang bảo trì'),
                    selected: _status == 'MAINTENANCE',
                    selectedColor: AppColors.warningContainer,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _status == 'MAINTENANCE' ? AppColors.warning : AppColors.textSecondary,
                    ),
                    onSelected: (sel) {
                      if (sel) setState(() => _status = 'MAINTENANCE');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 6. Tiện ích phòng
              const Text(
                'Tiện ích phòng',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _allAmenities.map((amenity) {
                  final isSelected = _selectedAmenities.contains(amenity);
                  return FilterChip(
                    label: Text(amenity, style: TextStyle(fontSize: 11, color: isSelected ? AppColors.primary : AppColors.textPrimary)),
                    selected: isSelected,
                    selectedColor: AppColors.primaryContainer,
                    checkmarkColor: AppColors.primary,
                    visualDensity: VisualDensity.compact,
                    onSelected: (sel) {
                      setState(() {
                        if (sel) {
                          _selectedAmenities.add(amenity);
                        } else {
                          _selectedAmenities.remove(amenity);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Nút Tạo phòng
              CustomButton(
                text: 'Tạo Phòng Mới',
                icon: Icons.add_circle_outline,
                isLoading: _isSubmitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
