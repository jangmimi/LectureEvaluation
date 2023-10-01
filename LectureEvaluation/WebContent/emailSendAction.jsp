<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="javax.mail.*" %>
<%@ page import="java.util.Properties" %>
<%@ page import="user.UserDAO" %>
<%@ page import="util.SHA256" %>
<%@ page import="util.Nmail" %>
<%@ page import="java.io.PrintWriter" %>
<%
	UserDAO userDAO = new UserDAO();
	String userID = null;
	if(session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	if(userID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href='userLogin.jsp';");
		script.println("</script>");
		script.close();
	}

	boolean emailChecked = userDAO.getUserEmailChecked(userID);
	if(emailChecked) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 인증된 회원입니다.');");
		script.println("location.href='index.jsp';");
		script.println("</script>");
		script.close();
	}
	String host = "http://localhost:8080/LectureEvaluation/";
	String from = "alwkd920101@naver.com";
	String to = userDAO.getUserEmail(userID);
	String subject = "강의평가를 위한 이메일 인증 메일입니다.";
	String content = "다음 링크에 접속하여 이메일 인증을 진행하세요. " +
		"<a href='" + host + "emailCheckAction.jsp?code=" + new SHA256().getSHA256(to) + "'>이메일 인증하기</a>";
		
	Properties p = new Properties();
    p.put("mail.smtp.starttls.enable", "true");     // gmail은 true 고정
    p.put("mail.smtp.host", "smtp.naver.com");      // smtp 서버 주소
    p.put("mail.smtp.auth","true");                 // gmail은 true 고정
    p.put("mail.smtp.port", "587");                 // 네이버 포트
	
    try {
    	Authenticator auth = new Nmail();
    	Session ses = Session.getInstance(p, auth);
    	ses.setDebug(true);
    	MimeMessage msg = new MimeMessage(ses);
    	msg.setSubject(subject);
    	Address fromAddr = new InternetAddress(from);
    	msg.setFrom(fromAddr);
    	Address toAddr = new InternetAddress(to);
    	msg.addRecipient(Message.RecipientType.TO, toAddr);
    	msg.setContent(content,"text/html;charset=UTF-8");
    	Transport.send(msg);
    } catch(Exception e) {
    	e.printStackTrace();
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('오류가 발생했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
    }
%>
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
	            <li><a class="dropdown-item active" href="userLogin.jsp">로그인</a></li>
	            <li><a class="dropdown-item" href="userJoin.jsp">회원가입</a></li>
	            <li><a class="dropdown-item" href="userLogoutAction.jsp">로그아웃</a></li>
	          </ul>
	        </li>
	      </ul>
	      <form class="d-flex" role="search">
	        <input class="form-control me-2" type="search" placeholder="내용을 입력하세요." aria-label="Search">
	        <button class="btn btn-outline-success" type="submit" style="width: 80px;">검색</button>
	      </form>
	    </div>
	  </div>
	</nav>
	
	<section class="container mt-3" style="max-width: 560px;">
		<div class="alert alert-success mt-4" role="alert">
			이메일 주소 인증 메일이 전송되었습니다. 회원 가입 시 입력했던 이메일에 들어가셔서 인증해주세요.
		</div>
	</section>

	<footer class="bg-dark mt-auto p-5 text-center" style="color: #FFFFFF;">
		Copyright &copy; 2023 박장미 All Rights Reserved;
	</footer>

<script></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
</body>
</html>