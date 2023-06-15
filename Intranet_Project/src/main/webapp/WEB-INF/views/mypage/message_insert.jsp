<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="../includes/head.jsp" %>
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
					<li><a href="${path}/mypage/myinfo_view">마이페이지</a>&#62;</li>
					<li><a href="${path}/mypage/move_message_view">쪽지함</a>&#62;</li>
					<li><a href="#">쪽지 쓰기</a></li>
				</ul>
			</div>
			<!-- =================================contents================================================= -->
			<div class="content">
				<div style="height: 610px">
                	<form id="frm" action="${path}/mypage/transMessage" method="post" enctype="multipart/form-data" onsubmit="return check_form()">
	                	
	                	<input type="hidden" name="transeempno" value="${EmpVO.empno}" />
                		<input type="hidden" name="emplist" />
	                	
	                	<table class="msginsert">
	                
	                		<tr height="50px">
	                			<th colspan="2" class="thTitle">쪽지 보내기</th>
	                		</tr>
							<tr>
								<th width="100px">받는 사람</th>
								<td class="msg_td">
									<div class="msg_receive">
										<div class="receive_list"></div>
										<input name="empsearch" type="text" autocomplete="off" onkeyup="searchemp()"/>
										<button name="transemebtn" type="button" onclick="transeme('${EmpVO.name}(${EmpVO.empno})')">내게 쓰기</button>
									</div>
									<div class="msg_dropdown">

									</div>
								</td>
							</tr>
							<tr>
								<th>제목</th>
								<td class="msg_td"><input name="title" type="text" /></td>
							</tr>
							<tr>
								<th>첨부파일</th>
								<td class="msg_attach">
									<span id="selectfile"></span>
									<label for="filename">파일 선택<input id="filename" type="file" name="filename" /></label>
								</td>
							</tr>
							<tr>
								<th colspan="2"><textarea name="content" rows="13"></textarea></th>
							</tr>

		                </table>
		                
		                <div class="msginsert" align="right">
		                	<input type="reset" value="다시쓰기"/>
							<input type="submit" value="전송" />
		                </div>
		                
					</form>
                </div>
				<div class="msginsert" align="right">
					<input type="button" value="돌아가기" onclick="location.href='${path}/mypage/move_message_view'"/>
                </div>
			
			</div>
			<!-- =================================contents================================================= -->
		
		</div>
		<!-- main -->
		
		<!-- right -->
		<%@ include file="../includes/con_right.jsp" %>
		
	</div>
	<!-- contents end -->
	
	<!-- footer -->
	<%@ include file="../includes/footer.jsp" %>

	<!-- 일정 등록 Modal -->
	<%@ include file="../modal/insertTodoModal.jsp" %>

</body>

</html>