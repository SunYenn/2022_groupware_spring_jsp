package com.tjoeun.controller.approval;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.GenericXmlApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.tjoeun.dao.MyBatisDAO;
import com.tjoeun.service.GetList;
import com.tjoeun.vo.ApprovalVO;
import com.tjoeun.vo.EmpVO;
import com.tjoeun.vo.Param;

@Controller
@RequestMapping("/approval")
public class ApprovalController {

	private static final Logger logger = LoggerFactory.getLogger(ApprovalController.class);

	AbstractApplicationContext CTX = new GenericXmlApplicationContext("classpath:applicationCTX.xml");

	@Autowired
	private SqlSession sqlsession;

	@RequestMapping("/approvalMain")
	public ModelAndView approvalMain(HttpServletRequest request, ModelAndView model,
			@RequestParam(value = "pageSize", required = false, defaultValue = "10") int pageSize,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage) {
		HttpSession session = request.getSession();
		MyBatisDAO mapper = sqlsession.getMapper(MyBatisDAO.class);

		EmpVO empvo = (EmpVO) session.getAttribute("EmpVO");
		
		if (empvo == null) {
			model.setViewName("redirect:../login");
			return model;
		}
		
		int empno = empvo.getEmpno();

		int approvalCount_YET = mapper.approvalCount_YET(empno);
		int approvalCount_UNDER = mapper.approvalCount_UNDER(empno);
		int approvalCount_DONE = mapper.approvalCount_DONE(empno);
		int approvalCount_CANCEL = mapper.approvalCount_CANCEL(empno);

		int totalCount = mapper.listCount(new Param());
		GetList paging = new GetList(pageSize, totalCount, currentPage);

		Param param = new Param();
		param.setUserNo(empno);
		param.setStartNo(paging.getStartNo());
		param.setEndNo(paging.getEndNo());

		List<ApprovalVO> mainList = mapper.selectRecentList(param); // 내 결재 목록
		List<ApprovalVO> mainList1 = mapper.selectRecentList1(param); // 내가 작성한 결재

		model.addObject("countYet", approvalCount_YET);
		model.addObject("countUnder", approvalCount_UNDER);
		model.addObject("countDone", approvalCount_DONE);
		model.addObject("countCancel", approvalCount_CANCEL);
		model.addObject("mainList", mainList);
		model.addObject("mainList1", mainList1);
		model.setViewName("approval/approvalMain");

		return model;
	}

	@RequestMapping("/move_approval_List")
	public String move_board_list(HttpServletRequest request, Model model) {

		HttpSession session = request.getSession();

		session.setAttribute("searchcategory", null);
		session.setAttribute("searchobj", null);
		
		model.addAttribute("approvalStatus", request.getParameter("approvalStatus"));
		model.addAttribute("userNo", request.getParameter("userNo"));
		model.addAttribute("currentPage", 1);

		return "redirect:approvalList";
	}
	
	// 결재리스트
	@RequestMapping("/approvalList")
	public ModelAndView approvalList(ModelAndView model, HttpServletRequest request,
			@RequestParam(required = false, defaultValue = "") String approvalStatus,
			@RequestParam(required = false) Integer userNo,
			@RequestParam(value = "pageSize", required = false, defaultValue = "10") int pageSize,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage) {

		HttpSession session = request.getSession();
		MyBatisDAO mapper = sqlsession.getMapper(MyBatisDAO.class);

		String searchcategory = request.getParameter("searchcategory");
		String searchobj = request.getParameter("searchobj");

		try {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		} catch (Exception e) {

		}
		
		if (searchobj != null) {
			session.setAttribute("searchcategory", searchcategory);
			searchobj = searchobj.trim().length() == 0 ? "" : searchobj;
			session.setAttribute("searchobj", searchobj);
		} else { // 페이지가 이동되어도 검색 내용 유지
			searchcategory = (String) session.getAttribute("searchcategory");
			searchobj = (String) session.getAttribute("searchobj");
		}

		GetList paging = null;

		if (searchobj == null || searchobj.trim().length() == 0) {

			final Param param = new Param();
			param.setApproval_status(approvalStatus);
			
			if(request.getParameter("userNo") != null && !String.valueOf(request.getParameter("userNo")).equals("")){
				
				param.setUserNo(Integer.parseInt(String.valueOf(request.getParameter("userNo"))));
			}
			
			int totalCount = mapper.listCount(param);
			
			paging = new GetList(pageSize, totalCount, currentPage);
			param.setStartNo(paging.getStartNo());
			param.setEndNo(paging.getEndNo());

			paging.setAppList(mapper.selectApprovalList(param));

		} else {

			Param param = new Param();
			param.setSearchobj(searchobj);
			param.setSearchcategory(searchcategory);

			int totalCount = mapper.AselecCountMulti(param);

			paging = new GetList(pageSize, totalCount, currentPage);
			param.setStartNo(paging.getStartNo());
			param.setEndNo(paging.getEndNo());

			paging.setAppList(mapper.AselectListMulti(param));

		}

		request.setAttribute("currentPage", currentPage);
		
		if (userNo != null){
			model.addObject("userNo", userNo);
		}
		model.addObject("approvalStatus", approvalStatus);
		model.addObject("paging", paging);
		model.setViewName("approval/approvalList");

		return model;
	}

