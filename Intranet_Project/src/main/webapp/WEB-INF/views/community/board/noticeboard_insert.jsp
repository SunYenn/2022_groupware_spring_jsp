<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../includes/head.jsp" %>
</head>

<body>
	<!-- haeder -->
	<%@ include file="../../includes/header.jsp" %>

	<!-- contents start -->
	<div class="tjcontainer">
	
		<!-- menu list -->	
		<%@ include file="../../includes/menu_bar.jsp" %>
		
		<!-- main -->
        <div class="con_middle">
            <div class="nav">
                <ul>
                    <li><a href="${path}/main"><img src="${path}/images/home.png" alt="home" width="18px"></a>&#62;</li>
                    <li><a href="move_board_list?category=공지사항">게시판</a>&#62;</li>
                    <li><a href="move_board_list?category=공지사항">공지사항</a>&#62;</li>
                    <li>글 작성</li>
                </ul>
            </div>
			<!-- =================================contents================================================= -->
			<div class="content">
				<div style="height: 610px">
					<form action="board_insert" method="post">
						<table style="width: 900px; margin: auto;">
							<tr height="50px">
								<th colspan="2" class="thTitle">공지사항 글쓰기</th>
							</tr>
	
							<tr>
								<th>제목</th>
								<td><input id="title" type="text" name="title"/></td>
							</tr>
							<tr>
								<th>내용</th>
								<td><textarea id="content" name="content" rows="20"></textarea></td>
							</tr>
							<tr>
								<td colspan="2" align="right">
									<input type="reset" value="다시쓰기" /> 
									<input type="submit" value="저장하기" />
								</td>
							</tr>
	
							<input id="empno" type="hidden" name="empno" value="${EmpVO.empno}" /> 
							<input id="category" type="hidden" name="category" value="공지사항"/>
						</table>
					</form>
				</div>
				<div class="backBtn">
					<input type="button" value="돌아가기" onclick="history.back()" />
				</div>
			</div>
			<!-- =================================contents================================================= -->
		
		</div>
		<!-- main -->
		
		<!-- right -->
		<%@ include file="../../includes/con_right.jsp" %>
		
	</div>
	<!-- contents end -->
	
	<!-- footer -->
	<%@ include file="../../includes/footer.jsp" %>

	<!-- 일정 등록 Modal -->
	<%@ include file="../../modal/insertTodoModal.jsp" %>

</body>

</html>