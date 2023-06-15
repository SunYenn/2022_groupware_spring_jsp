<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
</head>
<body>

	<div class="background">
		<div class="pwchange">			
			<div class="top">
				<p class="top1">비밀번호 변경</p>
				<p class="top2" onclick="closePop()">X</p>
			</div>
			
			<div class="middle">
				
				<input type="hidden" value="${EmpVO.password}" id="password" /> 
				<input type="hidden" value="${EmpVO.empno}" id="empno" />
				
				<table>
					<tr>
						<th>현재 비밀번호</th>
						<td><input type="password" id="checkPassword" placeholder="현재 비밀번호를 입력하세요."/></td>
					</tr>
					<tr>
						<th>비밀번호</th>
						<td colspan="2">
							<input type="password" id="password1" maxlength="16" 
								placeholder="비밀번호(최대 16자리)를 입력하세요." onkeyup="passwordCheckFunction()" />
						</td>
					</tr>

					<!-- 비밀번호 확인(userPassword2) -->
					<tr>
						<th class="pwcheck">비밀번호 확인</th>
						<td colspan="2">
							<input type="password" id="password2" maxlength="16" placeholder="비밀번호를 한번 더 입력하세요."
								onkeyup="passwordCheckFunction()" />
						</td>
					</tr>
					<tr style="height: 30px;">
						<th colspan="2">
							<h5 id="pwCheckMessage" style="color: red; font-size:12px;"></h5>
						</th>
					</tr>
					<tr>
						<td colspan="2" align="right">
							<input class="cancel" type="button" value="취소" onclick="closePop()" />
							<input class="change" type="button" value="변경" onclick="changePassword()" disabled="disabled" />
						</td>
					</tr>
				</table>
			</div>			
		</div>
	</div>

</body>
</html>