	// 품의서 작성 폼
	@RequestMapping("/letterOfApproval")
	public String letterOfApproval() {
		return "approval/letterOfApproval";
	}

	// 품의서 작성 (insert)
	@RequestMapping("/letterOfApproval_insert")
	public ModelAndView letterOfApproval_insert(HttpServletRequest request,
			@RequestPart(value="loaFileUpload", required=false) MultipartFile loaFileUpload,
			ModelAndView model, ApprovalVO vo){

		HttpSession session = request.getSession();
		MyBatisDAO mapper = sqlsession.getMapper(MyBatisDAO.class);
		EmpVO empvo = (EmpVO) session.getAttribute("EmpVO");
		int empno = empvo.getEmpno();
		String name = empvo.getName();

		int result = 0;
		int result2 = 0;
		int result3 = 0;

		vo.setAppWriteNo(empno);
		
		// 품의서 파일 업로드
		String originFileName = "";
		String finalFileName = "";
		String path = "";
		
		if (!loaFileUpload.getOriginalFilename().isEmpty()) {
			StringBuilder sb = new StringBuilder();
			
			path = request.getSession().getServletContext().getRealPath("/resources/upload/");			
			
			File file = new File(path);
			if (!file.exists()) {
				file.mkdir();
			}
			
			// 업로드할 파일 이름 (사번_이름_원본파일이름)
			originFileName = loaFileUpload.getOriginalFilename();
			finalFileName = sb.append(empno).append("_").append(name).append("_").append(originFileName).toString();
			
			file = new File(path + finalFileName);
			
			try {
				loaFileUpload.transferTo(file);
				logger.error("업로드 성공");
			} catch (Exception e) {
				logger.error("업로드 실패");
			}
		}
		vo.setLoaOriginalFileName(originFileName);
		vo.setLoaRealFileName(finalFileName);
		
		result = mapper.insertApproval(vo); // APPROVAL
		vo.setLoaAppNo(vo.getAppNo());
		result2 = mapper.insertAppLoa(vo); // APP_LOA
		vo.setReRefAppNo(vo.getAppNo());
		result3 = mapper.insertReceiveRef(vo); // APP_RECEIVE_REF

		if (result > 0 && result2 > 0 && result3 > 0) {
			model.addObject("msg", "품의서가 정상 등록 되었습니다.");
			model.addObject("location", "/approval/approvalList");
		} else {
			model.addObject("msg", "품의서 등록에 실패했습니다.");
			model.addObject("location", "/");
		}

		model.addObject("action", "letterOfApproval_insert");
		model.setViewName("modal/msg");

		return model;
	}

	// 품의서 수신
	@RequestMapping("/letterOfApprovalView")
	public ModelAndView letterOfApprovalView(HttpServletRequest request, ModelAndView model) {
		
		MyBatisDAO mapper = sqlsession.getMapper(MyBatisDAO.class);
		int appNo = Integer.parseInt(request.getParameter("appNo"));

		ApprovalVO vo = mapper.selectLOAListDetail(appNo);

		model.addObject("signImg", vo.getAppCheckProgress().equals("결재반려") ? "canceled.png" : "approved.png");
		model.addObject("approval", vo);
		model.addObject("enter", "\r\n");
		model.setViewName("/approval/letterOfApprovalView");

		return model;
	}

	// 휴가 신청서 작성 폼
	@RequestMapping("/leaveApplication")
	public String leaveApplication(HttpServletRequest request) {
		return "/approval/leaveApplication";
	}

