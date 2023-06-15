<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<header>

	<c:if test="${EmpVO.empno == null}"><c:redirect url="/login"></c:redirect> </c:if>
	<h1>
		<a href="${path}/main">TJ INTRANET</a>
	</h1>
	<ul>
		<li>
			${EmpVO.deptname} / ${EmpVO.name}&lpar;${EmpVO.empno}&rpar;
		</li>
	</ul>
	
</header>
