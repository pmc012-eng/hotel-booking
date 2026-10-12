# -*- coding: utf-8 -*-
"""
Module conclusion_appendix:
- KẾT LUẬN (Part of Section 2 - Body)
- TÀI LIỆU THAM KHẢO & PHỤ LỤC (Part of Section 3 - Post-body)
"""

import docx
from docx.shared import Cm, Pt, Inches, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from report_builder.helpers import (
    add_special_title, add_heading_2, add_heading_3, add_body_p, add_code_block
)

def add_conclusion(doc):
    """Phần KẾT LUẬN (Thuộc Phần thân chính Section 2)."""
    add_special_title(doc, "KẾT LUẬN")

    add_heading_2(doc, "1. Tổng kết kết quả nghiên cứu của đồ án")
    add_body_p(doc, "Sau quá trình nghiên cứu lý thuyết, khảo sát nghiệp vụ thực tiễn và triển khai kỹ thuật nghiêm túc, đồ án đã hoàn thành xuất sắc toàn bộ các mục tiêu đề ra ban đầu, xây dựng thành công một hệ sinh thái phần mềm đặt phòng khách sạn trực tuyến hoàn chỉnh trên nền tảng di động Android kết hợp hệ thống dịch vụ RESTful API.")
    add_body_p(doc, "Các đóng góp và kết quả cốt lõi của đồ án bao gồm:")
    add_body_p(doc, "– Về mặt kiến trúc và thiết kế: Đồ án đã thiết lập thành công mô hình kiến trúc phân tầng 3 lớp (Client - Server - Database) chuẩn mực, tạo sự độc lập hoàn toàn giữa giao diện người dùng di động và logic xử lý nghiệp vụ máy chủ. Cơ sở dữ liệu quan hệ được chuẩn hóa đạt chuẩn 3NF với 7 thực thể dữ liệu gắn kết chặt chẽ qua các ràng buộc toàn vẹn tham chiếu CASCADE.", is_bullet=True)
    add_body_p(doc, "– Về mặt thuật toán nghiệp vụ: Đã xây dựng và chứng minh thành công tính chính xác của thuật toán kiểm tra tính khả dụng phòng trống theo thời gian thực (Real-time Availability Engine) dựa trên công thức toán học loại trừ giao cắt lịch, giải quyết triệt để bài toán nan giải về xung đột trùng phòng (Overbooking).", is_bullet=True)
    add_body_p(doc, "– Về mặt an toàn thông tin: Cài đặt hệ thống bảo mật đa tầng với chuẩn băm mật khẩu một chiều Bcrypt và cơ chế xác thực phiên không trạng thái JSON Web Token (JWT), kết hợp bộ lọc phân quyền hai cấp độ (RBAC Middleware) bảo vệ nghiêm ngặt các tài nguyên quản trị.", is_bullet=True)
    add_body_p(doc, "– Về sản phẩm ứng dụng: Đóng gói thành công ứng dụng di động Flutter trên thiết bị Android (app-release.apk) với giao diện Material Design trực quan, mượt mà, hỗ trợ bộ lọc thông minh, quy trình đặt phòng 2 bước tiện lợi và cơ chế tự động giải phóng phòng trống ngay lập tức khi hủy đơn.", is_bullet=True)
    add_body_p(doc, "– Về kiểm thử chất lượng: Toàn bộ 22 Test Case kiểm thử chức năng bao phủ 6 phân hệ đều vượt qua thành công với tỷ lệ 100%, thời gian phản hồi API đạt tốc độ ấn tượng dưới 100ms trên môi trường kiểm thử.", is_bullet=True)

    add_heading_2(doc, "2. Bài học kinh nghiệm rút ra")
    add_body_p(doc, "Quá trình thực hiện đồ án đã mang lại cho tác giả những bài học kinh nghiệm vô cùng quý giá về chuyên môn và kỹ năng nghề nghiệp:")
    add_body_p(doc, "– Nâng cao tư duy kiến trúc phần mềm: Hiểu rõ tầm quan trọng của việc phân tầng hệ thống và nguyên lý trách nhiệm đơn lẻ (Single Responsibility Principle). Việc tách biệt hoàn toàn giữa Client và Server giúp quá trình nâng cấp, sửa đổi mã nguồn trở nên độc lập và an toàn hơn.", is_bullet=True)
    add_body_p(doc, "– Kỹ năng xử lý lỗi kỹ thuật khó (Troubleshooting): Học được phương pháp chẩn đoán nguyên nhân gốc rễ và xử lý triệt để các bài toán kỹ thuật phức tạp như lỗi bố cục vô hạn BoxConstraints trong Flutter và tối ưu hóa truy vấn CSDL bằng Composite Indexing.", is_bullet=True)
    add_body_p(doc, "– Tầm quan trọng của an toàn tài chính: Nhận thức sâu sắc rằng trong các ứng dụng thương mại điện tử, máy chủ (Backend) phải là chốt chặn cuối cùng kiểm soát toàn bộ tính toán tiền tệ, tuyệt đối không bao giờ tin cậy dữ liệu tính toán từ máy khách.", is_bullet=True)
    add_body_p(doc, "– Kỹ năng tự học và thích ứng công nghệ mới: Rèn luyện khả năng đọc hiểu tài liệu kỹ thuật quốc tế, khai thác các thư viện mã nguồn mở và làm chủ các công cụ lập trình hiện đại.", is_bullet=True)

    add_heading_2(doc, "3. Hướng nghiên cứu và phát triển trong tương lai")
    add_body_p(doc, "Để đưa sản phẩm từ môi trường nghiên cứu ứng dụng vào khai thác thương mại quy mô lớn trên thị trường, định hướng nghiên cứu tiếp theo sẽ tập trung vào các hướng đi chiến lược:")
    add_body_p(doc, "– Tích hợp cổng thanh toán trực tuyến chính thức có bảo chứng pháp lý (VNPay / Momo / ZaloPay Gateway) để hỗ trợ đầy đủ các phương thức thanh toán không tiền mặt.", is_bullet=True)
    add_body_p(doc, "– Tích hợp dịch vụ Firebase Cloud Messaging (FCM) để gửi thông báo đẩy tự động nhắc lịch nhận phòng và các chương trình khuyến mãi theo thời gian thực.", is_bullet=True)
    add_body_p(doc, "– Ứng dụng Trí tuệ nhân tạo và Học máy (AI/ML) để phát triển hệ thống gợi ý khách sạn cá nhân hóa (Personalized Hotel Recommendation) và định giá phòng linh hoạt (Dynamic Pricing Engine) theo quy luật cung - cầu thị trường.", is_bullet=True)
    add_body_p(doc, "– Mở rộng sang nền tảng iOS và xây dựng cổng thông tin quản trị Web Portal hoàn chỉnh dành riêng cho các chủ khách sạn đối tác.", is_bullet=True)

