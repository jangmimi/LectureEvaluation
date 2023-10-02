<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="evaluation.EvaluationDAO" %>
<%@ page import="likey.LikeyDTO" %>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");

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
	
	String evaluationID = null;
	if(request.getParameter("evaluationID") != null) {
		evaluationID = request.getParameter("evaluationID");
	}
	
	EvaluationDAO evaluationDAO = new EvaluationDAO();
	if(userID.equals(evaluationDAO.getUserID(evaluationID))) {
		int result = evaluationDAO.deleteEvaluation(evaluationID);
		
		if(result == 1) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('강의 평가 삭제가 완료되었습니다.');");
			script.println("location.href='index.jsp';");
			script.println("</script>");
			script.close();
		} else {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('강의 평가 삭제에 실패했습니다.');");
			script.println("history.back();");
			script.println("</script>");
			script.close();
		}
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('자신이 쓴 게시글만 삭제가 가능합니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>