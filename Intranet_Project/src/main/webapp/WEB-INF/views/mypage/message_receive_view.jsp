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
                    <li><a href="move_message_view">쪽지함</a>&#62;</li>
                    <li><a href="move_message_view">받은 쪽지함</a></li>
                </ul>
            </div>
            <!-- =================================contents================================================= -->
            <fmt:requestEncoding value="UTF-8"/>
            <c:set var="view" value="${MessageList.msList}"></c:set>
            <jsp:useBean id="date" class="java.util.Date"/>
			<fmt:formatDate value="${date}" pattern = "yyyy-MM-dd(E)" var = "today"/>
            <div class="content message">
            	<div>
            		<ul>
            			<li><a href="move_message_view" style="color: #398AB9">받은 쪽지함</a></li>
            			<li><a href="move_message_view?divs=send">보낸 쪽지함</a></li>
            			<li><a href="move_message_view?divs=trash">휴지통</a></li>
            		</ul>
            	</div>
                <div>
               		<form action="message_receive_view" method="post">
						<select name="searchcategory" style="width:100px;">
	                        <option>보낸사람</option>
	                        <option>제목</option>
                   		</select>
               			<input type="text" name="searchobj" style="width: 250px"/>
               			<input type="submit" value="검색" />
               		</form>
                </div> <hr>
                
                <!-- 반복문 -->
                <div class="message_list">
					<table style="width: 900px; margin: auto;"> 
 						<c:if test="${view.size() == 0 }">
							<tr><td align="center">받은 쪽지가 없습니다.</td></tr>
						</c:if>
						<c:if test="${view.size() != 0 }">
							<c:forEach var="meo" items="${view}">
								<fmt:formatDate value="${meo.writedate}" pattern = "yyyy-MM-dd(E)" var = "sdf1date"/>
								<fmt:formatDate value="${meo.writedate}" pattern = "a h:mm:ss" var = "sdf2date"/>
								
								<c:set var="title" value="${fn:replace(meo.title, '<', '&lt;') }"></c:set>
								<c:set var="title" value="${fn:replace(meo.title, '>', '&gt;') }"></c:set>
								<tr onclick="location.href='message_content_view?idx=${meo.idx}&currentPage=${MessageList.currentPage}&divs=receive'">
									<td>
										<div class="messageList">
											<div class="messageDelete">
												<!-- tr에 걸려있는 onclick 이벤트 적용 안되게 -->
												<button onclick="
													if(event.stopPropagation){
														event.stopPropagation();
													}
													event.cancelBubble=true; 
													location.href='message_service?idx=${meo.idx}&currentPage=${currentPage}&mode=2'
												">삭제</button>
											</div>

											<div>
												<a >${meo.title}</a>
												<c:if test="${meo.read == 'NO'}">
													<span><img src="${path}/images/new.png" style="width:30px;"></span>
												</c:if>
											</div>
											<div>
												<span class="underText">보낸사람 : ${meo.transename}(${meo.transeempno}) |
													<c:if test="${today == sdf1date}">${sdf2date}</c:if>
													<c:if test="${today != sdf1date}">${sdf1date}</c:if>
													<c:if test="${meo.attachedfile != null}">
														<img src="${path}/images/clip.png" style="width:12px; margin-top: 5px;">
													</c:if>
												</span>
											</div>
										</div>
									</td>
								</tr>
							</c:forEach>
						</c:if>
					</table>
				</div>
				
				<div>
					<input type="button" value="쪽지 쓰기" onclick="location.href='message_insert'"/>
				</div>
                
                <!-- 페이지 이동 -->
                <table class="pagebutton" align="center" border="0" cellpadding="0" cellspacing="0" height="30">
					<tr>		
						<c:if test="${MessageList.currentPage > 1 }">
							<td><button type="button" title="첫 페이지로" onclick="location.href='?currentPage=1 '"> 처음 </button></td>
						</c:if>
						<c:if test="${MessageList.currentPage <= 1 }">
							<td><button type="button" title="이미 첫 페이지입니다" disabled="disabled"> 처음 </button></td>
						</c:if>
						<c:if test="${MessageList.startPage > 1 }">
							<td><button type="button" title="10페이지 이동" onclick="location.href='?currentPage=${MessageList.currentPage - 10} '"> << </button></td>
						</c:if>
						<c:if test="${MessageList.startPage <= 1 }">
							<td><button type="button" title="이미 첫 페이지입니다" disabled="disabled"> << </button></td>
						</c:if>
						<c:if test="${MessageList.currentPage > 1}">
							<td><button type="button" title="전 페이지로" onclick="location.href='?currentPage=${MessageList.currentPage - 1} '"> < </button></td>
						</c:if>
						<c:if test="${MessageList.currentPage <= 1}">
							<td><button type="button" title="이미 전 페이지 입니다." disabled="disabled"> < </button></td>
						</c:if>
			 			
						<c:forEach var="i" begin="${MessageList.startPage}" end="${MessageList.endPage}">
							<c:if test="${i == MessageList.currentPage}">
								<td width='30' align='center' style='background: #D8D2CB; border:1px;'>${i}</td>
							</c:if>
							<c:if test="${i != MessageList.currentPage}">
 								<td class='tda' width='30' align='center'><a href='?currentPage=${i}'>${i}</a></td>
							</c:if>
						</c:forEach>	
						
						<c:if test="${MessageList.currentPage < MessageList.totalPage}">
							<td><button type="button" title="다음 페이지로" onclick="location.href='?currentPage=${MessageList.currentPage+1} '"> > </button></td>
						</c:if>
						<c:if test="${MessageList.currentPage >= MessageList.totalPage}">
							<td><button type="button" title="이미 마지막 페이지 입니다." disabled="disabled"> > </button></td>
						</c:if>
						<c:if test="${MessageList.endPage < MessageList.totalPage}">
							<td><button type="button" title="10페이지 이동" onclick="location.href='?currentPage=${MessageList.currentPage + 10} '"> >> </button></td>
						</c:if>
						<c:if test="${MessageList.endPage >= MessageList.totalPage}">
							<td><button type="button" title="이미 마지막 페이지입니다" disabled="disabled"> >> </button></td>
						</c:if>
						<c:if test="${MessageList.currentPage < MessageList.totalPage}">
							<td><button type="button" title="마지막 페이지로" onclick="location.href='?currentPage=${MessageList.totalPage} '"> 끝 </button></td>
						</c:if>
						<c:if test="${MessageList.currentPage >= MessageList.totalPage}">
							<td><button type="button" title="이미 마지막 페이지입니다" disabled="disabled"> 끝 </button></td>
						</c:if>
										
					</tr>
					
				</table>
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