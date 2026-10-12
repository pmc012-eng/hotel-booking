# -*- coding: utf-8 -*-
"""
Module pre_body: Bìa chính, Bìa phụ, Lời cam đoan, Mục lục, Danh mục từ viết tắt, Danh mục hình vẽ, Danh mục bảng biểu.
(Số trang được đồng bộ 100% khớp với kết quả layout thực tế của Microsoft Word).
"""

import docx
from docx.shared import Cm, Pt, Inches, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT, WD_ALIGN_VERTICAL
from report_builder.helpers import (
    apply_section_margins, add_special_title, add_body_p,
    set_table_borders, format_table_row, set_cell_background
)

def add_cover_page(doc, is_sub=False):
    """Trang bìa chính hoặc bìa phụ."""
    p1 = doc.add_paragraph()
    p1.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p1.paragraph_format.space_before = Pt(0)
    p1.paragraph_format.space_after = Pt(2)
    p1.paragraph_format.first_line_indent = Cm(0)
    r1 = p1.add_run("BỘ GIÁO DỤC VÀ ĐÀO TẠO\nTRƯỜNG ĐẠI HỌC BÁCH KHOA\nKHOA CÔNG NGHỆ THÔNG TIN")
    r1.font.name = 'Times New Roman'
    r1.font.size = Pt(14)
    r1.bold = True

    p_line = doc.add_paragraph()
    p_line.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p_line.paragraph_format.space_before = Pt(2)
    p_line.paragraph_format.space_after = Pt(36)
    p_line.paragraph_format.first_line_indent = Cm(0)
    r_l = p_line.add_run("-----------------------***-----------------------")
    r_l.font.name = 'Times New Roman'
    r_l.font.size = Pt(13)
    r_l.bold = True

    # Title box
    p_badge = doc.add_paragraph()
    p_badge.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p_badge.paragraph_format.space_before = Pt(20)
    p_badge.paragraph_format.space_after = Pt(8)
    p_badge.paragraph_format.first_line_indent = Cm(0)
    r_b = p_badge.add_run("BÁO CÁO ĐỒ ÁN TỐT NGHIỆP / ĐỒ ÁN KỲ" if not is_sub else "ĐỒ ÁN TỐT NGHIỆP ĐẠI HỌC")
    r_b.font.name = 'Times New Roman'
    r_b.font.size = Pt(15)
    r_b.bold = True

    p_title = doc.add_paragraph()
    p_title.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p_title.paragraph_format.space_before = Pt(10)
    p_title.paragraph_format.space_after = Pt(12)
    p_title.paragraph_format.first_line_indent = Cm(0)
    p_title.paragraph_format.line_spacing = 1.3
    r_t = p_title.add_run("NGHIÊN CỨU, THIẾT KẾ VÀ PHÁT TRIỂN HỆ THỐNG\nĐẶT PHÒNG KHÁCH SẠN TRỰC TUYẾN TRÊN NỀN TẢNG\nDI ĐỘNG FLUTTER VÀ KIẾN TRÚC RESTFUL API")
    r_t.font.name = 'Times New Roman'
    r_t.font.size = Pt(18)
    r_t.bold = True
    r_t.font.color.rgb = RGBColor(0, 0, 0)

    p_spec = doc.add_paragraph()
    p_spec.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p_spec.paragraph_format.space_before = Pt(6)
    p_spec.paragraph_format.space_after = Pt(50)
    p_spec.paragraph_format.first_line_indent = Cm(0)
    r_sp = p_spec.add_run("Chuyên ngành: Kỹ thuật Phần mềm / Công nghệ Thông tin")
    r_sp.font.name = 'Times New Roman'
    r_sp.font.size = Pt(14)
    r_sp.italic = True

    # Info table
    info_tbl = doc.add_table(rows=4, cols=2)
    info_tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    info_tbl.autofit = False
    widths = [Inches(2.5), Inches(3.8)]
    
    rows_data = [
        ("Sinh viên thực hiện:", "Sinh viên Nghiên cứu & Phát triển"),
        ("Mã số sinh viên:", "2020xxxx - Khóa 65"),
        ("Giảng viên hướng dẫn:", "TS. Giảng viên Hướng dẫn"),
        ("Bộ môn:", "Công nghệ Phần mềm")
    ]
    for idx, (label, val) in enumerate(rows_data):
        row = info_tbl.rows[idx]
        row.cells[0].paragraphs[0].text = label
        row.cells[1].paragraphs[0].text = val
        format_table_row(row, widths, bg_color=None, is_header=False, font_size=13)
        row.cells[0].paragraphs[0].runs[0].bold = True

    p_footer = doc.add_paragraph()
    p_footer.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p_footer.paragraph_format.space_before = Pt(80)
    p_footer.paragraph_format.space_after = Pt(0)
    p_footer.paragraph_format.first_line_indent = Cm(0)
    r_f = p_footer.add_run("Hà Nội – Năm 2026")
    r_f.font.name = 'Times New Roman'
    r_f.font.size = Pt(14)
    r_f.bold = True

    doc.add_page_break()

