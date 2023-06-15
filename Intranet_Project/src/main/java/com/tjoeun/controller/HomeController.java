package com.tjoeun.controller;

import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.GenericXmlApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.tjoeun.dao.MyBatisDAO;
import com.tjoeun.service.GetCalendar;
import com.tjoeun.service.GetList;
import com.tjoeun.vo.DateData;
import com.tjoeun.vo.EmpVO;
import com.tjoeun.vo.TodoVO;

@Controller
public class HomeController {

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	long time = System.currentTimeMillis();
	SimpleDateFormat ysdf = new SimpleDateFormat("yyyy");
	SimpleDateFormat msdf = new SimpleDateFormat("MM");
	SimpleDateFormat dsdf = new SimpleDateFormat("dd");
	SimpleDateFormat sdf = new SimpleDateFormat("YYYY-MM-dd");
	
	int year = Integer.parseInt(ysdf.format(time));
	int month = Integer.parseInt(msdf.format(time));
	int date = Integer.parseInt(dsdf.format(time));
	String setdate = sdf.format(time);
	
	DateData todayData = new DateData(year, month, date);

	@Autowired
	private SqlSession sqlSession;

	@RequestMapping(value = "/")
	public String index(Locale locale, Model model) {
		return "redirect:login";
	}

	@RequestMapping("/login")
	public String login(HttpServletRequest request, Model model) {
		return "login";
	}

	@RequestMapping("/login_confirm")
	public String login_confirm(HttpServletRequest request, Model model, EmpVO vo) {

		AbstractApplicationContext CTX = new GenericXmlApplicationContext("classpath:applicationCTX.xml");
		
		HttpSession session = request.getSession();
		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);

		int confirmEmpno = mapper.confirmEmpno(vo.getEmpno());

		if (confirmEmpno != 0) {

			EmpVO confirm = mapper.selectlogin(vo.getEmpno());

			if (vo.getPassword().equals(confirm.getPassword())) {
				
				if (confirm.getPermission().equals("waiting")) {
					session.setAttribute("alertt", "승인되지 않은 아이디입니다.");
					return "redirect:login";
				} else {
					session.setAttribute("EmpVO", confirm);

					GetList todolist = CTX.getBean("getList", GetList.class);
					TodoVO todovo = CTX.getBean("todovo", TodoVO.class);

					todovo.setSetdate(setdate);
					todovo.setEmpno(vo.getEmpno());
					
					todolist.setTodoList(mapper.todolist(todovo));
					session.setAttribute("TodoList", todolist);
					session.setAttribute("todayData", todayData); // 오늘 날짜

					return "redirect:main";
				}
			} else {
				session.setAttribute("alertt", "비밀번호가 일치하지 않습니다.");
				return "redirect:login";
			}

		} else {
			session.setAttribute("alertt", "존재하지 않는 사원번호입니다.");
			return "redirect:login";
		}

	}

	@RequestMapping("/main")
	public String main(HttpServletRequest request, HttpServletResponse response, Model model, DateData dateData, TodoVO todo) {

		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);
		HttpSession session = request.getSession();
		EmpVO vo = (EmpVO) session.getAttribute("EmpVO");
		
		if(vo == null) {
			return "redirect:login";
		}

		// =============== 쿠키 ==========================
		Cookie cookie = new Cookie("coki", null);
		cookie.setComment("게시글 조회 확인");
		cookie.setMaxAge(60 * 60 * 2);

		response.addCookie(cookie); // 클라이언트에게 쿠키 추가
		// =============== 쿠키 ==========================

		// 달력 초기화
		if (dateData.getYear() == 0 && dateData.getMonth() == 0) { // DateData의 초기값(아무런 입력이 없을 때)
			dateData = todayData;
		}

		if (dateData.getMonth() == 13) {
			dateData.setMonth(1);
			dateData.setYear(dateData.getYear() + 1);
		}

		if (dateData.getMonth() == 0) {
			dateData.setMonth(12);
			dateData.setYear(dateData.getYear() - 1);
		}
		
		todo.setEmpno(vo.getEmpno());
		todo.setDeptno(vo.getDeptno());
		
		
		List<DateData> dateList = GetCalendar.month_info(dateData, sqlSession, todo); // 이번달 필드

		model.addAttribute("dateList", dateList);
		model.addAttribute("datedata", dateData); // 달력 날짜

		// 공지사항
		GetList boardlist = new GetList();
		String category = "공지사항";
		boardlist.setBoardList(mapper.selectBoardList(category));
		model.addAttribute("noticeList", boardlist);
		
		// 자료실
		boardlist = new GetList();
		category = "자료실";
		boardlist.setBoardList(mapper.selectBoardList(category));
		model.addAttribute("dataList", boardlist);
		
		// 새쪽지 여부
		int noreadCount = mapper.noreadCount(vo.getEmpno());
		session.setAttribute("noRead",noreadCount);

		return "main";
	}

	@RequestMapping("/logout")
	public String lotout(HttpServletRequest request, Model model) {
			
		HttpSession session = request.getSession();
		session.setAttribute("EmpVO", null);
		return "redirect:login";
	}
	
	@RequestMapping("/findIDpage")
	public String findIDpage(HttpServletRequest request, Model model) {
		return "findIDpage";
	}
	
	@RequestMapping("/findPWpage")
	public String findPWpage(HttpServletRequest request, Model model) {
		return "findPWpage";
	}
	
	@ResponseBody
	@RequestMapping("/findID")
	public String findID(HttpServletRequest request, Model model, EmpVO vo) {
		
		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);
		
		return mapper.findID(vo);
	}
	
	@ResponseBody
	@RequestMapping("/findPW")
	public String findPW(HttpServletRequest request, Model model, EmpVO vo) {
		
		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);
		
		return mapper.findPW(vo);
	}

}
