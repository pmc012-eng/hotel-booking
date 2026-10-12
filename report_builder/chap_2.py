# -*- coding: utf-8 -*-
"""
Module chap_2:
CHƯƠNG 2. PHÂN TÍCH VÀ THIẾT KẾ GIẢI PHÁP
- 2.1 Phân tích yêu cầu và chức năng cốt lõi
- 2.2 Use case hoặc luồng xử lý chính (Chèn ảnh Use Case tổng quát, Đặt phòng, Quản trị + Bảng 26 UC + 5 Biểu mẫu đặc tả chi tiết)
- 2.3 Thiết kế kiến trúc hệ thống hoặc pipeline xử lý (Chèn ảnh Kiến trúc 3 tầng + Lưu đồ xử lý đặt phòng)
- 2.4 Thiết kế cơ sở dữ liệu (Chèn ảnh ERD + 7 Bảng đặc tả chi tiết)
- 2.5 Thiết kế giao diện, API và các thành phần kỹ thuật cần thiết (Bảng danh mục Endpoints API)
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

def add_chapter_2(doc):
    """Nội dung chi tiết CHƯƠNG 2 (Khoảng 18-20 trang A4 chuẩn)."""
    add_chapter_title(doc, "2", "PHÂN TÍCH VÀ THIẾT KẾ GIẢI PHÁP")

    # 2.1 Phân tích yêu cầu và chức năng cốt lõi
    add_heading_2(doc, "2.1. Phân tích yêu cầu và chức năng cốt lõi")
    
    add_heading_3(doc, "2.1.1. Xác định chân dung người dùng (User Personas)")
    add_body_p(doc, "Quá trình phân tích yêu cầu phần mềm bắt đầu bằng việc thấu hiểu đối tượng thụ hưởng trực tiếp của sản phẩm. Hệ thống phục vụ 3 nhóm người dùng điển hình:")
    add_body_p(doc, "– Nhóm 1: Người dùng cá nhân / Du khách (Travelers): Là những người bận rộn, thường xuyên di chuyển công tác hoặc du lịch cùng gia đình, bạn bè. Nhu cầu cốt lõi của họ là sự nhanh chóng, tiện lợi, giao diện trực quan, dễ dàng tra cứu khách sạn tại các địa điểm du lịch, xem trước hình ảnh thực tế và đặt phòng nhanh mà không cần gọi điện thoại xác nhận.", is_bullet=True)
    add_body_p(doc, "– Nhóm 2: Khách hàng thành viên trung thành (Loyal Customers): Là những người dùng thường xuyên sử dụng ứng dụng. Họ cần khả năng quản lý lịch sử đơn đặt phòng, theo dõi trạng thái các chuyến đi sắp tới, có quyền hủy phòng linh hoạt khi lịch trình thay đổi và muốn đóng góp ý kiến nhận xét sau kỳ nghỉ.", is_bullet=True)
    add_body_p(doc, "– Nhóm 3: Nhà quản trị cơ sở lưu trú (Hotel Administrators): Là các chủ khách sạn hoặc nhà quản lý chuỗi phòng nghỉ. Nhu cầu cốt lõi của họ là công cụ quản lý tập trung: giám sát doanh thu tổng thể thời gian thực, chủ động cập nhật giá phòng, quản lý tình trạng bảo trì phòng vật lý và kiểm soát toàn bộ đơn đặt phòng phát sinh trong ngày.", is_bullet=True)

    add_heading_3(doc, "2.1.2. Phân tích các yêu cầu chức năng cốt lõi (Functional Requirements - FR)")
    add_body_p(doc, "Dựa trên kết quả khảo sát nghiệp vụ thực tế, các yêu cầu chức năng của hệ thống được phân rã thành 6 phân hệ nghiệp vụ chính:")
    add_body_p(doc, "1. Phân hệ Định danh và Xác thực (Authentication Module):", is_bullet=True)
    add_body_p(doc, "   – FR-01: Cho phép người dùng đăng ký tài khoản với các thông tin: Họ tên, Email, Mật khẩu, Số điện thoại. Hệ thống kiểm tra tính duy nhất của Email trên toàn hệ thống.")
    add_body_p(doc, "   – FR-02: Cho phép người dùng đăng nhập bằng Email và Mật khẩu. Khi thành công, hệ thống cấp phát thẻ phiên JSON Web Token (JWT) có thời hạn 7 ngày.")
    add_body_p(doc, "   – FR-03: Cho phép người dùng đăng xuất và xóa Token an toàn khỏi bộ nhớ thiết bị.")
    add_body_p(doc, "   – FR-04: Cho phép người dùng xem và cập nhật hồ sơ cá nhân (Họ tên, SĐT, ảnh đại diện).")
    add_body_p(doc, "   – FR-05: Cho phép người dùng đổi mật khẩu tài khoản sau khi xác thực đúng mật khẩu cũ.")
    add_body_p(doc, "2. Phân hệ Khám phá và Tìm kiếm (Discovery & Search Module):", is_bullet=True)
    add_body_p(doc, "   – FR-06: Hiển thị danh sách khách sạn thịnh hành trên màn hình trang chủ với đầy đủ thông tin: tên, ảnh đại diện, hạng sao, điểm rating và giá tối thiểu (min_price).")
    add_body_p(doc, "   – FR-07: Cho phép tìm kiếm toàn văn theo từ khóa tên khách sạn hoặc địa chỉ cụ thể.")
    add_body_p(doc, "   – FR-08: Hỗ trợ bộ lọc nâng cao đa tiêu chí: Lọc theo Tỉnh/Thành phố du lịch (Hà Nội, TP.HCM, Đà Nẵng, Nha Trang, Phú Quốc, Đà Lạt), Hạng sao (1-5★), Mức giá tối đa và Điểm đánh giá.")
    add_body_p(doc, "   – FR-09: Xem trang thông tin chi tiết khách sạn: mô tả vị trí, tiện ích chung, thư viện ảnh đa phương tiện và danh sách các hạng phòng đi kèm.")
    add_body_p(doc, "3. Phân hệ Đặt phòng và Quản lý phòng trống (Availability & Booking Module):", is_bullet=True)
    add_body_p(doc, "   – FR-10: Cung cấp giao diện bộ lịch chọn ngày nhận phòng (Check-in) và ngày trả phòng (Check-out) với các ràng buộc ngày logic.")
    add_body_p(doc, "   – FR-11: Tự động kiểm tra tính khả dụng của phòng trống theo thời gian thực dựa trên thuật toán loại trừ xung đột ngày giao cắt.")
    add_body_p(doc, "   – FR-12: Tự động tính toán số đêm lưu trú và tổng tiền dự kiến dựa trên đơn giá gốc của loại phòng.")
    add_body_p(doc, "   – FR-13: Quy trình đặt phòng 2 bước: Bước chọn cấu hình -> Bước xác nhận thông tin lưu trú (Họ tên người nhận phòng, SĐT, Email liên hệ) và phương thức thanh toán.")
    add_body_p(doc, "   – FR-14: Thực thi giao dịch đặt phòng nguyên tử: Tự động chọn 1 phòng vật lý còn trống, sinh mã booking duy nhất (BK + Timestamp + RandomHex), lưu đơn với trạng thái CONFIRMED và khóa phòng.")
    add_body_p(doc, "4. Phân hệ Lịch sử và Quản lý đơn đặt (Booking Lifecycle Module):", is_bullet=True)
    add_body_p(doc, "   – FR-15: Hiển thị danh sách các chuyến đi đã đặt của khách hàng theo 3 tab phân loại: Đã xác nhận, Đã hoàn thành, Đã hủy.")
    add_body_p(doc, "   – FR-16: Xem chi tiết đơn đặt phòng: Mã booking, tên khách sạn, loại phòng, số phòng vật lý, ngày check-in/out, tổng tiền, quy định nhận phòng.")
    add_body_p(doc, "   – FR-17: Cho phép khách hàng hủy đơn đặt phòng đối với các đơn ở trạng thái CONFIRMED trước ngày nhận phòng.")
    add_body_p(doc, "   – FR-18: Tự động giải phóng phòng trống ngay lập tức khi đơn chuyển sang trạng thái CANCELLED.")
    add_body_p(doc, "5. Phân hệ Nhận xét và Đánh giá (Review & Rating Module):", is_bullet=True)
    add_body_p(doc, "   – FR-19: Xem danh sách các đánh giá, điểm sao và bình luận của những khách lưu trú trước.")
    add_body_p(doc, "   – FR-20: Cho phép khách hàng viết nhận xét và chấm điểm số sao từ 1 đến 5 sao sau chuyến đi.")
    add_body_p(doc, "   – FR-21: Tự động cập nhật lại điểm rating trung bình cộng của khách sạn làm tròn 1 chữ số thập phân.")
    add_body_p(doc, "6. Phân hệ Quản trị hệ thống (Administration Module):", is_bullet=True)
    add_body_p(doc, "   – FR-22: Bảng điều khiển KPI Dashboard thống kê tổng quan: Tổng khách sạn, Tổng số phòng, Số đơn đặt phòng và Tổng doanh thu thực tế.")
    add_body_p(doc, "   – FR-23: Quản lý khách sạn (CRUD): Thêm mới khách sạn, sửa đổi thông tin, tải ảnh đại diện và xóa khách sạn (liên hoàn kèm phòng và ảnh).")
    add_body_p(doc, "   – FR-24: Quản lý loại phòng (Room Types): Tạo hạng phòng (Standard, Deluxe...), cấu hình đơn giá/đêm, sức chứa, tiện nghi và ảnh đại diện.")
    add_body_p(doc, "   – FR-25: Quản lý phòng vật lý (Rooms): Tạo các số phòng cụ thể (101, 102...) thuộc loại phòng và cập nhật trạng thái hoạt động / bảo trì.")
    add_body_p(doc, "   – FR-26: Tự động quét và đồng bộ giá sàn nhỏ nhất (`hotels.min_price = MIN(price)`) khi thêm hoặc sửa giá loại phòng.")

    add_heading_3(doc, "2.1.3. Phân tích các yêu cầu phi chức năng (Non-Functional Requirements - NFR)")
    add_body_p(doc, "Bên cạnh các tính năng nghiệp vụ, hệ thống đặt ra các tiêu chuẩn kỹ thuật phi chức năng khắt khe nhằm bảo đảm chất lượng phần mềm:")
    add_body_p(doc, "– Tính sẵn sàng (Availability): Hệ thống máy chủ API có khả năng phục vụ liên tục 24/7 với tỷ lệ sẵn sàng đạt tối thiểu 99.5%, bảo đảm người dùng có thể tra cứu và đặt phòng bất kỳ thời điểm nào trong ngày.", is_bullet=True)
    add_body_p(doc, "– Hiệu năng và Tốc độ đáp ứng (Performance): Thời gian phản hồi trung bình của các API truy vấn (tìm kiếm, xem chi tiết, kiểm tra phòng trống) đạt dưới 200 mili-giây trên mạng tiêu chuẩn; tốc độ vẽ khung hình trên ứng dụng Flutter đạt tối thiểu 60 FPS, không gây hiện tượng giật lag màn hình.", is_bullet=True)
    add_body_p(doc, "– Độ tin cậy và Toàn vẹn dữ liệu (Reliability & Data Integrity): Cơ sở dữ liệu tuân thủ các tính chất ACID; bảo đảm tuyệt đối không xảy ra tình trạng mất mát dữ liệu hoặc phân phối cùng 1 phòng vật lý cho 2 khách hàng khác nhau.", is_bullet=True)
    add_body_p(doc, "– Tính bảo mật an toàn thông tin (Security): Mã hóa 100% mật khẩu bằng giải thuật Bcrypt salt 10; sử dụng chuẩn xác thực JWT có chữ ký số điện tử; bảo vệ nghiêm ngặt các API quản trị qua 2 lớp Middleware xác thực và phân quyền RBAC.", is_bullet=True)
    add_body_p(doc, "– Tính công thái học và Trải nghiệm người dùng (Usability & UX): Giao diện được thiết kế theo ngôn ngữ Material Design hiện đại, màu sắc hài hòa, bố cục trực quan, các nút thao tác chính nằm trong vùng thuận tiện của ngón tay cái, tự động định dạng tiền tệ Việt Nam Đồng rõ ràng.", is_bullet=True)

    # 2.2 Use case hoặc luồng xử lý chính
    add_heading_2(doc, "2.2. Use case hoặc luồng xử lý chính")
    add_body_p(doc, "Mô hình Use Case là công cụ trực quan mạnh mẽ của ngôn ngữ UML giúp mô tả sự tương tác giữa các tác nhân bên ngoài (Actors) và hệ thống phần mềm. Dưới đây là phân tích chi tiết các biểu đồ Use Case và biểu mẫu đặc tả nghiệp vụ của hệ thống.")

    add_heading_3(doc, "2.2.1. Sơ đồ Use Case tổng quát toàn hệ thống")
    add_body_p(doc, "Biểu đồ Use Case tổng quát thể hiện toàn cảnh các chức năng của hệ thống được phân chia cho 3 tác nhân chính: Khách vãng lai (Guest), Khách hàng thành viên (Customer) và Quản trị viên (Admin).")
    
    # Chèn ảnh usecase_tong_quat.png
    add_image_box(doc, os.path.join(assets_dir, "usecase_tong_quat.png"), width_inches=6.0)
    add_figure_caption(doc, "2.1", "Sơ đồ Use Case tổng quát của toàn bộ hệ thống đặt phòng khách sạn")

    add_body_p(doc, "Như minh họa trên Hình 2.1, hệ thống thiết lập ranh giới phân quyền rõ ràng:")
    add_body_p(doc, "– Khách vãng lai có quyền thực hiện các Use Case cơ bản: UC-01 (Đăng ký/Đăng nhập), UC-02 (Tìm kiếm/Lọc khách sạn) và UC-03 (Xem thông tin chi tiết, loại phòng, ảnh).", is_bullet=True)
    add_body_p(doc, "– Khách hàng thành viên sau khi đăng nhập được kế thừa toàn bộ quyền của Khách vãng lai và mở khóa các Use Case cốt lõi: UC-04 (Kiểm tra phòng trống), UC-05 (Thực hiện đặt phòng), UC-06 (Xem lịch sử và hủy đơn), UC-07 (Viết nhận xét đánh giá).", is_bullet=True)
    add_body_p(doc, "– Quản trị viên (Admin) nắm giữ quyền kiểm soát tại Use Case UC-08 (Quản trị hệ thống: Khách sạn, Cơ cấu phòng và Giám sát doanh thu).", is_bullet=True)

    add_heading_3(doc, "2.2.2. Bảng danh mục 26 Use Case chi tiết")
    add_body_p(doc, "Toàn bộ 26 Use Case của hệ thống được thống kê đầy đủ trong Bảng 2.1 dưới đây:")

    add_table_caption(doc, "2.1", "Danh mục tổng hợp 26 Use Case cốt lõi của hệ thống đặt phòng khách sạn")
    tbl_uc = doc.add_table(rows=27, cols=6)
    tbl_uc.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl_uc.autofit = False
    widths_uc = [Inches(0.8), Inches(1.5), Inches(0.9), Inches(1.1), Inches(0.6), Inches(1.7)]
    
    headers_uc = ["Mã UC", "Tên Use Case", "Tác nhân", "Phân hệ", "Ưu tiên", "Mô tả tóm tắt"]
    for j, h in enumerate(headers_uc):
        tbl_uc.rows[0].cells[j].paragraphs[0].text = h
    format_table_row(tbl_uc.rows[0], widths_uc, bg_color="FFFFFF", is_header=True, font_size=11)

    uc_data = [
        ("UC-AUTH-01", "Đăng ký tài khoản", "Khách vãng lai", "Xác thực", "Bắt buộc", "Tạo tài khoản mới với email duy nhất và mật khẩu mã hóa."),
        ("UC-AUTH-02", "Đăng nhập hệ thống", "Khách vãng lai", "Xác thực", "Bắt buộc", "Xác thực danh tính và cấp phát thẻ phiên JWT token 7 ngày."),
        ("UC-AUTH-03", "Đăng xuất tài khoản", "Khách hàng, Admin", "Xác thực", "Bắt buộc", "Hủy phiên làm việc và xóa token lưu trữ an toàn."),
        ("UC-AUTH-04", "Xem & sửa hồ sơ", "Khách hàng", "Cá nhân", "Quan trọng", "Xem thông tin họ tên, SĐT và cập nhật hồ sơ cá nhân."),
        ("UC-AUTH-05", "Đổi mật khẩu", "Khách hàng, Admin", "Cá nhân", "Quan trọng", "Đổi mật khẩu tài khoản sau khi kiểm tra đúng mật khẩu cũ."),
        ("UC-EXPL-01", "Xem khách sạn nổi bật", "Tất cả", "Khám phá", "Bắt buộc", "Hiển thị danh sách khách sạn đề xuất trên màn hình Home."),
        ("UC-EXPL-02", "Tìm kiếm theo từ khóa", "Tất cả", "Khám phá", "Bắt buộc", "Tìm kiếm tức thời tên khách sạn hoặc địa chỉ cụ thể."),
        ("UC-EXPL-03", "Lọc khách sạn đa tiêu chí", "Tất cả", "Khám phá", "Bắt buộc", "Lọc kết hợp theo Thành phố, Sao, Khoảng giá và Rating."),
        ("UC-EXPL-04", "Xem chi tiết khách sạn", "Tất cả", "Khám phá", "Bắt buộc", "Xem ảnh, mô tả, vị trí, tiện ích chung và các loại phòng."),
        ("UC-EXPL-05", "Xem chi tiết loại phòng", "Tất cả", "Khám phá", "Bắt buộc", "Xem sức chứa, đơn giá niêm yết, tiện nghi và ảnh phòng."),
        ("UC-BOOK-01", "Kiểm tra phòng trống", "Khách hàng", "Đặt phòng", "Bắt buộc", "Chọn ngày Check-in/Out để quét phòng vật lý còn khả dụng."),
        ("UC-BOOK-02", "Tạo đơn đặt phòng", "Khách hàng", "Đặt phòng", "Bắt buộc", "Điền thông tin lưu trú, gán phòng ngẫu nhiên và khóa phòng."),
        ("UC-BOOK-03", "Xem lịch sử đơn đặt", "Khách hàng", "Đặt phòng", "Bắt buộc", "Xem danh sách các đơn đã đặt phân theo tab trạng thái."),
        ("UC-BOOK-04", "Xem chi tiết đơn", "Khách hàng", "Đặt phòng", "Bắt buộc", "Xem mã code, số phòng, số đêm, tổng tiền và quy định."),
        ("UC-BOOK-05", "Hủy đơn đặt phòng", "Khách hàng", "Đặt phòng", "Bắt buộc", "Khách hàng thực hiện hủy đơn trước ngày nhận phòng."),
        ("UC-BOOK-06", "Giải phóng phòng tự động", "Hệ thống", "Đặt phòng", "Bắt buộc", "Mở khóa phòng vật lý ngay lập tức khi đơn bị hủy."),
        ("UC-REV-01", "Xem danh sách đánh giá", "Tất cả", "Đánh giá", "Bắt buộc", "Xem bình luận và điểm sao từ các khách hàng trước."),
        ("UC-REV-02", "Viết đánh giá & Chấm sao", "Khách hàng", "Đánh giá", "Bắt buộc", "Chấm điểm từ 1 đến 5 sao kèm bình luận thực tế."),
        ("UC-REV-03", "Cập nhật rating trung bình", "Hệ thống", "Đánh giá", "Bắt buộc", "Tính toán lại điểm trung bình cộng hotels.rating tự động."),
        ("UC-ADM-01", "Xem Dashboard thống kê", "Admin", "Quản trị", "Bắt buộc", "Thống kê tổng khách sạn, phòng, đơn đặt và tổng doanh thu."),
        ("UC-ADM-02", "Thêm mới khách sạn", "Admin", "Quản trị", "Bắt buộc", "Tạo cơ sở lưu trú mới với địa chỉ, thành phố, hạng sao."),
        ("UC-ADM-03", "Chỉnh sửa khách sạn", "Admin", "Quản trị", "Bắt buộc", "Cập nhật mô tả, địa chỉ, ảnh đại diện của khách sạn."),
        ("UC-ADM-04", "Xóa khách sạn (Cascade)", "Admin", "Quản trị", "Bắt buộc", "Xóa khách sạn và tự động dọn dẹp các bản ghi liên quan."),
        ("UC-ADM-05", "Quản lý loại phòng", "Admin", "Quản trị", "Bắt buộc", "Tạo các hạng phòng, cấu hình đơn giá, sức chứa, tiện nghi."),
        ("UC-ADM-06", "Quản lý phòng vật lý", "Admin", "Quản trị", "Bắt buộc", "Tạo số phòng cụ thể (101, 102...) và cập nhật bảo trì."),
        ("UC-ADM-07", "Giám sát đơn đặt toàn bộ", "Admin", "Quản trị", "Bắt buộc", "Xem và kiểm soát trạng thái mọi đơn đặt phòng trên hệ thống.")
    ]
    for i, row_vals in enumerate(uc_data):
        row = tbl_uc.rows[i + 1]
        for c, val in enumerate(row_vals):
            row.cells[c].paragraphs[0].text = val
        format_table_row(row, widths_uc, bg_color="FFFFFF", is_header=False, font_size=10)
        row.cells[0].paragraphs[0].runs[0].bold = True
    set_table_borders(tbl_uc, color="000000", sz="4")

    add_heading_3(doc, "2.2.3. Sơ đồ Use Case phân hệ Đặt phòng và Quản trị")
    add_body_p(doc, "Để làm rõ luồng tương tác chuyên sâu của hai phân hệ phức tạp nhất trong hệ thống, các sơ đồ Use Case phân rã được xây dựng như sau:")
    
    # Chèn ảnh usecase_dat_phong.png
    add_image_box(doc, os.path.join(assets_dir, "usecase_dat_phong.png"), width_inches=5.8)
    add_figure_caption(doc, "2.2", "Sơ đồ Use Case phân hệ Đặt phòng và Quản lý tính khả dụng phòng trống")

    add_body_p(doc, "Hình 2.2 mô tả chi tiết chu trình đặt phòng: Khách hàng chọn ngày -> Hệ thống kiểm tra phòng trống -> Xác nhận thông tin -> Tạo mã booking và khóa phòng. Đặc biệt, tác nhân Hệ thống ngầm (System Worker) chịu trách nhiệm tự động giải phóng phòng khi người dùng thực hiện hủy đơn.")

    # Chèn ảnh usecase_quan_tri.png
    add_image_box(doc, os.path.join(assets_dir, "usecase_quan_tri.png"), width_inches=5.8)
    add_figure_caption(doc, "2.3", "Sơ đồ Use Case phân hệ Quản trị hệ thống dành cho Administrator")

    add_body_p(doc, "Hình 2.3 thể hiện toàn bộ các quyền hạn đặc quyền của Administrator trong việc giám sát KPI doanh thu, quản lý danh mục khách sạn, cơ cấu phòng ốc và cơ chế tự động đồng bộ giá sàn nhỏ nhất.")

    add_heading_3(doc, "2.2.4. Biểu mẫu đặc tả Use Case chi tiết chuẩn quốc tế (Use Case Specifications)")
    add_body_p(doc, "Để phục vụ quá trình lập trình và kiểm thử chính xác, 5 Use Case trọng yếu nhất của hệ thống được đặc tả chi tiết theo biểu mẫu chuẩn công nghiệp:")

    def render_spec_table(doc, table_id_str, title_str, spec_dict):
        add_table_caption(doc, table_id_str, title_str)
        tbl = doc.add_table(rows=len(spec_dict), cols=2)
        tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
        tbl.autofit = False
        widths = [Inches(1.8), Inches(4.8)]
        for idx, (k, v) in enumerate(spec_dict.items()):
            row = tbl.rows[idx]
            row.cells[0].paragraphs[0].text = k
            row.cells[1].paragraphs[0].text = v
            format_table_row(row, widths, bg_color="FFFFFF", is_header=False, font_size=11)
            row.cells[0].paragraphs[0].runs[0].bold = True
            row.cells[0].paragraphs[0].runs[0].font.color.rgb = RGBColor(0, 0, 0)
        set_table_borders(tbl, color="000000", sz="4")

    # Spec 1: UC-AUTH-02
    render_spec_table(doc, "2.2", "Bảng đặc tả Use Case chi tiết: UC-AUTH-02 (Đăng nhập & Cấp phát JWT)", {
        "Mã Use Case / Tên": "UC-AUTH-02: Đăng nhập hệ thống (User Authentication)",
        "Tác nhân (Actor)": "Khách vãng lai, Khách hàng, Quản trị viên",
        "Mục tiêu Use Case": "Xác thực tính hợp lệ của Email và Mật khẩu, cấp phát thẻ phiên JSON Web Token (JWT) có chữ ký số điện tử để duy trì phiên làm việc.",

        "Tiền điều kiện": "Người dùng đã có tài khoản tồn tại trong bảng `users`.",
        "Hậu điều kiện": "Token JWT được lưu vào bộ nhớ an toàn của thiết bị di động, người dùng chuyển hướng vào màn hình chính theo đúng quyền hạn (USER hoặc ADMIN).",
        "Luồng sự kiện chính (Basic Flow)": (
            "1. Người dùng mở màn hình Đăng nhập từ ứng dụng di động.\n"
            "2. Người dùng nhập Email và Mật khẩu, sau đó nhấn nút 'Đăng nhập'.\n"
            "3. Ứng dụng kiểm tra tính hợp lệ cơ bản tại Client (Email đúng định dạng, Mật khẩu >= 6 ký tự).\n"
            "4. Ứng dụng gửi yêu cầu POST /api/auth/login kèm body JSON chứa email và password.\n"
            "5. Máy chủ Backend tìm kiếm tài khoản theo email trong cơ sở dữ liệu.\n"
            "6. Backend sử dụng `bcrypt.compare()` để so khớp mật khẩu người dùng nhập với chuỗi băm lưu trong CSDL.\n"
            "7. Mật khẩu khớp hoàn toàn: Backend tạo JWT Token ký bằng Secret Key, hạn dùng 7 ngày, chứa payload: id, email, role.\n"
            "8. Backend trả về HTTP Status 200 OK kèm Token và đối tượng User.\n"
            "9. Ứng dụng di động lưu Token vào Secure Storage và cập nhật trạng thái đã đăng nhập thông qua AuthProvider."
        ),
        "Luồng ngoại lệ (Exception Flow)": (
            "– Ngoại lệ 1 (Email không tồn tại): Backend trả về mã lỗi 401 Unauthorized với thông báo 'Email hoặc mật khẩu không chính xác'.\n"
            "– Ngoại lệ 2 (Sai mật khẩu): `bcrypt.compare()` trả về false -> Backend phản hồi lỗi 401 Unauthorized tương tự để chống lộ thông tin tài khoản."
        ),
        "Quy tắc nghiệp vụ": "BR-SEC-01: Không bao giờ trả về thông báo 'Email không tồn tại' để tránh bị tin tặc dò quét danh sách email người dùng."
    })

    # Spec 2: UC-BOOK-01
    render_spec_table(doc, "2.3", "Bảng đặc tả Use Case chi tiết: UC-BOOK-01 (Kiểm tra phòng trống thời gian thực)", {
        "Mã Use Case / Tên": "UC-BOOK-01: Kiểm tra tính khả dụng của phòng theo thời gian thực (Check Room Availability)",
        "Tác nhân (Actor)": "Khách hàng thành viên (Customer / User)",
        "Mục tiêu Use Case": "Xác định chính xác các phòng vật lý thuộc loại phòng mong muốn còn trống trong khoảng ngày Check-in/Check-out.",
        "Tiền điều kiện": "Khách hàng đã chọn một khách sạn và một loại phòng cụ thể trên ứng dụng di động.",
        "Hậu điều kiện": "Hệ thống trả về danh sách các mã phòng vật lý khả dụng và kích hoạt nút tiếp tục Đặt phòng.",
        "Luồng sự kiện chính (Basic Flow)": (
            "1. Khách hàng mở hộp thoại chọn ngày lưu trú trên màn hình chi tiết loại phòng.\n"
            "2. Khách hàng chọn ngày Check-in và Check-out hợp lệ (Check-out > Check-in >= Ngày hiện tại).\n"
            "3. Ứng dụng di động gọi API GET /api/rooms/available?hotel_id=...&room_type_id=...&check_in=...&check_out=...\n"
            "4. Backend truy vấn cơ sở dữ liệu để tìm các phòng vật lý có `status = 'AVAILABLE'` thuộc loại phòng đó.\n"
            "5. Backend áp dụng thuật toán kiểm tra giao cắt lịch, loại bỏ các phòng đã có đơn đặt phòng hiệu lực (status != 'CANCELLED') trùng lịch.\n"
            "6. Backend trả về danh sách các phòng trống khả dụng.\n"
            "7. Ứng dụng hiển thị số lượng phòng còn trống, tính tổng số tiền dự kiến và mở khóa nút 'Tiến hành đặt phòng'."
        ),
        "Luồng ngoại lệ (Exception Flow)": (
            "– Ngoại lệ 1 (Ngày không hợp lệ): Khách chọn ngày Check-out nhỏ hơn hoặc bằng Check-in -> Ứng dụng cảnh báo đỏ ngay trên giao diện lịch.\n"
            "– Ngoại lệ 2 (Hết phòng hoàn toàn): Toàn bộ phòng vật lý đã kín lịch trong khoảng ngày đó -> Ứng dụng hiển thị nhãn đỏ 'Hết phòng trong khoảng thời gian này' và vô hiệu hóa nút đặt phòng."
        ),
        "Quy tắc nghiệp vụ": "BR-BOOK-01: Chỉ những đơn đặt phòng có trạng thái khác 'CANCELLED' mới được tính là đang chiếm chỗ phòng vật lý."
    })

    # Spec 3: UC-BOOK-02
    render_spec_table(doc, "2.4", "Bảng đặc tả Use Case chi tiết: UC-BOOK-02 (Tạo đơn đặt phòng & Khóa phòng)", {
        "Mã Use Case / Tên": "UC-BOOK-02: Thực hiện đặt phòng và gán phòng tự động (Create Hotel Booking)",
        "Tác nhân (Actor)": "Khách hàng thành viên (Customer / User)",
        "Mục tiêu Use Case": "Tạo hợp đồng đặt phòng mới, tự động phân phối 1 phòng vật lý khả dụng, sinh mã booking duy nhất và khóa lịch phòng.",
        "Tiền điều kiện": "Người dùng đã đăng nhập hợp lệ, đã chọn Loại phòng và khoảng ngày có phòng trống khả dụng.",
        "Hậu điều kiện": "Một bản ghi mới được lưu vào bảng `bookings` với trạng thái CONFIRMED, phòng vật lý được khóa lịch và hiển thị màn hình thành công.",
        "Luồng sự kiện chính (Basic Flow)": (
            "1. Khách hàng bấm nút 'Tiến hành đặt phòng' từ màn hình chi tiết.\n"
            "2. Màn hình xác nhận đặt phòng hiển thị: Tên khách sạn, Tên loại phòng, Ngày Check-in, Ngày Check-out, Số đêm, và Tổng số tiền.\n"
            "3. Khách hàng kiểm tra và hoàn thiện thông tin: Họ tên người lưu trú, Số điện thoại liên hệ, Email nhận biên lai.\n"
            "4. Khách hàng chọn hình thức thanh toán (mặc định: Thanh toán tại khách sạn - PAY_AT_HOTEL).\n"
            "5. Khách hàng nhấn nút 'Xác nhận đặt phòng'.\n"
            "6. Ứng dụng gửi yêu cầu POST /api/bookings kèm Token định danh và thông tin đơn đặt phòng.\n"
            "7. Backend thực hiện giao dịch nguyên tử (Atomic Transaction):\n"
            "   a. Lấy đơn giá gốc từ bảng `room_types` và tính lại `total_price = price * nights`.\n"
            "   b. Quét lại danh sách phòng trống của loại phòng trong khoảng ngày đó để chống xung đột tức thời.\n"
            "   c. Chọn 1 phòng vật lý (room_id) còn trống.\n"
            "   d. Sinh mã `booking_code` duy nhất dạng BK + Timestamp + Hex.\n"
            "   e. Ghi bản ghi vào bảng `bookings` với status='CONFIRMED', payment_status='UNPAID'.\n"
            "8. Backend phản hồi HTTP Status 201 Created kèm dữ liệu chi tiết của đơn đặt phòng.\n"
            "9. Ứng dụng hiển thị thông báo Đặt phòng thành công và cung cấp tùy chọn chuyển sang xem lịch sử đơn hàng."
        ),
        "Luồng ngoại lệ (Exception Flow)": (
            "– Ngoại lệ 1 (Xung đột tức thời - Race Condition): Tại thời điểm bấm nút, phòng cuối cùng vừa bị khách khác đặt -> Giao dịch thất bại, thông báo: 'Rất tiếc, phòng vừa được đặt hết. Vui lòng chọn loại phòng khác'.\n"
            "– Ngoại lệ 2 (Thiếu thông tin người nhận phòng): Ứng dụng chặn và yêu cầu nhập đầy đủ Họ tên và Số điện thoại."
        ),
        "Quy tắc nghiệp vụ": "BR-FIN-01: Tổng tiền bắt buộc phải do máy chủ tính toán từ cơ sở dữ liệu, tuyệt đối không nhận giá tiền do máy khách gửi lên."
    })

    # Spec 4: UC-BOOK-05 & 06
    render_spec_table(doc, "2.5", "Bảng đặc tả Use Case chi tiết: UC-BOOK-05 & 06 (Hủy đơn & Giải phóng phòng)", {
        "Mã Use Case / Tên": "UC-BOOK-05 & 06: Hủy đơn đặt phòng và Tự động giải phóng phòng (Cancel Booking & Auto-Release Room)",
        "Tác nhân (Actor)": "Khách hàng thành viên & Hệ thống ngầm (System Worker)",
        "Mục tiêu Use Case": "Cho phép khách hàng hủy đơn đặt phòng hợp lệ trước hạn; hệ thống tự động mở khóa phòng vật lý ngay lập tức.",
        "Tiền điều kiện": "Đơn đặt phòng đang ở trạng thái 'CONFIRMED' và ngày hiện tại chưa vượt quá ngày Check-in.",
        "Hậu điều kiện": "Trạng thái đơn chuyển sang 'CANCELLED'; phòng vật lý tương ứng lập tức sẵn sàng cho người dùng khác đặt.",
        "Luồng sự kiện chính (Basic Flow)": (
            "1. Khách hàng truy cập tab 'Chuyến đi của tôi' -> Chọn mục 'Đã xác nhận' -> Chọn đơn muốn hủy.\n"
            "2. Khách hàng nhấn nút 'Hủy đơn đặt phòng'.\n"
            "3. Ứng dụng hiển thị hộp thoại xác nhận: 'Bạn có chắc chắn muốn hủy đơn đặt phòng này?'.\n"
            "4. Khách hàng chọn 'Đồng ý hủy'.\n"
            "5. Ứng dụng gọi API PUT /api/bookings/:id/cancel kèm Token xác thực.\n"
            "6. Máy chủ kiểm tra quyền sở hữu đơn hàng (user_id của token trùng với user_id của booking).\n"
            "7. Máy chủ kiểm tra trạng thái hiện tại là CONFIRMED và ngày hiện tại <= check_in date.\n"
            "8. Máy chủ cập nhật `bookings.status = 'CANCELLED'` và `updated_at = NOW()`.\n"
            "9. Vì trạng thái đơn đã đổi thành CANCELLED, thuật toán kiểm tra phòng trống tự động bỏ qua đơn này, phòng vật lý lập tức khả dụng.\n"
            "10. Ứng dụng hiển thị thông báo 'Hủy đặt phòng thành công' và chuyển đơn sang tab 'Đã hủy'."
        ),
        "Luồng ngoại lệ (Exception Flow)": (
            "– Ngoại lệ 1 (Hủy đơn của người khác): Token không khớp -> Phản hồi 403 Forbidden: 'Bạn không có quyền can thiệp vào đơn này'.\n"
            "– Ngoại lệ 2 (Đơn đã qua ngày nhận phòng hoặc đã hoàn thành): Phản hồi 400 Bad Request: 'Đơn không ở trạng thái cho phép hủy'."
        ),
        "Quy tắc nghiệp vụ": "BR-BOOK-02: Đơn sau khi đã chuyển sang trạng thái CANCELLED thì không bao giờ được phép khôi phục ngược lại."
    })

    # Spec 5: UC-ADM-02 & 05
    render_spec_table(doc, "2.6", "Bảng đặc tả Use Case chi tiết: UC-ADM-02 & 05 (Quản lý khách sạn & Giá sàn)", {
        "Mã Use Case / Tên": "UC-ADM-02 & 05: Quản lý Khách sạn, Loại phòng & Tự động đồng bộ giá sàn (Hotel & Room Management)",
        "Tác nhân (Actor)": "Quản trị viên hệ thống (Administrator)",
        "Mục tiêu Use Case": "Admin tạo mới cơ sở lưu trú, tạo các hạng phòng và phòng vật lý; hệ thống tự động cập nhật mức giá sàn min_price.",
        "Tiền điều kiện": "Người dùng đăng nhập bằng tài khoản có vai trò 'ADMIN'.",
        "Hậu điều kiện": "Dữ liệu khách sạn, loại phòng và phòng vật lý được ghi nhận vào cơ sở dữ liệu và hiển thị ngay trên ứng dụng di động.",
        "Luồng sự kiện chính (Basic Flow)": (
            "1. Admin truy cập màn hình Quản trị -> Chọn 'Thêm khách sạn mới'.\n"
            "2. Admin điền thông tin: Tên khách sạn, Địa chỉ chi tiết, Tỉnh/Thành phố, Hạng sao (1-5), Mô tả và Giá niêm yết tham chiếu.\n"
            "3. Admin bấm 'Lưu khách sạn'. Backend ghi bản ghi mới vào bảng `hotels`.\n"
            "4. Admin vào mục quản lý phòng của khách sạn vừa tạo -> Chọn 'Thêm loại phòng' (Standard, Deluxe...).\n"
            "5. Admin nhập Tên loại phòng, Đơn giá/đêm, Sức chứa, Tiện nghi và Ảnh minh họa.\n"
            "6. Admin chọn 'Thêm phòng vật lý' và nhập các số phòng thực tế (ví dụ: 101, 102, 201) thuộc loại phòng tương ứng.\n"
            "7. Hệ thống tự động kích hoạt truy vấn đồng bộ giá sàn: Quét toàn bộ loại phòng của khách sạn và cập nhật `hotels.min_price = MIN(price)`."
        ),
        "Luồng ngoại lệ (Exception Flow)": (
            "– Ngoại lệ 1 (Trùng số phòng vật lý): Admin nhập số phòng 101 hai lần trong cùng một khách sạn -> Database chặn bởi ràng buộc UNIQUE(hotel_id, room_number), báo lỗi: 'Số phòng 101 đã tồn tại trong khách sạn này'.\n"
            "– Ngoại lệ 2 (Truy cập trái phép): Tài khoản thường gọi API quản trị -> Trả về lỗi 403 Forbidden do Middleware RBAC chặn."
        ),
        "Quy tắc nghiệp vụ": "BR-ADM-01: Giá tối thiểu min_price của khách sạn luôn phải phản ánh chính xác giá của loại phòng rẻ nhất hiện hữu."
    })

    # 2.3 Thiết kế kiến trúc hệ thống hoặc pipeline xử lý
    add_heading_2(doc, "2.3. Thiết kế kiến trúc hệ thống hoặc pipeline xử lý")
    add_body_p(doc, "Hệ thống được thiết kế theo mô hình kiến trúc phân tầng 3 lớp chuẩn mực (3-Tier Layered Architecture), phân định rạch ròi giữa Tầng Trình diễn (Presentation Tier), Tầng Nghiệp vụ (Application/Business Logic Tier) và Tầng Lưu trữ Dữ liệu (Data Tier).")

    # Hình 2.4: Kiến trúc hệ thống tổng thể
    add_image_box(doc, os.path.join(assets_dir, "kientruc_hethong.png"), width_inches=6.0)
    add_figure_caption(doc, "2.4", "Sơ đồ Kiến trúc hệ thống tổng thể 3 tầng (Client – Server – Database)")

    add_heading_3(doc, "2.3.1. Phân tích chi tiết các tầng kiến trúc hệ thống")
    add_body_p(doc, "1. Tầng Trình diễn (Presentation Tier - Mobile Client):", is_bullet=True)
    add_body_p(doc, "   – Được xây dựng hoàn toàn bằng Flutter SDK và ngôn ngữ Dart, đóng gói thành ứng dụng di động Android.")
    add_body_p(doc, "   – Tầng này chịu trách nhiệm hiển thị giao diện người dùng, tiếp nhận thao tác chạm vuốt, kiểm tra tính hợp lệ cơ bản của biểu mẫu (Client-side Form Validation) và xử lý hoạt họa mượt mà.")
    add_body_p(doc, "   – Áp dụng mô hình Provider State Management để quản lý trạng thái tập trung cho dữ liệu người dùng (`AuthProvider`), danh sách khách sạn (`HotelProvider`) và lịch sử chuyến đi (`BookingProvider`). Mọi tương tác mạng đều được đóng gói trong các dịch vụ chuyên biệt (`ApiService`, `AuthService`, `BookingService`) thông qua giao thức HTTP/HTTPS.")
    add_body_p(doc, "2. Tầng Nghiệp vụ (Business Logic Tier - Node.js/Express Server):", is_bullet=True)
    add_body_p(doc, "   – Đóng vai trò là bộ não trung tâm của hệ thống, lắng nghe các yêu cầu HTTP từ máy khách tại cổng dịch vụ (Port 5000).")
    add_body_p(doc, "   – Tầng này được tổ chức theo mô hình Controller - Model - Middleware: `Routing` điều hướng yêu cầu; `Middleware` thực thi xác thực JWT và kiểm tra quyền RBAC; `Controller` tiếp nhận tham số, gọi thuật toán nghiệp vụ và điều phối dữ liệu; `Model` thực thi các câu lệnh truy vấn SQL thông qua kết nối cơ sở dữ liệu.")
    add_body_p(doc, "   – Cài đặt bộ máy kiểm tra tính khả dụng phòng trống (Availability Engine) và bộ máy bảo vệ tài chính (Server-side Financial Protection).")
    add_body_p(doc, "3. Tầng Dữ liệu (Data Persistence Tier - MySQL Database):", is_bullet=True)
    add_body_p(doc, "   – Quản lý toàn bộ dữ liệu bền vững của hệ thống trên hệ quản trị cơ sở dữ liệu MySQL 8.x với động cơ InnoDB.")
    add_body_p(doc, "   – Cấu hình vùng nhớ kết nối dùng chung (Connection Pool) để tái sử dụng các kết nối cơ sở dữ liệu, giảm thiểu chi phí bắt tay kết nối và nâng cao khả năng chịu tải.")

    add_heading_3(doc, "2.3.2. Sơ đồ kiến trúc quản lý trạng thái di động (Flutter Provider State Management)")
    add_body_p(doc, "Để đảm bảo ứng dụng di động vận hành mượt mà với tốc độ 60 FPS và không bị render lại các phần tử giao diện không cần thiết, đồ án áp dụng mô hình quản lý trạng thái phản ứng (Reactive State Management) với Provider Pattern do Google khuyến nghị:")

    # Hình 2.5: kientruc_flutter_provider.png
    add_image_box(doc, os.path.join(assets_dir, "kientruc_flutter_provider.png"), width_inches=6.0)
    add_figure_caption(doc, "2.5", "Sơ đồ Kiến trúc quản lý trạng thái Flutter với Provider Pattern")

    add_body_p(doc, "Như minh họa trên Hình 2.5, luồng dữ liệu một chiều (Unidirectional Data Flow) được thiết lập chặt chẽ:")
    add_body_p(doc, "– UI Screens & Widgets tiếp nhận thao tác người dùng và kích hoạt các phương thức nghiệp vụ từ các lớp Provider (`AuthProvider`, `HotelProvider`, `BookingProvider`).", is_bullet=True)
    add_body_p(doc, "– Các lớp Provider kế thừa `ChangeNotifier`, đóng vai trò điều phối logic, gọi tới `ApiService` để giao tiếp với máy chủ Backend Node.js qua HTTP RESTful.", is_bullet=True)
    add_body_p(doc, "– Khi dữ liệu phản hồi trả về, Provider cập nhật thuộc tính trạng thái (State) và phát tín hiệu `notifyListeners()`. Chỉ các Widget lắng nghe (`Consumer` hoặc `context.watch()`) mới được vẽ lại, tối ưu hóa hiệu năng vẽ khung hình vượt trội.", is_bullet=True)

    add_heading_3(doc, "2.3.3. Lưu đồ quy trình xử lý đặt phòng và thuật toán chống trùng lặp lịch")
    add_body_p(doc, "Quy trình kiểm tra phòng trống và đặt phòng là hạt nhân quan trọng nhất của toàn bộ hệ thống. Lưu đồ thuật toán được trình bày chi tiết trên Hình 2.6:")

    # Hình 2.6: luong_xu_ly_dat_phong.png
    add_image_box(doc, os.path.join(assets_dir, "luong_xu_ly_dat_phong.png"), width_inches=5.8)
    add_figure_caption(doc, "2.6", "Lưu đồ quy trình xử lý kiểm tra phòng trống và tạo đơn đặt phòng tự động")

    add_body_p(doc, "Phân tích toán học của thuật toán kiểm tra giao cắt lịch (Date Overlapping Collision Prevention):")
    add_body_p(doc, "Giả sử khách hàng mới yêu cầu đặt một phòng trong khoảng thời gian $[CheckIn_{new}, CheckOut_{new}]$. Đối với một phòng vật lý cụ thể $R$, phòng này đã có một đơn đặt phòng hiện hữu $[CheckIn_{old}, CheckOut_{old}]$.")
    add_body_p(doc, "Hai khoảng thời gian trên KHÔNG XUNG ĐỘT khi và chỉ khi đơn mới kết thúc trước khi đơn cũ bắt đầu, HOẶC đơn mới bắt đầu sau khi đơn cũ đã kết thúc:")
    add_body_p(doc, "   $$\\text{NoConflict} = (CheckOut_{new} \\le CheckIn_{old}) \\lor (CheckIn_{new} \\ge CheckOut_{old})$$")
    add_body_p(doc, "Áp dụng định luật De Morgan, điều kiện XUNG ĐỘT LỊCH (Overlapping Conflict) xảy ra khi phủ định của điều kiện trên là đúng:")
    add_body_p(doc, "   $$\\text{Conflict} = \\neg \\text{NoConflict} = (CheckOut_{new} > CheckIn_{old}) \\land (CheckIn_{new} < CheckOut_{old})$$")

    # Hình 2.7: luong_thuat_toan_chong_trung_phong.png
    add_image_box(doc, os.path.join(assets_dir, "luong_thuat_toan_chong_trung_phong.png"), width_inches=6.0)
    add_figure_caption(doc, "2.7", "Sơ đồ Nguyên lý trực quan hóa giải thuật phòng ngừa xung đột giao cắt ngày phòng")

    add_body_p(doc, "Hình 2.7 trực quan hóa nguyên lý giao cắt thời gian: Khi khách hàng chọn ngày thuê phòng, hệ thống quét toàn bộ các phòng vật lý và loại bỏ các phòng có đơn đặt phòng hiệu lực vi phạm điều kiện giao cắt. Đoạn truy vấn SQL cốt lõi của thuật toán được cài đặt tại tầng Backend như sau:")

    add_code_block(doc, 
        "SELECT r.* FROM rooms r\n"
        "WHERE r.hotel_id = ? AND r.room_type_id = ? AND r.status = 'AVAILABLE'\n"
        "AND r.id NOT IN (\n"
        "    SELECT b.room_id FROM bookings b\n"
        "    WHERE b.status != 'CANCELLED'\n"
        "    AND (b.check_out > ? AND b.check_in < ?)\n"
        ");",
        caption="Đoạn mã SQL 2.1: Truy vấn lọc phòng trống khả dụng theo thuật toán loại trừ xung đột giao cắt"
    )

    add_heading_3(doc, "2.3.4. Sơ đồ tuần tự quy trình xác thực người dùng và cấp phát Token JWT")
    add_body_p(doc, "Quy trình xác thực người dùng và bảo mật hệ thống được thể hiện qua Sơ đồ Tuần tự (Sequence Diagram) trên Hình 2.8:")

    # Hình 2.8: sequence_auth_jwt.png
    add_image_box(doc, os.path.join(assets_dir, "sequence_auth_jwt.png"), width_inches=6.0)
    add_figure_caption(doc, "2.8", "Sơ đồ Tuần tự luồng xác thực đăng nhập và bảo mật phân quyền JWT")

    add_body_p(doc, "Như minh họa trên Hình 2.8, chu trình xác thực tuân thủ các bước nghiêm ngặt:")
    add_body_p(doc, "1. Người dùng gửi thông tin đăng nhập (Email, Mật khẩu) từ màn hình ứng dụng di động.", is_bullet=True)
    add_body_p(doc, "2. Controller tiếp nhận, truy vấn người dùng từ bảng `users` qua UserModel.", is_bullet=True)
    add_body_p(doc, "3. Hệ thống gọi hàm `bcrypt.compare()` để so khớp mật khẩu người dùng nhập với chuỗi băm lưu trữ.", is_bullet=True)
    add_body_p(doc, "4. Nếu khớp, Backend sinh chuỗi JSON Web Token ký số bằng thuật toán HMAC-SHA256 với thời hạn 7 ngày, chứa payload vai trò người dùng (USER hoặc ADMIN).", is_bullet=True)
    add_body_p(doc, "5. Client nhận Token, lưu vào bộ nhớ an toàn (Secure Storage) và đính kèm vào Header `Authorization: Bearer <Token>` cho các yêu cầu bảo vệ tiếp theo.", is_bullet=True)

    add_body_p(doc, "Dưới đây là đoạn mã nguồn Middleware xác thực JWT và kiểm soát phân quyền RBAC được triển khai trong dự án:")

    add_code_block(doc,
        "// auth.middleware.js - Middleware xác thực phiên JWT và phân quyền quản trị RBAC\n"
        "const jwt = require('jsonwebtoken');\n\n"
        "exports.verifyToken = (req, res, next) => {\n"
        "  const authHeader = req.headers['authorization'];\n"
        "  const token = authHeader && authHeader.split(' ')[1];\n"
        "  if (!token) {\n"
        "    return res.status(401).json({ success: false, message: 'Yêu cầu Token xác thực để truy cập' });\n"
        "  }\n"
        "  try {\n"
        "    const decoded = jwt.verify(token, process.env.JWT_SECRET);\n"
        "    req.user = decoded; // Lưu trữ payload { id, email, role }\n"
        "    next();\n"
        "  } catch (err) {\n"
        "    return res.status(401).json({ success: false, message: 'Token không hợp lệ hoặc đã hết hạn' });\n"
        "  }\n"
        "};\n\n"
        "exports.requireAdmin = (req, res, next) => {\n"
        "  if (req.user && req.user.role === 'ADMIN') {\n"
        "    next();\n"
        "  } else {\n"
        "    return res.status(403).json({ success: false, message: 'Truy cập bị từ chối: Yêu cầu quyền Quản trị viên' });\n"
        "  }\n"
        "};",
        caption="Đoạn mã 2.2: Middleware xác thực Token JWT và kiểm tra quyền RBAC"
    )

    add_heading_3(doc, "2.3.5. Sơ đồ tuần tự giao dịch đặt phòng và khóa phòng thời gian thực")
    add_body_p(doc, "Giao dịch tạo đơn đặt phòng đòi hỏi tính nhất quán tuyệt đối, tránh hiện tượng nhiều người cùng đặt 1 phòng trong cùng 1 tích tắc. Sơ đồ tuần tự của luồng đặt phòng được thể hiện trên Hình 2.9:")

    # Hình 2.9: sequence_dat_phong.png
    add_image_box(doc, os.path.join(assets_dir, "sequence_dat_phong.png"), width_inches=6.0)
    add_figure_caption(doc, "2.9", "Sơ đồ Tuần tự giao dịch tạo đơn đặt phòng và khóa phòng thời gian thực")

    add_body_p(doc, "Quy trình thực thi giao dịch đặt phòng tuân thủ nghiêm ngặt nguyên lý ACID:")
    add_body_p(doc, "1. Client gửi yêu cầu đặt phòng kèm Token định danh, khoảng ngày và thông tin khách lưu trú.", is_bullet=True)
    add_body_p(doc, "2. Middleware kiểm tra tính hợp lệ của Token JWT và nạp thông tin người dùng vào đối tượng Request.", is_bullet=True)
    add_body_p(doc, "3. Backend khởi tạo một Database Transaction: lấy đơn giá gốc từ CSDL và tự động tính `total_price = price * nights` (bảo vệ an toàn tài chính, loại trừ nguy cơ gian lận giá từ máy khách).", is_bullet=True)
    add_body_p(doc, "4. Quét và cấp phát 1 phòng vật lý khả dụng với lệnh `SELECT ... FOR UPDATE` nhằm khóa dòng tạm thời, ngăn chặn tranh chấp dữ liệu (Race Condition).", is_bullet=True)
    add_body_p(doc, "5. Sinh mã đặt phòng duy nhất dạng `BK` + Timestamp + RandomHex, lưu bản ghi vào bảng `bookings` với trạng thái CONFIRMED.", is_bullet=True)
    add_body_p(doc, "6. Cam kết giao dịch (Transaction Commit) và phản hồi mã 201 Created cùng dữ liệu đơn đặt phòng về ứng dụng di động.", is_bullet=True)

    add_body_p(doc, "Đoạn mã Controller xử lý giao dịch nguyên tử được lập trình như sau:")

    add_code_block(doc,
        "// booking.controller.js - Cài đặt giao dịch đặt phòng nguyên tử và tính giá Server-side\n"
        "exports.createBooking = async (req, res, next) => {\n"
        "  const conn = await db.getConnection();\n"
        "  try {\n"
        "    await conn.beginTransaction();\n"
        "    const { hotel_id, room_type_id, check_in, check_out, guest_name, guest_phone, guest_email } = req.body;\n"
        "    const userId = req.user.id;\n\n"
        "    // 1. Lấy giá gốc từ CSDL và tính tổng tiền an toàn\n"
        "    const [types] = await conn.query('SELECT price FROM room_types WHERE id = ?', [room_type_id]);\n"
        "    if (!types.length) throw new Error('Loại phòng không tồn tại');\n"
        "    const nights = Math.ceil(Math.abs(new Date(check_out) - new Date(check_in)) / (1000 * 60 * 60 * 24));\n"
        "    const totalPrice = types[0].price * nights;\n\n"
        "    // 2. Khóa và lấy 1 phòng vật lý còn trống (Chống Race Condition)\n"
        "    const [freeRooms] = await conn.query(`\n"
        "      SELECT id FROM rooms WHERE hotel_id = ? AND room_type_id = ? AND status = 'AVAILABLE'\n"
        "      AND id NOT IN (\n"
        "        SELECT room_id FROM bookings WHERE status != 'CANCELLED' AND (check_out > ? AND check_in < ?)\n"
        "      ) LIMIT 1 FOR UPDATE\n"
        "    `, [hotel_id, room_type_id, check_in, check_out]);\n"
        "    if (!freeRooms.length) throw new Error('Phòng vừa được khách khác đặt hết');\n\n"
        "    // 3. Sinh mã booking duy nhất và ghi dữ liệu\n"
        "    const bookingCode = 'BK' + Date.now().toString(36).toUpperCase() + Math.random().toString(36).substring(2, 5).toUpperCase();\n"
        "    await conn.query(`\n"
        "      INSERT INTO bookings (booking_code, user_id, room_id, check_in, check_out, guest_name, guest_phone, guest_email, total_price, status, payment_method)\n"
        "      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'CONFIRMED', 'PAY_AT_HOTEL')\n"
        "    `, [bookingCode, userId, freeRooms[0].id, check_in, check_out, guest_name, guest_phone, guest_email, totalPrice]);\n\n"
        "    await conn.commit();\n"
        "    res.status(201).json({ success: true, booking_code: bookingCode, total_price: totalPrice });\n"
        "  } catch (err) {\n"
        "    await conn.rollback();\n"
        "    next(err);\n"
        "  } finally {\n"
        "    conn.release();\n"
        "  }\n"
        "};",
        caption="Đoạn mã 2.3: Bộ điều khiển xử lý giao dịch đặt phòng nguyên tử và tính giá phía Server"
    )

    add_heading_3(doc, "2.3.6. Máy trạng thái (FSM) quản lý vòng đời đơn đặt phòng và cơ chế giải phóng phòng")
    add_body_p(doc, "Vòng đời của một đơn đặt phòng từ lúc khởi tạo đến khi kết thúc được mô hình hóa dưới dạng Máy trạng thái hữu hạn (Finite State Machine - FSM) trên Hình 2.10:")

    # Hình 2.10: state_booking_lifecycle.png
    add_image_box(doc, os.path.join(assets_dir, "state_booking_lifecycle.png"), width_inches=6.0)
    add_figure_caption(doc, "2.10", "Sơ đồ Máy trạng thái FSM quản lý vòng đời đơn đặt phòng và cơ chế giải phóng phòng")

    add_body_p(doc, "Phân tích các trạng thái và điều kiện chuyển dịch trong vòng đời đơn đặt phòng:")
    add_body_p(doc, "– Trạng thái PENDING: Khách hàng đang cấu hình thông tin lưu trú trên ứng dụng, phòng vật lý chưa bị khóa.", is_bullet=True)
    add_body_p(doc, "– Trạng thái CONFIRMED: Giao dịch đặt phòng thành công, phòng vật lý chính thức bị khóa lịch trong khoảng thời gian $[CheckIn, CheckOut]$.", is_bullet=True)
    add_body_p(doc, "– Trạng thái COMPLETED: Khách hàng hoàn tất kỳ lưu trú và làm thủ tục Check-out trả phòng tại quầy lễ tân.", is_bullet=True)
    add_body_p(doc, "– Trạng thái CANCELLED: Khách hàng hoặc Quản trị viên thực hiện hủy đơn trước hạn nhận phòng. Nhờ cơ chế liên kết trạng thái trong thuật toán kiểm tra phòng trống, ngay tại khoảnh khắc trạng thái chuyển thành CANCELLED, đơn này lập tức bị loại khỏi điều kiện xung đột, giải phóng phòng vật lý về trạng thái khả dụng cho toàn bộ người dùng khác ngay tức thì mà không cần tác vụ dọn dẹp nền chậm chạp.", is_bullet=True)

    # 2.4 Thiết kế cơ sở dữ liệu
    add_heading_2(doc, "2.4. Thiết kế cơ sở dữ liệu")
    add_body_p(doc, "Cơ sở dữ liệu của hệ thống được chuẩn hóa đạt chuẩn 3NF (Third Normal Form), triệt tiêu hoàn toàn sự dư thừa dữ liệu (Data Redundancy) và các dị thường khi thêm, sửa, xóa (Insertion, Update, Deletion Anomalies).")

    # Hình 2.11: sodo_erd_csdl.png
    add_image_box(doc, os.path.join(assets_dir, "sodo_erd_csdl.png"), width_inches=6.0)
    add_figure_caption(doc, "2.11", "Sơ đồ Quan hệ thực thể cơ sở dữ liệu (ERD – 7 bảng thực thể chuẩn hóa)")

    add_heading_3(doc, "2.4.1. Phân tích các mối quan hệ thực thể (Entity Relationships)")
    add_body_p(doc, "– Mối quan hệ giữa `hotels` và `hotel_images` (1 : N): Một khách sạn sở hữu một thư viện gồm nhiều hình ảnh minh họa thực tế. Khóa ngoại `hotel_images.hotel_id` tham chiếu đến `hotels.id` kèm quy tắc `ON DELETE CASCADE`.", is_bullet=True)
    add_body_p(doc, "– Mối quan hệ giữa `hotels` và `room_types` (1 : N): Một khách sạn có nhiều hạng loại phòng khác nhau (Standard, Deluxe, Suite VIP...). Khóa ngoại `room_types.hotel_id` tham chiếu `hotels.id` (ON DELETE CASCADE).", is_bullet=True)
    add_body_p(doc, "– Mối quan hệ giữa `hotels` và `rooms` (1 : N): Một khách sạn có nhiều phòng vật lý thực tế. Khóa ngoại `rooms.hotel_id` tham chiếu `hotels.id` (ON DELETE CASCADE).", is_bullet=True)
    add_body_p(doc, "– Mối quan hệ giữa `room_types` và `rooms` (1 : N): Một loại phòng bao gồm nhiều phòng vật lý cụ thể. Khóa ngoại `rooms.room_type_id` tham chiếu `room_types.id` (ON DELETE CASCADE).", is_bullet=True)
    add_body_p(doc, "– Mối quan hệ giữa `users` và `bookings` (1 : N): Một người dùng có thể thực hiện nhiều giao dịch đặt phòng theo thời gian. Khóa ngoại `bookings.user_id` tham chiếu `users.id` (ON DELETE CASCADE).", is_bullet=True)
    add_body_p(doc, "– Mối quan hệ giữa `rooms` và `bookings` (1 : N): Một phòng vật lý có thể được phân phối cho nhiều đơn đặt phòng ở các khoảng thời gian khác nhau không giao cắt. Khóa ngoại `bookings.room_id` tham chiếu `rooms.id` (ON DELETE CASCADE).", is_bullet=True)
    add_body_p(doc, "– Mối quan hệ giữa `users` và `reviews` (1 : N), và giữa `hotels` và `reviews` (1 : N): Một khách hàng có thể gửi nhiều bài đánh giá; một khách sạn nhận được nhiều nhận xét đánh giá từ cộng đồng khách lưu trú.", is_bullet=True)

    add_heading_3(doc, "2.4.2. Đặc tả chi tiết cấu trúc 7 bảng cơ sở dữ liệu (Data Dictionary)")
    add_body_p(doc, "Cấu trúc trường, kiểu dữ liệu, các ràng buộc và ý nghĩa nghiệp vụ của 7 bảng dữ liệu được đặc tả chi tiết từ Bảng 2.7 đến Bảng 2.13:")

    def render_schema_table(doc, table_id_str, tbl_name, desc_str, cols_data):
        add_table_caption(doc, table_id_str, f"Cấu trúc thực thể: {tbl_name} ({desc_str})")
        tbl = doc.add_table(rows=len(cols_data) + 1, cols=5)
        tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
        tbl.autofit = False
        widths = [Inches(1.3), Inches(1.3), Inches(1.2), Inches(0.6), Inches(2.2)]
        headers = ["Tên trường", "Kiểu dữ liệu", "Ràng buộc", "Null", "Diễn giải ý nghĩa nghiệp vụ"]
        for j, h in enumerate(headers):
            tbl.rows[0].cells[j].paragraphs[0].text = h
        format_table_row(tbl.rows[0], widths, bg_color="FFFFFF", is_header=True, font_size=11)
        for i, col in enumerate(cols_data):
            row = tbl.rows[i + 1]
            for c, val in enumerate(col):
                row.cells[c].paragraphs[0].text = val
            format_table_row(row, widths, bg_color="FFFFFF", is_header=False, font_size=10.5)
            row.cells[0].paragraphs[0].runs[0].bold = True
        set_table_borders(tbl, color="000000", sz="4")

    # Table users
    render_schema_table(doc, "2.7", "users", "Quản lý tài khoản người dùng và phân quyền hệ thống", [
        ("id", "INT", "PRIMARY KEY, AUTO_INC", "NO", "Mã định danh duy nhất người dùng"),
        ("name", "VARCHAR(100)", "NOT NULL", "NO", "Họ và tên đầy đủ người dùng"),
        ("email", "VARCHAR(100)", "UNIQUE, INDEX", "NO", "Địa chỉ email dùng để đăng nhập hệ thống"),
        ("password", "VARCHAR(255)", "NOT NULL", "NO", "Mật khẩu mã hóa một chiều bằng Bcrypt"),
        ("phone", "VARCHAR(20)", "DEFAULT NULL", "YES", "Số điện thoại di động liên hệ"),
        ("role", "ENUM('USER','ADMIN')", "DEFAULT 'USER'", "NO", "Phân quyền: 'USER' (khách) hoặc 'ADMIN' (quản trị)"),
        ("avatar", "VARCHAR(255)", "DEFAULT NULL", "YES", "Đường dẫn URL ảnh đại diện cá nhân"),
        ("created_at", "TIMESTAMP", "CURRENT_TIMESTAMP", "YES", "Thời điểm khởi tạo tài khoản"),
        ("updated_at", "TIMESTAMP", "ON UPDATE CURRENT_TIMESTAMP", "YES", "Thời điểm cập nhật thông tin gần nhất")
    ])

    # Table hotels
    render_schema_table(doc, "2.8", "hotels", "Lưu trữ thông tin cơ sở lưu trú và giá niêm yết tối thiểu", [
        ("id", "INT", "PRIMARY KEY, AUTO_INC", "NO", "Mã số định danh khách sạn"),
        ("name", "VARCHAR(255)", "NOT NULL, INDEX", "NO", "Tên đầy đủ của khách sạn"),
        ("description", "TEXT", "DEFAULT NULL", "YES", "Mô tả chi tiết tổng quan về khách sạn và vị trí"),
        ("address", "VARCHAR(255)", "NOT NULL", "NO", "Địa chỉ thực tế (Số nhà, tên đường, phường/xã)"),
        ("city", "VARCHAR(100)", "NOT NULL, INDEX", "NO", "Tỉnh/Thành phố phục vụ bộ lọc"),
        ("star", "TINYINT", "DEFAULT 4, INDEX", "NO", "Hạng sao xếp hạng từ 1 đến 5 sao"),
        ("rating", "DECIMAL(2,1)", "DEFAULT 4.5", "NO", "Điểm đánh giá trung bình cộng từ khách lưu trú (1.0 - 5.0)"),
        ("min_price", "DECIMAL(12,2)", "DEFAULT 0.00", "NO", "Mức giá niêm yết thấp nhất của các loại phòng hiện có"),
        ("created_at", "TIMESTAMP", "CURRENT_TIMESTAMP", "YES", "Thời điểm tạo khách sạn trong hệ thống"),
        ("updated_at", "TIMESTAMP", "ON UPDATE CURRENT_TIMESTAMP", "YES", "Thời điểm sửa đổi thông tin gần nhất")
    ])

    # Table hotel_images
    render_schema_table(doc, "2.9", "hotel_images", "Thư viện hình ảnh đa phương tiện của khách sạn", [
        ("id", "INT", "PRIMARY KEY, AUTO_INC", "NO", "Mã số định danh ảnh"),
        ("hotel_id", "INT", "FK -> hotels(id)", "NO", "Khóa ngoại liên kết khách sạn (ON DELETE CASCADE)"),
        ("image_url", "VARCHAR(255)", "NOT NULL", "NO", "Đường dẫn URL hình ảnh chất lượng cao"),
        ("is_primary", "BOOLEAN", "DEFAULT FALSE", "NO", "Cờ đánh dấu ảnh đại diện chính hiển thị trên card")
    ])

    # Table room_types
    render_schema_table(doc, "2.10", "room_types", "Định nghĩa các hạng phòng, bảng giá và tiện nghi", [
        ("id", "INT", "PRIMARY KEY, AUTO_INC", "NO", "Mã số định danh loại phòng"),
        ("hotel_id", "INT", "FK -> hotels(id)", "NO", "Khóa ngoại thuộc khách sạn nào (ON DELETE CASCADE)"),
        ("name", "VARCHAR(100)", "NOT NULL", "NO", "Tên hạng phòng: Standard, Deluxe, Suite VIP..."),
        ("description", "TEXT", "DEFAULT NULL", "YES", "Mô tả không gian và trang thiết bị trong phòng"),
        ("capacity", "INT", "DEFAULT 2", "NO", "Sức chứa tối đa (Số lượng người lớn tiêu chuẩn)"),
        ("price", "DECIMAL(12,2)", "NOT NULL", "NO", "Đơn giá thuê cho 1 đêm lưu trú (VND)"),
        ("image_url", "VARCHAR(255)", "DEFAULT NULL", "YES", "Ảnh minh họa tiêu biểu của loại phòng"),
        ("amenities", "TEXT", "DEFAULT NULL", "YES", "Chuỗi JSON / danh mục tiện ích (Wifi, Tủ lạnh...)"),
        ("created_at", "TIMESTAMP", "CURRENT_TIMESTAMP", "YES", "Thời điểm tạo loại phòng")
    ])

    # Table rooms
    render_schema_table(doc, "2.11", "rooms", "Danh mục phòng vật lý thực tế trong khách sạn", [
        ("id", "INT", "PRIMARY KEY, AUTO_INC", "NO", "Mã số định danh phòng vật lý"),
        ("hotel_id", "INT", "FK -> hotels(id)", "NO", "Thuộc khách sạn nào (ON DELETE CASCADE)"),
        ("room_type_id", "INT", "FK -> room_types(id)", "NO", "Thuộc loại phòng nào (ON DELETE CASCADE)"),
        ("room_number", "VARCHAR(20)", "UNIQUE WITH hotel_id", "NO", "Số phòng thực tế dán tại cửa (101, 102...)"),
        ("status", "ENUM('AVAILABLE','MAINTENANCE')", "DEFAULT 'AVAILABLE'", "NO", "Trạng thái vận hành của phòng vật lý"),
        ("created_at", "TIMESTAMP", "CURRENT_TIMESTAMP", "YES", "Thời điểm đưa phòng vào hệ thống")
    ])

    # Table bookings
    render_schema_table(doc, "2.12", "bookings", "Quản lý hợp đồng giao dịch đặt phòng của khách hàng", [
        ("id", "INT", "PRIMARY KEY, AUTO_INC", "NO", "Mã số định danh đơn đặt phòng"),
        ("booking_code", "VARCHAR(30)", "UNIQUE", "NO", "Mã hiển thị cho khách hàng (VD: BK1726451234AB)"),
        ("user_id", "INT", "FK -> users(id)", "NO", "Khóa ngoại người đặt phòng (ON DELETE CASCADE)"),
        ("room_id", "INT", "FK -> rooms(id)", "NO", "Khóa ngoại phòng vật lý được phân phối"),
        ("check_in", "DATE", "NOT NULL, INDEX", "NO", "Ngày bắt đầu nhận phòng (YYYY-MM-DD)"),
        ("check_out", "DATE", "NOT NULL, INDEX", "NO", "Ngày trả phòng rời đi (YYYY-MM-DD)"),
        ("guest_name", "VARCHAR(100)", "NOT NULL", "NO", "Họ tên người lưu trú thực tế"),
        ("guest_phone", "VARCHAR(20)", "NOT NULL", "NO", "Số điện thoại liên lạc của khách lưu trú"),
        ("guest_email", "VARCHAR(100)", "NOT NULL", "NO", "Địa chỉ email gửi hóa đơn và mã vé"),
        ("total_price", "DECIMAL(12,2)", "NOT NULL", "NO", "Tổng tiền lưu trú do Server tính toán (VND)"),
        ("status", "ENUM('PENDING','CONFIRMED','COMPLETED','CANCELLED')", "DEFAULT 'CONFIRMED'", "NO", "Trạng thái vòng đời của đơn đặt phòng"),
        ("payment_method", "VARCHAR(50)", "DEFAULT 'PAY_AT_HOTEL'", "NO", "Hình thức thanh toán: Trực tiếp / Thẻ"),
        ("payment_status", "ENUM('UNPAID','PAID')", "DEFAULT 'UNPAID'", "NO", "Trạng thái thu tiền"),
        ("created_at", "TIMESTAMP", "CURRENT_TIMESTAMP", "YES", "Thời điểm hoàn tất giao dịch đặt phòng"),
        ("updated_at", "TIMESTAMP", "ON UPDATE CURRENT_TIMESTAMP", "YES", "Thời điểm trạng thái thay đổi gần nhất")
    ])

    # Table reviews
    render_schema_table(doc, "2.13", "reviews", "Lưu trữ đánh giá và bình luận trải nghiệm của khách hàng", [
        ("id", "INT", "PRIMARY KEY, AUTO_INC", "NO", "Mã số định danh đánh giá"),
        ("user_id", "INT", "FK -> users(id)", "NO", "Người thực hiện đánh giá (ON DELETE CASCADE)"),
        ("hotel_id", "INT", "FK -> hotels(id)", "NO", "Khách sạn được đánh giá (ON DELETE CASCADE)"),
        ("rating", "TINYINT", "CHECK (rating BETWEEN 1 AND 5)", "NO", "Điểm chấm số sao từ 1 đến 5 sao"),
        ("comment", "TEXT", "NOT NULL", "NO", "Nội dung nhận xét chi tiết của khách hàng"),
        ("created_at", "TIMESTAMP", "CURRENT_TIMESTAMP", "YES", "Thời điểm đăng tải đánh giá")
    ])

    # 2.5 Thiết kế giao diện, API và các thành phần kỹ thuật cần thiết
    add_heading_2(doc, "2.5. Thiết kế giao diện, API và các thành phần kỹ thuật cần thiết")

    add_heading_3(doc, "2.5.1. Thiết kế hệ thống API RESTful")
    add_body_p(doc, "Hệ thống xây dựng một tập hợp toàn diện các Endpoints API tuân thủ tiêu chuẩn RESTful, sử dụng các mã trạng thái HTTP chuẩn để phản hồi kết quả:")
    add_body_p(doc, "– 200 OK: Truy vấn hoặc xử lý yêu cầu thành công.", is_bullet=True)
    add_body_p(doc, "– 201 Created: Tạo mới tài nguyên thành công (đăng ký tài khoản, tạo đơn booking, thêm khách sạn).", is_bullet=True)
    add_body_p(doc, "– 400 Bad Request: Dữ liệu gửi lên không hợp lệ hoặc vi phạm logic nghiệp vụ.", is_bullet=True)
    add_body_p(doc, "– 401 Unauthorized: Chưa cung cấp Token JWT hoặc Token đã hết hạn.", is_bullet=True)
    add_body_p(doc, "– 403 Forbidden: Tài khoản không có đủ quyền hạn truy cập (ví dụ tài khoản USER gọi API Admin).", is_bullet=True)
    add_body_p(doc, "– 404 Not Found: Tài nguyên yêu cầu không tồn tại trong cơ sở dữ liệu.", is_bullet=True)
    add_body_p(doc, "– 500 Internal Server Error: Lỗi ngoại lệ phía máy chủ.")

    add_table_caption(doc, "2.14", "Danh mục các Endpoints API RESTful chính của hệ thống")
    tbl_api = doc.add_table(rows=18, cols=5)
    tbl_api.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl_api.autofit = False
    widths_api = [Inches(1.0), Inches(2.2), Inches(0.9), Inches(1.3), Inches(1.2)]
    
    headers_api = ["Method", "Endpoint URI", "Quyền hạn", "Tham số / Body", "Ý nghĩa chức năng"]
    for j, h in enumerate(headers_api):
        tbl_api.rows[0].cells[j].paragraphs[0].text = h
    format_table_row(tbl_api.rows[0], widths_api, bg_color="FFFFFF", is_header=True, font_size=11)

    api_list = [
        ("POST", "/api/auth/register", "Public", "name, email, password, phone", "Đăng ký tài khoản mới"),
        ("POST", "/api/auth/login", "Public", "email, password", "Đăng nhập và nhận Token JWT"),
        ("GET", "/api/auth/profile", "User/Admin", "Header Bearer Token", "Xem thông tin tài khoản hiện tại"),
        ("PUT", "/api/auth/profile", "User/Admin", "name, phone, avatar", "Cập nhật hồ sơ cá nhân"),
        ("GET", "/api/hotels", "Public", "city, star, min_price, search", "Lấy danh sách khách sạn kèm bộ lọc"),
        ("GET", "/api/hotels/:id", "Public", "id (param)", "Lấy chi tiết khách sạn và loại phòng"),
        ("POST", "/api/hotels", "Admin", "name, address, city, star...", "Tạo mới khách sạn"),
        ("PUT", "/api/hotels/:id", "Admin", "name, address, city, star...", "Cập nhật thông tin khách sạn"),
        ("DELETE", "/api/hotels/:id", "Admin", "id (param)", "Xóa khách sạn liên hoàn"),
        ("GET", "/api/rooms/available", "Public", "hotel_id, room_type_id, in, out", "Kiểm tra phòng trống thời gian thực"),
        ("POST", "/api/rooms/types", "Admin", "hotel_id, name, price, capacity", "Thêm loại phòng mới"),
        ("POST", "/api/rooms", "Admin", "hotel_id, room_type_id, number", "Thêm phòng vật lý mới"),
        ("POST", "/api/bookings", "User", "hotel_id, room_type_id, in, out...", "Thực hiện tạo đơn đặt phòng"),
        ("GET", "/api/bookings/my", "User", "status (query)", "Xem lịch sử đơn đặt của cá nhân"),
        ("GET", "/api/bookings/:id", "User/Admin", "id (param)", "Xem chi tiết một đơn đặt phòng"),
        ("PUT", "/api/bookings/:id/cancel", "User/Admin", "id (param)", "Hủy đơn đặt phòng và nhả phòng"),
        ("GET", "/api/admin/dashboard", "Admin", "Header Bearer Token", "Lấy số liệu thống kê KPI và doanh thu")
    ]
    for i, (m, u, p, b, d) in enumerate(api_list):
        row = tbl_api.rows[i + 1]
        row.cells[0].paragraphs[0].text = m
        row.cells[1].paragraphs[0].text = u
        row.cells[2].paragraphs[0].text = p
        row.cells[3].paragraphs[0].text = b
        row.cells[4].paragraphs[0].text = d
        format_table_row(row, widths_api, bg_color="FFFFFF", is_header=False, font_size=10)
        row.cells[0].paragraphs[0].runs[0].bold = True
    set_table_borders(tbl_api, color="000000", sz="4")

    add_heading_3(doc, "2.5.2. Thiết kế luồng trải nghiệm người dùng (User Flow UX)")
    add_body_p(doc, "Ứng dụng Flutter được thiết kế theo cấu trúc điều hướng tối giản 4 màn hình chính thông qua thanh điều hướng đáy (Bottom Navigation Bar):")
    add_body_p(doc, "– Tab 1: Trang chủ (Home Screen) – Hiển thị thanh tìm kiếm, bộ lọc nhanh theo thành phố du lịch, danh sách khách sạn nổi bật và danh mục khuyến mãi.", is_bullet=True)
    add_body_p(doc, "– Tab 2: Tìm kiếm nâng cao (Search & Filter Screen) – Cung cấp bộ lọc kết hợp đầy đủ tiêu chí (thành phố, số sao, khoảng giá trần, rating tối thiểu).", is_bullet=True)
    add_body_p(doc, "– Tab 3: Chuyến đi của tôi (My Bookings Screen) – Quản lý toàn diện lịch sử các đơn đặt phòng, phân tách rõ ràng theo 3 tab con: 'Đã xác nhận', 'Đã hoàn thành' và 'Đã hủy'.", is_bullet=True)
    add_body_p(doc, "– Tab 4: Tài khoản cá nhân (Profile Screen) – Xem thông tin cá nhân, cập nhật số điện thoại, đổi mật khẩu, đăng xuất và nút truy cập cổng quản trị (nếu tài khoản có vai trò ADMIN).", is_bullet=True)

    doc.add_page_break()