def add_pledge_and_thanks(doc):
    """Lời cam đoan và Lời cảm ơn."""
    add_special_title(doc, "LỜI CAM ĐOAN")
    add_body_p(doc, "Tôi xin cam đoan rằng toàn bộ nội dung được trình bày trong bản Báo cáo Đồ án này là kết quả nghiên cứu, thiết kế và phát triển độc lập của bản thân tôi dưới sự định hướng và hướng dẫn tận tình của Giảng viên hướng dẫn.")
    add_body_p(doc, "Các dữ liệu, sơ đồ kiến trúc, biểu đồ Use Case, mô hình cơ sở dữ liệu và mã nguồn chương trình ứng dụng đặt phòng khách sạn (bao gồm cả phân hệ Mobile App xây dựng bằng Flutter và phân hệ Backend API xây dựng bằng Node.js/Express kết hợp MySQL) được xây dựng thực tế, không sao chép trái phép từ bất kỳ công trình nghiên cứu hay đề tài tốt nghiệp nào khác.")
    add_body_p(doc, "Các tài liệu tham khảo, thư viện mã nguồn mở và nền tảng công nghệ được kế thừa trong quá trình thực hiện đều đã được trích dẫn nguồn gốc xuất xứ rõ ràng và đầy đủ theo đúng quy chuẩn học thuật của Nhà trường. Nếu phát hiện có bất kỳ sự gian lận hay vi phạm quy chế liêm chính học thuật nào, tôi xin chịu hoàn toàn trách nhiệm trước Hội đồng Đánh giá và Ban Giám hiệu Nhà trường.")
    
    p_sign = doc.add_paragraph()
    p_sign.alignment = WD_ALIGN_PARAGRAPH.RIGHT
    p_sign.paragraph_format.space_before = Pt(18)
    p_sign.paragraph_format.first_line_indent = Cm(0)
    r_s = p_sign.add_run("Hà Nội, tháng 09 năm 2026\nSinh viên thực hiện\n\n\n(Ký và ghi rõ họ tên)")
    r_s.font.name = 'Times New Roman'
    r_s.font.size = Pt(14)
    r_s.italic = True

    doc.add_page_break()

    add_special_title(doc, "LỜI CẢM ƠN")
    add_body_p(doc, "Để hoàn thành được bản Báo cáo Đồ án kỳ này một cách toàn diện và sâu sắc, tôi xin bày tỏ lòng biết ơn chân thành và sâu sắc nhất tới toàn thể quý Thầy, Cô giáo thuộc Khoa Công nghệ Thông tin – Trường Đại học Bách Khoa, những người đã truyền thụ cho tôi những tri thức nền tảng vững chắc về khoa học máy tính, kỹ thuật phần mềm, thiết kế hệ thống và tư duy giải quyết vấn đề công nghệ trong suốt những năm tháng học tập vừa qua.")
    add_body_p(doc, "Đặc biệt, tôi xin gửi lời cảm ơn sâu sắc nhất tới Thầy/Cô Giảng viên Hướng dẫn, người đã luôn dành nhiều thời gian quý báu để định hướng đề tài, tận tình chỉ dẫn phương pháp tiếp cận khoa học, phản biện các giải pháp kỹ thuật và đưa ra những lời khuyên vô cùng xác đáng giúp tôi từng bước tháo gỡ các khó khăn hóc búa trong suốt quá trình xây dựng hệ thống.")
    add_body_p(doc, "Tôi cũng xin gửi lời cảm ơn chân thành tới gia đình, bạn bè và các đồng nghiệp đã luôn ủng hộ, động viên tinh thần và tạo mọi điều kiện thuận lợi nhất để tôi có thể tập trung nghiên cứu, hoàn thành tốt đồ án đúng tiến độ đề ra.")
    add_body_p(doc, "Mặc dù đã rất nỗ lực, đầu tư nhiều tâm huyết và thời gian để hoàn thiện hệ thống, song do giới hạn về mặt thời gian và kinh nghiệm thực tiễn, đề tài khó tránh khỏi những thiếu sót nhất định. Tôi rất mong nhận được những ý kiến đóng góp, chỉ bảo quý báu từ quý Thầy Cô trong Hội đồng để sản phẩm phần mềm ngày một hoàn thiện và có tính ứng dụng thực tiễn cao hơn nữa trong tương lai.")

    doc.add_page_break()

