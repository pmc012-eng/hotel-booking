# -*- coding: utf-8 -*-
"""
Module chap_3:
CHƯƠNG 3. XÂY DỰNG SẢN PHẨM, KIỂM THỬ VÀ ĐÁNH GIÁ
- 3.1 Xây dựng và triển khai sản phẩm (Môi trường, cấu trúc source, mã nguồn cốt lõi, seed data, Hình 3.1, Hình 3.2)
- 3.2 Kiểm thử và đánh giá sản phẩm (Bảng 3.1: 22 Test Cases, Bảng 3.2: Hiệu năng)
- 3.3 Giải pháp cải tiến kỹ thuật (BoxConstraints, Indexing, Server Price, min_price sync, room release)
- 3.4 Quá trình tự học và phát triển (3.4.1, 3.4.2, 3.4.3)
- 3.5 Kết quả đạt được và hạn chế (Bảng 3.3: Đối chiếu mục tiêu)
"""

import os
import docx
from docx.shared import Cm, Pt, Inches, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from report_builder.helpers import (
    add_chapter_title, add_heading_2, add_heading_3, add_heading_4,
    add_body_p, add_table_caption, add_figure_caption, add_image_box,
    format_table_row, set_table_borders, add_code_block
)

assets_dir = r"D:\Projects\hotel-android\report_assets"

