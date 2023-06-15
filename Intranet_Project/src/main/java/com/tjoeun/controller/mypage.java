package com.tjoeun.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.GenericXmlApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.tjoeun.dao.MyBatisDAO;
import com.tjoeun.service.GetList;
import com.tjoeun.vo.BoardVO;
import com.tjoeun.vo.EmpVO;
import com.tjoeun.vo.MessageVO;
import com.tjoeun.vo.Param;

@Controller
@RequestMapping("/mypage")
public class mypage {

	AbstractApplicationContext CTX = new GenericXmlApplicationContext("classpath:applicationCTX.xml");
	Param param = CTX.getBean("param", Param.class);

	private int PageSize = 8;
	private int currentPage = 1;

	@Autowired
	private SqlSession sqlSession;

	// 내정보
	@RequestMapping("/myinfo_view")
	public String myinfo_view(HttpServletRequest request, Model model) {

		return "mypage/myinfo_view";
	}
	
	// 비밀번호 변경
	@ResponseBody
	@RequestMapping("/UserRegisterUpdate")
	public void UserRegisterUpdate(HttpServletRequest request, Model model, EmpVO vo) {
		
		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);
		HttpSession session = request.getSession();		

		mapper.registerUpdate(vo);
		session.setAttribute("EmpVO", mapper.selectlogin(vo.getEmpno()));
	}
	
	// 프로필 이미지 등록
	@RequestMapping("/uploadProfile")
	public String uploadProfile(MultipartHttpServletRequest request, Model model, EmpVO vo) {
		
		String rootUploarDir = "D:" + File.separator + "upload" + File.separator + "profile"; // 업로드하는 파일이 저장될 디렉토리
		File dir = new File(rootUploarDir);
		
		// 업로드 되는 파일 정보 수집
		Iterator<String> iterator = request.getFileNames();
		MultipartFile multipartFile = null;
		String realprofile = ""; // 실제 업로드 파일명
		String profilename = ""; // 원래 파일명
		
		while (iterator.hasNext()) {
			realprofile = iterator.next(); // 실제 업로드 파일명
			multipartFile = request.getFile(realprofile);
			profilename = multipartFile.getOriginalFilename();

			if (profilename != null && profilename.length() != 0) {
				try {
					multipartFile.transferTo(new File(dir + File.separator + vo.getEmpno() + "_" + vo.getName() + "." + profilename.split("[.]")[1])); 
					vo.setProfilename(profilename);
					vo.setRealprofile(vo.getEmpno() + "_" + profilename);
					
					MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);
					mapper.updateProfile(vo);
					
					HttpSession session = request.getSession();
					session.setAttribute("EmpVO", mapper.selectlogin(vo.getEmpno()));

				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		
		return "redirect:myinfo_view";
	}

	@RequestMapping("/mywrite_view")
	public String mywrite_view(HttpServletRequest request, Model model) {

		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);

		HttpSession session = request.getSession();
		EmpVO vo = (EmpVO) session.getAttribute("EmpVO");
		
		if (vo == null) {
			return "redirect:../login";
		}

		try {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		} catch (NumberFormatException e) {

		}

		int totalCount = mapper.mywrite_selectCount(vo.getEmpno());

		GetList boardlist = new GetList(PageSize, totalCount, currentPage);

		HashMap<String, Integer> myhmap = new HashMap<String, Integer>();
		myhmap.put("startNo", boardlist.getStartNo());
		myhmap.put("endNo", boardlist.getEndNo());
		myhmap.put("empno", vo.getEmpno());

		boardlist.setBoardList(mapper.mywrite_selectList(myhmap));

		model.addAttribute("BoardList", boardlist);

		return "mypage/mywrite_view";
	}

	// 내가 쓴 글 보기
	@RequestMapping("/mywrite_content_view")
	public String mywrite_content_view(HttpServletRequest request, Model model) {
		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);

		int idx = Integer.parseInt(request.getParameter("idx"));

		BoardVO boardvo = mapper.selectContentByIdx(idx);

		model.addAttribute("currentPage", request.getParameter("currentPage"));
		model.addAttribute("BoardVO", boardvo);
		model.addAttribute("enter", "\r\n");

		return "mypage/mywrite_content_view";
	}
	
	// 쪽지함 리스트 이동
	@RequestMapping("/move_message_view")
	public String move_message_view(HttpServletRequest request, Model model, String divs) {
		
		HttpSession session = request.getSession();
		
		session.setAttribute("searchcategory", null);
		session.setAttribute("searchobj", null);

		model.addAttribute("currentPage", 1);

		if(divs == null || divs.equals("receive")) {
			return "redirect:message_receive_view";
		} else if(divs.equals("send")) {
			return "redirect:message_send_view";
		} else if(divs.equals("trash")) {
			return "redirect:message_trash_view";
		} 
		return "./error";
	}
	
	// 받은 쪽지
	@RequestMapping("/message_receive_view")
	public String message_receive_view(HttpServletRequest request, Model model) {

		HttpSession session = request.getSession();
		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);

		EmpVO vo = (EmpVO) session.getAttribute("EmpVO");
		String searchcategory = request.getParameter("searchcategory");
		String searchobj = request.getParameter("searchobj");
		
		if (vo == null) {
			return "redirect:../login";
		}

		try {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		} catch (NumberFormatException e) {

		}

		if (searchobj != null) { 
			session.setAttribute("searchcategory", searchcategory);
			searchobj = searchobj.trim().length() == 0 ? null : searchobj;
			session.setAttribute("searchobj", searchobj);
		} else { 
			searchcategory = (String) session.getAttribute("searchcategory");
			searchobj = (String) session.getAttribute("searchobj");
		}

		GetList messageList = null;
		param.setEmpno(vo.getEmpno());

		// 검색 내용 없을 경우에 전체 글 목록 얻어오기
		if (searchobj == null) { 

			int totalCount = mapper.receiveMessageCount(vo.getEmpno());

			messageList = new GetList(PageSize, totalCount, currentPage);

			param.setStartNo(messageList.getStartNo());
			param.setEndNo(messageList.getEndNo());

			messageList.setMsList(mapper.receiveMessageList(param));
			
		} else { // 검색 내용 찾기

			param.setSearchobj(searchobj);
			param.setSearchcategory(searchcategory);

			int totalCount = mapper.receiveMessageCountMulti(param);

			messageList = new GetList(PageSize, totalCount, currentPage);
			
			param.setStartNo(messageList.getStartNo());
			param.setEndNo(messageList.getEndNo());
			
			messageList.setMsList(mapper.receiveMessageListMulti(param));		
		}
		model.addAttribute("MessageList", messageList);
		
		return "mypage/message_receive_view";
	}
		
	// 보낸 쪽지
	@RequestMapping("/message_send_view")
	public String message_send_view(HttpServletRequest request, Model model) {

		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);
		HttpSession session = request.getSession();
		
		EmpVO vo = (EmpVO) session.getAttribute("EmpVO");
		String searchcategory = request.getParameter("searchcategory");
		String searchobj = request.getParameter("searchobj");
		
		if (vo == null) {
			return "redirect:../login";
		}
		
		try {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		} catch (NumberFormatException e) {
			
		}
		
		if (searchobj != null) { 
			session.setAttribute("searchcategory", searchcategory);
			searchobj = searchobj.trim().length() == 0 ? null : searchobj;
			session.setAttribute("searchobj", searchobj);
		} else { 
			searchcategory = (String) session.getAttribute("searchcategory");
			searchobj = (String) session.getAttribute("searchobj");
		}
		
		GetList messageList = null;
		param.setEmpno(vo.getEmpno());
		
		// 검색 내용 없을 경우에 전체 글 목록 얻어오기
		if (searchobj == null || searchobj.trim().length() == 0) { 
			
			int totalCount = mapper.sendMessageCount(vo.getEmpno());
			
			messageList = new GetList(PageSize, totalCount, currentPage);
			
			param.setStartNo(messageList.getStartNo());
			param.setEndNo(messageList.getEndNo());
			
			messageList.setMsList(mapper.sendMessageList(param));
			
		} else { // 검색 내용 찾기
			
			param.setSearchobj(searchobj);
			param.setSearchcategory(searchcategory);
			
			int totalCount = mapper.sendMessageCountMulti(param);
			
			messageList = new GetList(PageSize, totalCount, currentPage);
			
			param.setStartNo(messageList.getStartNo());
			param.setEndNo(messageList.getEndNo());
			
			messageList.setMsList(mapper.sendMessageListMulti(param));
			
		}

		model.addAttribute("MessageList", messageList);
		return "mypage/message_send_view";
	}
		
	// 휴지통
	@RequestMapping("/message_trash_view")
	public String message_trash_view(HttpServletRequest request, Model model) {
		
		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);
		HttpSession session = request.getSession();
		
		EmpVO vo = (EmpVO) session.getAttribute("EmpVO");
		String searchcategory = request.getParameter("searchcategory");
		String searchobj = request.getParameter("searchobj");
		
		if (vo == null) {
			return "redirect:../login";
		}
		
		try {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		} catch (Exception e) {
			
		}
		
		if (searchobj != null) { 
			session.setAttribute("searchcategory", searchcategory);
			searchobj = searchobj.trim().length() == 0 ? null : searchobj;
			session.setAttribute("searchobj", searchobj);
		} else { 
			searchcategory = (String) session.getAttribute("searchcategory");
			searchobj = (String) session.getAttribute("searchobj");
		}
		
		GetList messageList = null;
		param.setEmpno(vo.getEmpno());
		
		// 검색 내용 없을 경우에 전체 글 목록 얻어오기
		if (searchobj == null || searchobj.trim().length() == 0) { 
			
			int totalCount = mapper.trashMessageCount(vo.getEmpno());
			
			messageList = new GetList(PageSize, totalCount, currentPage);
			
			param.setEmpno(vo.getEmpno());
			param.setStartNo(messageList.getStartNo());
			param.setEndNo(messageList.getEndNo());
			
			messageList.setMsList(mapper.trashMessageList(param));
			
		} else { // 검색 내용 찾기
			
			param.setSearchobj(searchobj);
			param.setSearchcategory(searchcategory);
			param.setEmpno(vo.getEmpno());
			
			int totalCount = mapper.trashMessageCountMulti(param);
			
			messageList = new GetList(PageSize, totalCount, currentPage);
			
			param.setStartNo(messageList.getStartNo());
			param.setEndNo(messageList.getEndNo());
			
			messageList.setMsList(mapper.trashMessageListMulti(param));
		}
		
		model.addAttribute("MessageList", messageList);
		
		return "mypage/message_trash_view";
	}
		
	// 쪽지 글 보기
	@RequestMapping("/message_content_view")
	public String message_content_list(HttpServletRequest request, Model model) {
		
		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);
		HttpSession session = request.getSession();
		
		int idx = Integer.parseInt(request.getParameter("idx"));
		String divs = request.getParameter("divs");
		
		EmpVO vo = (EmpVO) session.getAttribute("EmpVO");
		
		if (vo == null) {
			return "redirect:../login";
		}
		
		if(divs.equals("receive")) {
			mapper.updateMessageStatus(idx);
			int noreadCount = mapper.noreadCount(vo.getEmpno());
			session.setAttribute("noRead",noreadCount);
		}
		MessageVO messageVO = mapper.messageSelectByIdx(idx);

		model.addAttribute("divs", divs);
		model.addAttribute("currentPage", Integer.parseInt(request.getParameter("currentPage")));
		model.addAttribute("MessageVO", messageVO);
		model.addAttribute("enter", "\r\n");
		
		return "mypage/message_content_view";
	}
		
		
	// 쪽지 삭제관련
	@RequestMapping("/message_service")
	public String mailboxes_service(HttpServletRequest request, Model model, MessageVO meo) {
		
		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);
		int mode = Integer.parseInt(request.getParameter("mode"));
		
		if(mode == 2){ // 삭제
			mapper.messageRemove(meo);
			return "redirect:message_receive_view";
		}else if(mode == 3){ // 복구
			mapper.messageRestore(meo);
			return "redirect:message_trash_view";
		}else if(mode == 4){ // 찐삭제
			mapper.messageDelete(meo);
			return "redirect:message_trash_view";
		}
		
		return "error";
	}
	
	@RequestMapping("/message_insert")
	public String mailboxes_insert(HttpServletRequest request, Model model) {
		return "mypage/message_insert";
	}
	
	// 쪽지 받는 사람 자동완성
	@ResponseBody
	@RequestMapping("/searchemp")
	public ArrayList<EmpVO> searchemp(HttpServletRequest request, Param pr) {
		
		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);
		GetList emplist = new GetList();
		emplist.setEmpList(mapper.searchemp(pr));
		
		return emplist.getEmpList();
	}

	// 쪽지 전송
	@RequestMapping("/transMessage")
	public void transMessage(MultipartHttpServletRequest request, HttpServletResponse response, Model model, MessageVO vo) throws IOException {

		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);
		
		String receiver = request.getParameter("receiver");
		String[] empli = null;
		int empno = 0;
		
		try {
			empli = request.getParameter("emplist").split(",");
		} catch (NullPointerException e) { }

		try {
			empno = Integer.parseInt(receiver.split("[\\(\\)]")[1]); // ()로 split
		} catch (NullPointerException e) { }
		
		String rootUploarDir = "D:" + File.separator + "upload" + File.separator + "message"; // 업로드하는 파일이 저장될 디렉토리
		File dir = new File(rootUploarDir);
		UUID uuid = UUID.randomUUID();

		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		
		// 업로드 디렉토리가 존재하지 않을 경우 업로드 디렉토리 생성
		if (!dir.exists()) {
			dir.mkdir();
		}

		// 업로드 되는 파일 정보 수집
		Iterator<String> iterator = request.getFileNames();
		MultipartFile multipartFile = null;
		String realfilename = ""; // 실제 업로드 파일명
		String attachedfile = ""; // 원래 파일명

		while (iterator.hasNext()) {
			realfilename = iterator.next(); // 실제 업로드 파일명
			multipartFile = request.getFile(realfilename);
			attachedfile = multipartFile.getOriginalFilename();
			
			if (attachedfile != null && attachedfile.length() != 0) {
				try {
					// MultipartFile 인터페이스 객체에서 transferTo() 메소드로 파일을 File 객체로 만들어 업로드
					multipartFile.transferTo(new File(dir + File.separator + uuid.toString() + "_" + attachedfile)); 
					vo.setAttachedfile(attachedfile);
					vo.setRealfilename(uuid.toString() + "_" + attachedfile);

				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

		out.println("<script>alert('전송 완료');</script>");
		if (receiver == null) { // 쪽지함 -> 쪽지 전송으로 넘어온 경우
			for(int i=0; i < empli.length; i++) {
				vo.setReceiveempno(Integer.parseInt(empli[i]));
				mapper.sendmessage(vo);
			}
			out.println("<script>location.href='message_send_view';</script>");
		} else { // 쪽지 전송 모달로 전송한 경우
			vo.setReceiveempno(empno);
			mapper.sendmessage(vo);
			out.println("<script>location.href = document.referrer;</script>");
		}
		out.flush();

	}

	// 오늘 할 일
	@RequestMapping("/todo_view")
	public String todo_view(HttpServletRequest request, Model model) {
		return "mypage/todo_view";
	}

}
