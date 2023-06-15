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
					<li><a href="${path}/approval/letterOfApproval">품의서 작성</a></li>
				</ul>
			</div>

			<div class="cash-form-section">
				<form action="${path}/approval/letterOfApproval_insert" method="post" onsubmit="return check_onclick()" enctype="multipart/form-data">
					<div class="cash-disbursement">
						<table>
							<thead>
								<tr>
									<td rowspan="2" colspan="4" class="appformtitle">품 의 서</td>
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
										<input type="text" value="" id="finalApproverName" name="finalApproverName" readonly class="nameView">
										<input type="button" value="검색" class="searchMember" id="thirdBtn" name="finalApprover" onclick="showEmployeeSearchForm(this)">
									</td>
								</tr>
								<tr class="formrefer">
									<td>
										<button class="send-open" type="button">수신참조자 +</button>
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
								<tr>
									<td width="100px">제 목</td>
									<td colspan="7"><input type="text" name="loaTitle" id="loaTitle"></td>
								</tr>
								<tr class="fileattach">
									<td colspan="8">
										<input type="file" id="inputFile" name="loaFileUpload" />
									</td>
								</tr>
								<tr>
									<td colspan="8">품의사유 및 상세내용</td>
								</tr>
								<tr class="contentarea">
									<td colspan="8">
										<textarea name="loaContent" id="loaContent" rows="15"></textarea>
									</td>
								</tr>
								<tr>
									<td colspan="8">위와 같은 품의사유로, 검토 후 결재 바랍니다.</td>
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
						<input type="hidden" name="appKinds" value="품의서">
						<button type="submit" >등록</button>
						<button type="reset" >리셋</button>
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
</html>