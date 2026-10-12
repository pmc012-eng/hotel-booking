# -*- coding: utf-8 -*-
"""
Master script to assemble the complete Graduation / Term Project Report:
File: D:\\Projects\\hotel-android\\Bao_Cao_Do_An_Hotel_Booking.docx
"""

import os
import sys
import docx
from docx.shared import Cm, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.section import WD_SECTION

# Fix windows console unicode printing
if sys.stdout.encoding != 'utf-8':
    try:
        sys.stdout.reconfigure(encoding='utf-8')
    except Exception:
        pass

from report_builder.helpers import (
    apply_section_margins, set_page_number_start, add_page_number_to_footer
)
from report_builder.pre_body import (
    add_cover_page, add_pledge_and_thanks, add_table_of_contents_placeholder,
    add_abbreviations_table, add_list_of_figures, add_list_of_tables
)
from report_builder.chap_intro_1 import (
    add_introduction, add_chapter_1
)
from report_builder.chap_2 import add_chapter_2
from report_builder.chap_3 import add_chapter_3
from report_builder.conclusion_appendix import (
    add_conclusion, add_references_and_appendices
)

def build_report():
    print("Initializing Document...")
    doc = docx.Document()

    # Configure Normal Style: Times New Roman, 14pt, Multiple 1.3, Justify
    style = doc.styles['Normal']
    font = style.font
    font.name = 'Times New Roman'
    font.size = Pt(14)
    font.color.rgb = RGBColor(0, 0, 0)
    
    # ---------------------------------------------------------
    # SECTION 1: PRE-BODY (Bia, Loi cam doan, Muc luc, Danh muc)
    # No headers, no footers (no page numbers)
    # ---------------------------------------------------------
    sec1 = doc.sections[0]
    apply_section_margins(sec1)
    sec1.header.is_linked_to_previous = False
    sec1.footer.is_linked_to_previous = False
    sec1.header.paragraphs[0].text = ""
    sec1.footer.paragraphs[0].text = ""

    print("Building Section 1: Pre-body...")
    add_cover_page(doc, is_sub=False)
    add_cover_page(doc, is_sub=True)
    add_pledge_and_thanks(doc)
    add_table_of_contents_placeholder(doc)
    add_abbreviations_table(doc)
    add_list_of_figures(doc)
    add_list_of_tables(doc)

    # ---------------------------------------------------------
    # SECTION 2: BODY (Mo dau, Chuong 1, 2, 3, Ket luan)
    # Starts page numbering from 1 at footer center
    # Strictly >= 50 pages from Mo dau to Ket luan!
    # ---------------------------------------------------------
    print("Building Section 2: Body (Mo dau -> Ket luan)...")
    sec2 = doc.add_section(WD_SECTION.NEW_PAGE)
    apply_section_margins(sec2)
    sec2.header.is_linked_to_previous = False
    sec2.footer.is_linked_to_previous = False
    sec2.header.paragraphs[0].text = ""
    set_page_number_start(sec2, 1)
    add_page_number_to_footer(sec2.footer)

    add_introduction(doc)
    add_chapter_1(doc)
    add_chapter_2(doc)
    add_chapter_3(doc)
    add_conclusion(doc)

    # ---------------------------------------------------------
    # SECTION 3: POST-BODY (Tai lieu tham khao, Phu luc)
    # ---------------------------------------------------------
    print("Building Section 3: References & Appendices...")
    sec3 = doc.add_section(WD_SECTION.NEW_PAGE)
    apply_section_margins(sec3)
    sec3.header.is_linked_to_previous = False
    sec3.footer.is_linked_to_previous = False
    sec3.header.paragraphs[0].text = ""
    sec3.footer.paragraphs[0].text = ""

    add_references_and_appendices(doc)

    output_path = r"D:\Projects\hotel-android\Bao_Cao_Do_An_Hotel_Booking.docx"
    doc.save(output_path)
    print(f"Report successfully saved to: {output_path}")

if __name__ == '__main__':
    build_report()
