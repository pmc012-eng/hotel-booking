# -*- coding: utf-8 -*-
"""
Module chap_intro_1:
- MỞ ĐẦU
- CHƯƠNG 1. TỔNG QUAN ĐỀ TÀI VÀ CƠ SỞ THỰC HIỆN
"""

import docx
from docx.shared import Cm, Pt, Inches, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from report_builder.helpers import (
    add_chapter_title, add_special_title, add_heading_2, add_heading_3, add_heading_4,
    add_body_p, add_table_caption, format_table_row, set_table_borders
)

def add_introduction(doc):
    """Phần MỞ ĐẦU (Khoảng 3-4 trang A4 chuẩn)."""
    add_special_title(doc, "MỞ ĐẦU")

    add_heading_2(doc, "1. Tính cấp thiết của đề tài")
    add_body_p(doc, "Trong kỷ nguyên chuyển đổi số và cuộc cách mạng công nghiệp lần thứ tư (Industry 4.0), công nghệ thông tin đã thâm nhập sâu rộng vào mọi lĩnh vực của đời sống kinh tế – xã hội. Trong đó, ngành du lịch và dịch vụ lưu trú (Hospitality Industry) là một trong những ngành tiên phong và chịu sự tác động chuyển biến mạnh mẽ nhất. Theo các báo cáo thống kê của Tổng cục Du lịch Việt Nam và Tổ chức Du lịch Thế giới (UNWTO), xu hướng hành vi của du khách đã có sự thay đổi căn bản trong những năm gần đây: trên 80% người dùng hiện đại lựa chọn tìm kiếm thông tin, so sánh giá cả và đặt dịch vụ lưu trú trực tiếp thông qua các thiết bị di động thông minh (Smartphones).")
    add_body_p(doc, "Tại Việt Nam, với sự bùng nổ của mạng di động băng thông rộng 4G/5G và tỷ lệ sở hữu điện thoại thông minh thuộc hàng cao nhất khu vực, nhu cầu trải nghiệm các dịch vụ du lịch tức thời (On-demand Services), nhanh chóng, minh bạch và an toàn đã trở thành một tiêu chuẩn bắt buộc. Tuy nhiên, trên thực tế, đại đa số các khách sạn vừa và nhỏ, các cơ sở lưu trú gia đình hoặc chuỗi nhà nghỉ nội địa tại các địa bàn du lịch trọng điểm vẫn đang loay hoay với các phương thức vận hành truyền thống: ghi chép sổ sách thủ công, quản lý phòng bằng bảng tính Excel rời rạc, hoặc tiếp nhận đặt phòng thông qua điện thoại và tin nhắn mạng xã hội.")
    add_body_p(doc, "Phương thức thủ công này bộc lộ những nhược điểm đặc biệt nghiêm trọng: tình trạng phản hồi chậm trễ dẫn tới mất khách hàng; sai sót do con người trong việc tính toán tiền tệ; và đặc biệt nguy hiểm là sự cố trùng phòng (Overbooking) – hiện tượng cùng một phòng vật lý bị bán cho hai khách hàng khác nhau trong cùng một khoảng thời gian. Sự cố này không chỉ gây thiệt hại nặng nề về mặt tài chính mà còn phá hủy hoàn toàn uy tín thương hiệu của cơ sở lưu trú.")
    add_body_p(doc, "Mặc dù trên thị trường quốc tế đã xuất hiện các nền tảng đại lý du lịch trực tuyến khổng lồ (Online Travel Agencies - OTA) như Booking.com hay Agoda, song mức chi phí hoa hồng rất cao (thường dao động từ 15% đến 25% trên mỗi giao dịch thành công) đang tạo ra gánh nặng tài chính quá lớn cho các chủ khách sạn trong nước. Đồng thời, các hệ thống ngoại này thường có quy trình thanh toán quốc tế phức tạp, thiếu tính linh hoạt và không được tối ưu hóa riêng cho các thói quen tiêu dùng cũng như đặc thù vận hành của thị trường du lịch Việt Nam.")
    add_body_p(doc, "Xuất phát từ thực tế cấp bách nêu trên, việc nghiên cứu, thiết kế và phát triển một hệ thống hoàn chỉnh về phần mềm đặt phòng khách sạn trực tuyến – kết hợp giữa ứng dụng di động đa nền tảng Flutter (chạy trên Android) với hệ thống máy chủ dịch vụ RESTful API Node.js và cơ sở dữ liệu quan hệ MySQL chuẩn ACID – là một bài toán mang tính thời sự cao, có ý nghĩa khoa học sâu sắc và giá trị ứng dụng thực tiễn to lớn.")

    add_heading_2(doc, "2. Ý nghĩa khoa học và thực tiễn của đề tài")
    add_body_p(doc, "Về mặt khoa học và kỹ thuật: Đề tài là cơ hội nghiên cứu và áp dụng các nguyên lý tiên tiến trong ngành kỹ thuật phần mềm: mô hình kiến trúc phân tầng Client-Server tách biệt hoàn toàn giữa giao diện di động và logic máy chủ; kỹ thuật quản lý trạng thái phản ứng (Reactive State Management) với Provider Pattern trong Flutter; giải thuật toán học ngăn ngừa xung đột lịch giao cắt (Date Overlapping Collision Prevention Algorithm); cùng cơ chế bảo mật xác thực phiên không trạng thái chuẩn công nghiệp với JSON Web Token (JWT) và thuật toán băm mật khẩu một chiều Bcrypt.")
    add_body_p(doc, "Về mặt thực tiễn: Sản phẩm phần mềm sau khi hoàn thiện cung cấp một công cụ hữu hiệu, trực quan và dễ tiếp cận cho người dùng phổ thông khi có nhu cầu tìm kiếm, tra cứu tình trạng phòng trống theo thời gian thực và đặt phòng khách sạn chỉ qua vài thao tác chạm trên điện thoại di động. Đồng thời, hệ thống cung cấp cho các nhà quản trị một bảng điều khiển trung tâm (Admin Dashboard) mạnh mẽ để số hóa toàn bộ quy trình vận hành: quản lý cơ cấu phòng ốc đa tầng, theo dõi doanh thu thời gian thực và xử lý đơn đặt phòng tức thì mà không cần đầu tư chi phí hạ tầng đắt đỏ.")

    add_heading_2(doc, "3. Đối tượng và phương pháp nghiên cứu")
    add_body_p(doc, "Đối tượng nghiên cứu của đồ án tập trung vào:")
    add_body_p(doc, "– Quy trình nghiệp vụ quản lý khách sạn và giao dịch thương mại điện tử trong dịch vụ lưu trú du lịch.", is_bullet=True)
    add_body_p(doc, "– Nền tảng phát triển ứng dụng di động Flutter và ngôn ngữ lập trình Dart.", is_bullet=True)
    add_body_p(doc, "– Môi trường thực thi Node.js, framework Express.js và các giải pháp xây dựng dịch vụ RESTful API chuẩn mực.", is_bullet=True)
    add_body_p(doc, "– Hệ quản trị cơ sở dữ liệu quan hệ MySQL và động cơ lưu trữ InnoDB hỗ trợ giao dịch ACID.", is_bullet=True)
    add_body_p(doc, "– Các kỹ thuật bảo mật ứng dụng mạng: mã hóa mật khẩu, kiểm soát truy cập dựa trên vai trò (RBAC) và xác thực người dùng.", is_bullet=True)
    add_body_p(doc, "Phương pháp nghiên cứu được áp dụng:")
    add_body_p(doc, "– Phương pháp nghiên cứu lý thuyết: Thu thập, phân tích và tổng hợp các tài liệu học thuật, tiêu chuẩn công nghệ và sách chuyên khảo quốc tế về kỹ thuật phần mềm di động và kiến trúc backend.", is_bullet=True)
    add_body_p(doc, "– Phương pháp khảo sát thực nghiệm: Phân tích các mô hình đặt phòng trực tuyến hiện hành để chắt lọc những ưu điểm và khắc phục các nhược điểm trong quy trình người dùng.", is_bullet=True)
    add_body_p(doc, "– Phương pháp mô hình hóa hướng đối tượng: Sử dụng ngôn ngữ mô hình hóa UML (Use Case Diagram, Sequence Diagram, Activity Diagram) để phân tích yêu cầu và thiết kế kiến trúc hệ thống.", is_bullet=True)
    add_body_p(doc, "– Phương pháp thực nghiệm xây dựng sản phẩm: Trực tiếp lập trình, tích hợp hệ thống, triển khai trên môi trường giả lập và thiết bị Android thật, sau đó tiến hành kiểm thử chức năng (Black-box Testing) với các kịch bản kiểm thử toàn diện.", is_bullet=True)

    add_heading_2(doc, "4. Bố cục của quyển báo cáo đồ án")
    add_body_p(doc, "Nội dung quyển báo cáo đồ án được kết cấu thành 3 chương chính cùng phần mở đầu, kết luận, tài liệu tham khảo và phụ lục kỹ thuật như sau:")
    add_body_p(doc, "– Mở đầu: Trình bày bối cảnh thực tiễn, tính cấp thiết, mục tiêu nghiên cứu, phương pháp tiếp cận và cấu trúc tổng quát của đồ án.", is_bullet=True)
    add_body_p(doc, "– Chương 1. Tổng quan đề tài và cơ sở thực hiện: Phân tích bài toán thực tế, lý do chọn đề tài, mục tiêu chi tiết, phạm vi và giới hạn, đặc tả dữ liệu vào/ra và trình bày nền tảng lý thuyết, công nghệ sử dụng trong đồ án.", is_bullet=True)
    add_body_p(doc, "– Chương 2. Phân tích và thiết kế giải pháp: Phân tích yêu cầu chức năng và phi chức năng, xây dựng biểu đồ Use Case và bảng đặc tả nghiệp vụ, thiết kế kiến trúc hệ thống 3 tầng, thiết kế mô hình CSDL quan hệ 7 bảng và thiết kế giao diện, hệ thống API RESTful.", is_bullet=True)
    add_body_p(doc, "– Chương 3. Xây dựng sản phẩm, kiểm thử và đánh giá: Trình bày quá trình cài đặt, triển khai mã nguồn, kết quả giao diện ứng dụng di động, kết quả bộ test case kiểm thử toàn diện, các giải pháp cải tiến kỹ thuật đã áp dụng, quá trình tự học và đánh giá đối chiếu kết quả.", is_bullet=True)
    add_body_p(doc, "– Kết luận: Tổng kết các đóng góp chính của đồ án, rút ra bài học kinh nghiệm và đề xuất các định hướng nghiên cứu phát triển tiếp theo.", is_bullet=True)
    add_body_p(doc, "– Tài liệu tham khảo và Phụ lục: Danh mục các nguồn tài liệu học thuật trích dẫn, tài liệu hướng dẫn cài đặt, kịch bản tạo CSDL SQL và mã nguồn các thuật toán cốt lõi.", is_bullet=True)

    doc.add_page_break()

