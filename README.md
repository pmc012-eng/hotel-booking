<<<<<<< HEAD
# hotel-booking
Ứng dụng đặt phòng khách sạn trực tuyến (Flutter + Node.js Express + MySQL)
=======
# 🏨 Hotel Booking System (Full-Stack Mobile App & Management)

Dự án đồ án học kỳ xây dựng Hệ thống Đặt phòng Khách sạn trực tuyến hoàn chỉnh từ Backend REST API đến Ứng dụng di động Flutter.

---

## 🌟 Tính Năng Nổi Bật

* **Phía Khách Hàng (Mobile App):**
  * Đăng ký, đăng nhập bảo mật bằng JWT & BCrypt.
  * Tìm kiếm và lọc đa tiêu chí: theo thành phố (Hà Nội, TP.HCM, Đà Nẵng, Phú Quốc,...), số sao, mức giá.
  * Xem thông tin chi tiết khách sạn, danh mục tiện ích (Wifi, Hồ bơi, Gym, Buffet,...), đánh giá & bình luận.
  * Chọn khoảng ngày lưu trú qua bộ chọn lịch (Calendar Picker).
  * **Thuật toán kiểm tra phòng trống thực tế theo thời gian thực (Overlap Prevention)**.
  * Đặt phòng với cơ chế **tính tiền an toàn phía máy chủ (Server-side price calculation)**.
  * Quản lý đơn đặt với 4 tab trạng thái (Tất cả, Đã xác nhận, Đã hoàn thành, Đã hủy).
  * Hủy phòng tức thì và tự động giải phóng phòng để người khác đặt.
  * Quản lý hồ sơ cá nhân và đổi mật khẩu.

* **Phía Quản Trị Viên (Admin Module):**
  * **Dashboard Thống kê KPI:** Tổng doanh thu, tổng lượt đặt, tổng số phòng, tỷ lệ lấp đầy (Occupancy Rate).
  * **Quản lý Khách sạn:** Thêm, sửa, xóa khách sạn (hỗ trợ ràng buộc toàn vẹn ON DELETE CASCADE).
  * **Quản lý Phòng:** Cập nhật giá, sức chứa, chuyển đổi trạng thái phòng (`AVAILABLE`, `MAINTENANCE` - bảo trì).
  * **Quản lý Đơn đặt phòng:** Xem danh sách toàn hệ thống, duyệt chuyển trạng thái đơn hàng.

---

## 🛠️ Công Nghệ Sử Dụng

