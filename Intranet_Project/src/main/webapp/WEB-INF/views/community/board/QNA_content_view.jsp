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
                    <li><a href="board_list?category=자유 게시판">게시판</a>&#62;</li>
                    <li><a href="board_list?category=QNA">Q&A</a>&#62;</li>
                    <li>${BoardVO.idx}번 질문</li>
                </ul>
            </div>
            <!-- =================================contents================================================= -->
            <fmt:requestEncoding value="UTF-8"/>
            <c:set var="vo" value="${BoardVO}"></c:set>
            
        	<c:set var="content" value="${fn:replace(vo.content, '<', '&lt;') }"></c:set>
			<c:set var="content" value="${fn:replace(content, '>', '&gt;') }"></c:set>
			<c:set var="content" value="${fn:replace(content, enter, '<br/>') }"></c:set>		
			
            <div class="content_view">
            	<!-- 질문 -->
	         	<h1 class="board_content_view_title">Q. ${vo.title}</h1>
				<p class="content_writer">${vo.name}&lpar;${vo.deptname}&rpar;</p>
				<div class="board_content_view_undertitle">
					<p class="board_content_view_date" ><fmt:formatDate value="${vo.writedate}" pattern = "yyyy-MM-dd aa h시 mm분"/></p>
         		</div>
				<hr/>	
				<div class="qNaQ">	
					<p>${content}</p>
				</div>
				<div class="delORupdateQNA">
	               	<c:if test="${vo.name == EmpVO.name}">
	                	<input type="button" value="삭제" onclick="location.href='board_delete?idx=${vo.idx}&currentPage=${currentPage}&category=QNA'"/>
	                </c:if>
	            </div>
		        <!-- 질문 -->
                <hr/>
                <!-- 관리자 답변 달기 -->
                <c:if test="${EmpVO.permission == 'YES' && commentList.boardList.size() == 0}">
              		<div style="height: 43%">
	                	<table style="width: 100%">
		                	<form action="answer_insert" method="post">
		                		<input type="hidden" id="category" name="category" value="QNA"> 
								<tr>
									<th>답변등록</th>
									<td></td>
								</tr>
								<tr> 
									<th>제목</th>
									<td><input id="title" type="text" name="title"/></td>
								</tr>
								<tr>
									<th>내용</th>
									<td><textarea id="content" name="content" rows="7"></textarea></td>
								</tr>
								<tr>
									<td class="qNaBtn" colspan="2" align="right">
										<input type="reset" value="다시쓰기"/>
										<input type="submit" value="저장하기"/>
									</td>					
								</tr>
								<input id="empno" type="hidden" name="empno" value="${EmpVO.empno}"/>
								<input id="deptno" type="hidden" name="gup" value="${vo.idx}"/>
							</form>
		                </table>
		            </div>
					<hr/>
                </c:if>
				
				<!-- 답변 -->
				<c:if test="${commentList.boardList.size() != 0}">		
					<c:forEach var="co" items="${commentList.boardList}">
						<c:set var="cocontent" value="${fn:replace(co.content, '<', '&lt;') }"></c:set>
						<c:set var="cocontent" value="${fn:replace(cocontent, '>', '&gt;') }"></c:set>
						<c:set var="cocontent" value="${fn:replace(cocontent, enter, '<br/>') }"></c:set>
		            	<h1 class="board_content_view_title">A. ${co.title}</h1>
		            	<p class="content_writer">${co.name}&lpar;${co.deptname}&rpar;</p>
						<div class="board_content_view_undertitle">
							<p class="board_content_view_date" ><fmt:formatDate value="${vo.writedate}" pattern = "yyyy-MM-dd aa h시 mm분"/></p>
	         			</div>
						<hr/>	
						<div class="qNaQ">	
							<p>${cocontent}</p>
						</div>
						<div class="delORupdateQNA">
			               	<c:if test="${co.name == EmpVO.name}">
			                	<input type="button" value="삭제" onclick="location.href='board_delete?idx=${co.idx}&currentPage=${currentPage}&category=QNA'"/>
			                </c:if>
			            </div>
	                	<hr/>
			        </c:forEach>
				</c:if>
				<!-- 답변 -->
				<div align="right">
					<input type="button" value="목록" onclick="location.href='board_list?currentPage=${currentPage}&category=QNA'"/>
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