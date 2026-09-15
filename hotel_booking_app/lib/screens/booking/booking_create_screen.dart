import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/hotel_model.dart';
import '../../models/room_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_text_field.dart';

class BookingCreateScreen extends ConsumerStatefulWidget {
  final HotelModel hotel;
  final RoomModel room;

  const BookingCreateScreen({
    super.key,
    required this.hotel,
    required this.room,
  });

  @override
  ConsumerState<BookingCreateScreen> createState() => _BookingCreateScreenState();
}

class _BookingCreateScreenState extends ConsumerState<BookingCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _guestNameController;
  late TextEditingController _guestPhoneController;
  late TextEditingController _guestEmailController;
  late TextEditingController _notesController;

  late DateTime _checkIn;
  late DateTime _checkOut;
  String _paymentMethod = 'PAY_AT_HOTEL';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _checkIn = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    _checkOut = _checkIn.add(const Duration(days: 2));

    final user = ref.read(currentUserProvider);
    _guestNameController = TextEditingController(text: user?.name ?? '');
    _guestPhoneController = TextEditingController(text: user?.phone ?? '');
    _guestEmailController = TextEditingController(text: user?.email ?? '');
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _guestNameController.dispose();
    _guestPhoneController.dispose();
    _guestEmailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  int get _numberOfNights => DateFormatter.calculateNights(_checkIn, _checkOut);
  double get _totalPrice => widget.room.price * _numberOfNights;

  Future<void> _selectDates() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final picked = await showDateRangePicker(
      context: context,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: _checkIn, end: _checkOut),
      saveText: 'Chọn',
      helpText: 'Chọn ngày lưu trú',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(80, 40),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _checkIn = picked.start;
        _checkOut = picked.end;
      });
    }
  }

  void _setNights(int nights) {
    setState(() {
      _checkOut = _checkIn.add(Duration(days: nights));
    });
  }

  void _proceedToSummary() {
    if (!_formKey.currentState!.validate()) return;

    context.push(
      '/booking/summary',
      extra: {
        'hotel': widget.hotel,
        'room': widget.room,
        'checkIn': _checkIn,
        'checkOut': _checkOut,
        'guestName': _guestNameController.text.trim(),
        'guestPhone': _guestPhoneController.text.trim(),
        'guestEmail': _guestEmailController.text.trim(),
        'notes': _notesController.text.trim(),
        'paymentMethod': _paymentMethod,
        'numberOfNights': _numberOfNights,
        'totalPrice': _totalPrice,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Thông Tin Đặt Phòng'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step Indicator
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Bước 1 / 2',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Điền thông tin đặt phòng',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Selected Hotel & Room Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border, width: 0.8),
                    boxShadow: const [
                      BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.hotel_rounded, color: AppColors.primary, size: 30),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.hotel.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.room.roomTypeName ?? "Phòng tiêu chuẩn"} • Số ${widget.room.roomNumber}',
                              style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${CurrencyFormatter.formatVND(widget.room.price)} / đêm',
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Date Selection Section
                const Text(
                  'Thời gian lưu trú',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 10),

                GestureDetector(
                  onTap: _selectDates,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.primary, width: 1.2),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Nhận phòng', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                              const SizedBox(height: 4),
                              Text(
                                DateFormatter.formatDate(_checkIn),
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                              ),
                              Text(
                                'Từ 14:00',
                                style: TextStyle(fontSize: 11, color: AppColors.primary.withAlpha(200)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.nightlight_round, size: 14, color: AppColors.primary),
                              Text(
                                '$_numberOfNights đêm',
                                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Trả phòng', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                              const SizedBox(height: 4),
                              Text(
                                DateFormatter.formatDate(_checkOut),
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                              ),
                              Text(
                                'Trước 12:00',
                                style: TextStyle(fontSize: 11, color: AppColors.primary.withAlpha(200)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Quick Night Shortcuts
                Row(
                  children: [
                    const Text('Chọn nhanh: ', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    const SizedBox(width: 6),
                    _buildQuickNightChip('1 đêm', 1),
                    const SizedBox(width: 6),
                    _buildQuickNightChip('2 đêm', 2),
                    const SizedBox(width: 6),
                    _buildQuickNightChip('3 đêm', 3),
                    const SizedBox(width: 6),
                    _buildQuickNightChip('5 đêm', 5),
                  ],
                ),
                const SizedBox(height: 24),

                // Guest Info
                const Text(
                  'Thông tin người nhận phòng',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),

                CustomTextField(
                  label: 'Họ và tên người nhận phòng',
                  hint: 'Nguyễn Văn A',
                  controller: _guestNameController,
                  prefixIcon: Icons.person_outline,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Vui lòng nhập họ và tên!' : null,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Số điện thoại',
                  hint: '0912345678',
                  controller: _guestPhoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Vui lòng nhập số điện thoại!';
                    final cleaned = v.trim().replaceAll(' ', '');
                    if (cleaned.length < 9 || cleaned.length > 11) return 'Số điện thoại không hợp lệ!';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Địa chỉ Email (để nhận xác nhận vé)',
                  hint: 'example@gmail.com',
                  controller: _guestEmailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Vui lòng nhập email!';
                    if (!v.contains('@') || !v.contains('.')) return 'Email không đúng định dạng!';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Yêu cầu đặc biệt (không bắt buộc)',
                  hint: 'Ví dụ: Tầng cao, giường đôi, nhận phòng muộn...',
                  controller: _notesController,
                  prefixIcon: Icons.note_alt_outlined,
                  maxLines: 2,
                ),
                const SizedBox(height: 24),

                // Payment Methods
                const Text(
                  'Phương thức thanh toán',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),

                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border, width: 0.8),
                  ),
                  child: Column(
                    children: [
                      _buildPaymentOption(
                        key: 'PAY_AT_HOTEL',
                        title: 'Thanh toán tại khách sạn',
                        subtitle: 'Thanh toán tiền mặt hoặc quẹt thẻ khi check-in (Khuyên dùng)',
                        icon: Icons.storefront_outlined,
                        isFirst: true,
                        isLast: false,
                      ),
                      const Divider(height: 1, color: AppColors.divider),
                      _buildPaymentOption(
                        key: 'BANK_TRANSFER',
                        title: 'Chuyển khoản Ngân hàng / QR Pay',
                        subtitle: 'Quét mã QR VietQR chuyển khoản nhanh 24/7',
                        icon: Icons.qr_code_2_rounded,
                        isFirst: false,
                        isLast: false,
                      ),
                      const Divider(height: 1, color: AppColors.divider),
                      _buildPaymentOption(
                        key: 'CREDIT_CARD',
                        title: 'Thẻ tín dụng / Thẻ ghi nợ quốc tế',
                        subtitle: 'Visa, MasterCard, JCB',
                        icon: Icons.credit_card_rounded,
                        isFirst: false,
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Price Summary Breakdown
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border, width: 0.8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Chi tiết giá',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${CurrencyFormatter.formatVND(widget.room.price)} x $_numberOfNights đêm',
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                          Text(
                            CurrencyFormatter.formatVND(_totalPrice),
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Thuế & Phí dịch vụ', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                          Text('Miễn phí', style: TextStyle(fontSize: 13, color: AppColors.success, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const Divider(height: 20, color: AppColors.divider),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tổng thanh toán', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          Text(
                            CurrencyFormatter.formatVND(_totalPrice),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(0, -3)),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tổng tiền', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    Text(
                      CurrencyFormatter.formatVND(_totalPrice),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              ElevatedButton(
                onPressed: _proceedToSummary,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(160, 48),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Tiếp tục', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward_ios, size: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickNightChip(String label, int nights) {
    final isSelected = _numberOfNights == nights;
    return GestureDetector(
      onTap: () => _setNights(nights),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String key,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isFirst,
    required bool isLast,
  }) {
    final isSelected = _paymentMethod == key;
    return InkWell(
      onTap: () => setState(() => _paymentMethod = key),
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(14) : Radius.zero,
        bottom: isLast ? const Radius.circular(14) : Radius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(width: 12),
            Icon(icon, size: 22, color: isSelected ? AppColors.primary : AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.textPrimary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
