const fs = require('fs');
const path = require('path');
const bcrypt = require('bcryptjs');
const { pool } = require('../src/config/db');

async function seedDatabase() {
  console.log('🔄 Bắt đầu khởi tạo CSDL và Seed dữ liệu mẫu...');

  try {
    // 1. Chạy Schema SQL
    const schemaSql = fs.readFileSync(
      path.join(__dirname, '../src/config/schema.sql'),
      'utf8'
    );

    // Tách các câu lệnh theo dấu ;
    const statements = schemaSql
      .split(';')
      .map((st) => st.trim())
      .filter((st) => st.length > 0);

    for (const statement of statements) {
      await pool.query(statement);
    }
    console.log('✅ Đã tạo các bảng CSDL thành công!');

    // Tắt kiểm tra khóa ngoại để dọn dẹp dữ liệu cũ nếu có
    await pool.query('SET FOREIGN_KEY_CHECKS = 0');
    await pool.query('TRUNCATE TABLE reviews');
    await pool.query('TRUNCATE TABLE bookings');
    await pool.query('TRUNCATE TABLE rooms');
    await pool.query('TRUNCATE TABLE room_types');
    await pool.query('TRUNCATE TABLE hotel_images');
    await pool.query('TRUNCATE TABLE hotels');
    await pool.query('TRUNCATE TABLE users');
    await pool.query('SET FOREIGN_KEY_CHECKS = 1');

    console.log('🧹 Đã làm sạch các bảng dữ liệu.');

    // 2. Hash mật khẩu người dùng
    const adminPassword = await bcrypt.hash('admin123', 10);
    const userPassword = await bcrypt.hash('user123', 10);

    // 3. Tạo Users (1 Admin, 3 Users)
    const [adminResult] = await pool.query(
      `INSERT INTO users (name, email, password, phone, role, avatar) VALUES (?, ?, ?, ?, ?, ?)`,
      [
        'Quản Trị Viên',
        'admin@hotelbooking.com',
        adminPassword,
        '0901234567',
        'ADMIN',
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
      ]
    );

    const [user1Result] = await pool.query(
      `INSERT INTO users (name, email, password, phone, role, avatar) VALUES (?, ?, ?, ?, ?, ?)`,
      [
        'Nguyễn Văn An',
        'user1@gmail.com',
        userPassword,
        '0912345678',
        'USER',
        'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=300&q=80',
      ]
    );

    const [user2Result] = await pool.query(
      `INSERT INTO users (name, email, password, phone, role, avatar) VALUES (?, ?, ?, ?, ?, ?)`,
      [
        'Trần Thị Mai',
        'user2@gmail.com',
        userPassword,
        '0987654321',
        'USER',
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=300&q=80',
      ]
    );

    await pool.query(
      `INSERT INTO users (name, email, password, phone, role, avatar) VALUES (?, ?, ?, ?, ?, ?)`,
      [
        'Lê Hoàng Nam',
        'user3@gmail.com',
        userPassword,
        '0933445566',
        'USER',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80',
      ]
    );
    console.log('✅ Đã tạo 1 ADMIN và 3 USERS demo (Mật khẩu: admin123 / user123).');

    // 4. Danh sách 10 Khách sạn mẫu trải dài khắp Việt Nam
    const hotelData = [
      {
        name: 'The Oriental Jade Hotel',
        description:
          'Khách sạn boutique sang trọng nằm ngay trung tâm phố cổ Hà Nội, cách Hồ Hoàn Kiếm chỉ vài bước chân. Tầm nhìn panorama ngắm trọn thủ đô thơ mộng, hồ bơi vô cực trên tầng thượng và dịch vụ chuẩn quốc tế.',
        address: '94 Hàng Trống, Quận Hoàn Kiếm',
        city: 'Hà Nội',
        star: 5,
        rating: 4.9,
        images: ['/uploads/hotel_1.jpg', '/uploads/hotel_2.jpg'],
        roomTypes: [
          {
            name: 'Deluxe City View',
            desc: 'Phòng Deluxe ấm cúng với ban công ngắm nhìn phố cổ Hà Nội.',
            capacity: 2,
            price: 1350000,
            image: '/uploads/room_1.jpg',
            amenities: ['Wifi tốc độ cao', 'Điều hòa 2 chiều', 'TV 55 inch', 'Bồn tắm sang trọng', 'Bữa sáng buffet'],
            roomNumbers: ['201', '202', '203'],
          },
          {
            name: 'Grand Suite Lake View',
            desc: 'Phòng Suite thượng hạng nhìn thẳng ra Hồ Gươm tuyệt đẹp.',
            capacity: 2,
            price: 2600000,
            image: '/uploads/room_2.jpg',
            amenities: ['View Hồ Gươm', 'Bồn tắm sục Jacuzzi', 'Máy pha cà phê Nespresso', 'Rượu vang chào mừng', 'Bữa sáng tại phòng'],
            roomNumbers: ['501', '502'],
          },
          {
            name: 'Family Executive Suite',
            desc: 'Không gian rộng rãi, tiện nghi chuẩn mực cho cả gia đình nghỉ dưỡng.',
            capacity: 4,
            price: 3400000,
            image: '/uploads/room_3.jpg',
            amenities: ['2 giường King', 'Khu vực tiếp khách riêng', 'Ban công rộng', 'Bữa sáng 4 người'],
            roomNumbers: ['601'],
          },
        ],
      },
      {
        name: 'Sofitel Legend Metropole Hanoi',
        description:
          'Khách sạn 5 sao cổ điển mang phong cách kiến trúc Pháp thời thuộc địa đầu tiên tại Hà Nội, biểu tượng lịch sử và sự xa hoa tinh tế với bề dày hơn 120 năm lịch sử.',
        address: '15 Ngô Quyền, Quận Hoàn Kiếm',
        city: 'Hà Nội',
        star: 5,
        rating: 4.9,
        images: ['/uploads/hotel_2.jpg', '/uploads/hotel_3.jpg'],
        roomTypes: [
          {
            name: 'Premium Historical Room',
            desc: 'Phong cách Đông Dương hoài cổ với nội thất gỗ cao cấp.',
            capacity: 2,
            price: 3200000,
            image: '/uploads/room_4.jpg',
            amenities: ['Nội thất gỗ lim', 'Bồn tắm kiểu cổ', 'Quầy bar mini miễn phí', 'Wifi riêng'],
            roomNumbers: ['101', '102', '103'],
          },
          {
            name: 'Opera Wing Luxury',
            desc: 'Kiến trúc tân cổ điển sang trọng mang đến trải nghiệm nghỉ dưỡng hoàn hảo.',
            capacity: 2,
            price: 4500000,
            image: '/uploads/room_5.jpg',
            amenities: ['Ban công hướng vườn', 'Phòng tắm cẩm thạch', 'Hồ bơi nhiệt đới', 'Dịch vụ quản gia 24/7'],
            roomNumbers: ['301', '302'],
          },
        ],
      },
      {
        name: 'TMS Hotel Da Nang Beach',
        description:
          'Tọa lạc ngay mặt tiền biển Mỹ Khê, một trong những bãi biển đẹp nhất hành tinh. Thiết kế kính tràn góc rộng ôm trọn biển xanh mênh mông, hồ bơi kính vô cực tầng 25 ngoạn mục.',
        address: '292 Võ Nguyên Giáp, Quận Sơn Trà',
        city: 'Đà Nẵng',
        star: 5,
        rating: 4.8,
        images: ['/uploads/hotel_3.jpg', '/uploads/hotel_4.jpg'],
        roomTypes: [
          {
            name: 'Premier Ocean Front',
            desc: 'Ngắm bình minh biển Mỹ Khê ngay từ chiếc giường ngủ êm ái.',
            capacity: 2,
            price: 1850000,
            image: '/uploads/room_6.jpg',
            amenities: ['100% hướng biển', 'Ban công kính', 'Bồn tắm view biển', 'Buffet sáng hải sản'],
            roomNumbers: ['1201', '1202', '1203'],
          },
          {
            name: 'Family Ocean Suite',
            desc: 'Phòng gia đình tiện nghi cao cấp có phòng khách và bếp mini.',
            capacity: 4,
            price: 2950000,
            image: '/uploads/room_7.jpg',
            amenities: ['Bếp nấu nhẹ', 'Máy giặt riêng', '2 phòng ngủ', 'Phòng khách view biển'],
            roomNumbers: ['1501', '1502'],
          },
        ],
      },
      {
        name: 'Sala Danang Beach Hotel',
        description:
          'Khách sạn ven biển Đà Nẵng phong cách trẻ trung, hiện đại. Dịch vụ thân thiện, ẩm thực Á-Âu phong phú cùng quầy sky bar sôi động về đêm.',
        address: '36 Lâm Hoành, Phước Mỹ, Quận Sơn Trà',
        city: 'Đà Nẵng',
        star: 4,
        rating: 4.7,
        images: ['/uploads/hotel_4.jpg', '/uploads/hotel_5.jpg'],
        roomTypes: [
          {
            name: 'Superior Double Room',
            desc: 'Phòng tiêu chuẩn ấm cúng, thiết kế trang nhã tối giản.',
            capacity: 2,
            price: 950000,
            image: '/uploads/room_8.jpg',
            amenities: ['Wifi cáp quang', 'Máy sấy tóc', 'Két sắt an toàn', 'Nước suối miễn phí'],
            roomNumbers: ['401', '402', '403'],
          },
          {
            name: 'Deluxe Sea View',
            desc: 'Tầm nhìn bao quát bãi biển và bán đảo Sơn Trà thơ mộng.',
            capacity: 2,
            price: 1450000,
            image: '/uploads/room_9.jpg',
            amenities: ['View biển trực diện', 'Bồn tắm nằm', 'Ban công ngắm cảnh', 'Bữa sáng phong phú'],
            roomNumbers: ['801', '802'],
          },
        ],
      },
      {
        name: 'The Reverie Saigon',
        description:
          'Khách sạn thành viên The Leading Hotels of the World, sự kết tinh hoàn mỹ giữa kiến trúc thủ công Ý xa hoa và lòng hiếu khách Việt Nam giữa trung tâm phồn hoa Sài Gòn.',
        address: '22-36 Nguyễn Huệ, Bến Nghé, Quận 1',
        city: 'Hồ Chí Minh',
        star: 5,
        rating: 4.9,
        images: ['/uploads/hotel_5.jpg', '/uploads/hotel_6.jpg'],
        roomTypes: [
          {
            name: 'Grand Deluxe King',
            desc: 'Nội thất nhập khẩu từ các thương hiệu nội thất xa xỉ hàng đầu nước Ý.',
            capacity: 2,
            price: 3800000,
            image: '/uploads/room_10.jpg',
            amenities: ['Tầm nhìn sông Sài Gòn', 'Phòng tắm đá cẩm thạch Carrara', 'Âm thanh Cisco cao cấp'],
            roomNumbers: ['2101', '2102'],
          },
          {
            name: 'Panorama River Suite',
            desc: 'Phòng Suite góc với tầm nhìn bao quát toàn bộ vẻ tráng lệ của Sài Gòn về đêm.',
            capacity: 2,
            price: 5900000,
            image: '/uploads/room_1.jpg',
            amenities: ['Phòng khách độc lập', 'Quầy bar riêng', 'Quyền vào Reverie Lounge', 'Quản gia'],
            roomNumbers: ['2801'],
          },
        ],
      },
      {
        name: 'Hotel Nikko Saigon',
        description:
          'Khách sạn 5 sao mang đậm tinh hoa Nhật Bản: thanh lịch, yên bình và chu đáo đến từng chi tiết nhỏ. Nổi tiếng với tiệc buffet hải sản thượng hạng.',
        address: '235 Nguyễn Văn Cừ, Quận 1',
        city: 'Hồ Chí Minh',
        star: 5,
        rating: 4.8,
        images: ['/uploads/hotel_6.jpg', '/uploads/hotel_7.jpg'],
        roomTypes: [
          {
            name: 'Deluxe King Bed',
            desc: 'Không gian tĩnh lặng, đệm ngủ cao cấp theo chuẩn khách sạn Nhật.',
            capacity: 2,
            price: 1950000,
            image: '/uploads/room_2.jpg',
            amenities: ['Nội thất phong cách Zen', 'Bồn cầu thông minh TOTO', 'Bồn tắm sâu', 'Bữa sáng Nhật - Âu'],
            roomNumbers: ['1101', '1102', '1103'],
          },
          {
            name: 'Nikko Club Executive',
            desc: 'Đặc quyền sử dụng phòng chờ Club Lounge sang trọng tại tầng cao.',
            capacity: 2,
            price: 3100000,
            image: '/uploads/room_3.jpg',
            amenities: ['Trà chiều miễn phí', 'Cocktail tối', 'Check-in riêng tư', 'Bữa sáng độc quyền'],
            roomNumbers: ['1901', '1902'],
          },
        ],
      },
      {
        name: 'Vinpearl Resort & Spa Nha Trang Bay',
        description:
          'Khu nghỉ dưỡng hình cánh cung duyên dáng trên đảo Hòn Tre. Bãi biển riêng tuyệt mỹ, công viên giải trí VinWonders kề bên, lý tưởng cho kỳ nghỉ gia đình thiên đường.',
        address: 'Đảo Hòn Tre, Vĩnh Nguyên',
        city: 'Nha Trang',
        star: 5,
        rating: 4.8,
        images: ['/uploads/hotel_7.jpg', '/uploads/hotel_8.jpg'],
        roomTypes: [
          {
            name: 'Deluxe Ocean View Room',
            desc: 'Ngắm nhìn trọn vẹn vịnh biển Nha Trang thơ mộng từ ban công riêng.',
            capacity: 2,
            price: 1750000,
            image: '/uploads/room_4.jpg',
            amenities: ['Cáp treo sang đảo miễn phí', 'Hồ bơi vô cực khổng lồ', 'Bãi tắm riêng', 'Bữa sáng phong phú'],
            roomNumbers: ['301', '302', '303'],
          },
          {
            name: '2-Bedroom Ocean Villa',
            desc: 'Biệt thự 2 phòng ngủ có hồ bơi riêng tư giữa khu vườn nhiệt đới xanh mát.',
            capacity: 4,
            price: 5200000,
            image: '/uploads/room_5.jpg',
            amenities: ['Hồ bơi riêng', 'Xe điện đưa đón', 'Sân vườn nhiệt đới', 'Bếp ăn và phòng khách lớn'],
            roomNumbers: ['V101', 'V102'],
          },
        ],
      },
      {
        name: 'InterContinental Nha Trang',
        description:
          'Tọa lạc trên con đường ven biển Trần Phú sầm uất. Đẳng cấp nghỉ dưỡng quốc tế của thương hiệu IHG với hồ bơi vô cực ngoài trời ngắm trọn vịnh Nha Trang.',
        address: '32-34 Trần Phú, Lộc Thọ',
        city: 'Nha Trang',
        star: 5,
        rating: 4.9,
        images: ['/uploads/hotel_8.jpg', '/uploads/hotel_9.jpg'],
        roomTypes: [
          {
            name: 'Classic Ocean View',
            desc: 'Thiết kế hiện đại đan xen nghệ thuật chạm khắc gỗ truyền thống.',
            capacity: 2,
            price: 2150000,
            image: '/uploads/room_6.jpg',
            amenities: ['Ban công view biển', 'Đệm lông vũ cao cấp', 'Phòng tắm kính ngắm biển'],
            roomNumbers: ['701', '702', '703'],
          },
          {
            name: 'Junior Suite Sea Front',
            desc: 'Không gian mở hướng trọn biển xanh với tiện nghi cao cấp nhất.',
            capacity: 2,
            price: 3600000,
            image: '/uploads/room_7.jpg',
            amenities: ['Phòng khách liền kề', 'Bồn tắm đặt cạnh kính view biển', 'Dịch vụ hỗ trợ du lịch riêng'],
            roomNumbers: ['1401', '1402'],
          },
        ],
      },
      {
        name: 'Dalat Edensee Lake Resort & Spa',
        description:
          'Làng biệt thự nghỉ dưỡng phong cách châu Âu nép mình bên hồ Tuyền Lâm mộng mơ, bao bọc bởi rừng thông nguyên sinh xanh mướt và không khí trong lành mát lạnh quanh năm.',
        address: 'Khu du lịch Hồ Tuyền Lâm, Phường 4',
        city: 'Đà Lạt',
        star: 5,
        rating: 4.8,
        images: ['/uploads/hotel_9.jpg', '/uploads/hotel_10.jpg'],
        roomTypes: [
          {
            name: 'Mimosa Superior Pine View',
            desc: 'Thức giấc giữa tiếng chim hót và sương sớm bay lãng đãng qua rặng thông.',
            capacity: 2,
            price: 1650000,
            image: '/uploads/room_8.jpg',
            amenities: ['Lò sưởi ấm cúng', 'Ban công ngắm rừng thông', 'Trà atiso tươi', 'Xe đạp dạo hồ'],
            roomNumbers: ['201', '202', '203'],
          },
          {
            name: 'Jasmine Luxury Lake View',
            desc: 'Biệt thự bên bờ hồ Tuyền Lâm với tầm nhìn mặt nước phẳng lặng như gương.',
            capacity: 2,
            price: 2850000,
            image: '/uploads/room_9.jpg',
            amenities: ['View trực diện hồ', 'Bồn tắm sục massage', 'Bữa sáng tại ban công', 'Chèo kayak miễn phí'],
            roomNumbers: ['101', '102'],
          },
        ],
      },
      {
        name: 'Premier Village Phu Quoc Resort',
        description:
          'Khu nghỉ dưỡng 2 mặt biển độc nhất vô nhị tại Mũi Ông Đội. Nơi du khách có thể chiêm ngưỡng cả bình minh và hoàng hôn biển tại cùng một vị trí tuyệt tác.',
        address: 'Mũi Ông Đội, Phường An Thới',
        city: 'Phú Quốc',
        star: 5,
        rating: 4.9,
        images: ['/uploads/hotel_10.jpg', '/uploads/hotel_1.jpg'],
        roomTypes: [
          {
            name: 'Island Villa 2-Bedroom',
            desc: 'Biệt thự giữa vườn xanh nhiệt đới yên bình có bể bơi riêng biệt lập.',
            capacity: 4,
            price: 4900000,
            image: '/uploads/room_10.jpg',
            amenities: ['Hồ bơi riêng', 'Bếp hiện đại', '2 phòng tắm lớn', 'Bãi biển biệt lập'],
            roomNumbers: ['B101', 'B102'],
          },
          {
            name: 'Sunset Ocean View Villa',
            desc: 'Biệt thự trên ghềnh đá ngắm hoàng hôn ngút ngàn ngoạn mục.',
            capacity: 4,
            price: 7200000,
            image: '/uploads/room_11.jpg',
            amenities: ['Hồ bơi tràn viền ghềnh đá', 'View hoàng hôn trọn vẹn', 'Đầu bếp riêng theo yêu cầu'],
            roomNumbers: ['R201'],
          },
        ],
      },
    ];

    let firstRoomIdForBooking = null;
    let secondRoomIdForBooking = null;
    let thirdRoomIdForBooking = null;
    let firstHotelId = null;

    // Chèn Khách sạn, Ảnh, Loại phòng và Phòng thực tế
    for (let i = 0; i < hotelData.length; i++) {
      const h = hotelData[i];
      const [hotelRes] = await pool.query(
        `INSERT INTO hotels (name, description, address, city, star, rating) VALUES (?, ?, ?, ?, ?, ?)`,
        [h.name, h.description, h.address, h.city, h.star, h.rating]
      );
      const hotelId = hotelRes.insertId;
      if (i === 0) firstHotelId = hotelId;

      // Chèn hotel_images
      for (let j = 0; j < h.images.length; j++) {
        await pool.query(
          `INSERT INTO hotel_images (hotel_id, image_url, is_primary) VALUES (?, ?, ?)`,
          [hotelId, h.images[j], j === 0 ? 1 : 0]
        );
      }

      // Chèn room_types và rooms
      for (const rt of h.roomTypes) {
        const [rtRes] = await pool.query(
          `INSERT INTO room_types (hotel_id, name, description, capacity, price, image_url, amenities) VALUES (?, ?, ?, ?, ?, ?, ?)`,
          [
            hotelId,
            rt.name,
            rt.desc,
            rt.capacity,
            rt.price,
            rt.image,
            JSON.stringify(rt.amenities),
          ]
        );
        const roomTypeId = rtRes.insertId;

        // Chèn danh sách rooms
        for (const roomNum of rt.roomNumbers) {
          const [rRes] = await pool.query(
            `INSERT INTO rooms (hotel_id, room_type_id, room_number, status) VALUES (?, ?, ?, ?)`,
            [hotelId, roomTypeId, roomNum, 'AVAILABLE']
          );

          if (!firstRoomIdForBooking) {
            firstRoomIdForBooking = rRes.insertId;
          } else if (!secondRoomIdForBooking) {
            secondRoomIdForBooking = rRes.insertId;
          } else if (!thirdRoomIdForBooking) {
            thirdRoomIdForBooking = rRes.insertId;
          }
        }
      }
    }

    console.log(`✅ Đã chèn thành công ${hotelData.length} khách sạn mẫu đầy đủ loại phòng và phòng!`);

    // 5. Chèn Bookings mẫu
    // Booking 1: Sắp tới (CONFIRMED) - User 1
    const nextWeekStart = new Date();
    nextWeekStart.setDate(nextWeekStart.getDate() + 5);
    const nextWeekEnd = new Date();
    nextWeekEnd.setDate(nextWeekEnd.getDate() + 8);

    const checkIn1 = nextWeekStart.toISOString().slice(0, 10);
    const checkOut1 = nextWeekEnd.toISOString().slice(0, 10);

    await pool.query(
      `INSERT INTO bookings (booking_code, user_id, room_id, check_in, check_out, guest_name, guest_phone, guest_email, total_price, status, payment_method, payment_status)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        'HB-2026-0001',
        user1Result.insertId,
        firstRoomIdForBooking,
        checkIn1,
        checkOut1,
        'Nguyễn Văn An',
        '0912345678',
        'user1@gmail.com',
        4050000,
        'CONFIRMED',
        'PAY_AT_HOTEL',
        'UNPAID',
      ]
    );

    // Booking 2: Đã hoàn thành trong quá khứ (COMPLETED) - User 1
    const pastStart = new Date();
    pastStart.setDate(pastStart.getDate() - 15);
    const pastEnd = new Date();
    pastEnd.setDate(pastEnd.getDate() - 13);

    await pool.query(
      `INSERT INTO bookings (booking_code, user_id, room_id, check_in, check_out, guest_name, guest_phone, guest_email, total_price, status, payment_method, payment_status)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        'HB-2026-0002',
        user1Result.insertId,
        secondRoomIdForBooking,
        pastStart.toISOString().slice(0, 10),
        pastEnd.toISOString().slice(0, 10),
        'Nguyễn Văn An',
        '0912345678',
        'user1@gmail.com',
        5200000,
        'COMPLETED',
        'CREDIT_CARD',
        'PAID',
      ]
    );

    // Booking 3: Đã hủy (CANCELLED) - User 2
    const cancelStart = new Date();
    cancelStart.setDate(cancelStart.getDate() + 10);
    const cancelEnd = new Date();
    cancelEnd.setDate(cancelEnd.getDate() + 12);

    await pool.query(
      `INSERT INTO bookings (booking_code, user_id, room_id, check_in, check_out, guest_name, guest_phone, guest_email, total_price, status, payment_method, payment_status)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        'HB-2026-0003',
        user2Result.insertId,
        thirdRoomIdForBooking,
        cancelStart.toISOString().slice(0, 10),
        cancelEnd.toISOString().slice(0, 10),
        'Trần Thị Mai',
        '0987654321',
        'user2@gmail.com',
        3700000,
        'CANCELLED',
        'PAY_AT_HOTEL',
        'UNPAID',
      ]
    );
    console.log('✅ Đã tạo 3 Bookings mẫu (CONFIRMED, COMPLETED, CANCELLED).');

    // 6. Chèn Reviews mẫu
    await pool.query(
      `INSERT INTO reviews (user_id, hotel_id, rating, comment) VALUES (?, ?, ?, ?)`,
      [
        user1Result.insertId,
        firstHotelId,
        5,
        'Khách sạn rất đẹp, phục vụ chuyên nghiệp và nhiệt tình. Vị trí ngay trung tâm vô cùng thuận tiện, bữa sáng buffet rất ngon!',
      ]
    );

    await pool.query(
      `INSERT INTO reviews (user_id, hotel_id, rating, comment) VALUES (?, ?, ?, ?)`,
      [
        user2Result.insertId,
        firstHotelId,
        5,
        'Trải nghiệm tuyệt vời! Phòng ốc sạch sẽ, thơm tho, view nhìn ra phố cổ cực chill. Nhất định sẽ quay lại lần sau!',
      ]
    );
    console.log('✅ Đã tạo Reviews mẫu cho khách sạn.');

    console.log('\n🎉 ====================================================');
    console.log('🎉 TOÀN BỘ CƠ SỞ DỮ LIỆU ĐÃ ĐƯỢC SEED THÀNH CÔNG RỰC RỠ!');
    console.log('🎉 ====================================================\n');

    process.exit(0);
  } catch (error) {
    console.error('❌ Lỗi khi seed database:', error);
    process.exit(1);
  }
}

seedDatabase();
