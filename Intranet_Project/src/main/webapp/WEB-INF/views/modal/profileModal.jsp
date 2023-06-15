<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>

	<div class="profileback">
		<div class=profilediv>
			<div class="top">
				<p class="top1">프로필 등록</p>
				<p class="top2" onclick="closeProfilePop()">X</p>
			</div>
			
			<div class="middle" style="padding: 10px;">
				<form action="${path}/mypage/uploadProfile" method="post" enctype="multipart/form-data">
					<input type="hidden" name="empno" value="${EmpVO.empno}">
					<input type="hidden" name="name" value="${EmpVO.name}">
					<input id="PROFILENAME" type="hidden" value="/upload/profile/${EmpVO.realprofile}"/>
					<table>
						<tr>
							<th>
								<img id="proimg" src="/upload/profile/${EmpVO.realprofile}">
							</th>
						</tr>
						<tr>
							<th><input id="profilename" type="file" name="filename" onchange="showImg()" accept="image/*"/></th>
						</tr>
						<tr>
							<th>
								<input type="button" value="닫기" onclick="closeProfilePop()" /> 
								<input type="submit" value="등록"/>
							</th>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</div>

</body>
</html>