	// 휴가 신청서 작성 (insert)
	@RequestMapping(value = "/leaveApplication_insert", method = RequestMethod.POST)
	public ModelAndView leaveApplication_insert(HttpServletRequest request, @ModelAttribute ApprovalVO vo, ModelAndView model) {
		HttpSession session = request.getSession();
		MyBatisDAO mapper = sqlsession.getMapper(MyBatisDAO.class);

		EmpVO empvo = (EmpVO) session.getAttribute("EmpVO");
		int empno = empvo.getEmpno();

		int result = 0;
		int result2 = 0;
		int result3 = 0;

		vo.setAppWriteNo(empno);

		if (empno == vo.getAppWriteNo()) {
			
			result = mapper.insertApproval(vo);
			vo.setLeaveAppNo(vo.getAppNo());
			request.setAttribute("result", vo);

			result2 = mapper.insertAppLeave(vo);
			vo.setReRefAppNo(vo.getAppNo());

			result3 = mapper.insertReceiveRef(vo);

			if (result > 0 && result2 > 0 && result3 > 0) {
				model.addObject("msg", "휴가 신청서가 정상 등록 되었습니다.");
				model.addObject("location", "/approval/approvalList");

			} else {
				model.addObject("msg", "휴가 신청서 등록 실패");
				model.addObject("location", "/");
			}
		}
		model.addObject("action", "leaveApplication_insert");
		model.setViewName("modal/msg");

		return model;
	}

	// 휴가 신청서 수신
	@RequestMapping("/leaveApplicationView")
	public ModelAndView leaveApplicationView(ModelAndView model, HttpServletRequest request, ApprovalVO vo) {
		
		MyBatisDAO mapper = sqlsession.getMapper(MyBatisDAO.class);
		int appNo = vo.getAppNo();

		vo = mapper.selectLeaveListDetail(appNo);

		model.addObject("signImg", vo.getAppCheckProgress().equals("결재반려") ? "canceled.png" : "approved.png");
		model.addObject("approval", vo);
		model.addObject("enter", "\r\n");
		model.setViewName("/approval/leaveApplicationView");

		return model;
	}

	// 지출결의서 작성 폼
	@RequestMapping("/expenseReport")
	public String expenseReport() {
		return "approval/expenseReport";
	}

	// 지출결의서 작성(insert)
	@RequestMapping("/expenseReport_insert")
	public ModelAndView expenseReport_insert (ApprovalVO vo, ModelAndView model, HttpServletRequest request) {
		HttpSession session = request.getSession();
		MyBatisDAO mapper = sqlsession.getMapper(MyBatisDAO.class);

		int empno = ((EmpVO)session.getAttribute("EmpVO")).getEmpno();

		vo.setAppWriteNo(empno);

		int result = mapper.insertApproval(vo); // APPROVAL
		vo.setAppWriteNo(vo.getAppNo());
		request.setAttribute("approval", vo);

		int result2 = mapper.insertAppER(vo); // APP_ER
		vo.setErAppNo(vo.getAppNo());

		int result3 = mapper.insertReceiveRef(vo); // APP_RECEIVE_REF

		if (result > 0 && result2 > 0 && result3 > 0) {
			model.addObject("msg", "지출결의서가 등록되었습니다.");
			model.addObject("location", "/approval/approvalList");
		} else {
			model.addObject("msg", "지출결의서 등록 실패");
			model.addObject("location", "/");
		}
		model.addObject("action", "expenseReport_insert");
		model.setViewName("modal/msg");

		return model;
	}

	// 지출결의서 수신
	@RequestMapping("/expenseReportView")
	public ModelAndView expenseReportView(ModelAndView model, HttpServletRequest request, ApprovalVO vo) {
		
		MyBatisDAO mapper = sqlsession.getMapper(MyBatisDAO.class);
		int appNo = vo.getAppNo();
		vo = mapper.selectExpenseReportListDetail(appNo);

		model.addObject("signImg", vo.getAppCheckProgress().equals("결재반려") ? "canceled.png" : "approved.png");
		model.addObject("approval", vo);
		model.addObject("enter", "\r\n");
		model.setViewName("/approval/expenseReportView");

		return model;
	}

