<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>강의평가 웹 사이트</title>
<link rel="stylesheet" href="./css/custom.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
</head>
<body class="d-flex flex-column min-vh-100">
<%
	String userID = null;
	if(session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	if(userID != null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인이 된 상태입니다.');");
		script.println("location.href='index.jsp';");
		script.println("</script>");
		script.close();
	}
%>
	<nav class="navbar navbar-expand-lg bg-body-tertiary">
	  <div class="container-fluid">
	    <a class="navbar-brand" href="index.jsp">강의평가 웹 사이트</a>
	    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarTogglerDemo02" aria-controls="navbarTogglerDemo02" aria-expanded="false" aria-label="Toggle navigation">
	      <span class="navbar-toggler-icon"></span>
	    </button>
	    <div class="collapse navbar-collapse" id="navbarTogglerDemo02">
	      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
	        <li class="nav-item">
	          <a class="nav-link" aria-current="page" href="index.jsp">메인</a>
	        </li>
	         <li class="nav-item dropdown">
	          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
	            회원관리
	          </a>
	          <ul class="dropdown-menu">
	          <%
	          	if(userID == null) {
	          %>
	            <li><a class="dropdown-item" href="userLogin.jsp">로그인</a></li>
	            <li><a class="dropdown-item active" href="userJoin.jsp">회원가입</a></li>
            <% } else { %>
	            <li><a class="dropdown-item" href="userLogoutAction.jsp">로그아웃</a></li>
            <% } %>
	          </ul>
	        </li>
	      </ul>
	      <form action="./index.jsp" method="get" class="d-flex" role="search">
	        <input type="text" name="search" class="form-control me-2" type="search" placeholder="내용을 입력하세요." aria-label="Search">
	        <button class="btn btn-outline-success" type="submit" style="width: 80px;">검색</button>
	      </form>
	    </div>
	  </div>
	</nav>
	
	<section class="container mt-3" style="max-width: 400px;">
		<h2 class="mb-3 mt-3" style="text-align: center;">회원가입</h2>
		<form action="./userRegisterAction.jsp" method="post">
			<div class="form-group">
				<label>아이디</label>
				<input type="text" name="userID" class="form-control mb-3">
			</div>
			<div class="form-group">
				<label>비밀번호</label>
				<input type="password" name="userPwd" class="form-control mb-3">
			</div>
			<div class="form-group">
				<label>이메일</label>
				<input type="email" name="userEmail" class="form-control mb-3">
			</div>
			<div class="my-btn">
				<button type="submit" class="btn btn-primary w-100 mt-3">회원가입</button>
			</div>
		</form>
	</section>

	<footer class="bg-dark mt-auto p-5 text-center" style="color: #FFFFFF;">
		Copyright &copy; 2023 박장미 All Rights Reserved
	</footer>

<script></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
</body>
</html>