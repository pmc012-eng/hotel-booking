const http = require('http');
const app = require('../src/app');
const { query } = require('../src/config/db');

const PORT = 5002;
const server = app.listen(PORT, async () => {
  console.log('====================================================');
  console.log('🚀 BẮT ĐẦU KIỂM THỬ TOÀN DIỆN HỆ THỐNG (PHASE 11: E2E)');
  console.log('====================================================\n');

  let passedTests = 0;
  let failedTests = 0;

  function assert(condition, message) {
    if (condition) {
      console.log(`  ✅ [PASS] ${message}`);
      passedTests++;
    } else {
      console.error(`  ❌ [FAIL] ${message}`);
      failedTests++;
    }
  }

  async function request(path, method = 'GET', body = null, token = null) {
    return new Promise((resolve, reject) => {
      const url = new URL(`http://localhost:${PORT}${path}`);
      const headers = { 'Content-Type': 'application/json' };
      if (token) headers['Authorization'] = `Bearer ${token}`;

      const reqOpt = {
        hostname: url.hostname,
        port: url.port,
        path: url.pathname + url.search,
        method,
        headers,
      };

      const r = http.request(reqOpt, (res) => {
        let data = '';
        res.on('data', (chunk) => (data += chunk));
        res.on('end', () => {
          try {
            resolve({ status: res.statusCode, data: JSON.parse(data) });
          } catch (_) {
            resolve({ status: res.statusCode, data });
          }
        });
      });

      r.on('error', reject);
      if (body) r.write(JSON.stringify(body));
      r.end();
    });
  }

  try {
    // ----------------------------------------------------
    // 1. HEALTH CHECK
    // ----------------------------------------------------
    console.log('1. KIỂM TRA SERVER HEALTH CHECK:');
    const health = await request('/api/health');
    assert(health.status === 200 && health.data.data.server === 'Online', 'Health check API trả về 200 Online');

    // ----------------------------------------------------
    // 2. AUTHENTICATION & EDGE CASES
    // ----------------------------------------------------
    console.log('\n2. KIỂM TRA AUTHENTICATION VÀ CÁC TRƯỜNG HỢP BIÊN:');
    const timestamp = Date.now();
    const testEmail = `tester_${timestamp}@gmail.com`;

    // 2.1 Đăng ký tài khoản mới thành công
    const regSuccess = await request('/api/auth/register', 'POST', {
      name: 'Tester Phase 11',
      email: testEmail,
      password: 'password123',
      phone: '0988776655',
    });
    assert(regSuccess.status === 201 && regSuccess.data.data.token, 'Đăng ký tài khoản mới thành công');
    const testUserToken = regSuccess.data.data.token;

    // 2.2 Đăng ký trùng email -> Phải báo lỗi 400
    const regDuplicate = await request('/api/auth/register', 'POST', {
      name: 'Tester Trùng',
      email: testEmail,
      password: 'password123',
      phone: '0988776655',
    });
    assert(regDuplicate.status === 400, 'Chặn đăng ký trùng Email (Trả về 400)');

    // 2.3 Đăng nhập sai mật khẩu -> Phải báo lỗi 401
    const loginWrongPass = await request('/api/auth/login', 'POST', {
      email: testEmail,
      password: 'wrongpassword',
    });
    assert(loginWrongPass.status === 401, 'Chặn đăng nhập sai mật khẩu (Trả về 401)');

    // 2.4 Đăng nhập tài khoản không tồn tại -> Phải báo lỗi 401
    const loginNonExist = await request('/api/auth/login', 'POST', {
      email: 'nonexistent_user@gmail.com',
      password: 'password123',
    });
    assert(loginNonExist.status === 401, 'Chặn đăng nhập tài khoản không tồn tại (Trả về 401)');

    // 2.5 Đăng nhập thành công với tài khoản Admin
    const adminLogin = await request('/api/auth/login', 'POST', {
      email: 'admin@hotelbooking.com',
      password: 'admin123',
    });
    assert(adminLogin.status === 200 && adminLogin.data.data.user.role === 'ADMIN', 'Admin đăng nhập thành công');
    const adminToken = adminLogin.data.data.token;

    // ----------------------------------------------------
    // 3. HOTEL SEARCH & FILTERS
    // ----------------------------------------------------
    console.log('\n3. KIỂM TRA TÌM KIẾM & BỘ LỌC KHÁCH SẠN:');
    const allHotels = await request('/api/hotels');
    assert(allHotels.status === 200 && allHotels.data.data.length > 0, 'Lấy danh sách tất cả khách sạn thành công');

    const hanoiHotels = await request('/api/hotels?city=Hà Nội');
    const allHanoi = hanoiHotels.data.data.every((h) => h.city === 'Hà Nội');
    assert(hanoiHotels.status === 200 && allHanoi, 'Lọc khách sạn theo thành phố Hà Nội chính xác 100%');

    const starHotels = await request('/api/hotels?star=5');
    const all5Star = starHotels.data.data.every((h) => h.star === 5);
    assert(starHotels.status === 200 && all5Star, 'Lọc khách sạn theo số sao (5 sao) chính xác');

    // ----------------------------------------------------
    // 4. ROOM AVAILABILITY & DATE VALIDATION
    // ----------------------------------------------------
    console.log('\n4. KIỂM TRA TÍNH KHẢ DỤNG CỦA PHÒNG & VALIDATION NGÀY:');
    // 4.1 Ngày quá khứ -> Lỗi 400
    const pastCheck = await request('/api/hotels/1/available-rooms?checkIn=2020-01-01&checkOut=2020-01-03');
    assert(pastCheck.status === 400, 'Chặn chọn ngày Check-in trong quá khứ (Trả về 400)');

    // 4.2 Check-out trước Check-in -> Lỗi 400
    const invalidDates = await request('/api/hotels/1/available-rooms?checkIn=2026-12-10&checkOut=2026-12-05');
    assert(invalidDates.status === 400, 'Chặn ngày Check-out trước ngày Check-in (Trả về 400)');

    // 4.3 Ngày hợp lệ trong tương lai
    const futureCheck = await request('/api/hotels/1/available-rooms?checkIn=2026-12-01&checkOut=2026-12-04');
    assert(futureCheck.status === 200 && futureCheck.data.data.rooms.length > 0, 'Tìm phòng trống ngày hợp lệ thành công');

    // ----------------------------------------------------
    // 5. BOOKING OVERLAP PREVENTION (CHỐNG TRÙNG LỊCH ĐẶT PHÒNG)
    // ----------------------------------------------------
    console.log('\n5. KIỂM TRA CƠ CHẾ CHỐNG TRÙNG PHÒNG (OVERLAP PREVENTION):');
    const testRoomId = 1; // Room 201 hotel 1

    // Dọn dẹp dữ liệu test cũ nếu có
    await query("DELETE FROM bookings WHERE guest_name LIKE 'Khách Hàng %' OR guest_email LIKE '%khach%@gmail.com'");

    // Tạo booking 1 từ 2026-12-10 đến 2026-12-15
    const booking1 = await request(
      '/api/bookings',
      'POST',
      {
        roomId: testRoomId,
        checkIn: '2026-12-10',
        checkOut: '2026-12-15',
        guestName: 'Khách Hàng 1',
        guestPhone: '0911111111',
        guestEmail: 'khach1@gmail.com',
      },
      testUserToken
    );
    assert(booking1.status === 201 && booking1.data.data.booking_code, 'Tạo đơn đặt phòng 1 thành công');
    const b1Id = booking1.data.data.id;

    // Đặt trùng lịch (2026-12-12 đến 2026-12-14) trên cùng phòng -> BẮT BUỘC PHẢI THẤT BẠI
    const bookingOverlap = await request(
      '/api/bookings',
      'POST',
      {
        roomId: testRoomId,
        checkIn: '2026-12-12',
        checkOut: '2026-12-14',
        guestName: 'Khách Hàng 2',
        guestPhone: '0922222222',
        guestEmail: 'khach2@gmail.com',
      },
      testUserToken
    );
    assert(bookingOverlap.status === 400, 'BẢO VỆ CHỐNG TRÙNG LỊCH: Chặn đặt phòng bị trùng khoảng ngày (Trả về 400)');

    // Đặt ngoài khoảng ngày trùng (2026-12-16 đến 2026-12-18) -> Thành công
    const bookingAfter = await request(
      '/api/bookings',
      'POST',
      {
        roomId: testRoomId,
        checkIn: '2026-12-16',
        checkOut: '2026-12-18',
        guestName: 'Khách Hàng 3',
        guestPhone: '0933333333',
        guestEmail: 'khach3@gmail.com',
      },
      testUserToken
    );
    assert(bookingAfter.status === 201, 'Đặt phòng cùng phòng nhưng ngoài khoảng ngày trùng thành công');

    // 5.4 Hủy booking 1 -> Phòng phải được giải phóng
    const cancelB1 = await request(`/api/bookings/${b1Id}/cancel`, 'PUT', null, testUserToken);
    assert(cancelB1.status === 200 && cancelB1.data.data.status === 'CANCELLED', 'Hủy đơn đặt phòng 1 thành công');

    // Đặt lại đúng khoảng ngày (2026-12-10 đến 2026-12-15) -> Giờ đã được giải phóng nên phải thành công!
    const rebooking = await request(
      '/api/bookings',
      'POST',
      {
        roomId: testRoomId,
        checkIn: '2026-12-10',
        checkOut: '2026-12-15',
        guestName: 'Khách Hàng 4',
        guestPhone: '0944444444',
        guestEmail: 'khach4@gmail.com',
      },
      testUserToken
    );
    assert(rebooking.status === 201, 'Sau khi hủy, phòng được giải phóng ngay lập tức và khách khác đặt được');

    // ----------------------------------------------------
    // 6. ADMIN SECURITY & STATS
    // ----------------------------------------------------
    console.log('\n6. KIỂM TRA PHÂN QUYỀN VÀ TÍNH NĂNG QUẢN TRỊ VIÊN:');
    // User thường truy cập admin -> 403
    const userToAdmin = await request('/api/admin/statistics', 'GET', null, testUserToken);
    assert(userToAdmin.status === 403, 'Bảo vệ RBAC: User thường bị từ chối truy cập Admin API (403)');

    // Admin truy cập thống kê -> 200
    const adminStats = await request('/api/admin/statistics', 'GET', null, adminToken);
    assert(adminStats.status === 200 && adminStats.data.data.revenue >= 0, 'Admin lấy thống kê KPI thành công');

    // Admin cập nhật trạng thái phòng sang MAINTENANCE
    const setMaintenance = await request(`/api/rooms/${testRoomId}`, 'PUT', { status: 'MAINTENANCE' }, adminToken);
    assert(setMaintenance.status === 200, 'Admin chuyển phòng sang trạng thái bảo trì MAINTENANCE');

    // Khách thử đặt phòng đang bảo trì -> Phải báo lỗi
    const bookMaintenance = await request(
      '/api/bookings',
      'POST',
      {
        roomId: testRoomId,
        checkIn: '2027-01-01',
        checkOut: '2027-01-03',
        guestName: 'Test Maintenance',
        guestPhone: '0987654321',
        guestEmail: 'testm@gmail.com',
      },
      testUserToken
    );
    assert(bookMaintenance.status === 400, 'Hệ thống từ chối đặt phòng đang trong trạng thái bảo trì');

    // Admin khôi phục phòng về AVAILABLE
    const setAvailable = await request(`/api/rooms/${testRoomId}`, 'PUT', { status: 'AVAILABLE' }, adminToken);
    assert(setAvailable.status === 200, 'Admin khôi phục phòng về trạng thái AVAILABLE đón khách');

    // Dọn dẹp dữ liệu sau khi test
    await query("DELETE FROM bookings WHERE guest_name LIKE 'Khách Hàng %' OR guest_email LIKE '%khach%@gmail.com'");
    await query("DELETE FROM users WHERE email LIKE 'tester_%@gmail.com'");

    // ----------------------------------------------------
    // KẾT QUẢ TỔNG HỢP
    // ----------------------------------------------------
    console.log('\n====================================================');
    console.log(`🏁 TỔNG KẾT KIỂM THỬ: ${passedTests} PASSED, ${failedTests} FAILED`);
    console.log('====================================================');

    server.close();
    process.exit(failedTests > 0 ? 1 : 0);
  } catch (err) {
    console.error('Lỗi ngoại lệ trong quá trình chạy test:', err);
    server.close();
    process.exit(1);
  }
});