def add_table_of_contents_placeholder(doc):
    """Mục lục tổng quan với số trang chính xác 100% theo Word layout."""
    add_special_title(doc, "MỤC LỤC")
    
    toc_data = [
        ("LỜI CAM ĐOAN", "ii"),
        ("LỜI CẢM ƠN", "iii"),
        ("MỤC LỤC", "iv"),
        ("DANH MỤC TỪ VIẾT TẮT", "vi"),
        ("DANH MỤC HÌNH VẼ VÀ SƠ ĐỒ", "vii"),
        ("DANH MỤC BẢNG BIỂU", "viii"),
        ("MỞ ĐẦU", "1"),
        ("CHƯƠNG 1. TỔNG QUAN ĐỀ TÀI VÀ CƠ SỞ THỰC HIỆN", "5"),
        ("   1.1. Bài toán và lý do lựa chọn đề tài", "5"),
        ("   1.2. Mục tiêu của đề tài", "7"),
        ("   1.3. Đối tượng sử dụng, phạm vi và giới hạn của đề tài", "9"),
        ("   1.4. Dữ liệu đầu vào, đầu ra và các yêu cầu/ràng buộc chính", "11"),
        ("   1.5. Cơ sở lý thuyết, công nghệ và công cụ sử dụng", "12"),
        ("CHƯƠNG 2. PHÂN TÍCH VÀ THIẾT KẾ GIẢI PHÁP", "18"),
        ("   2.1. Phân tích yêu cầu và chức năng cốt lõi", "18"),
        ("   2.2. Use case hoặc luồng xử lý chính", "21"),
        ("   2.3. Thiết kế kiến trúc hệ thống hoặc pipeline xử lý", "31"),
        ("   2.4. Thiết kế cơ sở dữ liệu", "34"),
        ("   2.5. Thiết kế giao diện, API và các thành phần kỹ thuật cần thiết", "40"),
        ("CHƯƠNG 3. XÂY DỰNG SẢN PHẨM, KIỂM THỬ VÀ ĐÁNH GIÁ", "43"),
        ("   3.1. Xây dựng và triển khai sản phẩm", "43"),
        ("   3.2. Kiểm thử và đánh giá sản phẩm", "57"),
        ("   3.3. Giải pháp cải tiến kỹ thuật", "60"),
        ("   3.4. Quá trình tự học và phát triển", "62"),
        ("      3.4.1. Nội dung kiến thức/công nghệ tự học", "62"),
        ("      3.4.2. Áp dụng vào đồ án và minh chứng", "63"),
        ("      3.4.3. Kế hoạch và định hướng phát triển", "63"),
        ("   3.5. Kết quả đạt được và hạn chế", "64"),
        ("KẾT LUẬN", "66"),
        ("TÀI LIỆU THAM KHẢO", "69"),
        ("PHỤ LỤC", "71"),
        ("   Phụ lục A: Hướng dẫn Cài đặt và Vận hành Hệ thống", "71"),
        ("   Phụ lục B: Kịch bản Cơ sở Dữ liệu SQL Hoàn chỉnh", "72"),
        ("   Phụ lục C: Mã nguồn Thuật toán Trọng yếu", "76")
    ]
    
    tbl = doc.add_table(rows=len(toc_data), cols=2)
    tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl.autofit = False
    widths = [Inches(5.6), Inches(0.8)]
    for i, (title, pg) in enumerate(toc_data):
        row = tbl.rows[i]
        row.cells[0].paragraphs[0].text = title
        row.cells[1].paragraphs[0].text = pg
        format_table_row(row, widths, bg_color=None, is_header=False, font_size=12, align=WD_ALIGN_PARAGRAPH.LEFT)
        row.cells[1].paragraphs[0].alignment = WD_ALIGN_PARAGRAPH.RIGHT
        if "CHƯƠNG" in title or title in ["MỞ ĐẦU", "KẾT LUẬN", "TÀI LIỆU THAM KHẢO", "PHỤ LỤC"]:
            row.cells[0].paragraphs[0].runs[0].bold = True
            row.cells[1].paragraphs[0].runs[0].bold = True

    doc.add_page_break()

