<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- jstl 사용 선언 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="path" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
	    <title>1조 팀프로젝트</title>
	    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
	    <link rel="icon" href="${path}/images/apple.png">
	    <script src="${path}/js/jquery-3.6.1.js"></script>
	    <script src="${path}/js/user.js" defer="defer"></script>
	    <link rel="stylesheet" href="${path}/css/tjoeun_intro.css">	
	</head>

	<body class="is-preload">

		<!-- Wrapper -->
		<div class="wrapper">

			<!-- Main -->
			<section class="main register">
				<h1>회원가입</h1><hr>
				<div class="fields">
					
					<div class="field">
						<label for="empno" class="label">사원번호(ID)</label>
						<div class="group">
							<input type="text" id="empno" placeholder="사원번호를 입력해주세요." maxlength="5" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');"/>
							<input class="check-btn" type="button" value="중복검사" onclick="registerCheckFunction()">
						</div>
					</div>
					
					<div class="field">
						<label for="name" class="label">이름</label>
						<input type="text" id="name" placeholder="이름을 입력해주세요." maxlength="20" onkeyup="nameCheckFunction()"/>
					</div>
					
					<h5 id="nameCheckMessage"></h5>
					
					<div class="field">
						<label for="password1" class="label">비밀번호</label>
						<input type="password" id="password1" placeholder="비밀번호(최대 16자리)를 입력하세요." maxlength="16" onkeyup="passwordCheckFunction()"/>
					</div>
					
					<div class="field">
						<label for="password2" class="label">비밀번호 확인</label>
						<input type="password" id="password2" placeholder="비밀번호를 한번 더 입력하세요." maxlength="16" onkeyup="passwordCheckFunction()"/>
					</div>
					
					<h5 id="pwCheckMessage"></h5>
					
					<div class="field">
						<label for="gender" class="label">성별</label>
						<div class="gendiv">
							<label>
								<input id="gender" type="radio" name="gender" value="M"/>남자
							</label>
							<label>
								<input id="gender" type="radio" name="gender" value="F" checked="checked"/>여자
							</label>
						</div>
					</div>
					
					<div class="field">
						<label for="pernum" class="label">전화번호</label>
						<input type="text" id="pernum" placeholder="휴대폰 번호를 입력하세요." maxlength="13" onkeyup="pernumCheckFunction(this)"/>
					</div>
					
					<div class="field">
						<label for="email" class="label">이메일</label>
						<input type="text" id="email" placeholder="이메일을 입력하세요.(@ 포함) " onkeyup="emailCheckFunction()"/>
					</div>
					
					<h5 id="emailCheckMessage"></h5>

					<hr>
					<div class="field btn2">
						<button type = "button" onclick="location.href='${path}/login'">Back</button>
						<button type = "button" class="change" onclick="userRegister()">Join us</button>
					</div>			
	
				</div>	

			</section>
			
			<!-- Footer -->
			<footer class="footer">
				<ul class="copyright">
					<li>&copy; 선예은</li>
				</ul>
			</footer>

		</div>

		<!-- Scripts -->
		<script>
			if ('addEventListener' in window) {
				window.addEventListener('load', function() { document.body.className = document.body.className.replace(/\bis-preload\b/, ''); });
				document.body.className += (navigator.userAgent.match(/(MSIE|rv:11\.0)/) ? ' is-ie' : '');
			}
		</script>
	</body>
</html>