def add_references_and_appendices(doc):
    """Phần TÀI LIỆU THAM KHẢO và PHỤ LỤC (Thuộc Section 3 - Hậu kỳ báo cáo)."""
    # =========================================================================
    # TÀI LIỆU THAM KHẢO
    # =========================================================================
    add_special_title(doc, "TÀI LIỆU THAM KHẢO")
    
    refs = [
        "[1] Đặng Văn Đức (2018), Phân tích và thiết kế hệ thống hướng đối tượng với UML, Nhà xuất bản Giáo dục Việt Nam.",
        "[2] Nguyễn Văn Ba (2020), Cơ sở dữ liệu và Hệ quản trị cơ sở dữ liệu quan hệ, Nhà xuất bản Đại học Quốc gia Hà Nội.",
        "[3] Đoàn Văn Ban (2021), Giáo trình Kỹ thuật Phần mềm Nâng cao, Nhà xuất bản Khoa học và Kỹ thuật.",
        "[4] Eric Evans (2003), Domain-Driven Design: Tackling Complexity in the Heart of Software, Addison-Wesley Professional.",
        "[5] Robert C. Martin (2017), Clean Architecture: A Craftsman's Guide to Software Structure and Design, Prentice Hall.",
        "[6] Marco L. Napoli (2020), Beginning Flutter: A Hands On Guide to App Development, Wrox / John Wiley & Sons, Inc.",
        "[7] Google Developers (2024), Flutter Documentation and Architecture Guide, Website chính thức: https://flutter.dev/docs (Truy cập tháng 09/2026).",
        "[8] Dart Language Team (2024), A Tour of the Dart Language and Sound Null Safety, Website: https://dart.dev/guides (Truy cập tháng 09/2026).",
        "[9] Mario Casciaro, Luciano Mammino (2020), Node.js Design Patterns: Design and implement production-grade Node.js applications, 3rd Edition, Packt Publishing.",
        "[10] Express.js Foundation (2024), Express.js Web Application Framework Documentation, Website: https://expressjs.com (Truy cập tháng 09/2026).",
        "[11] Baron Schwartz, Peter Zaitsev, Vadim Tkachenko (2012), High Performance MySQL: Optimization, Backups, and Replication, 3rd Edition, O'Reilly Media.",
        "[12] MySQL Documentation Team (2024), MySQL 8.0 Reference Manual: InnoDB Storage Engine and Locking, Oracle Corporation, https://dev.mysql.com/doc/ (Truy cập tháng 09/2026).",
        "[13] Michael Jones, John Bradley, Nat Sakimura (2015), JSON Web Token (JWT) - RFC 7519, Internet Engineering Task Force (IETF), https://datatracker.ietf.org/doc/html/rfc7519.",
        "[14] Niels Provos, David Mazières (1999), A Future-Adaptable Password Scheme (Bcrypt), USENIX Annual Technical Conference.",
        "[15] Roy Thomas Fielding (2000), Architectural Styles and the Design of Network-based Software Architectures, Doctoral Dissertation, University of California, Irvine."
    ]
    for r in refs:
        p_r = doc.add_paragraph()
        p_r.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
        p_r.paragraph_format.line_spacing = 1.3
        p_r.paragraph_format.space_before = Pt(2)
        p_r.paragraph_format.space_after = Pt(4)
        p_r.paragraph_format.left_indent = Cm(1.27)
        p_r.paragraph_format.first_line_indent = Cm(-1.27)
        run_r = p_r.add_run(r)
        run_r.font.name = 'Times New Roman'
        run_r.font.size = Pt(13)

    doc.add_page_break()

    # =========================================================================
    # PHỤ LỤC
    # =========================================================================
    add_special_title(doc, "PHỤ LỤC")

    # Phụ lục A
    add_heading_2(doc, "Phụ lục A: Hướng dẫn Cài đặt, Cấu hình và Vận hành Hệ thống")
    add_body_p(doc, "1. Yêu cầu tiên quyết về môi trường phần mềm:")
    add_body_p(doc, "   – Node.js (phiên bản LTS v18 trở lên) và npm được cài đặt trên hệ điều hành.", is_bullet=True)
    add_body_p(doc, "   – Hệ quản trị cơ sở dữ liệu MySQL Server 8.0 đã được cài đặt và đang chạy dịch vụ tại cổng 3306.", is_bullet=True)
    add_body_p(doc, "   – Flutter SDK (phiên bản 3.24 trở lên) và Android SDK Command-line Tools / Android Studio.", is_bullet=True)
    add_body_p(doc, "2. Cấu hình và khởi động máy chủ Backend:")
    add_body_p(doc, "   – Bước 1: Mở cửa sổ dòng lệnh tại thư mục backend/.")
    add_body_p(doc, "   – Bước 2: Cài đặt các gói phụ thuộc cần thiết bằng lệnh:")
    add_body_p(doc, "     npm install")
    add_body_p(doc, "   – Bước 3: Tạo tệp cấu hình .env dựa trên .env.example với các tham số:")
    add_body_p(doc, "     PORT=5000\n     DB_HOST=localhost\n     DB_PORT=3306\n     DB_USER=root\n     DB_PASSWORD=your_password\n     DB_NAME=hotel_booking_db\n     JWT_SECRET=super_secret_hotel_booking_key_2026\n     JWT_EXPIRES_IN=7d")
    add_body_p(doc, "   – Bước 4: Khởi tạo cấu trúc cơ sở dữ liệu và nạp dữ liệu mẫu bằng lệnh:")
    add_body_p(doc, "     npm run init-db  (hoặc chạy trực tiếp tệp src/config/schema.sql trong MySQL)")
    add_body_p(doc, "   – Bước 5: Khởi động máy chủ dịch vụ bằng lệnh:")
    add_body_p(doc, "     npm run dev  (hoặc node server.js). Khi thành công, console sẽ hiển thị thông báo: 'Server running on port 5000' và 'Database connected successfully'.")
    add_body_p(doc, "3. Khởi động và chạy ứng dụng di động Flutter:")
    add_body_p(doc, "   – Bước 1: Mở cửa sổ dòng lệnh tại thư mục hotel_booking_app/.")
    add_body_p(doc, "   – Bước 2: Tải các gói thư viện Flutter bằng lệnh: flutter pub get.")
    add_body_p(doc, "   – Bước 3: Kết nối thiết bị di động Android qua cáp USB (bật chế độ USB Debugging) hoặc khởi động máy ảo Android Emulator.")
    add_body_p(doc, "   – Bước 4: Chạy ứng dụng bằng lệnh: flutter run.")
    add_body_p(doc, "   – Bước 5: Để đóng gói tệp cài đặt chính thức ra máy thật: flutter build apk --release -> Gói tệp cài đặt sẽ được tạo tại đường dẫn build/app/outputs/flutter-apk/app-release.apk.")

    # Phụ lục B
    add_heading_2(doc, "Phụ lục B: Kịch bản Cơ sở Dữ liệu SQL Hoàn chỉnh (Full DDL Schema)")
    add_body_p(doc, "Dưới đây là kịch bản SQL toàn vẹn được sử dụng để khởi tạo toàn bộ 7 bảng trong cơ sở dữ liệu hotel_booking_db:")
    
    schema_sql = (
        "-- Hotel Booking Database Schema (InnoDB, utf8mb4)\n"
        "CREATE DATABASE IF NOT EXISTS `hotel_booking_db`\n"
        "  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;\n"
        "USE `hotel_booking_db`;\n\n"
        "-- 1. Bảng users\n"
        "CREATE TABLE IF NOT EXISTS `users` (\n"
        "  `id` INT AUTO_INCREMENT PRIMARY KEY,\n"
        "  `name` VARCHAR(100) NOT NULL,\n"
        "  `email` VARCHAR(100) NOT NULL UNIQUE,\n"
        "  `password` VARCHAR(255) NOT NULL,\n"
        "  `phone` VARCHAR(20) NULL,\n"
        "  `role` ENUM('USER', 'ADMIN') NOT NULL DEFAULT 'USER',\n"
        "  `avatar` VARCHAR(255) NULL,\n"
        "  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,\n"
        "  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,\n"
        "  INDEX `idx_users_email` (`email`)\n"
        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\n\n"
        "-- 2. Bảng hotels\n"
        "CREATE TABLE IF NOT EXISTS `hotels` (\n"
        "  `id` INT AUTO_INCREMENT PRIMARY KEY,\n"
        "  `name` VARCHAR(255) NOT NULL,\n"
        "  `description` TEXT NULL,\n"
        "  `address` VARCHAR(255) NOT NULL,\n"
        "  `city` VARCHAR(100) NOT NULL,\n"
        "  `star` TINYINT NOT NULL DEFAULT 4,\n"
        "  `rating` DECIMAL(2,1) NOT NULL DEFAULT 4.5,\n"
        "  `min_price` DECIMAL(12,2) NOT NULL DEFAULT 0,\n"
        "  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,\n"
        "  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,\n"
        "  INDEX `idx_hotels_city` (`city`),\n"
        "  INDEX `idx_hotels_name` (`name`),\n"
        "  INDEX `idx_hotels_star` (`star`)\n"
        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\n\n"
        "-- 3. Bảng hotel_images\n"
        "CREATE TABLE IF NOT EXISTS `hotel_images` (\n"
        "  `id` INT AUTO_INCREMENT PRIMARY KEY,\n"
        "  `hotel_id` INT NOT NULL,\n"
        "  `image_url` VARCHAR(255) NOT NULL,\n"
        "  `is_primary` BOOLEAN NOT NULL DEFAULT FALSE,\n"
        "  FOREIGN KEY (`hotel_id`) REFERENCES `hotels`(`id`) ON DELETE CASCADE\n"
        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\n\n"
        "-- 4. Bảng room_types\n"
        "CREATE TABLE IF NOT EXISTS `room_types` (\n"
        "  `id` INT AUTO_INCREMENT PRIMARY KEY,\n"
        "  `hotel_id` INT NOT NULL,\n"
        "  `name` VARCHAR(100) NOT NULL,\n"
        "  `description` TEXT NULL,\n"
        "  `capacity` INT NOT NULL DEFAULT 2,\n"
        "  `price` DECIMAL(12,2) NOT NULL,\n"
        "  `image_url` VARCHAR(255) NULL,\n"
        "  `amenities` TEXT NULL,\n"
        "  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,\n"
        "  FOREIGN KEY (`hotel_id`) REFERENCES `hotels`(`id`) ON DELETE CASCADE\n"
        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\n\n"
        "-- 5. Bảng rooms\n"
        "CREATE TABLE IF NOT EXISTS `rooms` (\n"
        "  `id` INT AUTO_INCREMENT PRIMARY KEY,\n"
        "  `hotel_id` INT NOT NULL,\n"
        "  `room_type_id` INT NOT NULL,\n"
        "  `room_number` VARCHAR(20) NOT NULL,\n"
        "  `status` ENUM('AVAILABLE', 'MAINTENANCE') NOT NULL DEFAULT 'AVAILABLE',\n"
        "  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,\n"
        "  FOREIGN KEY (`hotel_id`) REFERENCES `hotels`(`id`) ON DELETE CASCADE,\n"
        "  FOREIGN KEY (`room_type_id`) REFERENCES `room_types`(`id`) ON DELETE CASCADE,\n"
        "  UNIQUE KEY `unique_hotel_room` (`hotel_id`, `room_number`)\n"
        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\n\n"
        "-- 6. Bảng bookings\n"
        "CREATE TABLE IF NOT EXISTS `bookings` (\n"
        "  `id` INT AUTO_INCREMENT PRIMARY KEY,\n"
        "  `booking_code` VARCHAR(30) NOT NULL UNIQUE,\n"
        "  `user_id` INT NOT NULL,\n"
        "  `room_id` INT NOT NULL,\n"
        "  `check_in` DATE NOT NULL,\n"
        "  `check_out` DATE NOT NULL,\n"
        "  `guest_name` VARCHAR(100) NOT NULL,\n"
        "  `guest_phone` VARCHAR(20) NOT NULL,\n"
        "  `guest_email` VARCHAR(100) NOT NULL,\n"
        "  `total_price` DECIMAL(12,2) NOT NULL,\n"
        "  `status` ENUM('PENDING', 'CONFIRMED', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'CONFIRMED',\n"
        "  `payment_method` VARCHAR(50) NOT NULL DEFAULT 'PAY_AT_HOTEL',\n"
        "  `payment_status` ENUM('UNPAID', 'PAID') NOT NULL DEFAULT 'UNPAID',\n"
        "  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,\n"
        "  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,\n"
        "  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,\n"
        "  FOREIGN KEY (`room_id`) REFERENCES `rooms`(`id`) ON DELETE CASCADE,\n"
        "  INDEX `idx_bookings_user` (`user_id`),\n"
        "  INDEX `idx_bookings_dates` (`room_id`, `check_in`, `check_out`, `status`)\n"
        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\n\n"
        "-- 7. Bảng reviews\n"
        "CREATE TABLE IF NOT EXISTS `reviews` (\n"
        "  `id` INT AUTO_INCREMENT PRIMARY KEY,\n"
        "  `user_id` INT NOT NULL,\n"
        "  `hotel_id` INT NOT NULL,\n"
        "  `rating` TINYINT NOT NULL CHECK (`rating` BETWEEN 1 AND 5),\n"
        "  `comment` TEXT NOT NULL,\n"
        "  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,\n"
        "  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,\n"
        "  FOREIGN KEY (`hotel_id`) REFERENCES `hotels`(`id`) ON DELETE CASCADE,\n"
        "  INDEX `idx_reviews_hotel` (`hotel_id`)\n"
        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;"
    )
    add_code_block(doc, schema_sql, caption="Kịch bản DDL khởi tạo cơ sở dữ liệu hotel_booking_db")

    # Phụ lục C
    add_heading_2(doc, "Phụ lục C: Mã nguồn Thuật toán Trọng yếu")
    add_body_p(doc, "1. Thuật toán kiểm tra phòng trống khả dụng (JavaScript Node.js):")
    
    code_avail = (
        "exports.getAvailableRooms = async (req, res, next) => {\n"
        "  try {\n"
        "    const { hotel_id, room_type_id, check_in, check_out } = req.query;\n"
        "    if (!hotel_id || !room_type_id || !check_in || !check_out) {\n"
        "      return res.status(400).json({ success: false, message: 'Thiếu tham số bắt buộc' });\n"
        "    }\n"
        "    const query = `\n"
        "      SELECT r.* FROM rooms r\n"
        "      WHERE r.hotel_id = ? AND r.room_type_id = ? AND r.status = 'AVAILABLE'\n"
        "      AND r.id NOT IN (\n"
        "        SELECT b.room_id FROM bookings b\n"
        "        WHERE b.status != 'CANCELLED'\n"
        "        AND (b.check_out > ? AND b.check_in < ?)\n"
        "      )\n"
        "    `;\n"
        "    const [rooms] = await db.query(query, [hotel_id, room_type_id, check_in, check_out]);\n"
        "    return res.status(200).json({ success: true, count: rooms.length, data: rooms });\n"
        "  } catch (error) {\n"
        "    next(error);\n"
        "  }\n"
        "};"
    )
    add_code_block(doc, code_avail, caption="Mã nguồn phương thức getAvailableRooms trong room.model.js")

    add_body_p(doc, "2. Giao dịch đặt phòng nguyên tử và tính giá an toàn Server-side:")
    
    code_booking = (
        "exports.createBooking = async (req, res, next) => {\n"
        "  const connection = await db.getConnection();\n"
        "  try {\n"
        "    await connection.beginTransaction();\n"
        "    const { hotel_id, room_type_id, check_in, check_out, guest_name, guest_phone, guest_email, payment_method } = req.body;\n"
        "    const userId = req.user.id;\n\n"
        "    // Lấy đơn giá gốc từ CSDL\n"
        "    const [types] = await connection.query('SELECT price FROM room_types WHERE id = ?', [room_type_id]);\n"
        "    if (!types.length) throw new AppError('Loại phòng không tồn tại', 404);\n"
        "    const unitPrice = parseFloat(types[0].price);\n\n"
        "    // Tính số đêm và tổng tiền\n"
        "    const nights = Math.ceil(Math.abs(new Date(check_out) - new Date(check_in)) / (1000 * 60 * 60 * 24));\n"
        "    if (nights <= 0) throw new AppError('Ngày trả phòng phải sau ngày nhận phòng', 400);\n"
        "    const totalPrice = unitPrice * nights;\n\n"
        "    // Khóa và lấy 1 phòng vật lý trống\n"
        "    const [availableRooms] = await connection.query(`\n"
        "      SELECT id FROM rooms\n"
        "      WHERE hotel_id = ? AND room_type_id = ? AND status = 'AVAILABLE'\n"
        "      AND id NOT IN (\n"
        "        SELECT room_id FROM bookings\n"
        "        WHERE status != 'CANCELLED' AND (check_out > ? AND check_in < ?)\n"
        "      ) LIMIT 1 FOR UPDATE\n"
        "    `, [hotel_id, room_type_id, check_in, check_out]);\n\n"
        "    if (!availableRooms.length) throw new AppError('Phòng vừa được khách khác đặt hết', 400);\n"
        "    const allocatedRoomId = availableRooms[0].id;\n\n"
        "    // Sinh mã booking duy nhất\n"
        "    const bookingCode = 'BK' + Date.now().toString(36).toUpperCase() + Math.random().toString(36).substring(2, 5).toUpperCase();\n\n"
        "    // Lưu đơn đặt phòng\n"
        "    await connection.query(`\n"
        "      INSERT INTO bookings (booking_code, user_id, room_id, check_in, check_out, guest_name, guest_phone, guest_email, total_price, status, payment_method)\n"
        "      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'CONFIRMED', ?)\n"
        "    `, [bookingCode, userId, allocatedRoomId, check_in, check_out, guest_name, guest_phone, guest_email, totalPrice, payment_method || 'PAY_AT_HOTEL']);\n\n"
        "    await connection.commit();\n"
        "    res.status(201).json({ success: true, booking_code: bookingCode, total_price: totalPrice });\n"
        "  } catch (err) {\n"
        "    await connection.rollback();\n"
        "    next(err);\n"
        "  } finally {\n"
        "    connection.release();\n"
        "  }\n"
        "};"
    )
    add_code_block(doc, code_booking, caption="Mã nguồn phương thức createBooking trong booking.controller.js")
