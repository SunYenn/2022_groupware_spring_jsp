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
                    <li>글 수정</li>
                </ul>
            </div>
            <!-- =================================contents================================================= -->
            <fmt:requestEncoding value="UTF-8"/>
            <c:set var="vo" value="${BoardVO}"></c:set>
            
        	<c:set var="content" value="${fn:replace(vo.content, '<', '&lt;') }"></c:set>
			<c:set var="content" value="${fn:replace(content, '>', '&gt;') }"></c:set>	
			
            <div class="content_view">
	         	<h1 class="board_content_view_title">${vo.title}</h1>
	         	<p class="content_writer">${vo.name}&lpar;${vo.deptname}&rpar;</p>
	         	<div class="board_content_view_undertitle">
					<p class="board_content_view_date" ><fmt:formatDate value="${vo.writedate}" pattern = "yyyy-MM-dd aa h시 mm분"/></p>
					<img class="thums" src="${path}/images/thums.png" alt="thums">
					<p>${vo.hit}</p>
				</div>
				<hr/>		
				<form action="board_updateOK?idx=${vo.idx}&currentPage=${currentPage}&category=공지사항" method="post">					
					<textarea id="content" name="content" style="resize: none;" rows="15" >${content}</textarea>
					<br/>
	                <div align="right">
		                <input type="reset" value="다시쓰기"/>
						<input type="submit" value="저장"/>
					</div>
	                <hr/>
	                <div align="right">
	                	<input type="button" value="돌아가기" onclick="history.back()"/>
	                </div>
	            </form>		  
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