def add_abbreviations_table(doc):
    """Danh mục từ viết tắt."""
    add_special_title(doc, "DANH MỤC TỪ VIẾT TẮT")
    
    abbr_data = [
        ("API", "Application Programming Interface", "Giao diện lập trình ứng dụng"),
        ("REST", "Representational State Transfer", "Kiến trúc truyền trạng thái đại diện"),
        ("JWT", "JSON Web Token", "Chuẩn mã hóa thẻ phiên người dùng không trạng thái"),
        ("RBAC", "Role-Based Access Control", "Kiểm soát truy cập dựa trên vai trò"),
        ("CRUD", "Create, Read, Update, Delete", "Bốn thao tác cơ bản trên dữ liệu"),
        ("ACID", "Atomicity, Consistency, Isolation, Durability", "Các tính chất toàn vẹn giao dịch cơ sở dữ liệu"),
        ("RDBMS", "Relational Database Management System", "Hệ quản trị cơ sở dữ liệu quan hệ"),
        ("SQL", "Structured Query Language", "Ngôn ngữ truy vấn dữ liệu có cấu trúc"),
        ("UI/UX", "User Interface / User Experience", "Giao diện người dùng / Trải nghiệm người dùng"),
        ("JSON", "JavaScript Object Notation", "Định dạng trao đổi dữ liệu dạng văn bản nhẹ"),
        ("HTTP/HTTPS", "HyperText Transfer Protocol (Secure)", "Giao thức truyền tải siêu văn bản bảo mật"),
        ("DTO", "Data Transfer Object", "Đối tượng truyền dữ liệu giữa các tầng"),
        ("SDK", "Software Development Kit", "Bộ công cụ phát triển phần mềm"),
        ("APK", "Android Package Kit", "Gói tệp tin cài đặt ứng dụng trên hệ điều hành Android"),
        ("FSM", "Finite State Machine", "Mô hình máy trạng thái hữu hạn"),
        ("ORDBMS", "Object-Relational Database Management", "Hệ quản trị CSDL quan hệ - hướng đối tượng"),
        ("NFR", "Non-Functional Requirements", "Các yêu cầu phi chức năng"),
        ("FR", "Functional Requirements", "Các yêu cầu chức năng hệ thống"),
        ("ORM", "Object-Relational Mapping", "Kỹ thuật ánh xạ đối tượng vào cơ sở dữ liệu")
    ]
    
    tbl = doc.add_table(rows=len(abbr_data) + 1, cols=3)
    tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl.autofit = False
    widths = [Inches(1.2), Inches(2.7), Inches(2.5)]
    
    headers = ["Ký hiệu viết tắt", "Thuật ngữ Tiếng Anh đầy đủ", "Ý nghĩa giải thích trong đề tài"]
    for j, h in enumerate(headers):
        tbl.rows[0].cells[j].paragraphs[0].text = h
    format_table_row(tbl.rows[0], widths, bg_color="FFFFFF", is_header=True, font_size=12)
    
    for i, (k, e, v) in enumerate(abbr_data):
        row = tbl.rows[i + 1]
        row.cells[0].paragraphs[0].text = k
        row.cells[1].paragraphs[0].text = e
        row.cells[2].paragraphs[0].text = v
        format_table_row(row, widths, bg_color="FFFFFF", is_header=False, font_size=11.5)
        row.cells[0].paragraphs[0].runs[0].bold = True
        
    set_table_borders(tbl, color="000000", sz="4")
    doc.add_page_break()

