<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="../includes/head.jsp" %>
    <script src="${path}/js/chat.js" defer="defer"></script>
</head>

<body>
	<!-- haeder -->
	<%@ include file="../includes/header.jsp" %>

	<!-- contents start -->
	<div class="tjcontainer">
	
		<!-- menu list -->	
		<%@ include file="../includes/menu_bar.jsp" %>
		
		<!-- main -->
        <div class="con_middle">
            <div class="nav">
                <ul>
                    <li><a href="${path}/main"><img src="${path}/images/home.png" alt="home" width="18px"></a>&#62;</li>
                    <li><a href="#">커뮤니티</a>&#62;</li>
                    <li><a href="chat.action">라이브 채팅</a></li>
                </ul>
            </div>
            
            <!-- =================================contents================================================= -->
			<div class="container">
				<h1 class="page-header">라이브 채팅</h1>
				
				<input type="hidden" name="user" id="user" value="${EmpVO.name}" disabled="disabled">
				<input type="hidden" id="profile" value="${EmpVO.realprofile}" disabled="disabled">
				
				<div class="chating">
					<div id="list" class="chat_list"></div>
					<div class="chat_foot">
						<input type="text" id="msg" onkeyup="this.value=this.value.replace(/[#]/,'')"
							placeholder="대화 내용을 입력하세요." class="form-control" disabled>
						<button type="button" class="btn btn-default" id="btnConnect">연결</button>
						<button type="button" class="btn btn-default" id="btnDisconnect" disabled>종료</button>
					</div>
				</div>
			</div>
			<!-- =================================contents================================================= -->
			
		<!-- main -->
		</div>
		
		<!-- right -->
		<%@ include file="../includes/con_right.jsp" %>
		
	<!-- contents end -->
	</div>
	
	<!-- footer -->
	<%@ include file="../includes/footer.jsp" %>

	<!-- 일정 등록 Modal -->
	<%@ include file="../modal/insertTodoModal.jsp" %>

</body>
</html>