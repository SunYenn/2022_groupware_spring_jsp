<%@page import="com.tjoeun.vo.BoardVO"%>
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
                    <li><a href="myinfo_view">마이페이지</a>&#62;</li>
                    <li><a href="#">내가 쓴 글</a></li>
                </ul>
            </div>
            <!-- =================================contents================================================= -->
            <fmt:requestEncoding value="UTF-8"/>
            <c:set var="vo" value="${BoardVO}"></c:set>
            
        	<c:set var="content" value="${fn:replace(vo.content, '<', '&lt;') }"></c:set>
			<c:set var="content" value="${fn:replace(vo.content, '>', '&gt;') }"></c:set>
			<c:set var="content" value="${fn:replace(vo.content, enter, '<br/>') }"></c:set>			
			
			<div class="content_view">
										
	         	<h1 class="board_content_view_title">${vo.title}</h1>
	         	<div class="board_content_view_undertitle">
					<p class="board_content_view_date" ><fmt:formatDate value="${vo.writedate}" pattern = "yyyy-MM-dd aa h시 mm분"/></p>
					<img src="${path}/images/thums.png" alt="thums" class="thums">
					<p>${vo.hit}</p>
	         	</div>
				<hr/>	
				<div style="padding: 2px 10px; height: 70%">	
					<div style="height: 100%">
						<div style="height : 95%">
							<p>${content}</p>
						</div>
						<c:if test="${vo.attachedfile != null}">
							<div class="attach">
								<img alt="" src="${path}/images/clip.png" width="15x" style="margin: 4px 1px">
								<a href="${path}/Download?filename=${vo.realfilename}">${vo.attachedfile}</a>
							</div>
						</c:if>
					</div>
				</div>
				<br/>
				<div style="text-align: right;">
					<c:if test="${vo.name == EmpVO.name}">
	                	<input type="button" value="삭제" onclick="location.href='${path}/board/board_delete?idx=${vo.idx}&currentPage=${currentPage}&category=내가쓴글'"/>
	                </c:if>
	            </div>
                <hr/>
                
                <div style="float:right;">
					<input type="button" value="목록" onclick="history.back()"/>
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