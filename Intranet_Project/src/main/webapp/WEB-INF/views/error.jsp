<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="./includes/head.jsp" %>
</head>

<body>

	<!-- haeder -->
	<%@ include file="./includes/header.jsp" %>



	<!-- main -->
	<div style="background: white; height: 800px;">
	
		<!-- =================================contents================================================= -->
		<div align="center">
			<h1 style="line-height: 600px">잘못된 접근입니다.</h1>
			<button onclick="location.href='${path}/main'">홈으로</button>
		</div>
		<!-- =================================contents================================================= -->
		
	</div>
	<!-- main -->

	<!-- footer -->
	<%@ include file="./includes/footer.jsp"%>

</body>

</html>