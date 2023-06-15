package com.tjoeun.controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.apache.poi.hssf.util.HSSFColor.HSSFColorPredefined;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.PrintSetup;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.GenericXmlApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.tjoeun.dao.MyBatisDAO;
import com.tjoeun.service.GetList;
import com.tjoeun.vo.AttendVO;
import com.tjoeun.vo.EmpVO;
import com.tjoeun.vo.Param;
import com.tjoeun.vo.PaySlipVO;

@Controller
@RequestMapping("/attend")
public class attend {

	private static final Logger logger = LoggerFactory.getLogger(attend.class);

	@Autowired
	private SqlSession sqlSession;
	
	AbstractApplicationContext CTX = new GenericXmlApplicationContext("classpath:applicationCTX.xml");
	Param param = CTX.getBean("param", Param.class);
		
	private int currentPage = 1;
	private int PageSize = 10;
	
	@RequestMapping("/move_attend_list")
	public String move_attend_list(HttpServletRequest request, Model model) {

		HttpSession session = request.getSession();

		session.setAttribute("searchdate", null);		
		model.addAttribute("currentPage", 1);

		return "redirect:attend_list";
	}
	
	@RequestMapping("/attend_list")
	public String attend_list(HttpServletRequest request, Model model) {
		
		HttpSession session = request.getSession();
		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);
			
		String searchdate = request.getParameter("searchdate");
		String searchname = ((EmpVO)session.getAttribute("EmpVO")).getName();
		
		if (searchname == null) {
			return "redirect:../login";
		}
		
		if (searchdate != null) {
			searchdate = searchdate.trim().length() == 0 ? null : searchdate;
			session.setAttribute("searchdate", searchdate);
		} else { // 페이지가 이동되어도 검색 내용 유지
			searchdate = (String) session.getAttribute("searchdate");
		}

		GetList attendList = null;
		
		try {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		} catch (NumberFormatException e) {
		}

		// 검색 내용 없을 경우 내 근태 모두 얻어오기
		if (searchdate == null) {
			int totalCount = mapper.countAttendByName(searchname);
			
			attendList = new GetList(PageSize, totalCount, currentPage);
			
			param.setStartNo(attendList.getStartNo());
			param.setEndNo(attendList.getEndNo());
			param.setSearchname(searchname);
			
			attendList.setAttList((ArrayList<AttendVO>) mapper.selectAttendByName(param));
		} else if (searchdate != null) { // 날짜 조회
			param.setSearchdate(searchdate);
			param.setSearchname(searchname);
			int totalCount = mapper.countAttendByDateName(param);
			
			attendList = new GetList(PageSize, totalCount, currentPage);
			
			param.setStartNo(attendList.getStartNo());
			param.setEndNo(attendList.getEndNo());
			
			attendList.setAttList((ArrayList<AttendVO>) mapper.selectAttendByDateName(param));
		} 
		model.addAttribute("attendList", attendList);
		model.addAttribute("currentPage", currentPage);
		