	// 수신참조자 모달 내 멤버 리스트 불러오기 (leaveApplication)
	@ResponseBody
	@RequestMapping(value = "/leaveApplication", method = { RequestMethod.GET })
	public ModelAndView leaveApplication (HttpServletRequest request, EmpVO empVO, ModelAndView model) {
		
		HttpSession session = request.getSession();
		MyBatisDAO mapper = sqlsession.getMapper(MyBatisDAO.class);

		EmpVO empvo = (EmpVO) session.getAttribute("EmpVO");
		List<EmpVO> empList = mapper.selectMemberAllForApproval(empvo);

		model.addObject("empList", empList);
		model.setViewName("approval/leaveApplication");

		return model;
	}

	// 수신참조자 모달 내 멤버 리스트 불러오기 (expenseReport)
	@ResponseBody
	@RequestMapping(value = "/expenseReport", method = { RequestMethod.GET })
	public ModelAndView expenseReport(HttpServletRequest request, ModelAndView model, EmpVO empVO) {
		
		HttpSession session = request.getSession();
		MyBatisDAO mapper = sqlsession.getMapper(MyBatisDAO.class);

		EmpVO empvo = (EmpVO) session.getAttribute("EmpVO");
		List<EmpVO> empList = mapper.selectMemberAllForApproval(empvo);

		model.addObject("empList", empList);
		model.setViewName("approval/expenseReport");

		return model;
	}

	// 수신참조자 모달 내 멤버 리스트 불러오기 (letterOfApproval)
	@ResponseBody
	@RequestMapping(value = "/letterOfApproval", method = { RequestMethod.GET })
	public ModelAndView letterOfApproval(HttpServletRequest request, ModelAndView model, EmpVO empvo) {
		HttpSession session = request.getSession();
		MyBatisDAO mapper = sqlsession.getMapper(MyBatisDAO.class);

		empvo = (EmpVO) session.getAttribute("EmpVO");

		Date date = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyy년 MM월 dd일");
		String today = format.format(date);
		model.addObject("serverTime", today);

		List<EmpVO> empList = null;
		empList = mapper.selectMemberAllForApproval(empvo);

		model.addObject("empList", empList);
		model.setViewName("approval/letterOfApproval");

		return model;
	}

	// 결재 사원 검색
	@ResponseBody
	@GetMapping(value = "/searchEmployee", produces = "application/json; charset=UTF-8")
	public List<EmpVO> getMemberList(@RequestParam(required = false) String searchName){
		MyBatisDAO mapper = sqlsession.getMapper(MyBatisDAO.class);
		return mapper.selectMemberByName(searchName);
	}
	
	// 결재 승인
	@ResponseBody
	@RequestMapping("/loaApproved1")
	public int loaApproved1(HttpServletRequest request, ApprovalVO vo) {

		MyBatisDAO mapper = sqlsession.getMapper(MyBatisDAO.class);
		int appNo = vo.getAppNo();

		return mapper.approved1(appNo);
	}
	
	@ResponseBody
	@RequestMapping("/loaApproved2")
	public int loaApproved2(HttpServletRequest request, ApprovalVO vo) {
		
		MyBatisDAO mapper = sqlsession.getMapper(MyBatisDAO.class);
		int appNo = vo.getAppNo();

		return mapper.approved2(appNo);
	}
	
	@ResponseBody
	@RequestMapping("/loaApproved3")
	public int loaApproved3(HttpServletRequest request, ApprovalVO vo) {

		MyBatisDAO mapper = sqlsession.getMapper(MyBatisDAO.class);
		int appNo = vo.getAppNo();

		return mapper.approved3(appNo);
	}

	// 결재 반려
	@ResponseBody
	@RequestMapping("/appcanceled1")
	public int loacanceled1(HttpServletRequest request, ApprovalVO vo) {

		MyBatisDAO mapper = sqlsession.getMapper(MyBatisDAO.class);
		return mapper.canceled1(vo);
	}
	@ResponseBody
	@RequestMapping("/appcanceled2")
	public int loacanceled2(HttpServletRequest request, ApprovalVO vo) {
		
		MyBatisDAO mapper = sqlsession.getMapper(MyBatisDAO.class);
		return mapper.canceled2(vo);
	}
	@ResponseBody
	@RequestMapping("/appcanceled3")
	public int loacanceled3(HttpServletRequest request, ApprovalVO vo) {
		
		MyBatisDAO mapper = sqlsession.getMapper(MyBatisDAO.class);
		return mapper.canceled3(vo);
	}

}