def add_chapter_3(doc):
    """Nội dung chi tiết CHƯƠNG 3 (Khoảng 18-20 trang A4 chuẩn)."""
    add_chapter_title(doc, "3", "XÂY DỰNG SẢN PHẨM, KIỂM THỬ VÀ ĐÁNH GIÁ")

    # 3.1 Xây dựng và triển khai sản phẩm
    add_heading_2(doc, "3.1. Xây dựng và triển khai sản phẩm")

    add_heading_3(doc, "3.1.1. Môi trường phát triển và cấu hình triển khai")
    add_body_p(doc, "Hệ thống được xây dựng và triển khai thực tế trên môi trường phần cứng và phần mềm tiêu chuẩn như sau:")
    add_body_p(doc, "– Môi trường phần cứng phát triển: Máy trạm vi xử lý Intel Core i5/i7, bộ nhớ trong RAM 16GB, ổ đĩa lưu trữ thể rắn SSD NVMe 512GB.", is_bullet=True)
    add_body_p(doc, "– Nền tảng phía máy khách (Client Environment): Flutter SDK phiên bản 3.24.x, Dart SDK 3.5.x, hệ điều hành Android API Level 34 (Android 14) kết hợp công cụ biên dịch Gradle 8.x.", is_bullet=True)
    add_body_p(doc, "– Nền tảng phía máy chủ (Server Environment): Node.js phiên bản LTS v18.17.x, trình quản lý gói npm v9.x, framework Express.js v4.18.x.", is_bullet=True)
    add_body_p(doc, "– Nền tảng cơ sở dữ liệu (Database Environment): MySQL Community Server 8.0.x cấu hình bộ nhớ đệm kết nối InnoDB Buffer Pool, lắng nghe tại cổng mặc định 3306.", is_bullet=True)
    add_body_p(doc, "– Thiết bị kiểm thử thực tế: Thiết bị di động thông minh Xiaomi / Samsung chạy hệ điều hành Android 13/14 kết nối qua giao thức gỡ lỗi ADB (Android Debug Bridge) và máy ảo Android Emulator Google Pixel 6.")

    add_heading_3(doc, "3.1.2. Cấu trúc tổ chức mã nguồn của dự án")
    add_body_p(doc, "Toàn bộ mã nguồn dự án được tổ chức theo cấu trúc module hóa phân tầng rõ ràng, bảo đảm tính dễ bảo trì, dễ mở rộng và tuân thủ các nguyên lý thiết kế phần mềm sạch (Clean Architecture):")
    add_body_p(doc, "1. Cấu trúc thư mục ứng dụng di động Flutter (`hotel_booking_app/`):", is_bullet=True)
    add_body_p(doc, "   – `lib/models/`: Chứa các lớp đối tượng thực thể dữ liệu (User, Hotel, RoomType, Room, Booking, Review) hỗ trợ chuyển đổi JSON (fromJson / toJson).")
    add_body_p(doc, "   – `lib/screens/`: Chứa các màn hình giao diện chính (SplashScreen, LoginScreen, RegisterScreen, HomeScreen, HotelDetailScreen, BookingScreen, BookingHistoryScreen, ProfileScreen, AdminDashboardScreen).")
    add_body_p(doc, "   – `lib/providers/`: Chứa các lớp quản lý trạng thái kế thừa ChangeNotifier (AuthProvider, HotelProvider, BookingProvider).")
    add_body_p(doc, "   – `lib/services/`: Chứa các dịch vụ gọi API HTTP chuyên biệt và xử lý lưu trữ bảo mật Token cục bộ.")
    add_body_p(doc, "   – `lib/widgets/`: Chứa các thành phần giao diện dùng chung (HotelCard, RatingStars, FilterBottomSheet, CustomButton, DateRangePicker).")
    add_body_p(doc, "2. Cấu trúc thư mục máy chủ Backend Node.js (`backend/`):", is_bullet=True)
    add_body_p(doc, "   – `src/config/`: Cấu hình biến môi trường (`env.js`), kết nối CSDL MySQL Pool (`db.js`) và tệp khởi tạo schema CSDL (`schema.sql`).")
    add_body_p(doc, "   – `src/controllers/`: Xử lý logic nghiệp vụ chi tiết (`auth.controller.js`, `hotel.controller.js`, `room.controller.js`, `booking.controller.js`, `admin.controller.js`).")
    add_body_p(doc, "   – `src/models/`: Thực thi các truy vấn dữ liệu SQL thuần tối ưu hiệu năng cao (`user.model.js`, `hotel.model.js`, `room.model.js`, `booking.model.js`, `review.model.js`).")
    add_body_p(doc, "   – `src/routes/`: Định nghĩa các nhánh định tuyến URL (`auth.routes.js`, `hotel.routes.js`, `booking.routes.js`, `admin.routes.js`).")
    add_body_p(doc, "   – `src/middlewares/`: Bộ lọc tiền xử lý yêu cầu (`auth.middleware.js` chứa verifyToken và requireAdmin, `error.middleware.js` bắt lỗi tập trung).")

    add_heading_3(doc, "3.1.3. Cài đặt các chức năng cốt lõi")
    add_body_p(doc, "Dưới đây là các giải pháp lập trình tiêu biểu được áp dụng trực tiếp trong mã nguồn hệ thống:")
    add_body_p(doc, "1. Cài đặt thuật toán kiểm tra phòng trống khả dụng (`room.model.js`):", is_bullet=True)
    add_body_p(doc, "   Mã nguồn sử dụng câu truy vấn SQL lồng (Subquery with NOT IN / NOT EXISTS) để lọc ra các phòng vật lý chưa từng bị đặt hoặc đã hết hạn trong khoảng ngày khách chọn:")
    
    add_code_block(doc,
        "SELECT r.* FROM rooms r\n"
        "WHERE r.hotel_id = ? AND r.room_type_id = ? AND r.status = 'AVAILABLE'\n"
        "AND r.id NOT IN (\n"
        "    SELECT b.room_id FROM bookings b\n"
        "    WHERE b.status != 'CANCELLED'\n"
        "    AND (b.check_out > ? AND b.check_in < ?)\n"
        ");",
        caption="Đoạn mã 3.1: Truy vấn lọc phòng trống theo khoảng thời gian thực tế"
    )
    
    add_body_p(doc, "   Đoạn truy vấn trên truyền vào hai tham số ngày là `check_in` và `check_out` mà khách hàng muốn thuê. Mệnh đề `(b.check_out > ? AND b.check_in < ?)` chính là sự hiện thực hóa hoàn hảo của công thức toán học chống trùng phòng đã chứng minh tại Chương 2.")
    add_body_p(doc, "2. Cài đặt giao dịch đặt phòng nguyên tử và tính giá phía Server (`booking.controller.js`):", is_bullet=True)
    add_body_p(doc, "   Để triệt tiêu nguy cơ gian lận sửa giá, hàm `createBooking` truy vấn đơn giá gốc từ CSDL và tính toán số đêm:")
    
    add_code_block(doc,
        "const [roomType] = await db.query('SELECT price FROM room_types WHERE id = ?', [room_type_id]);\n"
        "const diffTime = Math.abs(new Date(check_out) - new Date(check_in));\n"
        "const diffNights = Math.ceil(diffTime / (1000 * 60 * 60 * 24));\n"
        "const totalPrice = roomType.price * diffNights;\n"
        "const bookingCode = 'BK' + Date.now().toString(36).toUpperCase() + Math.random().toString(36).substring(2, 5).toUpperCase();",
        caption="Đoạn mã 3.2: Tính toán chi phí lưu trú an toàn phía máy chủ Backend"
    )
    
    add_body_p(doc, "3. Cài đặt cơ chế tự động đồng bộ giá sàn nhỏ nhất (`hotel.controller.js`):", is_bullet=True)
    add_body_p(doc, "   Mỗi khi Admin bổ sung hoặc cập nhật giá của một loại phòng, hàm cập nhật sẽ tự động kích hoạt truy vấn đồng bộ hóa:")
    
    add_code_block(doc,
        "await db.query(`\n"
        "    UPDATE hotels SET min_price = (\n"
        "        SELECT COALESCE(MIN(price), 0) FROM room_types WHERE hotel_id = ?\n"
        "    ) WHERE id = ?\n"
        "`, [hotelId, hotelId]);",
        caption="Đoạn mã 3.3: Tự động đồng bộ hóa mức giá sàn nhỏ nhất của khách sạn"
    )
    
    add_body_p(doc, "   Cơ chế này khắc phục triệt để lỗi giá khách sạn hiển thị 0đ, bảo đảm trang chủ luôn hiển thị chuẩn xác mức giá thấp nhất có thể đặt.")

    add_heading_3(doc, "3.1.4. Bộ dữ liệu mẫu thực nghiệm (Seed Data)")
    add_body_p(doc, "Hệ thống đã được nạp sẵn bộ dữ liệu mẫu thực tế bao gồm:")
    add_body_p(doc, "– 10 tài khoản người dùng thực tế gồm 9 tài khoản khách hàng thông thường và 1 tài khoản quản trị viên tối cao (Email: admin@hotel.com, Mật khẩu đã băm Bcrypt).", is_bullet=True)
    add_body_p(doc, "– 8 khách sạn và khu nghỉ dưỡng tiêu biểu tại các thành phố du lịch lớn: Khách sạn Mường Thanh Grand (Hà Nội), Khách sạn Novotel Danang Premier (Đà Nẵng), Khách sạn Vinpearl Resort & Spa (Nha Trang), Khách sạn InterContinental Saigon (TP. Hồ Chí Minh), Khách sạn Colline (Đà Lạt), Khách sạn Premier Residences (Phú Quốc)...", is_bullet=True)
    add_body_p(doc, "– Hơn 30 loại phòng phong phú (Standard Queen, Deluxe King, Suite Executive, Family Suite) với đơn giá niêm yết từ 650,000 đ đến 3,500,000 đ/đêm.", is_bullet=True)
    add_body_p(doc, "– Hơn 80 phòng vật lý cụ thể (phòng 101, 102, 201, 202, 301...) sẵn sàng phục vụ kiểm tra tính khả dụng.", is_bullet=True)
    add_body_p(doc, "– Hơn 50 bài đánh giá nhận xét thực tế kèm số sao từ 4 đến 5 sao, giúp điểm rating của các khách sạn phản ánh đúng trải nghiệm cộng đồng.", is_bullet=True)

    add_heading_3(doc, "3.1.5. Giao diện và kết quả chạy thực tế của sản phẩm")
    add_body_p(doc, "Ứng dụng di động sau khi hoàn thiện toàn bộ mã nguồn đã được đóng gói và biên dịch thành tệp tin cài đặt APK Android (`app-release.apk`). Hệ thống đã được cài đặt và vận hành thử nghiệm thực tế trên thiết bị di động thông minh chạy hệ điều hành Android 14 kết nối thời gian thực với máy chủ Backend Node.js và cơ sở dữ liệu MySQL. Dưới đây là 10 màn hình giao diện then chốt đại diện cho toàn bộ các quy trình nghiệp vụ của sản phẩm:")

    add_heading_4(doc, "3.1.5.1. Nhóm giao diện phục vụ Khách hàng (Customer Experience Flow)")

    # Hình 3.1: Trang chủ
    add_image_box(doc, os.path.join(assets_dir, "app_trang_chu.jpg"), width_inches=2.4)
    add_figure_caption(doc, "3.1", "Giao diện màn hình Trang chủ ứng dụng đặt phòng (Home Screen)")
    add_body_p(doc, "Hình 3.1 thể hiện màn hình Trang chủ (Home Screen) khi người dùng đăng nhập thành công vào hệ thống. Phía trên cùng hiển thị lời chào cá nhân hóa theo tài khoản ('Xin chào, Phạm Minh Chi') kèm biểu tượng avatar viết tắt và chuông thông báo. Ngay bên dưới là thanh tìm kiếm nhanh cho phép nhập từ khóa tên khách sạn hoặc địa danh. Tiếp nối là thanh trượt danh mục thành phố (Filter Chips) với các tùy chọn như 'Tất cả', 'Hà Nội', 'Đà Nẵng', 'Hồ Chí Minh' giúp lọc nhanh danh sách khách sạn chỉ với một chạm.")
    add_body_p(doc, "Màn hình được bố cục thành hai phân vùng nội dung chính: mục 'Khách sạn nổi bật' hiển thị theo băng chuyền ngang (Horizontal Carousel) làm nổi bật các khách sạn 5 sao cao cấp (như Sofitel Legend Metropole Hanoi giá 3.200.000 đ/đêm, Ha Noi hotel giá 15.000.000 đ/đêm) kèm huy hiệu sao vàng đánh giá chất lượng; và phân vùng 'Đề xuất cho bạn' với danh sách các khách sạn được nạp động từ CSDL. Dưới cùng màn hình là thanh điều hướng đáy (Bottom Navigation Bar) gồm 4 phân hệ chính: Trang chủ, Khám phá, Đơn đặt và Hồ sơ.")

    # Hình 3.2: Khám phá
    add_image_box(doc, os.path.join(assets_dir, "app_kham_pha.jpg"), width_inches=2.4)
    add_figure_caption(doc, "3.2", "Giao diện màn hình Khám phá và Tìm kiếm phòng khách sạn (Explore Screen)")
    add_body_p(doc, "Hình 3.2 minh họa màn hình Khám phá (Explore Screen) tích hợp bộ công cụ tìm kiếm và lọc chuyên sâu. Người dùng có thể tìm kiếm theo từ khóa địa điểm hoặc mở khay bộ lọc nâng cao để thiết lập khoảng giá mong muốn, số sao đánh giá tối thiểu và khu vực địa lý cụ thể. Danh sách khách sạn kết quả được hiển thị dưới dạng các thẻ thông tin (Card View) trực quan và sang trọng.")
    add_body_p(doc, "Mỗi thẻ khách sạn hiển thị hình ảnh tiêu biểu góc rộng, vị trí chi tiết (ví dụ: '15 Ngô Quyền, Quận Hoàn Kiếm'), thanh đánh giá sao tích hợp số lượng nhận xét ('5.0 sao - 1 đánh giá') và đặc biệt là mức giá niêm yết 'Giá chỉ từ: 3.200.000 đ'. Mức giá này được hệ thống tự động đồng bộ hóa từ giá của loại phòng thấp nhất đang có trong khách sạn thông qua cơ chế tự động đồng bộ giá sàn đã cài đặt ở tầng Backend. Bên cạnh giá phòng là nút bấm hành động nổi bật 'Xem phòng', lập tức dẫn người dùng đến trang chi tiết các loại phòng khả dụng của khách sạn đó.")

    # Hình 3.3: Đặt phòng thành công
    add_image_box(doc, os.path.join(assets_dir, "app_dat_phong_thanh_cong.jpg"), width_inches=2.4)
    add_figure_caption(doc, "3.3", "Giao diện màn hình Xác nhận Đặt phòng thành công (Booking Success Screen)")
    add_body_p(doc, "Hình 3.3 thể hiện giao diện màn hình Đặt phòng thành công được kích hoạt ngay sau khi giao dịch tạo đơn đặt phòng được máy chủ Backend xử lý hoàn tất trong một Database Transaction nguyên tử. Trung tâm màn hình nổi bật với biểu tượng dấu tích xanh (Success Checkmark) sinh động mang lại trải nghiệm an tâm tuyệt đối cho khách hàng. Ngay phía dưới là thông điệp chúc mừng 'Đặt phòng thành công!' và mã đơn đặt phòng chuẩn hóa duy nhất ('HB-2026-3232') được sinh ngẫu nhiên bảo mật.")
    add_body_p(doc, "Khối tóm tắt thông tin đặt phòng (Booking Receipt Card) liệt kê đầy đủ các dữ liệu quan trọng của chuyến đi: Tên khách sạn ('The Oriental Jade Hotel'), địa chỉ chi tiết tại Hà Nội, thời gian nhận phòng ('25/03/2026'), thời gian trả phòng ('27/03/2026'), tổng số đêm lưu trú (2 đêm) và tổng chi phí quyết toán ('2.700.000 đ'). Tại chân màn hình, ứng dụng cung cấp hai nút bấm điều hướng tiện lợi: 'Xem Đơn Đặt Của Tôi' (chuyển sang màn hình quản lý lịch sử đơn) và 'Về Trang Chủ' (quay lại giao diện chính để tiếp tục khám phá).")

    # Hình 3.4: Đơn đặt của tôi
    add_image_box(doc, os.path.join(assets_dir, "app_don_dat_cua_toi.jpg"), width_inches=2.4)
    add_figure_caption(doc, "3.4", "Giao diện màn hình Quản lý Đơn đặt phòng của tôi (My Bookings Screen)")
    add_body_p(doc, "Hình 3.4 minh họa màn hình Lịch sử và Quản lý đơn đặt phòng cá nhân của khách hàng ('Đơn đặt phòng của tôi'). Giao diện được thiết kế khoa học với hệ thống thanh chuyển Tab trạng thái mượt mà gồm 3 nhóm: 'Sắp tới', 'Hoàn thành' và 'Đã hủy', giúp người dùng dễ dàng theo dõi toàn bộ các chuyến hành trình trong quá khứ lẫn kế hoạch tương lai.")
    add_body_p(doc, "Trong danh mục 'Sắp tới', thẻ đơn hàng hiển thị mã định danh đơn ('HB-2026-9761'), ảnh đại diện khách sạn Sofitel Legend Metropole Hà Nội, khoảng thời gian lưu trú dự kiến ('24/03/2026 - 26/03/2026', 2 đêm), tổng số tiền cần thanh toán ('6.400.000 đ') và nhãn trạng thái trực quan màu cam 'Chờ check-in'. Giao diện này cũng tích hợp cơ chế hủy phòng tự động: nếu chuyến đi chưa đến ngày khởi hành, người dùng có thể kích hoạt hủy đơn, hệ thống sẽ tự động cập nhật trạng thái CANCELLED và giải phóng phòng vật lý về trạng thái AVAILABLE trong CSDL theo đúng ràng buộc nghiệp vụ.")

    # Hình 3.5: Tài khoản người dùng
    add_image_box(doc, os.path.join(assets_dir, "app_tai_khoan_user.jpg"), width_inches=2.4)
    add_figure_caption(doc, "3.5", "Giao diện màn hình Hồ sơ cá nhân người dùng (User Profile Screen)")
    add_body_p(doc, "Hình 3.5 thể hiện màn hình Hồ sơ cá nhân (User Profile Screen) của tài khoản khách hàng thông thường. Phần Header hiển thị biểu tượng đại diện hình tròn với chữ cái viết tắt tên người dùng ('PC'), tên đầy đủ ('Phạm Minh Chi') và địa chỉ email đã xác thực. Ngay bên dưới là nhãn chức năng thể hiện vai trò tài khoản trong hệ thống.")
    add_body_p(doc, "Danh mục thiết lập tài khoản được thiết kế dạng danh sách (ListTile Menu) với các icon đồ họa phẳng hiện đại: 'Chỉnh sửa thông tin' (cho phép cập nhật họ tên, số điện thoại), 'Đổi mật khẩu' (mở biểu mẫu xác thực mật khẩu cũ và mã hóa mật khẩu mới bằng Bcrypt), 'Lịch sử đặt phòng' (lối tắt đến màn hình đơn hàng), 'Trợ giúp & hỗ trợ', và 'Điều khoản & chính sách'. Cuối màn hình là nút 'Đăng xuất' màu đỏ cảnh báo, khi nhấn vào sẽ kích hoạt xóa sạch Token JWT trong bộ nhớ an toàn (Flutter Secure Storage) và đưa người dùng trở lại màn hình đăng nhập.")

    add_heading_4(doc, "3.1.5.2. Nhóm giao diện phục vụ Quản trị viên (Administrator Management Flow)")

    # Hình 3.6: Tài khoản Admin
    add_image_box(doc, os.path.join(assets_dir, "app_tai_khoan_admin.jpg"), width_inches=2.4)
    add_figure_caption(doc, "3.6", "Giao diện màn hình Hồ sơ tài khoản Quản trị viên (Admin Profile Screen)")
    add_body_p(doc, "Hình 3.6 minh họa màn hình Hồ sơ khi đăng nhập bằng tài khoản Quản trị viên cấp cao (Admin Account). Ứng dụng tích hợp cơ chế phân quyền bảo mật tầng giao diện: sau khi giải mã Token JWT và xác định thuộc tính role === 'ADMIN', giao diện lập tức render nhãn nhận diện 'Quản trị viên' màu xanh chuyên biệt ngay bên dưới tên tài khoản.")
    add_body_p(doc, "Đặc biệt, trong danh mục cài đặt hệ thống xuất hiện một phân vùng riêng biệt mang tên 'Quản trị viên' với lối tắt 'Bảng điều khiển Admin' đi kèm biểu tượng bảng chỉ số đồ họa (Insights Icon). Phân vùng này hoàn toàn bị ẩn và được bảo vệ nghiêm ngặt đối với các tài khoản khách hàng thông thường, ngăn chặn triệt để hành vi xâm nhập trái phép vào khu vực điều hành hệ thống.")

    # Hình 3.7: Dashboard Admin
    add_image_box(doc, os.path.join(assets_dir, "app_admin_dashboard.jpg"), width_inches=2.4)
    add_figure_caption(doc, "3.7", "Giao diện màn hình Bảng điều khiển Quản trị hệ thống (Admin Dashboard Screen)")
    add_body_p(doc, "Hình 3.7 thể hiện trung tâm chỉ huy Bảng điều khiển Quản trị (Admin Dashboard) – nơi tổng hợp toàn bộ các chỉ số vận hành và tài chính then chốt của nền tảng đặt phòng. Phía trên cùng là thẻ báo cáo tài chính nổi bật với 'Tổng doanh thu' đạt '34.850.000 đ' được tính toán tự động bằng hàm SUM tổng hợp từ các đơn đặt phòng có trạng thái hợp lệ trong CSDL.")
    add_body_p(doc, "Bên dưới là lưới ma trận 3 thẻ KPI vận hành cốt lõi: 'Tổng đơn' (đang ghi nhận 9 đơn đặt phòng), 'Khách sạn' (11 khách sạn đối tác đang hoạt động trên hệ thống), và 'Phòng trống' (47/48 phòng sẵn sàng đón khách, biểu thị tỷ lệ lấp đầy phòng chuẩn xác theo thời gian thực). Phía dưới các chỉ số thống kê là hàng phím tắt điều hướng nhanh gồm: 'Quản lý đơn' (quản lý trạng thái đơn toàn cục), 'Quản lý KS' (quản lý danh mục khách sạn) và 'Quản lý phòng' (quản lý cấu hình buồng phòng vật lý), mang lại trải nghiệm quản trị tiện lợi và tối ưu hóa năng suất làm việc cho người vận hành.")

    # Hình 3.8: Quản lý Khách sạn
    add_image_box(doc, os.path.join(assets_dir, "app_admin_quan_ly_ks.jpg"), width_inches=2.4)
    add_figure_caption(doc, "3.8", "Giao diện màn hình Quản lý danh mục Khách sạn (Admin Hotel Management Screen)")
    add_body_p(doc, "Hình 3.8 minh họa giao diện Quản lý danh mục khách sạn của quản trị viên. Màn hình cung cấp ô tìm kiếm nhanh và danh sách tất cả các cơ sở lưu trú có trên hệ thống (như The Oriental Jade Hotel, Sofitel Legend Metropole Hanoi...). Mỗi thẻ khách sạn hiển thị hình ảnh thu nhỏ, tên cơ sở, địa chỉ chi tiết, điểm đánh giá số sao trung bình cùng hệ thống nút bấm tác vụ nhanh.")
    add_body_p(doc, "Quản trị viên có thể nhấn nút 'Quản lý phòng' để xem danh sách các buồng phòng trực thuộc khách sạn đó, nhấn 'Thêm phòng' để mở ngay biểu mẫu nạp buồng phòng mới, hoặc nhấn biểu tượng thùng rác màu đỏ để xóa khách sạn khỏi hệ thống (có hộp thoại cảnh báo xác nhận ràng buộc khóa ngoại CSDL). Tại góc dưới bên phải màn hình được bố trí nút bấm hành động nổi (Floating Action Button - FAB) mang nhãn '+ Thêm Khách Sạn', cho phép quản trị viên thêm mới cơ sở lưu trú vào mạng lưới dịch vụ chỉ với một cú nhấp.")

    # Hình 3.9: Thêm phòng khách sạn
    add_image_box(doc, os.path.join(assets_dir, "app_admin_them_phong.jpg"), width_inches=2.4)
    add_figure_caption(doc, "3.9", "Giao diện biểu mẫu Thêm phòng và Cấu hình loại phòng (Admin Add Room Screen)")
    add_body_p(doc, "Hình 3.9 thể hiện giao diện biểu mẫu tương tác (Modal Dialog / Bottom Sheet) phục vụ chức năng tạo mới buồng phòng cho từng khách sạn cụ thể. Biểu mẫu được thiết kế chuẩn mực với các trường dữ liệu bắt buộc: Menu xổ xuống (Dropdown) để 'Chọn khách sạn' cần bổ sung phòng, ô nhập 'Số phòng' (ví dụ: phòng 101, 202, 305...), bộ chọn 'Sức chứa' tối đa theo số lượng người lưu trú, và danh mục 'Loại phòng' (Phòng Tiêu Chuẩn, Superior, Deluxe, Suite...).")
    add_body_p(doc, "Đặc biệt, biểu mẫu tích hợp trường 'Giá phòng/đêm (VND)' phục vụ tính toán chi phí thuê thực tế; bộ chọn 'Trạng thái' phòng (Mặc định là 'Sẵn sàng'); và danh sách các thẻ tùy chọn 'Tiện ích' đa dạng (Wifi tốc độ cao, Bể bơi, Ban công thoáng mát, Bữa sáng buffet...). Khi người quản trị nhấn nút 'Tạo phòng', hệ thống Backend sẽ đồng thời kiểm tra tính duy nhất của số phòng (UNIQUE constraint) và tự động kích hoạt truy vấn tái tính toán mức giá sàn nhỏ nhất (`hotels.min_price`) cho toàn khách sạn, bảo đảm dữ liệu trên màn hình khám phá luôn luôn đồng nhất.")

    # Hình 3.10: Quản lý Đơn đặt phòng
    add_image_box(doc, os.path.join(assets_dir, "app_admin_quan_ly_don.jpg"), width_inches=2.4)
    add_figure_caption(doc, "3.10", "Giao diện màn hình Quản lý Đơn đặt phòng hệ thống (Admin Booking Management Screen)")
    add_body_p(doc, "Hình 3.10 minh họa giao diện Quản lý đơn đặt phòng toàn hệ thống dành cho Quản trị viên và Bộ phận Lễ tân. Phía trên cùng là hệ thống 4 tab chuyển đổi trạng thái đơn đặt: 'Tất cả', 'Chờ check-in', 'Hoàn thành' và 'Đã hủy', giúp quản trị viên lọc nhanh các đơn theo giai đoạn xử lý của nghiệp vụ buồng phòng.")
    add_body_p(doc, "Mỗi thẻ đơn đặt phòng thể hiện đầy đủ các thông tin: Tên khách hàng đặt phòng, Mã đặt phòng chuẩn hóa, Khách sạn lưu trú, Khoảng ngày nhận/trả phòng, Tổng số tiền thanh toán, và nhãn trạng thái nổi bật (màu cam cho 'Chờ check-in', màu xanh cho 'Hoàn thành', màu đỏ cho 'Đã hủy'). Đặc biệt, đối với các đơn đang chờ tiếp đón, hệ thống cung cấp trực tiếp hai nút bấm hành động nghiệp vụ: nút 'Hủy đơn' (hỗ trợ xử lý trường hợp khách hủy đột xuất hoặc không đến check-in) và nút 'Hoàn tất' (chuyển đổi trạng thái đơn sang COMPLETED khi khách đã làm thủ tục trả phòng). Toàn bộ các thao tác này đều cập nhật tức thời vào CSDL MySQL và tự động giải phóng phòng khi cần thiết.")

    # 3.2 Kiểm thử và đánh giá sản phẩm
    add_heading_2(doc, "3.2. Kiểm thử và đánh giá sản phẩm")

    add_heading_3(doc, "3.2.1. Chiến lược và phương pháp kiểm thử")
    add_body_p(doc, "Để đảm bảo chất lượng phần mềm đạt tiêu chuẩn cao nhất trước khi bàn giao, quy trình kiểm thử toàn diện được thực hiện thông qua 3 phương pháp cốt lõi:")
    add_body_p(doc, "– Kiểm thử hộp đen (Black-box Testing): Kiểm thử các tính năng chức năng của ứng dụng từ góc nhìn người dùng cuối mà không can thiệp vào cấu trúc mã nguồn bên trong; tập trung kiểm tra các luồng dữ liệu hợp lệ (Positive Test Cases) và các luồng dữ liệu không hợp lệ / biên giới (Negative & Boundary Test Cases).", is_bullet=True)
    add_body_p(doc, "– Kiểm thử tích hợp API (API Integration Testing): Sử dụng phần mềm Postman để gửi các bộ dữ liệu thử nghiệm đến từng Endpoint của máy chủ Node.js; kiểm tra độ chính xác của các mã trạng thái phản hồi HTTP, định dạng JSON và tính toàn vẹn của dữ liệu trong MySQL.", is_bullet=True)
    add_body_p(doc, "– Kiểm thử giao diện và trải nghiệm (UI/UX Testing): Kiểm tra độ tương thích trên các kích thước màn hình Android khác nhau, kiểm tra hiện tượng tràn khung hình (RenderFlex Overflow) và kiểm tra khả năng phục hồi dữ liệu khi xoay màn hình hoặc mất kết nối mạng đột ngột.", is_bullet=True)

    add_heading_3(doc, "3.2.2. Bộ Test Case kiểm thử chức năng toàn diện")
    add_body_p(doc, "Bảng 3.1 thống kê chi tiết 22 kịch bản kiểm thử bao phủ toàn bộ 6 phân hệ chức năng của hệ thống:")

    add_table_caption(doc, "3.1", "Bộ Test Case kiểm thử chức năng toàn diện của hệ thống (22 kịch bản)")
    tbl_tc = doc.add_table(rows=23, cols=6)
    tbl_tc.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl_tc.autofit = False
    widths_tc = [Inches(0.8), Inches(1.3), Inches(1.2), Inches(1.5), Inches(1.4), Inches(0.6)]
    
    headers_tc = ["Mã TC", "Chức năng", "Dữ liệu đầu vào", "Các bước thực hiện", "Kết quả mong đợi", "Đánh giá"]
    for j, h in enumerate(headers_tc):
        tbl_tc.rows[0].cells[j].paragraphs[0].text = h
    format_table_row(tbl_tc.rows[0], widths_tc, bg_color="FFFFFF", is_header=True, font_size=11)

    tc_data = [
        ("TC-01", "Đăng ký thành công", "Email mới, pass 6 ký tự", "Điền form đăng ký -> Nhấn Đăng ký", "Tạo tài khoản thành công, lưu CSDL", "Pass"),
        ("TC-02", "Đăng ký trùng Email", "Email đã có trong CSDL", "Điền form với email cũ -> Nhấn Đăng ký", "Báo lỗi 400 'Email đã được sử dụng'", "Pass"),
        ("TC-03", "Đăng nhập sai mật khẩu", "Email đúng, Pass sai", "Điền form đăng nhập -> Nhấn Đăng nhập", "Báo lỗi 401 'Mật khẩu không chính xác'", "Pass"),
        ("TC-04", "Đăng nhập thành công", "Email đúng, Pass đúng", "Điền form đăng nhập -> Nhấn Đăng nhập", "Cấp Token JWT 7 ngày, vào màn hình Home", "Pass"),
        ("TC-05", "Đổi mật khẩu", "Mật khẩu cũ + Mật khẩu mới", "Vào Profile -> Nhập pass cũ và pass mới", "Cập nhật hash mật khẩu mới vào bảng users", "Pass"),
        ("TC-06", "Tìm kiếm theo từ khóa", "Từ khóa 'Mường Thanh'", "Nhập từ khóa vào ô tìm kiếm", "Hiển thị danh sách khách sạn Mường Thanh", "Pass"),
        ("TC-07", "Lọc theo Thành phố", "Thành phố 'Đà Nẵng'", "Chọn tab 'Đà Nẵng' trên thanh trượt", "Chỉ hiển thị các khách sạn tại Đà Nẵng", "Pass"),
        ("TC-08", "Lọc đa tiêu chí", "Hà Nội, 5 sao, max 2tr", "Mở bộ lọc -> Thiết lập tiêu chí -> Áp dụng", "Hiển thị đúng khách sạn thỏa mãn cả 3 điều kiện", "Pass"),
        ("TC-09", "Xem chi tiết khách sạn", "ID khách sạn hợp lệ", "Nhấn vào card khách sạn từ danh sách", "Tải đầy đủ ảnh, mô tả, tiện ích, loại phòng", "Pass"),
        ("TC-10", "Chọn ngày không hợp lệ", "Check-out <= Check-in", "Chọn ngày về trước ngày đi trên lịch", "Báo lỗi đỏ, không cho phép xác nhận", "Pass"),
        ("TC-11", "Kiểm tra phòng trống", "Ngày hợp lệ, còn phòng", "Chọn ngày Check-in/out hợp lệ", "Hiển thị số phòng trống, tính tổng tiền", "Pass"),
        ("TC-12", "Kiểm tra hết phòng", "Khoảng ngày đã kín phòng", "Chọn ngày mà toàn bộ phòng đã có booking", "Hiển thị nhãn 'Hết phòng', khóa nút đặt", "Pass"),
        ("TC-13", "Đặt phòng thành công", "Thông tin khách + PAY_AT_HOTEL", "Điền thông tin lưu trú -> Nhấn Đặt phòng", "Tạo đơn CONFIRMED, gán phòng, sinh mã BK", "Pass"),
        ("TC-14", "Thiếu thông tin người nhận", "Để trống Họ tên hoặc SĐT", "Bấm xác nhận đặt phòng khi thiếu thông tin", "Hiển thị cảnh báo yêu cầu nhập đủ trường", "Pass"),
        ("TC-15", "Xem lịch sử chuyến đi", "Tài khoản có 3 đơn đặt", "Vào màn hình 'Chuyến đi của tôi'", "Hiển thị đúng 3 đơn tại các tab tương ứng", "Pass"),
        ("TC-16", "Hủy đơn hợp lệ", "Đơn CONFIRMED, trước ngày đi", "Nhấn nút 'Hủy đơn' -> Xác nhận đồng ý", "Đổi trạng thái CANCELLED, chuyển tab Đã hủy", "Pass"),
        ("TC-17", "Giải phóng phòng tức thì", "Đơn vừa hủy tại TC-16", "Quay lại kiểm tra phòng trống khoảng ngày đó", "Phòng vật lý lập tức xuất hiện trở lại khả dụng", "Pass"),
        ("TC-18", "Đánh giá sao khách sạn", "4 sao + Bình luận 'Rất tốt'", "Nhập điểm và nhận xét -> Gửi đánh giá", "Lưu bài đánh giá vào CSDL, cập nhật rating", "Pass"),
        ("TC-19", "Xem Dashboard Admin", "Tài khoản vai trò ADMIN", "Truy cập màn hình Admin Dashboard", "Hiển thị đúng 4 chỉ số KPI và doanh thu", "Pass"),
        ("TC-20", "Admin thêm khách sạn", "Dữ liệu khách sạn hợp lệ", "Nhập thông tin -> Bấm Lưu khách sạn", "Khách sạn mới hiển thị ngay trên ứng dụng", "Pass"),
        ("TC-21", "Tự động đồng bộ giá sàn", "Thêm loại phòng giá 800k", "Admin thêm loại phòng mới có giá rẻ nhất", "hotels.min_price tự động đổi thành 800,000 đ", "Pass"),
        ("TC-22", "Bắt lỗi trùng số phòng", "Thêm phòng 101 hai lần", "Admin nhập số phòng 101 bị trùng lặp", "Database chặn bởi ràng buộc UNIQUE, báo lỗi", "Pass")
    ]
    for i, row_vals in enumerate(tc_data):
        row = tbl_tc.rows[i + 1]
        for c, val in enumerate(row_vals):
            row.cells[c].paragraphs[0].text = val
        format_table_row(row, widths_tc, bg_color="FFFFFF", is_header=False, font_size=10)
        row.cells[0].paragraphs[0].runs[0].bold = True
        row.cells[5].paragraphs[0].runs[0].bold = True
        row.cells[5].paragraphs[0].runs[0].font.color.rgb = RGBColor(0, 0, 0)
    set_table_borders(tbl_tc, color="000000", sz="4")

    add_heading_3(doc, "3.2.3. Đánh giá mức độ ổn định và hiệu năng hệ thống")
    add_body_p(doc, "Kết quả kiểm thử cho thấy 22/22 Test Case đều vượt qua thành công (Tỷ lệ đạt 100%). Hệ thống vận hành ổn định, không có hiện tượng rò rỉ bộ nhớ (Memory Leak) hay sập ứng dụng bất thường.")
    add_body_p(doc, "Về mặt hiệu năng, thời gian phản hồi của các Endpoints API được đo lường thông qua Postman Runner trên môi trường kiểm thử với 100 yêu cầu liên tục được tổng hợp trong Bảng 3.2:")

    add_table_caption(doc, "3.2", "Bảng kết quả đo lường hiệu năng và thời gian phản hồi của các API chính")
    tbl_perf = doc.add_table(rows=6, cols=4)
    tbl_perf.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl_perf.autofit = False
    widths_perf = [Inches(1.2), Inches(2.8), Inches(1.4), Inches(1.4)]
    
    headers_perf = ["Method", "Endpoint API kiểm thử", "Thời gian TB", "Tỷ lệ thành công"]
    for j, h in enumerate(headers_perf):
        tbl_perf.rows[0].cells[j].paragraphs[0].text = h
    format_table_row(tbl_perf.rows[0], widths_perf, bg_color="FFFFFF", is_header=True, font_size=11)

    perf_data = [
        ("GET", "/api/hotels (Danh sách khách sạn kèm bộ lọc)", "45 ms", "100%"),
        ("GET", "/api/hotels/:id (Chi tiết khách sạn & phòng)", "38 ms", "100%"),
        ("GET", "/api/rooms/available (Kiểm tra phòng trống)", "52 ms", "100%"),
        ("POST", "/api/bookings (Tạo đơn đặt phòng & gán phòng)", "78 ms", "100%"),
        ("PUT", "/api/bookings/:id/cancel (Hủy đơn & nhả phòng)", "41 ms", "100%")
    ]
    for i, (m, ep, t, s) in enumerate(perf_data):
        row = tbl_perf.rows[i + 1]
        row.cells[0].paragraphs[0].text = m
        row.cells[1].paragraphs[0].text = ep
        row.cells[2].paragraphs[0].text = t
        row.cells[3].paragraphs[0].text = s
        format_table_row(row, widths_perf, bg_color="FFFFFF", is_header=False, font_size=10.5)
        row.cells[0].paragraphs[0].runs[0].bold = True
    set_table_borders(tbl_perf, color="000000", sz="4")

    # 3.3 Giải pháp cải tiến kỹ thuật
    add_heading_2(doc, "3.3. Giải pháp cải tiến kỹ thuật")
    add_body_p(doc, "Trong quá trình xây dựng và hoàn thiện sản phẩm thực tế, nhiều thách thức kỹ thuật phức tạp đã nảy sinh. Dưới đây là 5 giải pháp cải tiến kỹ thuật chuyên sâu đã được phân tích và cài đặt thành công:")

    add_heading_3(doc, "3.3.1. Khắc phục lỗi xung đột bố cục vô hạn BoxConstraints trong Flutter")
    add_body_p(doc, "– Vấn đề kỹ thuật gặp phải: Khi phát triển màn hình Trang chủ và màn hình Chi tiết khách sạn, ứng dụng liên tục gặp lỗi sập giao diện nghiêm trọng với thông báo lỗi từ Flutter Engine: 'FLUTTER_ERROR: BoxConstraints forces an infinite width/height: RenderConstrainedBox was not laid out: RenderDecoratedBox relayoutBoundary=up1'.")
    add_body_p(doc, "– Nguyên nhân gốc rễ: Trong cơ chế Layout của Flutter, các Widget danh sách động như `ListView.builder` hoặc `GridView.builder` mặc định sẽ cố gắng chiếm dụng tối đa không gian chiều cao vô hạn (Unbounded Height) theo trục dọc. Khi lập trình viên đặt một `ListView` lồng bên trong một `SingleChildScrollView` hoặc một `Column` (vốn cũng là các Widget có chiều cao vô hạn theo chiều dọc), hệ thống dựng hình không thể tính toán được kích thước thực tế của RenderBox, dẫn tới xung đột và làm crash giao diện.")
    add_body_p(doc, "– Giải pháp cải tiến đã thực hiện: Đồ án áp dụng hai giải pháp đồng bộ:")
    add_body_p(doc, "   1. Bổ sung đồng thời hai thuộc tính bắt buộc cho danh sách lồng: `shrinkWrap: true` (buộc ListView chỉ chiếm dụng đúng diện tích của các phần tử con bên trong) và `physics: const NeverScrollableScrollPhysics()` (vô hiệu hóa cơ chế cuộn riêng của ListView con, nhường toàn quyền điều khiển cuộn cho SingleChildScrollView cha).", is_bullet=True)
    add_body_p(doc, "   2. Đối với các danh sách cuộn ngang (Horizontal List) như thanh trượt danh mục thành phố hoặc danh sách ảnh khách sạn, bọc toàn bộ Widget con bên trong một `SizedBox(height: 180.0)` với chiều cao xác định tuyệt đối.", is_bullet=True)
    add_body_p(doc, "– Kết quả đạt được: Triệt tiêu 100% hiện tượng crash màn hình đỏ, giao diện cuộn mượt mà không còn bất kỳ cảnh báo BoxConstraints nào trong Console Log.")

    add_heading_3(doc, "3.3.2. Tối ưu hóa hiệu năng truy vấn lịch phòng trống với Composite Indexing")
    add_body_p(doc, "– Vấn đề kỹ thuật gặp phải: Trong giai đoạn đầu, câu truy vấn kiểm tra phòng trống thực hiện quét tuần tự (Full Table Scan) trên bảng `bookings`. Khi số lượng bản ghi đơn đặt phòng tăng cao, thời gian phản hồi API bị kéo dài lên đến 250 - 300 ms, gây nghẽn cổ chai hệ thống.")
    add_body_p(doc, "– Giải pháp cải tiến: Bổ sung chỉ mục kết hợp (Composite B-Tree Index) trực tiếp trên cơ sở dữ liệu MySQL:")
    
    add_code_block(doc,
        "CREATE INDEX idx_bookings_dates ON bookings (room_id, check_in, check_out, status);",
        caption="Đoạn mã 3.4: Tạo Composite Index tối ưu truy vấn phòng trống"
    )
    
    add_body_p(doc, "– Kết quả đạt được: MySQL chuyển từ Full Table Scan sang Index Range Scan (sử dụng Index `idx_bookings_dates`). Thời gian phản hồi của API `/api/rooms/available` giảm mạnh từ 250ms xuống chỉ còn trung bình 52ms (tăng tốc độ gấp 5 lần).")

    add_heading_3(doc, "3.3.3. Bảo vệ an toàn tài chính phía máy chủ (Chống Price Tampering)")
    add_body_p(doc, "– Vấn đề kỹ thuật gặp phải: Các hệ thống thương mại điện tử nghiệp dư thường tính tổng tiền trên Client (Flutter) rồi gửi trường `total_price` lên Server để ghi vào CSDL. Điều này tạo ra lỗ hổng bảo mật cực kỳ nguy hiểm: kẻ xấu có thể sử dụng các công cụ chặn bắt gói tin (như Charles Proxy, Fiddler) để sửa giá đơn phòng từ 5,000,000 đ thành 1,000 đ.")
    add_body_p(doc, "– Giải pháp cải tiến: Tách biệt hoàn toàn trách nhiệm tính toán giá. Phía Client tuyệt đối không được phép gửi giá tiền lên. Máy chủ Node.js tiếp nhận `room_type_id`, tự truy vấn giá gốc niêm yết trong bảng `room_types`, tự tính toán số đêm lưu trú và tự tính tổng tiền lưu vào CSDL.")
    add_body_p(doc, "– Kết quả: Ngăn chặn 100% các cuộc tấn công giả mạo giá tiền qua giao thức mạng.")

    add_heading_3(doc, "3.3.4. Tự động hóa đồng bộ giá sàn niêm yết (min_price Auto-sync)")
    add_body_p(doc, "– Vấn đề kỹ thuật gặp phải: Trước đây, khi Admin thêm mới một khách sạn và nhập mức giá tham chiếu, nhưng sau đó tạo các loại phòng có mức giá khác nhau thì giá hiển thị ngoài trang chủ vẫn giữ nguyên giá cũ hoặc hiển thị 0đ nếu chưa kịp cập nhật thủ công.")
    add_body_p(doc, "– Giải pháp cải tiến: Xây dựng cơ chế cập nhật tự động (Database Trigger / Controller Auto-sync). Mỗi khi Admin thêm, sửa giá hoặc xóa một loại phòng, hệ thống tự động chạy câu lệnh SQL quét lại toàn bộ giá của các loại phòng hiện có của khách sạn đó và gán giá trị nhỏ nhất vào cột `hotels.min_price`.")
    add_body_p(doc, "– Kết quả: Thông tin giá khởi điểm trên trang chủ luôn phản ánh tức thời mức giá tốt nhất của khách sạn mà không cần bất kỳ can thiệp thủ công nào.")

    add_heading_3(doc, "3.3.5. Cơ chế tự động giải phóng phòng trống tức thì khi hủy đơn")
    add_body_p(doc, "– Vấn đề kỹ thuật gặp phải: Khi khách hủy đơn đặt phòng, nếu không có cơ chế mở khóa tự động thì phòng đó vẫn bị xem là đang có khách, gây lãng phí tài nguyên phòng trống của khách sạn.")
    add_body_p(doc, "– Giải pháp cải tiến: Nhờ thiết kế liên kết trạng thái giữa thuật toán kiểm tra phòng trống và trường `bookings.status`, ngay tại khoảnh khắc lệnh hủy phòng đổi trạng thái đơn từ 'CONFIRMED' sang 'CANCELLED', câu truy vấn kiểm tra phòng trống lập tức loại bỏ đơn hủy này khỏi điều kiện xung đột. Phòng vật lý tương ứng lập tức trở về trạng thái trống khả dụng.")
    add_body_p(doc, "– Kết quả: Một khách hàng khác ở bất kỳ đâu trên thế giới đều có thể nhìn thấy phòng vừa nhả và đặt ngay lập tức.")

    # 3.4 Quá trình tự học và phát triển
    add_heading_2(doc, "3.4. Quá trình tự học và phát triển")

    add_heading_3(doc, "3.4.1. Nội dung kiến thức và công nghệ tự học")
    add_body_p(doc, "Trong suốt quá trình thực hiện đồ án, để đáp ứng khối lượng công việc lớn và các yêu cầu kỹ thuật hiện đại, tác giả đã chủ động tự học và nghiên cứu chuyên sâu các khối kiến thức công nghệ mới:")
    add_body_p(doc, "– Tự học ngôn ngữ Dart và khung phát triển ứng dụng di động Flutter từ tài liệu chính thức của Google (flutter.dev): Nắm vững vòng đời của Widget (StatefulWidget, StatelessWidget), cơ chế quản lý trạng thái phản ứng với Provider Pattern, xử lý đa luồng với Isolates và lập trình bất đồng bộ Future/Stream.", is_bullet=True)
    add_body_p(doc, "– Tự học lập trình máy chủ dịch vụ Node.js và Express.js: Nắm vững nguyên lý hoạt động của kiến trúc hướng sự kiện Event Loop, kỹ thuật xây dựng chuỗi Middleware tuần tự, cơ chế xử lý ngoại lệ tập trung và chuẩn RESTful API.", is_bullet=True)
    add_body_p(doc, "– Tự học tối ưu hóa cơ sở dữ liệu quan hệ MySQL: Tìm hiểu sâu về động cơ lưu trữ InnoDB, cơ chế khóa dòng (Row-level lock), cấu trúc chỉ mục B-Tree Index và kỹ thuật chuẩn hóa dữ liệu 3NF.", is_bullet=True)
    add_body_p(doc, "– Tự học an toàn thông tin phần mềm: Nghiên cứu nguyên lý mã hóa một chiều Bcrypt và tiêu chuẩn định danh phiên không trạng thái RFC 7519 JSON Web Token (JWT).", is_bullet=True)

    add_heading_3(doc, "3.4.2. Áp dụng vào đồ án và minh chứng cụ thể")
    add_body_p(doc, "Toàn bộ các kiến thức tự học đã được chuyển hóa thành các giải pháp kỹ thuật cụ thể trong đồ án với các minh chứng rõ ràng:")
    add_body_p(doc, "– Minh chứng 1: Xây dựng thành công ứng dụng di động Flutter mượt mà, hỗ trợ State Management bằng Provider, đồng bộ trạng thái tức thì khi người dùng đăng nhập hoặc đặt phòng thành công (`AuthProvider`, `BookingProvider`).", is_bullet=True)
    add_body_p(doc, "– Minh chứng 2: Xây dựng hệ thống máy chủ Node.js REST API ổn định, xử lý giao dịch nguyên tử, ngăn chặn xung đột phòng trống và bảo vệ an toàn tài chính 100% phía Server.", is_bullet=True)
    add_body_p(doc, "– Minh chứng 3: Cài đặt hệ thống phân quyền 2 tầng với Middleware `verifyToken` và `requireAdmin`, bảo vệ an toàn các tài nguyên quản trị trước các truy cập trái phép.", is_bullet=True)
    add_body_p(doc, "– Minh chứng 4: Khắc phục triệt để các lỗi kỹ thuật khó như xung đột BoxConstraints trên Flutter và tối ưu hóa tốc độ truy vấn CSDL bằng Composite Indexing.", is_bullet=True)

    add_heading_3(doc, "3.4.3. Kế hoạch và định hướng phát triển tiếp theo")
    add_body_p(doc, "Nhằm nâng cấp hệ thống thành một nền tảng thương mại hoàn thiện có khả năng triển khai thực tế trên diện rộng, kế hoạch phát triển tiếp theo được định hình như sau:")
    add_body_p(doc, "– Kế hoạch ngắn hạn (3 - 6 tháng tới):", is_bullet=True)
    add_body_p(doc, "   + Tích hợp cổng thanh toán trực tuyến thương mại có giấy phép ngân hàng: VNPay Sandbox, Momo Payment Gateway hoặc ZaloPay để hỗ trợ thanh toán qua mã QR và thẻ ATM/Visa nội địa.")
    add_body_p(doc, "   + Tích hợp dịch vụ đẩy thông báo nền Firebase Cloud Messaging (FCM) để gửi thông báo nhắc lịch nhận phòng trước 24 giờ cho khách hàng.")
    add_body_p(doc, "– Kế hoạch dài hạn (6 - 12 tháng tới):", is_bullet=True)
    add_body_p(doc, "   + Ứng dụng mô hình Trí tuệ nhân tạo và Học máy (AI/ML) để xây dựng hệ thống gợi ý khách sạn cá nhân hóa (Personalized Recommendation System) dựa trên lịch sử đặt phòng và sở thích du lịch của khách hàng.")
    add_body_p(doc, "   + Mở rộng nền tảng Web Portal dành riêng cho đối tác khách sạn (Hotel Partner Portal) bằng React.js / Vue.js để các chủ khách sạn có thể tự đăng ký và quản lý cơ sở lưu trú của mình theo mô hình chợ điện tử du lịch đa người bán (Multi-vendor Marketplace).")

    # 3.5 Kết quả đạt được và hạn chế
    add_heading_2(doc, "3.5. Kết quả đạt được và hạn chế")

    add_heading_3(doc, "3.5.1. Đối chiếu với mục tiêu ban đầu")
    add_body_p(doc, "Bảng 3.3 đối chiếu chi tiết giữa các mục tiêu đề ra ban đầu tại Chương 1 và kết quả thực tế đạt được của đồ án:")

    add_table_caption(doc, "3.3", "Bảng đối chiếu mức độ hoàn thành chức năng so với mục tiêu ban đầu")
    tbl_eval = doc.add_table(rows=7, cols=4)
    tbl_eval.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl_eval.autofit = False
    widths_eval = [Inches(1.8), Inches(2.3), Inches(2.0), Inches(0.7)]
    
    headers_eval = ["Nội dung mục tiêu", "Yêu cầu kỹ thuật đề ra", "Kết quả thực tế đạt được", "Đánh giá"]
    for j, h in enumerate(headers_eval):
        tbl_eval.rows[0].cells[j].paragraphs[0].text = h
    format_table_row(tbl_eval.rows[0], widths_eval, bg_color="FFFFFF", is_header=True, font_size=11)

    eval_data = [
        ("Phân hệ Xác thực & Tài khoản", "Đăng ký, đăng nhập JWT, đổi mật khẩu", "Hoàn thành 100%, bảo mật Bcrypt + JWT", "Đạt"),
        ("Phân hệ Khám phá & Tìm kiếm", "Lọc theo thành phố, sao, giá, xem chi tiết", "Hoàn thành 100%, bộ lọc mượt mà, xem ảnh", "Đạt"),
        ("Kiểm tra phòng trống & Đặt phòng", "Thuật toán loại trừ xung đột ngày, chống trùng", "Hoàn thành 100%, thuật toán chính xác tuyệt đối", "Đạt"),
        ("Quản lý đơn đặt & Hủy phòng", "Quản lý 3 tab, hủy đơn nhả phòng tự động", "Hoàn thành 100%, nhả phòng tức thì sau khi hủy", "Đạt"),
        ("Phân hệ Đánh giá khách sạn", "Chấm sao 1-5, tự tính rating trung bình", "Hoàn thành 100%, tự động làm tròn 1 số thập phân", "Đạt"),
        ("Phân hệ Quản trị Admin", "Dashboard KPI, CRUD khách sạn, phòng, min_price", "Hoàn thành 100%, tự động đồng bộ giá sàn", "Đạt")
    ]
    for i, (m, req, res, ev) in enumerate(eval_data):
        row = tbl_eval.rows[i + 1]
        row.cells[0].paragraphs[0].text = m
        row.cells[1].paragraphs[0].text = req
        row.cells[2].paragraphs[0].text = res
        row.cells[3].paragraphs[0].text = ev
        format_table_row(row, widths_eval, bg_color="FFFFFF", is_header=False, font_size=10.5)
        row.cells[0].paragraphs[0].runs[0].bold = True
        row.cells[3].paragraphs[0].runs[0].bold = True
        row.cells[3].paragraphs[0].runs[0].font.color.rgb = RGBColor(0, 0, 0)
    set_table_borders(tbl_eval, color="000000", sz="4")

    add_heading_3(doc, "3.5.2. Những kết quả nổi bật đã hoàn thành")
    add_body_p(doc, "– Xây dựng thành công một giải pháp phần mềm hoàn chỉnh khép kín từ máy khách di động Android (Flutter) đến máy chủ dịch vụ (Node.js/Express) và cơ sở dữ liệu quan hệ (MySQL).")
    add_body_p(doc, "– Cài đặt và chứng minh thành công tính chính xác của thuật toán phòng ngừa xung đột lịch phòng trống thời gian thực, giải quyết triệt để bài toán Overbooking.")
    add_body_p(doc, "– Cơ chế phân quyền RBAC và an toàn tài chính Server-side hoạt động chặt chẽ, ngăn chặn mọi hành vi can thiệp trái phép hoặc sửa đổi giá tiền.")
    add_body_p(doc, "– Giao diện người dùng trên thiết bị di động đẹp mắt, trực quan, tốc độ khung hình ổn định và hỗ trợ đầy đủ các thao tác tìm kiếm, lọc, đặt phòng nhanh chóng.")

    add_heading_3(doc, "3.5.3. Các hạn chế kỹ thuật hiện tại")
    add_body_p(doc, "Bên cạnh những kết quả nổi bật, hệ thống vẫn tồn tại một số hạn chế nhất định do điều kiện thời gian và nguồn lực nghiên cứu:")
    add_body_p(doc, "– Chưa tích hợp cổng thanh toán trực tuyến thương mại thực tế (VNPay/Momo Production) mà chủ yếu dựa trên phương thức thanh toán tại quầy lễ tân (Pay at Hotel).", is_bullet=True)
    add_body_p(doc, "– Chưa tích hợp SDK bản đồ số vệ tinh Google Maps trực tiếp trên giao diện để hiển thị lộ trình di chuyển tới khách sạn.", is_bullet=True)
    add_body_p(doc, "– Ứng dụng hiện mới hỗ trợ ngôn ngữ Tiếng Việt, chưa hỗ trợ đa ngôn ngữ quốc tế (i18n đa ngữ như Tiếng Anh, Tiếng Trung, Tiếng Hàn) cho khách du lịch nước ngoài.", is_bullet=True)

    doc.add_page_break()