* **Frontend (Mobile App):**
  * **Flutter SDK** (Dart 3.6+)
  * **State Management:** Riverpod 2.x / legacy compatibility
  * **Network & REST API:** Dio với Auth Bearer Token Interceptor & tự động xử lý 401 Unauthorized
  * **Navigation:** GoRouter (Khởi tạo định tuyến phân quyền và Deep Linking)
  * **Design System:** Material 3, Google Fonts (Plus Jakarta Sans), Phối màu chuẩn Luxury Blue (#2563EB)
* **Backend (REST API):**
  * **Node.js & Express.js**
  * **MySQL2 / MariaDB** với cơ chế Connection Pooling (Tối đa 10 connections)
  * **Mã hóa:** `bcryptjs` (Salt rounds 10), `jsonwebtoken` (JWT)
  * **Kiểm thử tự động:** E2E Test Suite tích hợp (22 kịch bản tự dọn rác)
* **Cơ Sở Dữ Liệu:** MySQL / MariaDB gồm 7 bảng chuẩn hóa 3NF (`users`, `hotels`, `rooms`, `amenities`, `hotel_amenities`, `bookings`, `reviews`).

---

## 🚀 Hướng Dẫn Cài Đặt & Chạy Ứng Dụng

### 1. Chuẩn bị Cơ sở dữ liệu MySQL
1. Khởi động MySQL / MariaDB (ví dụ qua XAMPP Control Panel cổng 3306).
2. Kiểm tra thông tin kết nối trong `backend/.env`:
   ```env
   PORT=5000
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=
   DB_NAME=hotel_booking_db
   JWT_SECRET=your_super_secret_jwt_key_2026_hotel_booking_project
   JWT_EXPIRE=7d
   ```

### 2. Khởi động Backend & Nạp Dữ Liệu Mẫu
```bash
cd backend

# Cài đặt dependencies
npm install

# Tạo bảng và nạp 10 khách sạn, 47 phòng, 4 tài khoản và dữ liệu mẫu
npm run seed

# Chạy bộ kiểm thử tự động 22 test cases
npm test

# Khởi động server API ở cổng 5000
npm run dev
```

### 3. Chạy Ứng Dụng Di Động Flutter
```bash
cd hotel_booking_app

# Cài đặt packages
flutter pub get

# Chạy phân tích tĩnh mã nguồn (0 issues found)
flutter analyze

# Chạy bộ kiểm thử tự động
flutter test

# Khởi chạy trên thiết bị giả lập hoặc máy thật
flutter run
```

> **Lưu ý cấu hình IP cho thiết bị:**
> * Trên **Android Emulator**: Ứng dụng tự động kết nối qua `http://10.0.2.2:5000/api`.
> * Trên **Web / Windows**: Tự động kết nối qua `http://localhost:5000/api`.
> * Trên **Thiết bị thật (Real Phone)**: Cập nhật IP máy tính tại `lib/core/constants/app_constants.dart` (ví dụ: `http://192.168.1.xxx:5000/api`).

---

## 🔑 Tài Khoản Thử Nghiệm

| Vai trò | Email | Mật khẩu | Chức năng nổi bật |
| :--- | :--- | :--- | :--- |
| **Quản trị viên (Admin)** | `admin@hotelbooking.com` | `admin123` | Toàn quyền Quản trị Dashboard, Quản lý Khách sạn, Phòng, Duyệt Đơn |
| **Khách hàng 1 (User)** | `user1@gmail.com` | `user123` | Đặt phòng, xem lịch sử đơn hàng, hủy phòng |
| **Khách hàng 2 (User)** | `user2@gmail.com` | `user123` | Đặt phòng, viết đánh giá |

---

## 📁 Cấu Trúc Thư Mục Dự Án

```
hotel-android/
├── README.md                   # Tài liệu tổng quan dự án
├── backend/                    # Mã nguồn Node.js REST API
│   ├── config/db.js            # MySQL Connection Pool
│   ├── controllers/            # Xử lý nghiệp vụ (Auth, Hotel, Room, Booking, Admin)
│   ├── middleware/             # JWT Protect, RBAC restrictTo, Error Handler
│   ├── routes/                 # Định nghĩa các tuyến đường API
│   ├── scripts/seed.js         # Script khởi tạo CSDL & nạp dữ liệu mẫu
│   ├── tests/e2e.test.js       # Test suite tự động 22 kịch bản E2E
│   └── server.js               # File khởi chạy máy chủ Express
└── hotel_booking_app/          # Ứng dụng di động Flutter
    ├── lib/
    │   ├── core/               # Theme, AppColors, ApiClient, Interceptors, Navigation
    │   ├── models/             # UserModel, HotelModel, RoomModel, BookingModel, AdminStatsModel
    │   ├── repositories/       # Auth, Hotel, Room, Booking, Admin Repositories
    │   ├── providers/          # Riverpod State Notifiers
    │   ├── screens/            # 15+ Màn hình người dùng và 4 Màn hình Admin
    │   └── widgets/            # Reusable UI widgets (HotelCard, RoomCard, SearchBar,...)
    └── test/                   # Flutter Unit & Widget tests
```

---

## 📜 Tài Liệu Báo Cáo Chi Tiết
Xem toàn bộ báo cáo phân tích thiết kế hệ thống, sơ đồ quan hệ thực thể (ERD), giải thuật chống trùng lịch, đặc tả 19 APIs và **Cẩm nang 15 câu hỏi vấn đáp bảo vệ đồ án** tại:
👉 [**BAO_CAO_DO_AN.md**](./BAO_CAO_DO_AN.md)
>>>>>>> ed2895b (feat: initial commit for Hotel Booking System (Flutter Mobile + Node.js Backend))
