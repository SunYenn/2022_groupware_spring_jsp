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
			<section class="main">
				<h1>비밀번호 찾기</h1><hr>
				<form name="findPWForm" class="findPWForm">
					<div class="fields">

						<div class="field">
							<input type="text" name="empno" placeholder="사원번호를 입력해주세요" maxlength="5" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');"/>
						</div>
						
						<div class="field">
							<input type="text" name="name" placeholder="이름을 입력해주세요" />
						</div>
						
						<div class="field">
							<input type="text" name="pernum" placeholder="전화번호를 입력해주세요" onkeyup="pernumCheckFunction(this)"/>
						</div>

						<div class="field btn3">
							<button type = "button" onclick="findPW()">Find</button>							
							<button type = "button" onclick="location.href='${path}/register'">Join us</button>
							<button type = "button" onclick="location.href='${path}/login'">Login</button>
						</div>			
		
					</div>	

					<a href="findIDpage">아이디 찾기</a>
				</form>
			
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