<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="../includes/head.jsp" %>
	
	<script src="${path}/js/manager.js" defer="defer"></script>
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
                    <li><a href="move_attend_list">근태관리</a>&#62;</li>
                    <li><a href="#">급여명세서</a></li>
                </ul>
            </div>
            <!-- =================================contents================================================= -->
            <div class="content_view">
            	
            	<!-- 검색 -->
            	<div align="right">
               		<form action="payslip" method="post">
                   		<select name="year" style="width: 80px">
                   			<c:forEach begin="1" end="22" var="i"><option>${2024 - i}</option></c:forEach>
                   		</select>
                   		<select name="month" style="width: 50px">
                   			<c:forEach begin="1" end="12" var="i"><option>${i}</option></c:forEach>
                   		</select>
               			<input type="submit" value="검색" />
               		</form>
                </div> <hr>

				<div class="payslip">
					<c:if test="${payslip == null}">
						<h1>저장된 명세서가 없습니다.</h1>
					</c:if>
				
					<c:if test="${payslip != null}">
						<table width="100%"> 
							<thead>
								<tr>
									<td width="185px">성명 : ${EmpVO.name}</td>
									<td width="240px">부서 : ${EmpVO.deptname}</td>
									<td width="185px">직책 : ${EmpVO.position}</td>
									<td width="240px" align="right">지급일 : ${year}-${month}-10</td>
								</tr>
							</thead>
							<tbody>
								<tr class="back">
									<th>지급 항목</th>
									<th>지급액</th>
									<th>공제 항목</th>
									<th>공제액</th>
								</tr>
								<tr>
									<td>기본급</td>
									<td><fmt:formatNumber value="${payslip.basepay}" pattern="#,###"/></td>
									<td>소득세</td>
									<td><fmt:formatNumber value="${payslip.incometax}" pattern="#,###"/></td>
								</tr>
								<tr>
									<td>직책 수당</td>
									<td><fmt:formatNumber value="${payslip.posallow}" pattern="#,###"/></td>
									<td>지방세</td>
									<td><fmt:formatNumber value="${payslip.localtax}" pattern="#,###"/></td>
								</tr>
								<tr>
									<td>근속 수당</td>
									<td><fmt:formatNumber value="${payslip.annualpay}" pattern="#,###"/></td>
									<td>국민연금</td>
									<td><fmt:formatNumber value="${payslip.nationpen}" pattern="#,###"/></td>
								</tr>
								<tr>
									<td>연장 수당</td>
									<td><fmt:formatNumber value="${payslip.extpay}" pattern="#,###"/></td>
									<td>고용보험</td>
									<td><fmt:formatNumber value="${payslip.empinsure}" pattern="#,###"/></td>
								</tr>
								<tr>
									<td>야간 수당</td>
									<td><fmt:formatNumber value="${payslip.nightpay}" pattern="#,###"/></td>
									<td>건강보험</td>
									<td><fmt:formatNumber value="${payslip.healthinsure}" pattern="#,###"/></td>
								</tr>
								<tr>
									<td>주말 수당</td>
									<td><fmt:formatNumber value="${payslip.holypay}" pattern="#,###"/></td>
									<td>기타 공제</td>
									<td><fmt:formatNumber value="${payslip.etcdeduce}" pattern="#,###"/></td>
								</tr>
								<tr>
									<td>상여금</td>
									<td><fmt:formatNumber value="${payslip.bonus}" pattern="#,###"/></td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<td>기타</td>
									<td><fmt:formatNumber value="${payslip.etcpay}" pattern="#,###"/></td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<td>식대</td>
									<td><fmt:formatNumber value="${payslip.foodfee}" pattern="#,###"/></td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<td>교통비</td>
									<td><fmt:formatNumber value="${payslip.transefee}" pattern="#,###"/></td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<td></td>
									<td></td>
									<th class="back">공제 합계</th>
									<td><fmt:formatNumber value="${deducesum}" pattern="#,###"/></td>
								</tr>
								<tr>
									<th class="back">급여 합계</th>
									<td><fmt:formatNumber value="${paysum}" pattern="#,###"/></td>
									<th class="back">수령액</th>
									<td><fmt:formatNumber value="${paysum - deducesum}" pattern="#,###"/></td>
								</tr>
							</tbody>
						</table>
					</c:if>
				</div><hr>
				
				<c:if test="${payslip != null}">
					<div align="right">
						<button onclick="location.href='${path}/attend/payslipDown?year=${year}&month=${month}&empno=${EmpVO.empno}'">다운로드</button>
					</div>
				</c:if>
     
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
	
	<!-- 쪽지 전송 Modal -->
	<%@ include file="../modal/pmModal.jsp" %>

</body>

</html>