def add_chapter_1(doc):
    """Nội dung chi tiết CHƯƠNG 1 (Khoảng 10-12 trang A4 chuẩn)."""
    add_chapter_title(doc, "1", "TỔNG QUAN ĐỀ TÀI VÀ CƠ SỞ THỰC HIỆN")

    # 1.1 Bài toán và lý do lựa chọn đề tài
    add_heading_2(doc, "1.1. Bài toán và lý do lựa chọn đề tài")
    
    add_heading_3(doc, "1.1.1. Bối cảnh chuyển đổi số trong lĩnh vực du lịch và khách sạn")
    add_body_p(doc, "Ngành du lịch và khách sạn luôn là một trong những trụ cột kinh tế có tốc độ tăng trưởng vượt bậc và đóng góp lớn vào GDP quốc gia. Với sự mở cửa hoàn toàn sau đại dịch, lượng khách du lịch nội địa và quốc tế tại Việt Nam không ngừng tăng trưởng mạnh mẽ, kéo theo nhu cầu lưu trú tăng đột biến tại các trung tâm du lịch lớn như Hà Nội, Đà Nẵng, Nha Trang, Phú Quốc, Đà Lạt và Thành phố Hồ Chí Minh.")
    add_body_p(doc, "Sự thay đổi căn bản trong thói quen của người tiêu dùng hiện đại – đặc biệt là thế hệ trẻ Gen Z và Millennials – đòi hỏi mọi dịch vụ phải có mặt tức thì trên chiếc điện thoại thông minh. Người dùng không còn chấp nhận việc phải đến tận nơi để hỏi thuê phòng, cũng như không muốn chờ đợi hàng giờ để nhân viên lễ tân kiểm tra lịch phòng qua tin nhắn hay điện thoại. Họ kỳ vọng một trải nghiệm liền mạch: mở ứng dụng, xem hình ảnh phòng chụp thực tế, kiểm tra số phòng trống chính xác trong ngày mong muốn, xem minh bạch tổng số tiền phải trả và nhận mã xác nhận đặt phòng chỉ trong vài giây.")

    add_heading_3(doc, "1.1.2. Những bất cập cốt lõi của phương thức quản lý và đặt phòng truyền thống")
    add_body_p(doc, "Qua khảo sát thực tế tại nhiều cơ sở lưu trú vừa và nhỏ, quy trình quản lý thủ công hiện nay đang bộc lộ những lỗ hổng kỹ thuật và rủi ro vận hành nghiêm trọng:")
    add_body_p(doc, "– Rủi ro trùng lịch đặt phòng (Overbooking): Đây là cơn ác mộng lớn nhất của các nhà quản lý khách sạn. Khi một nhân viên tiếp nhận khách qua điện thoại nhưng chưa kịp ghi vào sổ, một nhân viên khác tại quầy lại tiếp tục bán phòng đó cho khách vãng lai. Hậu quả là khi khách đến nhận phòng, khách sạn không còn phòng phục vụ, gây bức xúc tột độ cho khách hàng và phá vỡ uy tín kinh doanh.", is_bullet=True)
    add_body_p(doc, "– Bất đối xứng thông tin và thiếu minh bạch giá cả: Khách hàng thường không nắm được mức giá niêm yết chính xác, dễ bị tình trạng nâng giá vào dịp lễ tết hoặc không nắm rõ các tiện nghi đi kèm trong phòng.", is_bullet=True)
    add_body_p(doc, "– Thất thoát doanh thu và khó khăn trong kiểm soát: Việc ghi chép thủ công trên sổ sách hoặc file Excel đơn giản rất dễ bị sai lệch số liệu, nhầm lẫn công nợ và không cung cấp được các báo cáo phân tích doanh thu kịp thời cho chủ cơ sở.", is_bullet=True)
    add_body_p(doc, "– Tốn kém chi phí nhân sự và thời gian phản hồi chậm: Khách sạn phải duy trì đội ngũ trực tổng đài và fanpage 24/7 chỉ để trả lời những câu hỏi lặp đi lặp lại như 'Ngày mai còn phòng Deluxe không?', 'Giá phòng Standard bao nhiêu một đêm?'.", is_bullet=True)

    add_table_caption(doc, "1.1", "So sánh phương thức đặt phòng truyền thống và ứng dụng số trực tuyến")
    tbl_comp = doc.add_table(rows=6, cols=3)
    tbl_comp.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl_comp.autofit = False
    widths = [Inches(1.8), Inches(2.4), Inches(2.4)]
    
    headers = ["Tiêu chí so sánh", "Phương thức truyền thống (Thủ công)", "Hệ thống ứng dụng số trực tuyến"]
    for j, h in enumerate(headers):
        tbl_comp.rows[0].cells[j].paragraphs[0].text = h
    format_table_row(tbl_comp.rows[0], widths, bg_color="FFFFFF", is_header=True, font_size=12)
    
    comp_data = [
        ("Tốc độ kiểm tra phòng trống", "Mất từ 15 - 60 phút chờ nhân viên kiểm tra sổ sách", "Phản hồi tức thời trong mili-giây (< 200ms) qua thuật toán tự động"),
        ("Độ chính xác lịch phòng", "Dễ xảy ra sự cố trùng phòng (Overbooking) do con người", "Chính xác tuyệt đối nhờ ràng buộc toàn vẹn cơ sở dữ liệu"),
        ("Minh bạch hóa giá cả", "Giá biến động tùy tiện, khách khó so sánh", "Niêm yết công khai, tính toán tự động phía Server không thể gian lận"),
        ("Thời gian phục vụ", "Phụ thuộc vào ca trực của nhân viên lễ tân", "Tự động hóa 24/7/365, hoạt động liên tục không gián đoạn"),
        ("Báo cáo & Thống kê", "Tổng hợp sổ sách cuối tháng mất nhiều ngày, dễ thất thoát", "Bảng điều khiển KPI Dashboard cập nhật doanh thu theo thời gian thực")
    ]
    for i, (crit, trad, modern) in enumerate(comp_data):
        row = tbl_comp.rows[i + 1]
        row.cells[0].paragraphs[0].text = crit
        row.cells[1].paragraphs[0].text = trad
        row.cells[2].paragraphs[0].text = modern
        format_table_row(row, widths, bg_color="FFFFFF", is_header=False, font_size=11.5)
        row.cells[0].paragraphs[0].runs[0].bold = True
    set_table_borders(tbl_comp, color="000000", sz="4")

    add_heading_3(doc, "1.1.3. Nhu cầu thực tế và giải pháp đề xuất của đồ án")
    add_body_p(doc, "Từ những bất cập trên, nhu cầu cấp bách là phải có một giải pháp phần mềm khép kín, hiện đại nhưng có chi phí đầu tư hợp lý, cho phép chủ cơ sở lưu trú làm chủ hoàn toàn dữ liệu mà không bị phụ thuộc vào các nền tảng OTA đắt đỏ. Đồ án đề xuất giải pháp xây dựng hệ thống phần mềm hoàn chỉnh bao gồm:")
    add_body_p(doc, "1. Một ứng dụng di động phía người dùng (Mobile App) được phát triển bằng Flutter: mang lại giao diện người dùng đẹp mắt, tốc độ xử lý đồ họa mượt mà 60 FPS, hỗ trợ bộ lọc thông minh, kiểm tra phòng trống tức thì và đặt phòng nhanh chóng.", is_bullet=True)
    add_body_p(doc, "2. Một hệ thống máy chủ dịch vụ (Backend Server) xây dựng trên nền tảng Node.js và Express.js: đóng vai trò trung tâm xử lý logic nghiệp vụ, quản lý giao dịch nguyên tử (Atomic Transactions), bảo vệ an toàn tài chính và kiểm soát phiên làm việc an toàn.", is_bullet=True)
    add_body_p(doc, "3. Một hệ cơ sở dữ liệu quan hệ MySQL chuẩn hóa cao: lưu trữ và quản lý chặt chẽ 7 thực thể cốt lõi, bảo đảm tính toàn vẹn tham chiếu thông qua các ràng buộc khóa ngoại liên hoàn (ON DELETE CASCADE) và chỉ mục tối ưu truy vấn.", is_bullet=True)

    # 1.2 Mục tiêu của đề tài
    add_heading_2(doc, "1.2. Mục tiêu của đề tài")
    add_body_p(doc, "Đề tài được thiết lập với các mục tiêu cụ thể và rõ ràng, hướng đến việc tạo ra một sản phẩm hoàn thiện cả về mặt lý thuyết học thuật lẫn khả năng ứng dụng thực tiễn:")
    
    add_heading_3(doc, "1.2.1. Mục tiêu tổng quát")
    add_body_p(doc, "Nghiên cứu quy trình nghiệp vụ đặt phòng và quản lý khách sạn; từ đó thiết kế kiến trúc hệ thống và xây dựng thành công một ứng dụng di động Android kết hợp hệ thống dịch vụ RESTful API hoàn chỉnh, đáp ứng trọn vẹn các yêu cầu nghiệp vụ thực tế của thị trường lưu trú du lịch.")

    add_heading_3(doc, "1.2.2. Mục tiêu cụ thể")
    add_body_p(doc, "– Về mặt chức năng người dùng (Mobile Client):", is_bullet=True)
    add_body_p(doc, "   + Xây dựng chức năng xác thực: Đăng ký tài khoản mới, đăng nhập bằng email/mật khẩu, ghi nhớ phiên làm việc an toàn và cập nhật hồ sơ cá nhân.")
    add_body_p(doc, "   + Xây dựng phân hệ khám phá: Hiển thị danh sách khách sạn đề xuất, bộ lọc tìm kiếm theo từ khóa, lọc đa tiêu chí (Tỉnh/Thành phố, Hạng sao từ 1 đến 5 sao, Điểm rating, Mức giá trần).")
    add_body_p(doc, "   + Xây dựng phân hệ đặt phòng: Xem chi tiết khách sạn, thư viện hình ảnh, danh mục các loại phòng; chọn khoảng ngày Check-in/Check-out; kiểm tra số phòng trống khả dụng theo thời gian thực; tính toán tự động số đêm và tổng tiền; xác nhận thông tin lưu trú và tạo đơn đặt phòng thành công.")
    add_body_p(doc, "   + Xây dựng phân hệ lịch sử và hủy đơn: Tra cứu các chuyến đi theo trạng thái (Đã xác nhận, Đã hoàn thành, Đã hủy); hỗ trợ hủy đơn đặt phòng trước thời điểm nhận phòng và kích hoạt cơ chế giải phóng phòng trống tự động tức thì.")
    add_body_p(doc, "   + Xây dựng phân hệ đánh giá: Cho phép khách hàng đã trải nghiệm gửi điểm số sao (1-5★) và bình luận nhận xét; hệ thống tự động tính lại điểm rating trung bình cộng của khách sạn.")
    add_body_p(doc, "– Về mặt chức năng quản trị (Admin Portal):", is_bullet=True)
    add_body_p(doc, "   + Xây dựng bảng điều khiển KPI Dashboard: Thống kê số lượng khách sạn, tổng số phòng, số đơn đặt phòng và doanh thu lũy kế thực tế.")
    add_body_p(doc, "   + Xây dựng phân hệ quản lý khách sạn: Thêm mới khách sạn kèm địa chỉ, thành phố, số sao, mô tả và ảnh đại diện; chỉnh sửa thông tin và xóa khách sạn liên hoàn.")
    add_body_p(doc, "   + Xây dựng phân hệ quản lý loại phòng & phòng vật lý: Tạo các hạng phòng (Standard, Deluxe, Suite...), gán giá niêm yết, sức chứa, tiện nghi; sinh các số phòng vật lý (101, 102...); tự động kích hoạt tính năng đồng bộ giá sàn nhỏ nhất (min_price) vào thông tin khách sạn.")
    add_body_p(doc, "– Về mặt kỹ thuật phần mềm và kiến trúc:", is_bullet=True)
    add_body_p(doc, "   + Triển khai kiến trúc phần mềm phân tầng chuẩn RESTful API, phân định rõ ràng giữa Routing, Controller, Middleware và Data Access Layer.")
    add_body_p(doc, "   + Cài đặt giải thuật kiểm tra giao cắt lịch phòng trống chuẩn xác, loại trừ triệt để nguy cơ Overbooking.")
    add_body_p(doc, "   + Bảo vệ an toàn tài chính: Tính toán tổng tiền hoàn toàn ở tầng máy chủ, không tin cậy dữ liệu giá gửi từ máy khách.")
    add_body_p(doc, "   + Thiết kế cơ sở dữ liệu đạt chuẩn 3NF, bảo đảm tính toàn vẹn dữ liệu thông qua các ràng buộc Foreign Key CASCADE và Unique Composite Index.")
    add_body_p(doc, "– Về sản phẩm bàn giao:", is_bullet=True)
    add_body_p(doc, "   + Bộ mã nguồn ứng dụng di động Flutter hoàn chỉnh và gói tệp tin cài đặt APK (app-release.apk) có thể cài đặt và vận hành mượt mà trên các thiết bị Android thật.")
    add_body_p(doc, "   + Bộ mã nguồn máy chủ Backend Node.js/Express với đầy đủ hệ thống API, middleware bảo mật và cơ sở dữ liệu mẫu MySQL đã nạp sẵn dữ liệu thực nghiệm.")

    # 1.3 Đối tượng sử dụng, phạm vi và giới hạn của đề tài
    add_heading_2(doc, "1.3. Đối tượng sử dụng, phạm vi và giới hạn của đề tài")

    add_heading_3(doc, "1.3.1. Đối tượng sử dụng của hệ thống")
    add_body_p(doc, "Hệ thống được thiết kế hướng tới 3 nhóm đối tượng người dùng cụ thể, mỗi nhóm có vai trò, quyền hạn và mục đích sử dụng khác nhau:")
    add_body_p(doc, "1. Khách vãng lai (Guest): Là người dùng tải và mở ứng dụng di động nhưng chưa tiến hành đăng nhập tài khoản. Đối tượng này được phép duyệt danh sách khách sạn thịnh hành, tìm kiếm khách sạn theo tên hoặc thành phố, lọc theo khoảng giá và hạng sao, xem chi tiết tiện nghi phòng và đọc các bài nhận xét đánh giá của cộng đồng.", is_bullet=True)
    add_body_p(doc, "2. Khách hàng thành viên (Customer / User): Là người dùng đã đăng ký và xác thực tài khoản trong hệ thống. Ngoài toàn bộ quyền hạn của khách vãng lai, khách hàng thành viên có quyền chọn ngày lưu trú để kiểm tra phòng trống thực tế, thực hiện giao dịch đặt phòng, nhận mã xác nhận booking, quản lý lịch sử các chuyến đi của cá nhân, thực hiện thao tác hủy đơn trước hạn và gửi đánh giá chấm điểm sau chuyến lưu trú.", is_bullet=True)
    add_body_p(doc, "3. Quản trị viên hệ thống (Administrator): Là người nắm quyền vận hành cao nhất (được gắn vai trò 'ADMIN' trong cơ sở dữ liệu). Đối tượng này có quyền truy cập vào các chức năng quản trị đặc quyền: theo dõi báo cáo doanh thu trên KPI Dashboard, thêm/sửa/xóa khách sạn, tạo lập cơ cấu loại phòng và phòng vật lý, đồng bộ giá sàn niêm yết và giám sát mọi đơn đặt phòng trên toàn bộ hệ thống.", is_bullet=True)

    add_table_caption(doc, "1.2", "Tổng hợp đối tượng sử dụng và phạm vi phân quyền trong hệ thống")
    tbl_actor = doc.add_table(rows=4, cols=3)
    tbl_actor.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl_actor.autofit = False
    widths_act = [Inches(1.5), Inches(1.8), Inches(3.3)]
    
    headers_act = ["Đối tượng (Actor)", "Cơ chế định danh", "Quyền hạn và Chức năng được phép truy cập"]
    for j, h in enumerate(headers_act):
        tbl_actor.rows[0].cells[j].paragraphs[0].text = h
    format_table_row(tbl_actor.rows[0], widths_act, bg_color="FFFFFF", is_header=True, font_size=12)
    
    act_rows = [
        ("Khách vãng lai (Guest)", "Chưa xác thực (Không cần Token)", "Xem danh sách khách sạn, tìm kiếm, lọc theo thành phố/sao/giá, xem ảnh, xem đánh giá."),
        ("Khách hàng (Customer)", "Đã xác thực qua JWT (Role: 'USER')", "Kiểm tra phòng trống theo ngày, thực hiện đặt phòng, quản lý lịch sử đơn cá nhân, hủy đơn, viết đánh giá, cập nhật hồ sơ cá nhân."),
        ("Quản trị viên (Admin)", "Đã xác thực qua JWT (Role: 'ADMIN')", "Toàn quyền quản trị hệ thống: Xem Dashboard KPI doanh thu, CRUD khách sạn, quản lý loại phòng, tạo phòng vật lý, kiểm soát toàn bộ đơn đặt hệ thống.")
    ]
    for i, (act, auth, perm) in enumerate(act_rows):
        row = tbl_actor.rows[i + 1]
        row.cells[0].paragraphs[0].text = act
        row.cells[1].paragraphs[0].text = auth
        row.cells[2].paragraphs[0].text = perm
        format_table_row(row, widths_act, bg_color="FFFFFF", is_header=False, font_size=11.5)
        row.cells[0].paragraphs[0].runs[0].bold = True
    set_table_borders(tbl_actor, color="000000", sz="4")

    add_heading_3(doc, "1.3.2. Phạm vi của đề tài")
    add_body_p(doc, "– Phạm vi nền tảng: Tập trung phát triển hoàn thiện ứng dụng di động phía người dùng chạy trên hệ điều hành Android (hỗ trợ từ Android 8.0 trở lên, kiểm thử tối ưu trên Android 13 và 14).")
    add_body_p(doc, "– Phạm vi nghiệp vụ: Tập trung giải quyết bài toán cốt lõi của thương mại điện tử du lịch lưu trú: kiểm tra tính khả dụng phòng trống tức thời theo thời gian thực (Real-time Availability), quy trình đặt phòng nguyên tử (Atomic Booking), tự động giải phóng phòng khi hủy đơn (Room Auto-Release) và hệ thống đánh giá uy tín khách sạn.")
    add_body_p(doc, "– Phạm vi địa lý và dữ liệu: Áp dụng cho các cơ sở lưu trú và điểm đến du lịch tiêu biểu tại Việt Nam (Hà Nội, Thành phố Hồ Chí Minh, Đà Nẵng, Nha Trang, Phú Quốc, Đà Lạt).")

    add_heading_3(doc, "1.3.3. Giới hạn của đề tài")
    add_body_p(doc, "– Về phương thức thanh toán: Hệ thống tập trung tối ưu hóa quy trình 'Thanh toán trực tiếp tại khách sạn khi nhận phòng' (PAY_AT_HOTEL) và mô phỏng giao dịch thẻ/ví điện tử. Đồ án chưa tích hợp trực tiếp cổng thanh toán trực tuyến thương mại có ký quỹ doanh nghiệp (như VNPay Production hay Momo Business) do yêu cầu pháp lý về tư cách pháp nhân.")
    add_body_p(doc, "– Về bản đồ định vị: Hệ thống định danh vị trí khách sạn qua địa chỉ hành chính chi tiết và Tỉnh/Thành phố, chưa nhúng SDK bản đồ vệ tinh tương tác Google Maps trực tiếp trên app di động nhằm tối ưu hóa chi phí API và dung lượng gói cài đặt.")
    add_body_p(doc, "– Về dịch vụ thông báo: Hệ thống gửi thông báo trạng thái đặt phòng trực tiếp trên giao diện ứng dụng thông qua phản hồi API thời gian thực, chưa tích hợp máy chủ gửi SMS Brandname tự động hay dịch vụ đẩy thông báo nền Firebase Cloud Messaging (FCM).")

    # 1.4 Dữ liệu đầu vào, đầu ra và các yêu cầu/ràng buộc chính
    add_heading_2(doc, "1.4. Dữ liệu đầu vào, đầu ra và các yêu cầu/ràng buộc chính")

    add_heading_3(doc, "1.4.1. Dữ liệu đầu vào của hệ thống (Inputs)")
    add_body_p(doc, "– Dữ liệu tài khoản người dùng: Họ và tên, địa chỉ email hợp lệ (đóng vai trò định danh duy nhất), mật khẩu bảo mật (tối thiểu 6 ký tự) và số điện thoại liên lạc.")
    add_body_p(doc, "– Dữ liệu truy vấn và bộ lọc: Từ khóa tìm kiếm tên khách sạn, tiêu chí địa lý (Tỉnh/Thành phố), tiêu chuẩn hạng sao (1 - 5 sao), khoảng giá trần mong muốn và điểm đánh giá tối thiểu.")
    add_body_p(doc, "– Dữ liệu giao dịch đặt phòng: ID khách sạn, ID loại phòng mong muốn, ngày nhận phòng (Check-in), ngày trả phòng (Check-out), họ tên khách lưu trú thực tế, số điện thoại khẩn cấp, email nhận biên lai và hình thức thanh toán được lựa chọn.")
    add_body_p(doc, "– Dữ liệu quản trị khách sạn: Tên cơ sở lưu trú, địa chỉ số nhà/tên đường, thành phố, số sao, mô tả chi tiết, liên kết hình ảnh minh họa; tên loại phòng, đơn giá thuê theo đêm, sức chứa tối đa, danh mục tiện ích phòng; danh sách các số phòng vật lý tương ứng.")
    add_body_p(doc, "– Dữ liệu đánh giá: Điểm chấm số sao (số nguyên từ 1 đến 5) và nội dung nhận xét trải nghiệm bằng văn bản.")

    add_heading_3(doc, "1.4.2. Dữ liệu đầu ra của hệ thống (Outputs)")
    add_body_p(doc, "– Dữ liệu thẻ thông tin khách sạn: Tên khách sạn, ảnh đại diện chính, địa chỉ, thành phố, hạng sao, điểm đánh giá trung bình cộng và mức giá niêm yết thấp nhất (min_price).")
    add_body_p(doc, "– Kết quả kiểm tra tính khả dụng: Danh sách các phòng vật lý đang ở trạng thái 'AVAILABLE' và không có bất kỳ đơn đặt phòng nào giao cắt trong khoảng ngày được chọn; thông báo hết phòng nếu toàn bộ các phòng đã kín chỗ.")
    add_body_p(doc, "– Hợp đồng giao dịch đặt phòng: Mã đơn đặt phòng duy nhất dạng 'BK' + Timestamp + Chuỗi Hex ngẫu nhiên (ví dụ: BK1726451234AB), tổng số tiền lưu trú chính xác được tính toán phía Server, trạng thái đơn 'CONFIRMED', trạng thái thanh toán 'UNPAID', thông tin số phòng vật lý được phân phối.")
    add_body_p(doc, "– Lịch sử chuyến đi: Danh sách các đơn đặt phòng của khách hàng được phân loại trực quan theo 3 tab trạng thái: 'Đã xác nhận', 'Đã hoàn thành' và 'Đã hủy'.")
    add_body_p(doc, "– Thống kê quản trị: Báo cáo số liệu KPI tổng hợp theo thời gian thực hiển thị trên màn hình Admin Dashboard: tổng số khách sạn, tổng số phòng quản lý, tổng số đơn đặt phòng phát sinh và tổng doanh thu thực tế ghi nhận.")

    add_heading_3(doc, "1.4.3. Các yêu cầu và ràng buộc cốt lõi")
    add_body_p(doc, "– Ràng buộc toàn vẹn cơ sở dữ liệu: Khóa ngoại bắt buộc thiết lập quy tắc `ON DELETE CASCADE` để khi xóa khách sạn hoặc loại phòng, toàn bộ dữ liệu phụ thuộc liên quan tự động được dọn dẹp sạch sẽ, không để lại bản ghi rác mồ côi. Ràng buộc duy nhất kết hợp `UNIQUE(hotel_id, room_number)` bảo đảm không bao giờ có 2 phòng vật lý trùng số trong cùng một khách sạn.")
    add_body_p(doc, "– Ràng buộc phòng ngừa xung đột lịch phòng (Overbooking Prevention): Tuyệt đối không cho phép tạo đơn đặt phòng nếu tồn tại một đơn đặt phòng hiện hữu có trạng thái khác 'CANCELLED' giao cắt thời gian lưu trú với khoảng ngày khách hàng yêu cầu:")
    add_body_p(doc, "   $$\\text{Conflict} = (CheckOut_{new} > CheckIn_{exist}) \\land (CheckIn_{new} < CheckOut_{exist}) \\land (Status \\neq \\text{'CANCELLED'})$$")
    add_body_p(doc, "– Ràng buộc tính toán tài chính an toàn: Khách hàng ở tầng Client chỉ gửi `room_type_id`, `check_in` và `check_out`. Server Node.js sẽ truy vấn đơn giá gốc từ cơ sở dữ liệu và tính toán: `total_price = price * nights`. Tuyệt đối không nhận giá do Client tự tính toán gửi lên để triệt tiêu hoàn toàn nguy cơ gian lận sửa giá qua HTTP Request.")
    add_body_p(doc, "– Ràng buộc an toàn thông tin: Toàn bộ mật khẩu người dùng trước khi lưu trữ vào bảng `users` bắt buộc phải được băm qua giải thuật Bcrypt với độ phức tạp Salt Rounds = 10. Mọi yêu cầu nghiệp vụ nhạy cảm bắt buộc phải đính kèm thẻ phiên Bearer JWT hợp lệ và kiểm tra quyền thông qua Middleware RBAC.")

    # 1.5 Cơ sở lý thuyết, công nghệ và công cụ sử dụng
    add_heading_2(doc, "1.5. Cơ sở lý thuyết, công nghệ và công cụ sử dụng")

    add_heading_3(doc, "1.5.1. Kiến trúc Client-Server và giao thức truyền thông RESTful API")
    add_body_p(doc, "Kiến trúc Client-Server là một mô hình phân tán trong đó các tác vụ được phân chia rạch ròi giữa nhà cung cấp tài nguyên/dịch vụ (Server) và bên yêu cầu dịch vụ (Client). Trong đề tài này, ứng dụng di động Flutter đóng vai trò là Client, còn máy chủ Node.js/Express đóng vai trò là Server.")
    add_body_p(doc, "Giao tiếp giữa Client và Server được thực hiện thông qua kiến trúc RESTful API (Representational State Transfer) dựa trên giao thức HTTP/HTTPS. Kiến trúc REST tuân thủ 6 ràng buộc nguyên tắc cốt lõi: Client-Server tách biệt, Phi trạng thái (Stateless), Có thể lưu bộ nhớ đệm (Cacheable), Giao diện đồng nhất (Uniform Interface), Hệ thống phân tầng (Layered System), và Mã theo yêu cầu (Code on demand).")
    add_body_p(doc, "Hệ thống sử dụng các phương thức chuẩn của giao thức HTTP để thực hiện các thao tác quản lý tài nguyên:")
    add_body_p(doc, "– GET: Dùng để truy vấn và lấy dữ liệu (danh sách khách sạn, chi tiết phòng trống, lịch sử booking) mà không làm thay đổi trạng thái máy chủ.", is_bullet=True)
    add_body_p(doc, "– POST: Dùng để tạo mới tài nguyên (đăng ký tài khoản, đăng nhập, tạo đơn đặt phòng mới, thêm khách sạn).", is_bullet=True)
    add_body_p(doc, "– PUT: Dùng để cập nhật toàn bộ hoặc chỉnh sửa thông tin tài nguyên hiện có (sửa thông tin khách sạn, đổi trạng thái hủy đơn đặt phòng).", is_bullet=True)
    add_body_p(doc, "– DELETE: Dùng để xóa bỏ tài nguyên khỏi cơ sở dữ liệu (xóa khách sạn, xóa loại phòng).", is_bullet=True)
    add_body_p(doc, "Toàn bộ dữ liệu trao đổi giữa Client và Server đều được định dạng dưới dạng JSON (JavaScript Object Notation) – một định dạng văn bản tiêu chuẩn, siêu nhẹ, có cấu trúc chặt chẽ và dễ dàng phân tích cú pháp trên cả Dart và JavaScript.")

    add_heading_3(doc, "1.5.2. Khung phát triển ứng dụng di động Flutter và ngôn ngữ lập trình Dart")
    add_body_p(doc, "Flutter là một bộ công cụ phát triển phần mềm mã nguồn mở (UI Software Development Kit) do Google sáng lập và phát triển, cho phép lập trình viên xây dựng các ứng dụng đa nền tảng (Android, iOS, Web, Desktop) từ một cơ sở mã nguồn duy nhất (Single Codebase).")
    add_body_p(doc, "Các đặc tính kỹ thuật ưu việt của Flutter được ứng dụng trong đồ án:")
    add_body_p(doc, "– Đồ họa hiệu năng cao: Flutter không sử dụng các thành phần giao diện gốc (Native UI WebViews/Wrappers) như React Native mà tự sở hữu bộ máy dựng hình đồ họa riêng (Skia Graphics Engine và Impeller), giúp ứng dụng đạt tốc độ vẽ khung hình mượt mà 60 khung hình/giây (FPS) đến 120 FPS.", is_bullet=True)
    add_body_p(doc, "– Triết lý 'Everything is a Widget': Toàn bộ giao diện người dùng của Flutter được cấu thành từ cây Widget (Widget Tree). Các Widget có tính module hóa cao, dễ dàng tái sử dụng và tùy biến giao diện linh hoạt.", is_bullet=True)
    add_body_p(doc, "– Tính năng Hot Reload: Cho phép lập trình viên cập nhật mã nguồn và quan sát ngay lập tức kết quả thay đổi trên màn hình thiết bị mà không làm mất trạng thái (State) hiện tại của ứng dụng, rút ngắn đáng kể thời gian phát triển và sửa lỗi.", is_bullet=True)
    add_body_p(doc, "– Ngôn ngữ lập trình Dart: Một ngôn ngữ hướng đối tượng hiện đại, kiểu dữ liệu tĩnh mạnh (Strongly Typed), hỗ trợ Null Safety tuyệt đối giúp loại trừ hoàn toàn các lỗi sập ứng dụng do con trỏ null (Null Pointer Exception). Dart hỗ trợ cả cơ chế biên dịch JIT (Just-In-Time) trong quá trình lập trình và AOT (Ahead-Of-Time) khi đóng gói sản phẩm thương mại ra mã máy gốc ARM, tối ưu hóa tốc độ khởi chạy.", is_bullet=True)
    add_body_p(doc, "– Mô hình quản lý trạng thái Provider Pattern: Đồ án áp dụng thư viện Provider – giải pháp quản lý trạng thái chính thức được Google khuyến nghị. Provider kết hợp giữa nguyên lý kế thừa đối tượng (InheritedWidget) và mẫu thiết kế quan sát (Observer Pattern / ChangeNotifier), giúp tách biệt hoàn toàn giữa tầng logic dữ liệu (Business Logic) và tầng hiển thị giao diện (UI Layer), tránh hiện tượng render lại không cần thiết toàn bộ cây Widget.")

    add_heading_3(doc, "1.5.3. Nền tảng thực thi Node.js và Framework Express.js")
    add_body_p(doc, "Node.js là một môi trường thực thi mã JavaScript đa nền tảng, mã nguồn mở, hoạt động dựa trên bộ máy biên dịch JavaScript V8 cực nhanh của Google Chrome. Điểm cốt lõi tạo nên sức mạnh của Node.js là kiến trúc hướng sự kiện bất đồng bộ và mô hình vào/ra không chặn (Single-threaded Event Loop with Non-blocking I/O).")
    add_body_p(doc, "Trong các ứng dụng đặt phòng khách sạn, đa phần các tác vụ của hệ thống là xử lý truy vấn dữ liệu (I/O-intensive) như đọc/ghi cơ sở dữ liệu, kiểm tra lịch phòng, gửi nhận HTTP Request. Nhờ cơ chế Non-blocking I/O, một luồng duy nhất của Node.js có thể tiếp nhận và xử lý đồng thời hàng nghìn kết nối từ người dùng mà không cần phải cấp phát một luồng hệ thống riêng biệt cho từng kết nối như các máy chủ truyền thống (như Apache / Tomcat), giúp tiết kiệm tài nguyên bộ nhớ RAM và CPU tối đa.")
    add_body_p(doc, "Express.js là một web framework tối giản, linh hoạt và phổ biến nhất trong hệ sinh thái Node.js. Express cung cấp một tập hợp mạnh mẽ các tính năng để xây dựng các ứng dụng web và API:")
    add_body_p(doc, "– Hệ thống định tuyến mạnh mẽ (Robust Routing): Cho phép định nghĩa các ánh xạ đường dẫn URL tới các hàm xử lý logic nghiệp vụ tương ứng một cách mạch lạc.", is_bullet=True)
    add_body_p(doc, "– Kiến trúc Middleware linh hoạt: Cho phép chèn các hàm tiền xử lý vào luồng xử lý yêu cầu (Request-Response Pipeline) để thực hiện các nhiệm vụ: ghi log yêu cầu (Morgan), giải mã dữ liệu JSON trong body (express.json()), bảo mật CORS (Cross-Origin Resource Sharing), kiểm tra thẻ phiên JWT (verifyToken) và phân quyền quản trị (requireAdmin).", is_bullet=True)
    add_body_p(doc, "– Xử lý ngoại lệ tập trung (Centralized Error Handling): Toàn bộ các lỗi phát sinh trong quá trình thực thi bất đồng bộ đều được gom về một Middleware xử lý lỗi duy nhất (Error Middleware), bảo đảm hệ thống luôn trả về cấu trúc lỗi JSON đồng nhất và không làm sập máy chủ.", is_bullet=True)

    add_heading_3(doc, "1.5.4. Hệ quản trị cơ sở dữ liệu quan hệ MySQL và lưu trữ InnoDB")
    add_body_p(doc, "MySQL là hệ quản trị cơ sở dữ liệu quan hệ mã nguồn mở phổ biến nhất trên thế giới, hoạt động theo mô hình dữ liệu quan hệ (Relational Model) dựa trên đại số quan hệ và sử dụng ngôn ngữ truy vấn có cấu trúc SQL. Trong đề tài này, MySQL được lựa chọn làm giải pháp lưu trữ dữ liệu bền vững nhờ độ tin cậy cao, tốc độ xử lý nhanh và khả năng tương thích tuyệt vời với hệ sinh thái Node.js qua thư viện `mysql2/promise`.")
    add_body_p(doc, "Động cơ lưu trữ InnoDB (InnoDB Storage Engine) được cấu hình làm động cơ mặc định cho toàn bộ các bảng trong cơ sở dữ liệu `hotel_booking_db` nhờ những tính năng kỹ thuật vượt trội:")
    add_body_p(doc, "– Hỗ trợ giao dịch nguyên tử tuân thủ nghiêm ngặt 4 thuộc tính ACID: Tính nguyên tử (Atomicity – tất cả các thao tác trong giao dịch đều thành công hoặc không có thao tác nào được ghi nhận), Tính nhất quán (Consistency – cơ sở dữ liệu luôn chuyển từ trạng thái hợp lệ này sang trạng thái hợp lệ khác), Tính cô lập (Isolation – các giao dịch đồng thời không can thiệp lẫn nhau), và Tính bền vững (Durability – dữ liệu đã commit sẽ được lưu vĩnh viễn trên đĩa cứng ngay cả khi mất điện đột ngột).", is_bullet=True)
    add_body_p(doc, "– Hỗ trợ ràng buộc khóa ngoại (Foreign Key Constraints): Bảo đảm toàn vẹn tham chiếu dữ liệu ở mức độ vật lý, kích hoạt các cơ chế tự động dọn dẹp liên hoàn `ON DELETE CASCADE`.", is_bullet=True)
    add_body_p(doc, "– Cơ chế khóa ở mức dòng (Row-level Locking): Cho phép nhiều giao dịch ghi đồng thời vào các dòng khác nhau trong cùng một bảng mà không cần phải khóa toàn bộ bảng (Table-level lock), tối ưu hóa tối đa khả năng phục vụ khi có tải cao.", is_bullet=True)
    add_body_p(doc, "– Bảng mã ký tự UTF8MB4 (utf8mb4_unicode_ci): Hỗ trợ lưu trữ hoàn hảo toàn bộ ký tự tiếng Việt có dấu đầy đủ và các ký tự đặc biệt, biểu tượng cảm xúc (Emoji).", is_bullet=True)

    add_heading_3(doc, "1.5.5. Các công nghệ an toàn thông tin: Chuẩn băm Bcrypt và cơ chế xác thực JWT")
    add_body_p(doc, "An toàn thông tin là một tiêu chí sống còn trong các hệ thống thương mại điện tử. Đồ án áp dụng hai chuẩn công nghệ bảo mật hàng đầu thế giới hiện nay:")
    add_body_p(doc, "1. Thuật toán băm mật khẩu một chiều Bcrypt: Mật khẩu của người dùng không bao giờ được lưu trữ dưới dạng văn bản thô (Plain-text) mà được băm một chiều bằng hàm toán học phức tạp Bcrypt (dựa trên giải thuật mã hóa khối Blowfish). Bcrypt tự động sinh một chuỗi muối ngẫu nhiên (Salt) và ghép vào mật khẩu trước khi băm, đồng thời hỗ trợ tham số chi phí tính toán (Work Factor / Salt Rounds = 10). Cơ chế này tạo ra một chuỗi băm 60 ký tự duy nhất, giúp bảo vệ mật khẩu an toàn tuyệt đối trước các cuộc tấn công tra cứu bảng tính sẵn (Rainbow Table Attacks) hay tấn công vét cạn (Brute-force Attacks).", is_bullet=True)
    add_body_p(doc, "2. Chuẩn định danh phiên không trạng thái JSON Web Token (JWT - RFC 7519): Thay vì sử dụng cơ chế lưu phiên trên bộ nhớ máy chủ (Session-based) vốn làm tốn kém tài nguyên RAM và khó mở rộng theo chiều ngang (Horizontal Scaling), hệ thống áp dụng cơ chế Token-based với JWT. Khi người dùng đăng nhập thành công, máy chủ tạo một chuỗi Token gồm 3 phần được phân tách bằng dấu chấm: Header (thuật toán mã hóa), Payload (thông tin định danh: id, email, role) và Signature (chữ ký số điện tử được ký bằng thuật toán HMAC-SHA256 kết hợp Khóa bí mật riêng của máy chủ - JWT_SECRET). Thẻ JWT có thời hạn hiệu lực 7 ngày và được lưu trữ an toàn trong bộ nhớ cục bộ thiết bị di động (Flutter Secure Storage / SharedPreferences). Mọi yêu cầu tiếp theo chỉ cần gửi kèm Token trong Header `Authorization: Bearer <token>`, máy chủ xác thực tính hợp lệ của chữ ký mà không cần phải tốn chi phí truy vấn lại bảng tài khoản.", is_bullet=True)

    add_heading_3(doc, "1.5.6. Các công cụ và phần mềm hỗ trợ phát triển, kiểm thử")
    add_body_p(doc, "– Môi trường phát triển tích hợp (IDE): Visual Studio Code và Android Studio – hai công cụ lập trình mạnh mẽ hỗ trợ đầy đủ bộ công cụ gỡ lỗi (Debugging), tự động hoàn thành mã (IntelliSense) và giả lập thiết bị Android (Android Emulator).", is_bullet=True)
    add_body_p(doc, "– Nền tảng kiểm thử API (Postman Platform): Được sử dụng để thiết kế, gửi thử nghiệm các yêu cầu HTTP Request (GET, POST, PUT, DELETE), kiểm tra các tham số đầu vào, đo lường thời gian phản hồi và tự động hóa các kịch bản kiểm thử tích hợp API.", is_bullet=True)
    add_body_p(doc, "– Hệ thống quản lý cơ sở dữ liệu: MySQL Workbench và MySQL Command Line Client phục vụ thiết kế bảng, chạy các kịch bản DDL/DML và giám sát hiệu năng truy vấn.", is_bullet=True)
    add_body_p(doc, "– Hệ thống quản lý phiên bản phân tán (Git & GitHub): Quản lý toàn bộ lịch sử các phiên bản mã nguồn, bảo đảm an toàn dữ liệu dự án và hỗ trợ triển khai mã nguồn bài bản.", is_bullet=True)

    doc.add_page_break()
