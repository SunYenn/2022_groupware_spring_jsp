<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="../includes/head.jsp" %>
	<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.css">
	<script src="//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.js"></script>
    <script src="${path}/js/meetroom.js" defer="defer"></script>
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
                    <li><a href="meetroom_main">회의실 예약</a>&#62;</li>
                    <li><a href="meetroom_select?year=${meetdata.year}&month=${meetdata.month}&date=${meetdata.date}">${meetdata.year}/${meetdata.month}/${meetdata.date}</a>&#62;</li>
                    <li><a href="#">${mvo.roomnum}호</a></li>
                </ul>
            </div>
            <!-- =================================contents================================================= -->
            <div class="select_room">
            
				<div class="show_select_room">
					<table>
	            		<thead>
	            			<tr><th>${mvo.roomnum}호</th></tr>
	            		</thead>
	            		<tbody>
	            			<c:forEach var="room" items="${roomlist.meetRmList}">
	            				<tr>
	            				
	            					<c:if test="${room.deptno == 500}"><c:set var="dname" value="경영지원부"></c:set></c:if>
									<c:if test="${room.deptno == 400}"><c:set var="dname" value="IT부"></c:set></c:if>
									<c:if test="${room.deptno == 300}"><c:set var="dname" value="상품개발부"></c:set></c:if>
									<c:if test="${room.deptno == 200}"><c:set var="dname" value="마케팅부"></c:set></c:if>
									<c:if test="${room.deptno == 100}"><c:set var="dname" value="영업부"></c:set></c:if>
	            					<td style="border-bottom: 2px solid #D8D2CB; height: 55px">
										<div style="display: flex;">
											<div style="line-height: 50px; width: 55%">${dname}</div>
											<div style="line-height: 25px; width: 45%">
												<div class="setStime">${room.starttime}</div>
												<div class="setEtime">${room.endtime}</div>
											</div>
										</div>
									</td>
	            				</tr>
	            			</c:forEach>	
	            			<c:forEach begin="1" end="${5 - roomlist.meetRmList.size()}">	
	            				<tr><td style="border-bottom: 2px solid #D8D2CB; height: 55px"></td></tr>
	            			</c:forEach>
	            		</tbody>
	            		<tfoot>
	            			<tr>
	            				<td>
	            					<button onclick="location.href=href='meetroom_select?year=${meetdata.year}&month=${meetdata.month}&date=${meetdata.date}'">돌아가기</button>
	            				</td>
	            			</tr>
	            		</tfoot>
	            	</table>
				</div>
				
				<div class="form_room">
					<form action="meetroom_confirm" method="post" onsubmit="return checkTime()">
						<table>
							<thead>
								<tr><th colspan="2">회의실 예약 폼</th></tr>
							</thead>
							<tbody>				
								<tr>
									<th>시작시간</th>
									<td><input id="starttime" type="text" name="starttime" autocomplete="off" required/></td>
								</tr>
								<tr>
									<th>종료시간</th>
									<td><input id="endtime" type="text" name="endtime" autocomplete="off" required/></td>
								</tr>
							</tbody>
							
							<input type="hidden" name="size" value="${roomlist.meetRmList.size()}">
							<input type="hidden" name="year" value="${meetdata.year}">
							<input type="hidden" name="month" value="${meetdata.month}">
							<input type="hidden" name="date" value="${meetdata.date}">
							<input type="hidden" name="roomnum" value="${mvo.roomnum}">
							<input type="hidden" name="deptno" value="${EmpVO.deptno}">
							
							<tfoot>
								<tr>
									<td colspan="2">
										<input type="reset" value="다시쓰기"/>
										<input type="submit" value="예약하기"/>
									</td>
								</tr>
							</tfoot>					
						</table>
					</form>
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