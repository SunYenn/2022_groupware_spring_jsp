<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="../includes/head.jsp"%>
<link rel="stylesheet" href="${path}/css/approvalStyle.css">
<link rel="stylesheet" href="${path}/css/approval.css">
<script src="${path}/js/approval.js" defer="defer"></script>
</head>

<body>
	<!-- header -->
	<%@ include file="../includes/header.jsp"%>
	<!-- contents start -->
	<div class="tjcontainer">
		<!-- menu list -->
		<%@ include file="../includes/menu_bar.jsp"%>

		<!-- main -->
		<div class="con_middle">
			<div class="nav">
				<ul>
					<li><a href="${path}/approval/approvalMain"><img src="${path}/images/home.png" width="18px"></a>&#62;</li>
					<li><a href="${path}/approval/approvalMain">전자결재</a>&#62;</li>
					<li><a href="${path}/approval/approvalList?searchcategory=category&searchobj=휴가신청서">휴가신청서 수신</a></li>
				</ul>
			</div>
			
			<fmt:requestEncoding value="UTF-8" />
			<c:set var="view" value="${approval}"/>
			<c:if test="${view.deptName == 500}"><c:set var="dname" value="경영지원부"></c:set></c:if>
			<c:if test="${view.deptName == 400}"><c:set var="dname" value="IT부"></c:set></c:if>
			<c:if test="${view.deptName == 300}"><c:set var="dname" value="상품개발부"></c:set></c:if>
			<c:if test="${view.deptName == 200}"><c:set var="dname" value="마케팅부"></c:set></c:if>
			<c:if test="${view.deptName == 100}"><c:set var="dname" value="영업부"></c:set></c:if>
											
			<div class="cash-form-section">
				<div class="cash-disbursement">
					<table>
						<thead>
							<tr>
								<td rowspan="3" colspan="4" class="appformtitle">휴 가 신 청 서</td>
								<td rowspan="3" >결 <br> 재</td>
								<td style="height: 30px; width: 100px;">최초승인자</td>
								<td style="width: 100px;">중간승인자</td>
								<td style="width: 100px;">최종승인자</td>
							</tr>
							<tr class="signImg">
								<c:choose>
									<c:when test="${approval.appPresent eq 'A'}">
										<td name="firstA" id="firstA">${approval.firstApprover}</td>
										<td name="interimA" id="interimA">${approval.interimApprover}</td>
										<td name="finalA" id="finalA">${approval.finalApprover}</td>
									</c:when>
									<c:when test="${approval.appPresent eq 'B'}">
										<td name="firstA" id="firstA">${approval.firstApprover}
											<img src="${path}/images/${signImg}" /></td>
										<td name="interimA" id="interimA">${approval.interimApprover}</td>
										<td name="finalA" id="finalA">${approval.finalApprover}</td>
									</c:when>
									<c:when test="${approval.appPresent eq 'C'}">
										<td name="firstA" id="firstA">${approval.firstApprover}
											<img src="${path}/images/approved.png" /></td>
										<td name="interimA" id="interimA">${approval.interimApprover}
											<img src="${path}/images/${signImg}" /></td>
										<td name="finalA" id="finalA">${approval.finalApprover}</td>
									</c:when>
									<c:when test="${approval.appPresent eq 'D'}">
										<td name="firstA" id="firstA">${approval.firstApprover}
											<img src="${path}/images/approved.png" /></td>
										<td name="interimA" id="interimA">${approval.interimApprover}
											<img src="${path}/images/approved.png" /></td>
										<td name="finalA" id="finalA">${approval.finalApprover}
											<img src="${path}/images/${signImg}" /></td>
									</c:when>
									<c:otherwise>
										<td name="firstA" id="firstA">${approval.firstApprover}</td>
										<td name="interimA" id="interimA">${approval.interimApprover}</td>
										<td name="finalA" id="finalA">${approval.finalApprover}</td>
									</c:otherwise>
								</c:choose>
							</tr>
							<tr class="singBtn">
								<c:choose>
									<c:when test="${EmpVO.empno eq approval.firstApprover && approval.appPresent eq 'A'}">
										<td><input type="button" id="Approver1" onclick="Approver1(this, ${approval.appNo})" value="결재서명" /></td>
										<td><input type="button" value="결재서명" disabled /></td>
										<td><input type="button" value="결재서명" disabled /></td>
									</c:when>
									<c:when test="${EmpVO.empno eq approval.interimApprover && approval.appPresent eq 'B' && approval.appCheckProgress ne '결재반려'}">
										<td><input type="button" value="결재서명" disabled /></td>
										<td><input type="button" id="Approver2" onclick="Approver2(this, ${approval.appNo})" value="결재서명" /></td>
										<td><input type="button" value="결재서명" disabled /></td>
									</c:when>
									<c:when test="${EmpVO.empno eq approval.finalApprover && approval.appPresent eq 'C' && approval.appCheckProgress ne '결재반려'}">
										<td><input type="button" value="결재서명" disabled /></td>
										<td><input type="button" value="결재서명" disabled /></td>
										<td><input type="button" id="Approver3" onclick="Approver3(this, ${approval.appNo})" value="결재서명" /></td>
									</c:when>
									<c:otherwise>
										<td><input type="button" value="결재서명" disabled /></td>
										<td><input type="button" value="결재서명" disabled /></td>
										<td><input type="button" value="결재서명" disabled /></td>
									</c:otherwise>
								</c:choose>
							</tr>
							<tr class="formrefer">
								<td width="120px"> 수신참조자 </td>
								<td colspan="7">
									<div>${approval.referList}</div>
								</td>
							</tr>
						</thead>
						<tbody></tbody>
						<tr class="writeinfo">
							<td colspan="8">
								<div>
									<p>성명</p>
									<p><input type="text" name="writeName" value="${approval.userName}" readonly /></p>
									<p>부서</p>
									<p><input type="text" value="${dname}" readonly></p>
									<p>성명</p>
									<p><input type="text" value="${approval.rank}" readonly></p>
								</div>
							</td>
						</tr>
						<tr class="bisang">
							<td colspan="3">비 상 연 락 망</td>
							<td colspan="5">${approval.appEmergncyCall}</td>
						</tr>
						<tr class="gigan">
							<td colspan="3">기 간</td>
							<td colspan="5">
								<fmt:formatDate value="${approval.leaveStart}" pattern="yyyy 년 MM 월 dd 일" />
								&nbsp;&nbsp; ~ &nbsp;&nbsp;
								<fmt:formatDate value="${approval.leaveFinish}" pattern="yyyy 년 MM 월 dd 일" />
							</td>
						</tr>
						<tr>
							<td height="40px">휴가 구분</td>
							<td colspan="7">${ approval.leaveClassify }</td>
						</tr>
						<tr class="contentarea">
							<td>세부사항</td>
							<td colspan="7">
								<div style="height: 120px;">${approval.leaveDetail}</div>
							</td>
						</tr>
						<tr>
							<td colspan="8" height="50px">위와 같이 휴가를 신청하오니 결재 바랍니다.</td>
						</tr>
						<tr>
							<td colspan="8" height="50px">
							<fmt:formatDate value="${approval.appWriteDate}" pattern="yyyy 년 MM 월 dd 일" />
							</td>
						</tr>
						<tr class="signName">
							<td colspan="8" > 신청자 : ${approval.userName} (인)</td>
						</tr>
					</table>
				</div>


				<div id="button">
					<input type="hidden" name="appNo" value = "${approval.appNo}"/>
					<c:if test="${approval.appCheckProgress eq '결재반려'}">
						<button type="button" onclick="showAppReason()">사유확인</button>
					</c:if>
					<c:choose>
						<c:when
							test="${((EmpVO.empno eq approval.firstApprover && approval.appPresent eq 'A') ||
        						(EmpVO.empno eq approval.interimApprover && approval.appPresent eq 'B') ||
        						(EmpVO.empno eq approval.finalApprover && approval.appPresent eq 'C')) && approval.appCheckProgress ne '결재반려'}">
							<button type="button" id="canceldone" onclick="showCancelForm(${approval.appNo}, '${approval.appPresent}')">반려</button>
						</c:when>
						<c:otherwise>
							<button type="button" id="canceldone" disabled>반려</button>
						</c:otherwise>
					</c:choose>
	
					<button onclick="location.href='${path}/approval/approvalMain'"> 목록 </button>
				</div>
			</div> 

		</div>
		
		<!-- right -->
		<%@ include file="../includes/con_right.jsp"%>
		
	</div>

	<!-- 반려 -->
	<%@ include file="../approval/modal/cancel.jsp"%>

	<!-- footer -->
	<%@ include file="../includes/footer.jsp"%>
	<!-- 일정 등록 Modal -->
	<%@ include file="../modal/insertTodoModal.jsp"%>
</body>
</html>