		return "attend/attend_list";
	}

	@RequestMapping("/move_left_dayoff_list")
	public String move_left_dayoff_list(HttpServletRequest request, Model model) {
			
		model.addAttribute("currentPage", 1);
		
		return "redirect:left_dayoff_list";
	}
	
	@RequestMapping("/left_dayoff_list")
	public String left_dayoff_list(HttpServletRequest request, Model model) {
		
		HttpSession session = request.getSession();
		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);
	
		EmpVO vo = (EmpVO) session.getAttribute("EmpVO");
		Date hiredate =  ((EmpVO)session.getAttribute("EmpVO")).getHiredate();
		
		if (vo == null) {
			return "redirect:../login";
		}
		
		Date date = new Date();
		long workdays = (date.getTime() - hiredate.getTime()) / (24 * 60 * 60 * 1000); // 근속일수

		int annual = 15 + (int)(workdays / 365) / 2; // 근속년수 * 2 에 따른 연차 계산

		try {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		} catch (NumberFormatException e) {
		}
		
		int totalCount = mapper.countDayoffByEmpno(vo.getEmpno());
		
		GetList attendList = new GetList(PageSize, totalCount, currentPage);		
		
		param.setStartNo(attendList.getStartNo());
		param.setEndNo(attendList.getEndNo());
		param.setEmpno(vo.getEmpno());
		
		attendList.setAttList((ArrayList<AttendVO>) mapper.selectDayoffByEmpno(param));
		
		float deduce = 0; // 공제일 계산
		int latedate = 0; // 지각 횟수 계산
		for (AttendVO attvo : attendList.getAttList()) {
			deduce += attvo.getDeducedate();
			if (attvo.getEtc().equals("EC")) {
				++latedate;
			}
		}
		
		model.addAttribute("annual", annual);
		model.addAttribute("deduce", deduce);
		model.addAttribute("latedate", latedate);
		model.addAttribute("attendList", attendList);
		model.addAttribute("currentPage", currentPage);
		
		return "attend/left_dayoff_list";
	}
	
	@RequestMapping("/payslip")
	public String payslip(HttpServletRequest request, Model model) {
		
		HttpSession session = request.getSession();
		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);
		
		EmpVO empvo = (EmpVO)session.getAttribute("EmpVO");
		
		if (empvo == null) {
			return "redirect:../login";
		}
		
		Date date = new Date();
		date.setYear(date.getYear());
		date.setMonth(date.getMonth());
		if (date.getDate() < 10) {
			date.setMonth(date.getMonth() - 1);
			if (date.getMonth() == 0) {
				date.setYear(date.getYear() - 1);
				date.setMonth(12);
			}
		}
		
		try {
			date.setYear(Integer.parseInt(request.getParameter("year")) - 1900);
			date.setMonth(Integer.parseInt(request.getParameter("month")) - 1);
		} catch (NumberFormatException e) {
		}
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
		String setdate = sdf.format(date);
		
		param.setEmpno(empvo.getEmpno());
		param.setSearchdate(setdate);

		PaySlipVO vo = mapper.showPaySlip(param);
		
		Double paysum = 0.0;
		Double deducesum = 0.0;
		
		if (vo != null) {
			paysum = vo.getBasepay() + vo.getPosallow() + vo.getAnnualpay() + vo.getExtpay() + vo.getNightpay() + vo.getHolypay() + vo.getBonus() + vo.getEtcpay() + vo.getFoodfee() + vo.getTransefee();
			deducesum = vo.getIncometax() + vo.getLocaltax() + vo.getNationpen() + vo.getEmpinsure() + vo.getHealthinsure() + vo.getEtcdeduce();
		}
		model.addAttribute("year", date.getYear() + 1900);
		model.addAttribute("month", date.getMonth() + 1);
		model.addAttribute("payslip", vo);
		model.addAttribute("paysum", paysum);
		model.addAttribute("deducesum", deducesum);
		return "attend/payslip";
	}
	
	@RequestMapping("/payslipDown")
	public void payslipDown(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		HttpSession session = request.getSession();
		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);
		
		Date date = new Date();
		try {
			date.setYear(Integer.parseInt(request.getParameter("year")) - 1900);
			date.setMonth(Integer.parseInt(request.getParameter("month")) - 1);
		} catch (NumberFormatException e) {
		}
		
		String setdate = new SimpleDateFormat("yyyy-MM").format(date);
		EmpVO empvo = (EmpVO)session.getAttribute("EmpVO");
		
		param.setEmpno(empvo.getEmpno());
		param.setSearchdate(setdate);

		PaySlipVO vo = mapper.showPaySlip(param);
		String sdfdate = new SimpleDateFormat("yyyy-MM-dd").format(vo.getPaymentdate());
		
		Double paysum = 0.0;
		Double deducesum = 0.0;
		
		if (vo != null) {
			paysum = vo.getBasepay() + vo.getPosallow() + vo.getAnnualpay() + vo.getExtpay() + vo.getNightpay() + vo.getHolypay() + vo.getBonus() + vo.getEtcpay() + vo.getFoodfee() + vo.getTransefee();
			deducesum = vo.getIncometax() + vo.getLocaltax() + vo.getNationpen() + vo.getEmpinsure() + vo.getHealthinsure() + vo.getEtcdeduce();
		}
	
		Workbook wb = new XSSFWorkbook(); // 확장자 지정 XSS : xlsx, HSS : xls
        Sheet sheet = wb.createSheet("급여명세서");
        Row row = null;
        Cell cell = null;
        int rowNum = 0;
        PrintSetup print = null; // 인쇄설정
        
        // 셀 스타일 지정
        sheet.setDefaultColumnWidth(25);
        
        // Preface
        CellStyle prefacestyle = wb.createCellStyle(); 
        prefacestyle.setAlignment(HorizontalAlignment.CENTER); // 가운데 정렬
        
        row = sheet.createRow(rowNum++);
        cell = row.createCell(0);
        cell.setCellStyle(prefacestyle);
        cell.setCellValue("성명: " + empvo.getName());
        cell = row.createCell(1);
        cell.setCellStyle(prefacestyle);
        cell.setCellValue("부서: " + empvo.getDeptname());
        cell = row.createCell(2);
        cell.setCellStyle(prefacestyle);
        cell.setCellValue("직책: " + empvo.getPosition());
        cell = row.createCell(3);
        cell.setCellStyle(prefacestyle);
        cell.setCellValue("지급일: " + sdfdate);

        // Header
        CellStyle headStyle = wb.createCellStyle(); 
        headStyle.setAlignment(HorizontalAlignment.CENTER); // 가운데 정렬
        headStyle.setFillForegroundColor(HSSFColorPredefined.LIGHT_TURQUOISE.getIndex()); // 배경색 설정
        headStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        
        row = sheet.createRow(rowNum++);
        cell = row.createCell(0);
        cell.setCellStyle(headStyle);
        cell.setCellValue("지급 항목");
        cell = row.createCell(1);
        cell.setCellStyle(headStyle);
        cell.setCellValue("지급액");
        cell = row.createCell(2);
        cell.setCellStyle(headStyle);
        cell.setCellValue("공제 항목");
        cell = row.createCell(3);
        cell.setCellStyle(headStyle);
        cell.setCellValue("공제액");

        // Body
        CellStyle bodyStyle = wb.createCellStyle(); 
        bodyStyle.setAlignment(HorizontalAlignment.CENTER); // 가운데 정렬
        bodyStyle.setDataFormat((short)0x26); // 숫자형식 지정 https://poi.apache.org/apidocs/dev/org/apache/poi/ss/usermodel/BuiltinFormats.html
        
        String[] title = {"기본급", "소득세", "직책수당", "지방세", "근속수당", "국민 연금", "연장수당", "고용보험", "야간수당", "건강보험", "주말수당", "기타 공제", "상여금", "기타", "식대", "교통비"};
        
        for(int i = 0; i < 11; i++ ) {
            row = sheet.createRow(rowNum++);
            cell = row.createCell(0);
            cell.setCellStyle(bodyStyle);
            cell.setCellValue(title[i]);
            cell = row.createCell(1);
            cell.setCellStyle(bodyStyle);
            cell.setCellValue(vo.getArray()[i]);
            cell = row.createCell(2);
            cell.setCellStyle(bodyStyle);
            cell.setCellValue(title[++i]);
            cell = row.createCell(3);
            cell.setCellStyle(bodyStyle);
            cell.setCellValue(vo.getArray()[i]);
        }
        
        for(int i = 12; i < 16; i++ ) {
        	 row = sheet.createRow(rowNum++);
             cell = row.createCell(0);
             cell.setCellStyle(bodyStyle);
             cell.setCellValue(title[i]);
             cell = row.createCell(1);
             cell.setCellStyle(bodyStyle);
             cell.setCellValue(vo.getArray()[i]);
        }
        
        row = sheet.createRow(rowNum++);
        cell = row.createCell(2);
        cell.setCellStyle(headStyle);
        cell.setCellValue("공제 합계");
        cell = row.createCell(3);
        cell.setCellStyle(bodyStyle);
        cell.setCellValue(deducesum);
        
        row = sheet.createRow(rowNum++);
        cell = row.createCell(0);
        cell.setCellStyle(headStyle);
        cell.setCellValue("급여 합계");
        cell = row.createCell(1);
        cell.setCellStyle(bodyStyle);
        cell.setCellValue(paysum);
        cell = row.createCell(2);
        cell.setCellStyle(headStyle);
        cell.setCellValue("수령액");
        cell = row.createCell(3);
        cell.setCellStyle(bodyStyle);
        cell.setCellValue(paysum - deducesum);
        
        
        // 인쇄 설정
        wb.setPrintArea(0, "$A$1:$D$14"); // 인쇄 범위 지정
		print = sheet.getPrintSetup(); // 인쇄 옵션 설정
		print.setLandscape(true); // 인쇄 방향설정 - 가로방향
		print.setPaperSize(PrintSetup.A4_PAPERSIZE); // 인쇄용지 크기설정 - A4
		sheet.setFitToPage(true); // 인쇄영역에 맞춰서 한페이지에 모든열 맞추기 
		print.setFitWidth((short)1);
		print.setFitHeight((short)0);

        // 컨텐츠 타입과 파일명 지정
        response.setContentType("ms-vnd/excel");
        response.setHeader("Content-Disposition", "attachment;filename=" +  empvo.getEmpno() + "_" + sdfdate +".xlsx");

        // Excel File Output
        wb.write(response.getOutputStream());
        wb.close();
	}
	
	@RequestMapping("/perform_evalu")
	public String perform_evalu(HttpServletRequest request, Model model) {
		return "attend/perform_evalu";
	}
}
