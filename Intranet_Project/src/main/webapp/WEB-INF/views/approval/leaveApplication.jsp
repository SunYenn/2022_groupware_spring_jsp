<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="../includes/head.jsp"%>
	<link rel="stylesheet" href="${path}/css/approvalStyle.css">
	<link rel="stylesheet" href="${path}/css/approval.css">
	<script src="${path}/js/approval.js" defer="defer"></script>
	<% Calendar today =  Calendar.getInstance(); %>
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
					<li><a href="${path}/approval/leaveApplication">휴가신청서</a></li>
				</ul>
			</div>

			<div class="cash-form-section">
				<form id="leaveWriteForm" name="leaveWriteForm" action="${path}/approval/leaveApplication_insert" method="post" onsubmit="return check_onclick()">
					<div class="cash-disbursement">
						<table>
							<thead>
								<tr>
									<td rowspan="2" colspan="4" class="appformtitle">휴 가 신 청 서</td>
									<td rowspan="2" >결 <br> 재</td>
									<td style="height: 30px; width: 100px;">최초승인자</td>
									<td style="width: 100px;">중간승인자</td>
									<td style="width: 100px;">최종승인자</td>
								</tr>
								<tr>
									<td>
										<input type="hidden" value="" id="firstApprover" name="firstApprover" readonly class="nameView">
										<input type="text" value="" id="firstApproverName" name="firstApproverName" readonly class="nameView">
										<input type="button" value="검색" class="searchMember" id="firstBtn" name="firstApprover" onclick="showEmployeeSearchForm(this)">
									</td>
									<td>
										<input type="hidden" value="" id="interimApprover" name="interimApprover" readonly class="nameView">
										<input type="text" value="" id="interimApproverName" name="interimApproverName" readonly class="nameView">
										<input type="button" value="검색" class="searchMember" id="secondBtn" name="interimApprover" onclick="showEmployeeSearchForm(this)">
									</td>
									<td>
										<input type="hidden" value="" id="finalApprover" name="finalApprover" readonly class="nameView">
										<input type="text" value="" id="finalApproverName" name="finalApproverName" class="nameView">
										<input type="button" value="검색" class="searchMember" id="thirdBtn" name="finalApprover" onclick="showEmployeeSearchForm(this)">
									</td>
								</tr>
								<tr class="formrefer">
									<td width="80px">
										<button class="send-open" type="button" >수신참조자 +</button>
									</td>
									<td colspan="7">
										<textArea readonly name="referList" id="referList" rows="1"></textArea>
									</td>
								</tr>
							</thead>
							<tbody>
								<tr class="writeinfo">
									<td colspan="8">	
										<div>							
											<p>성명</p>			
											<p><input type="text" name="writeName" value="${EmpVO.name}" readonly/></p>			
											<p>부서</p>			
											<p><input type="text" value="${EmpVO.deptname}" readonly></p>			
											<p>성명</p>			
											<p><input type="text" value="${EmpVO.position}" readonly></p>		
										</div>	
									</td>
								</tr>
								<tr class="bisang">
									<td colspan="3">비 상 연 락 망</td>
									<td colspan="5">
										<input type="tel" placeholder="전화번호만 입력하세요." class="callNumber" name="appEmergncyCall" required />
									</td>
								</tr>
								<script>
									$(document).on("keyup", ".callNumber", function() {
									   $(this).val( $(this).val()
									         .replace(/[^0-9]/g, "")
									         .replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/,"$1-$2-$3").replace("--", "-") ); 
									});
								</script>
								<tr class="gigan">
									<td colspan="3">기 간</td>
									<td colspan="5">
										<input type="date" name="leaveStart" id="startDate" /> 
									 	&nbsp;&nbsp; ~ &nbsp;&nbsp; 
									 	<input type="date" name="leaveFinish" id="endDate" /> 
									 	<script type="text/javascript">
											// 시작일 < 종료일
											var start = document.getElementById('startDate');
											var end = document.getElementById('endDate');

											start .addEventListener(
												'change',
												function() {
													if (start.value)
														end.min = start.value;
											}, false);
											end .addEventListener(
												'change',
												function() {
													if (end.value)
														start.max = end.value;
											}, false);
										</script>
									</td>
								</tr>
								<tr class="leaveClassify">
									<td height="60px">휴가 구분</td>
									<td colspan="7">
										<div class="form-checkbox-wrap">
											<span class="form-inline"> 
												<input type="radio" name="leaveClassify" class="input-radio" id="radio1" value="연차">
												<label for="radio1" class="form-radio">연차</label> 
											</span>
											<span class="form-inline"> 
												<input type="radio" name="leaveClassify" class="input-radio" id="radio2" value="반차">
												<label for="radio2" class="form-radio">반차</label> 
											</span>
											<span class="form-inline"> 
												<input type="radio" name="leaveClassify" class="input-radio" id="radio3" value="병가">
												<label for="radio3" class="form-radio">병가</label> 
											</span>
											<span class="form-inline"> 
												<input type="radio" name="leaveClassify" class="input-radio" id="radio4" value="보상휴가">
												<label for="radio4" class="form-radio">보상휴가</label> 
											</span>
											<span class="form-inline"> 
												<input type="radio" name="leaveClassify" class="input-radio" id="radio5" value="기타">
												<label for="radio5" class="form-radio">기타(세부사항 상세 기술)</label> 
											</span>
										</div>
									</td>
								</tr>
								<tr>
									<td>세부사항</td>
									<td colspan="8">
										<input height="50px" type="text" name="leaveDetail" class="leaveDetailTextArea"/>
									</td>
								</tr>
								<tr>
									<td colspan="8" height="90px">위와 같이 휴가를 신청하오니 확인 후 결재 바랍니다.</td>
								</tr>
								<tr>
									<td colspan="8" height="100px">
										<%= today.get(java.util.Calendar.YEAR) %> 년 &nbsp; 
										<%= today.get(java.util.Calendar.MONTH) + 1 %> 월 &nbsp; 
										<%= today.get(java.util.Calendar.DATE) %> 일 &nbsp;
									</td>
								</tr>
								<tr class="signup">
				                    <td colspan="8">
					                    <div>
					                        <input type="button" name="proposer" id="proposer" value="서명" />
					                        <span>신청자 :  </span><textArea name="proposerText" id="proposerText" disabled="disabled"></textArea> <span>(인)</span>
				                        </div>
				                    </td>
								</tr>
							</tbody>
						</table>
					</div>
					<div id="button">
						<input type="hidden" name="appKinds" value="휴가신청서">
						<button type="submit">등록</button>
						<button type="reset">리셋</button>
					</div>
				</form>
			</div>
		</div>
   
		<!-- right -->
		<%@ include file="../includes/con_right.jsp"%>
		
	</div>

	<!-- 수신참조자 modal/script/ajax -->
	<%@ include file="../approval/modal/selectReferList.jsp"%>

	<!-- 사원 검색  -->
	<%@ include file="../approval/modal/searchEmployee.jsp"%>
	
	<!-- footer -->
	<%@ include file="../includes/footer.jsp"%>
	
	<!-- 일정 등록 Modal -->
	<%@ include file="../modal/insertTodoModal.jsp"%>
</body>
</html>