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

	request.setCharacterEncoding("UTF-8");
	String reportTitle = null;
	String reportContent = null;
	if(request.getParameter("reportTitle") != null) {
		reportTitle = request.getParameter("reportTitle");
	}
	if(request.getParameter("reportContent") != null) {
		reportContent = request.getParameter("reportContent");
	}
	if(reportTitle == null || reportContent == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안된 사항이 있습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
	}
	
	String host = "http://localhost:8080/LectureEvaluation/";
	String from = "alwkd920101@naver.com";
	String to = "alwkd920101@naver.com";
	String subject = "강의평가 사이트에서 접수된 신고 메일입니다.";
	String content = "신고자 : " + userID + 
					 "<br>제목: " + reportTitle +
					 "<br>내용: " + reportContent;
		
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
    PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('정상적으로 신고되었습니다.');");
	script.println("history.back();");
	script.println("</script>");
	script.close();
%>