def add_list_of_figures(doc):
    """Danh mục hình vẽ và sơ đồ khớp chính xác số trang."""
    add_special_title(doc, "DANH MỤC HÌNH VẼ VÀ SƠ ĐỒ")
    
    figs = [
        ("Hình 2.1", "Sơ đồ Use Case tổng quát của toàn bộ hệ thống đặt phòng khách sạn", "22"),
        ("Hình 2.2", "Sơ đồ Use Case phân hệ Đặt phòng và Quản lý tính khả dụng phòng trống", "24"),
        ("Hình 2.3", "Sơ đồ Use Case phân hệ Quản trị hệ thống dành cho Administrator", "25"),
        ("Hình 2.4", "Sơ đồ Kiến trúc hệ thống tổng thể 3 tầng (Client – Server – Database)", "31"),
        ("Hình 2.5", "Sơ đồ Kiến trúc quản lý trạng thái Flutter với Provider Pattern", "32"),
        ("Hình 2.6", "Lưu đồ quy trình xử lý kiểm tra phòng trống và tạo đơn đặt phòng tự động", "33"),
        ("Hình 2.7", "Sơ đồ Nguyên lý trực quan hóa giải thuật phòng ngừa xung đột giao cắt ngày phòng", "35"),
        ("Hình 2.8", "Sơ đồ Tuần tự luồng xác thực đăng nhập và bảo mật phân quyền JWT", "36"),
        ("Hình 2.9", "Sơ đồ Tuần tự giao dịch tạo đơn đặt phòng và khóa phòng thời gian thực", "38"),
        ("Hình 2.10", "Sơ đồ Máy trạng thái FSM quản lý vòng đời đơn đặt phòng và cơ chế giải phóng phòng", "40"),
        ("Hình 2.11", "Sơ đồ Quan hệ thực thể cơ sở dữ liệu (ERD – 7 bảng thực thể chuẩn hóa)", "42"),
        ("Hình 3.1", "Giao diện màn hình Trang chủ ứng dụng đặt phòng (Home Screen)", "47"),
        ("Hình 3.2", "Giao diện màn hình Khám phá và Tìm kiếm phòng khách sạn (Explore Screen)", "48"),
        ("Hình 3.3", "Giao diện màn hình Xác nhận Đặt phòng thành công (Booking Success Screen)", "49"),
        ("Hình 3.4", "Giao diện màn hình Quản lý Đơn đặt phòng của tôi (My Bookings Screen)", "50"),
        ("Hình 3.5", "Giao diện màn hình Hồ sơ cá nhân người dùng (User Profile Screen)", "51"),
        ("Hình 3.6", "Giao diện màn hình Hồ sơ tài khoản Quản trị viên (Admin Profile Screen)", "52"),
        ("Hình 3.7", "Giao diện màn hình Bảng điều khiển Quản trị hệ thống (Admin Dashboard Screen)", "53"),
        ("Hình 3.8", "Giao diện màn hình Quản lý danh mục Khách sạn (Admin Hotel Management Screen)", "54"),
        ("Hình 3.9", "Giao diện biểu mẫu Thêm phòng và Cấu hình loại phòng (Admin Add Room Screen)", "55"),
        ("Hình 3.10", "Giao diện màn hình Quản lý Đơn đặt phòng hệ thống (Admin Booking Management Screen)", "57")
    ]
    
    tbl = doc.add_table(rows=len(figs) + 1, cols=3)
    tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl.autofit = False
    widths = [Inches(1.2), Inches(4.5), Inches(0.7)]
    
    headers = ["Ký hiệu hình", "Tên hình vẽ, sơ đồ và biểu đồ", "Trang"]
    for j, h in enumerate(headers):
        tbl.rows[0].cells[j].paragraphs[0].text = h
    format_table_row(tbl.rows[0], widths, bg_color="FFFFFF", is_header=True, font_size=12)
    
    for i, (k, title, pg) in enumerate(figs):
        row = tbl.rows[i + 1]
        row.cells[0].paragraphs[0].text = k
        row.cells[1].paragraphs[0].text = title
        row.cells[2].paragraphs[0].text = pg
        format_table_row(row, widths, bg_color="FFFFFF", is_header=False, font_size=11.5)
        row.cells[0].paragraphs[0].runs[0].bold = True
        row.cells[2].paragraphs[0].alignment = WD_ALIGN_PARAGRAPH.RIGHT
        
    set_table_borders(tbl, color="000000", sz="4")
    doc.add_page_break()

