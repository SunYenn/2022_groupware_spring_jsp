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
                    <li>${BoardVO.idx}번 글</li>
                </ul>
            </div>
            <!-- =================================contents================================================= -->
            <fmt:requestEncoding value="UTF-8"/>
            <c:set var="vo" value="${BoardVO}"></c:set>
            
        	<c:set var="content" value="${fn:replace(vo.content, '<', '&lt;') }"></c:set>
			<c:set var="content" value="${fn:replace(content, '>', '&gt;') }"></c:set>
			<c:set var="content" value="${fn:replace(content, enter, '<br/>') }"></c:set>			
			
            <div class="content_view">
	         	<h1 class="board_content_view_title">${vo.title}</h1>
	         	<p class="content_writer">${vo.name}&lpar;${vo.deptname}&rpar;</p>
				<div class="board_content_view_undertitle">
					<p class="board_content_view_date" ><fmt:formatDate value="${vo.writedate}" pattern = "yyyy-MM-dd aa h시 mm분"/></p>
					<img src="${path}/images/thums.png" alt="thums" class="thums">
					<p>${vo.hit}</p>
	         	</div>
				<hr/>		
				<div style="padding: 2px 10px; height: 50%">	
					<p>${content}</p>
				</div>
         		<c:if test="${vo.name == EmpVO.name}">
					<div class="delORupdate">
	                	<input type="button" value="수정" onclick="location.href='board_update?&idx=${vo.idx}&currentPage=${currentPage}'"/>
	                	<input type="button" value="삭제" onclick="location.href='board_delete?idx=${vo.idx}&currentPage=${currentPage}&category=공지사항'"/>
	            	</div>
	            </c:if>
                <hr/>
				<div style="float:right;">
					<input type="button" value="목록" onclick="location.href='board_list?currentPage=${currentPage}&category=공지사항'"/>
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