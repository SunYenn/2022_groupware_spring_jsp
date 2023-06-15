<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

		<div class="con_left">
			<ul class="menu_box" style="height: 650px;">
				<li class="menu_under">
					<div class="menu">
						<span>커뮤니티</span>
						<!-- <img src="images/menu_arrow.png" alt="arrow"> -->
					</div>
					<ul class="menuSub">
						<li>
					    	<span class="menu2">
								<a>게시판</a>
							</span>
							<ul class="menuSub2">
				                <li><a href="${path}/community/move_board_list?category=자유 게시판">-자유게시판</a></li>
								<li><a href="${path}/community/move_board_list?category=공지사항">-공지사항</a></li>
								<li><a href="${path}/community/move_board_list?category=자료실">-자료실</a></li>
								<li><a href="${path}/community/move_board_list?category=QNA">-Q&A</a></li>
							</ul>		 
					    </li>	
						<li><a href="${path}/community/groupchart_main">조직도</a></li>
						<li><a href="${path}/community/meetroom_main">회의실</a></li>
						<li><a href="${path}/community/chat.action">라이브 채팅</a></li>
					</ul>
				</li>
				<li class="menu_under">
					<div class="menu">
						<span>전자결재</span>
						<!-- <img src="images/menu_arrow.png" alt="arrow"> -->
					</div>
					<ul class="menuSub">
						<li><a href="${path}/approval/approvalMain">전자결재 홈</a></li>
					    <li>
					    	<span class="menu2">
								<a>양식작성</a>
							</span>
							<ul class="menuSub2">
				                <li><a href="${path}/approval/letterOfApproval">-품의서</a></li>
				                <li><a href="${path}/approval/expenseReport">-지출결의서</a></li>
				                <li><a href="${path}/approval/leaveApplication">-휴가신청서</a></li>
							</ul>		 
					    </li>				    
					    <li><a href="${path}/approval/move_approval_List">결재리스트</a></li>		
					    <li>
					    	<span class="menu2">
								<a>보관함</a>
							</span>
							<ul class="menuSub2">
					             <li><a href="${path}/approval/move_approval_List?approvalStatus=결재대기">-결재대기</a></li>
					             <li><a href="${path}/approval/move_approval_List?approvalStatus=결재중">-결재중</a></li>
					             <li><a href="${path}/approval/move_approval_List?approvalStatus=결재완료">-결재완료</a></li>
					             <li><a href="${path}/approval/move_approval_List?approvalStatus=결재반려">-결재반려</a></li>
							</ul>		 
					    </li>	 		    			
					</ul>
				</li>
				<li class="menu_under">
					<div class="menu">
						<span>근태관리</span>
					</div>
					<ul class="menuSub">
						<li><a href="${path}/attend/move_attend_list">개인 근태 조회</a></li>
						<li><a href="${path}/attend/move_left_dayoff_list">개인 연차 현황</a></li>
						<li><a href="${path}/attend/payslip">급여명세서</a></li>
						<%-- <li><a href="${path}/attend/perform_evalu">인사고과</a></li> --%>
					</ul>
				</li>
				<li class="menu_under">
					<div class="menu">
						<span>마이페이지</span>
					</div>
					<ul class="menuSub">
						<li><a href="${path}/mypage/myinfo_view">내정보</a></li>
						<li><a href="${path}/mypage/mywrite_view">내가 쓴 글</a></li>
						<li><a href="${path}/mypage/move_message_view">쪽지함<c:if test="${noRead!=0}"><span style="font-size:12px;">(${noRead})</span></c:if></a>
						<li><a href="${path}/mypage/todo_view">오늘 할 일</a></li>
					</ul>
				</li>
	
			</ul>
	
			<c:if test="${EmpVO.permission eq 'YES'}">
			<div align="center">
				<button onclick="location.href='${path}/manager/Manager_Main'">관리자</button>
			</div>
			</c:if>
		</div>