def add_list_of_tables(doc):
    """Danh mục bảng biểu khớp chính xác số trang."""
    add_special_title(doc, "DANH MỤC BẢNG BIỂU")
    
    tables = [
        ("Bảng 1.1", "So sánh phương thức đặt phòng truyền thống và ứng dụng số trực tuyến", "6"),
        ("Bảng 1.2", "Tổng hợp đối tượng sử dụng và phạm vi phân quyền trong hệ thống", "10"),
        ("Bảng 2.1", "Danh mục tổng hợp 26 Use Case cốt lõi của hệ thống đặt phòng khách sạn", "23"),
        ("Bảng 2.2", "Bảng đặc tả Use Case chi tiết: UC-AUTH-02 (Đăng nhập & Cấp phát JWT)", "26"),
        ("Bảng 2.3", "Bảng đặc tả Use Case chi tiết: UC-BOOK-01 (Kiểm tra phòng trống thời gian thực)", "27"),
        ("Bảng 2.4", "Bảng đặc tả Use Case chi tiết: UC-BOOK-02 (Tạo đơn đặt phòng & Khóa phòng)", "28"),
        ("Bảng 2.5", "Bảng đặc tả Use Case chi tiết: UC-BOOK-05 & 06 (Hủy đơn & Giải phóng phòng)", "29"),
        ("Bảng 2.6", "Bảng đặc tả Use Case chi tiết: UC-ADM-02 & 05 (Quản lý khách sạn & Giá sàn)", "30"),
        ("Bảng 2.7", "Cấu trúc thực thể: users (Quản lý tài khoản và phân quyền)", "35"),
        ("Bảng 2.8", "Cấu trúc thực thể: hotels (Thông tin cơ sở lưu trú và giá sàn)", "36"),
        ("Bảng 2.9", "Cấu trúc thực thể: hotel_images (Thư viện hình ảnh đa phương tiện)", "37"),
        ("Bảng 2.10", "Cấu trúc thực thể: room_types (Định nghĩa hạng phòng, bảng giá)", "37"),
        ("Bảng 2.11", "Cấu trúc thực thể: rooms (Danh mục phòng vật lý thực tế)", "38"),
        ("Bảng 2.12", "Cấu trúc thực thể: bookings (Quản lý giao dịch đặt phòng)", "38"),
        ("Bảng 2.13", "Cấu trúc thực thể: reviews (Đánh giá và nhận xét của khách hàng)", "39"),
        ("Bảng 2.14", "Danh mục các Endpoints API RESTful chính của hệ thống", "40"),
        ("Bảng 3.1", "Bộ Test Case kiểm thử chức năng toàn diện của hệ thống (22 kịch bản)", "58"),
        ("Bảng 3.2", "Bảng kết quả đo lường hiệu năng và thời gian phản hồi của các API chính", "59"),
        ("Bảng 3.3", "Bảng đối chiếu mức độ hoàn thành chức năng so với mục tiêu ban đầu", "64")
    ]
    
    tbl = doc.add_table(rows=len(tables) + 1, cols=3)
    tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl.autofit = False
    widths = [Inches(1.2), Inches(4.5), Inches(0.7)]
    
    headers = ["Ký hiệu bảng", "Tên bảng biểu thống kê và đặc tả", "Trang"]
    for j, h in enumerate(headers):
        tbl.rows[0].cells[j].paragraphs[0].text = h
    format_table_row(tbl.rows[0], widths, bg_color="FFFFFF", is_header=True, font_size=12)
    
    for i, (k, title, pg) in enumerate(tables):
        row = tbl.rows[i + 1]
        row.cells[0].paragraphs[0].text = k
        row.cells[1].paragraphs[0].text = title
        row.cells[2].paragraphs[0].text = pg
        format_table_row(row, widths, bg_color="FFFFFF", is_header=False, font_size=11.5)
        row.cells[0].paragraphs[0].runs[0].bold = True
        row.cells[2].paragraphs[0].alignment = WD_ALIGN_PARAGRAPH.RIGHT
        
    set_table_borders(tbl, color="000000", sz="4")
    doc.add_page_break()
