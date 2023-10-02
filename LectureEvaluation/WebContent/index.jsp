<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>    
<%@ page import="user.UserDAO" %>
<%@ page import="evaluation.EvaluationDTO" %>
<%@ page import="evaluation.EvaluationDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.URLEncoder" %>
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
	request.setCharacterEncoding("UTF-8");
	String lectureDivide = "전체";
	String searchType = "최신순";
	String search = "";
	int pageNumber = 0;

	if(request.getParameter("lectureDivide") != null) {
		lectureDivide = request.getParameter("lectureDivide");
	}
	if(request.getParameter("searchType") != null) {
		searchType = request.getParameter("searchType");
	}
	if(request.getParameter("search") != null) {
		search = request.getParameter("search");
	}
	if(request.getParameter("pageNumber") != null) {
		try {
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		} catch(Exception e) {
			System.out.println("검색 페이지 번호 오류");
		}
	}
	
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
	boolean emailChecked = new UserDAO().getUserEmailChecked(userID);
	if(!emailChecked) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href='emailSendConfirm.jsp';");
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
	          <a class="nav-link active" aria-current="page" href="index.jsp">메인</a>
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
	            <li><a class="dropdown-item" href="userJoin.jsp">회원가입</a></li>
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
	
	<section class="container">
		<form method="get" action="./index.jsp" class="form-inline mt-3">
			<div style="display: flex;">
				<select name="lectureDivide" class="form-select mx-1 mt-2" style="width: 100px;">
					<option value="전체">전체</option>
					<option value="전공" <% if(lectureDivide.equals("전공")) out.println("selected"); %>>전공</option>
					<option value="교양" <% if(lectureDivide.equals("교양")) out.println("selected"); %>>교양</option>
					<option value="기타" <% if(lectureDivide.equals("기타")) out.println("selected"); %>>기타</option>
				</select>
				<select name="searchType" class="form-select mx-1 mt-2" style="width: 100px;">
					<option value="최신순">최신순</option>
					<option value="추천순" <% if(searchType.equals("추천순")) out.println("selected"); %>>추천순</option>
				</select>
				<input type="text" name="search" class="form-control mx-1 mt-2" placeholder="내용을 입력하세요.">
				<button type="submit" class="btn btn-primary mx-1 mt-2" style="width: 90px;">검색</button>
			    <a class="btn btn-primary mx-1 mt-2" data-bs-toggle="modal" data-bs-target="#registerModal" style="width: 130px;">등록하기</a>
			    <a class="btn btn-danger mx-1 mt-2" data-bs-toggle="modal" data-bs-target="#reportModal" style="width: 90px;">신고</a>
			</div>
		</form>
<%
	ArrayList<EvaluationDTO> evaluationList = new ArrayList<>();
	evaluationList = new EvaluationDAO().getList(lectureDivide, searchType, search, pageNumber);
	if(evaluationList != null) 
		for(int i=0; i<evaluationList.size(); i++) {
			if(i == 5) break;	// 5개까지만 출력
			EvaluationDTO evaluation = evaluationList.get(i);
%>
		<div class="card bg-light mt-3">
			<div class="card-header bg-light">
				<div class="row">
					<div class="col-8 text-left"><%= evaluation.getLectureName() %>&nbsp;<small><%= evaluation.getProfessorName() %></small></div>
					<div class="col-4 text-right">
						종합<span style="color: red;"><%= evaluation.getTotalScore() %></span>
					</div>
				</div>
			</div>
			<div class="card-body">
				<h5 class="cart-title">
					<%= evaluation.getEvaluationTitle() %>&nbsp;<small>(<%= evaluation.getLectureYear() %>년 <%= evaluation.getSemesterDivide() %>)</small>
				</h5>
				<p class="cart-text"><%= evaluation.getEvaluationContent() %></p>
				<div class="row">
					<div class="col-9 text-left">
						성적 <span style="color: red;"><%= evaluation.getCreditScore() %></span>
						널널 <span style="color: red;"><%= evaluation.getComportableScore() %></span>
						강의 <span style="color: red;"><%= evaluation.getLectureScore() %></span>
						<span style="color: green;">(추천 : <%= evaluation.getLikeCount() %>)</span>
					</div>
					<div class="col-3 text-right">
					<a onclick="return confirm('추천하시겠습니까?')" href="./likeAction.jsp?evaluationID=<%= evaluation.getEvaluationID() %>"">추천</a>
					<a onclick="return confirm('삭제하시겠습니까?')" href="./deleteAction.jsp?evaluationID=<%= String.valueOf(evaluation.getEvaluationID()) %>">삭제</a>
					</div>
				</div>
			</div>
		</div>
<%
		}
%>
	</section>
	<ul class="pagination justify-content-center mt-3">
		<li class="page-item">
<%
	if(pageNumber <= 0) {
%>
	<a class="page-link disabled">이전</a>
<%
	} else {
%>
	<a class="page-link" href="./index.jsp?lectureDivide=<%= URLEncoder.encode(lectureDivide, "UTF-8") %>&searchType=
	<%= URLEncoder.encode(searchType, "UTF-8") %>&search=<%= URLEncoder.encode(search, "UTF-8") %>&pageNumber=
	<%= pageNumber - 1 %>">이전</a>
<%
	}
%>
		</li>
		<li class="page-item">
<%
	if(evaluationList.size() < 6) {
%>
	<a class="page-link disabled">다음</a>
<%
	} else {
%>
	<a class="page-link" href="./index.jsp?lectureDivide=<%= URLEncoder.encode(lectureDivide, "UTF-8") %>&searchType=
	<%= URLEncoder.encode(searchType, "UTF-8") %>&search=<%= URLEncoder.encode(search, "UTF-8") %>&pageNumber=
	<%= pageNumber + 1 %>">다음</a>
<%
	}
%>
		</li>
	</ul>
	<div class="modal fade" id="registerModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hiiden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title fs-5" id="modal">평가 등록</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form action="./evaluationRegisterAction.jsp" method="post">
						<div class="form-row mb-3" style="display: flex;">
							<div class="form-group col-sm-6">
								<label>강의명</label>
								<input type="text" name="lectureName" class="form-control" maxlength="20"> 
							</div>
							<div class="form-group col-sm-6">
								<label>교수명</label>
								<input type="text" name="professorName" class="form-control" maxlength="20"> 
							</div>
						</div>
						<div class="form-row" style="display: flex;">
							<div class="form-group col-sm-4">
								<label>수강 연도</label>
								<select name="lectureYear" class="form-select">
									<option value="2011">2011</option>
									<option value="2012">2012</option>
									<option value="2013">2013</option>
									<option value="2014">2014</option>
									<option value="2015">2015</option>
									<option value="2016">2016</option>
									<option value="2017">2017</option>
									<option value="2018">2018</option>
									<option value="2019">2019</option>
									<option value="2020">2020</option>
									<option value="2021">2021</option>
									<option value="2022">2022</option>
									<option value="2023" selected>2023</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label>수강 학기</label>
								<select name="semesterDivide" class="form-select">
									<option value="1학기" selected>1학기</option>
									<option value="여름학기">여름학기</option>
									<option value="2학기">2학기</option>
									<option value="겨울학기">겨울학기</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label>강의 구분</label>
								<select name="lectureDivide" class="form-select">
									<option value="전공" selected>전공</option>
									<option value="교양">교양</option>
									<option value="기타">기타</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label>제목</label>
							<input type="text" name="evaluationTitle" class="form-control" maxlength="30">
						</div>
						<div class="form-group mb-3">
							<label>내용</label>
							<textarea name="evaluationContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea>
						</div>
						<div class="form-row" style="display: flex;">
							<div class="form-group col-sm-3">
								<label>종합</label>
								<select name="totalScore" class="form-select">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
							<div class="form-group col-sm-3">
								<label>성적</label>
								<select name="creditScore" class="form-select">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
							<div class="form-group col-sm-3">
								<label>널널</label>
								<select name="comportableScore" class="form-select">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
							<div class="form-group col-sm-3 mb-3">
								<label>강의</label>
								<select name="lectureScore" class="form-select">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-primary" data-bs-dismiss="modal">등록하기</button>
 						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<!-- 신고하기 -->
	<div class="modal fade" id="reportModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hiiden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title fs-5" id="modal">신고하기</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form action="./reportAction.jsp" method="post">
						<div class="form-group">
							<label>신고 제목</label>
							<input type="text" name="reportTitle" class="form-control" maxlength="30">
						</div>
						<div class="form-group mb-3">
							<label>신고 내용</label>
							<textarea name="reportContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-danger" data-bs-dismiss="modal">신고하기</button>
 						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<footer class="bg-dark mt-auto p-5 text-center" style="color: #FFFFFF;">
		Copyright &copy; 2023 박장미 All Rights Reserved;
	</footer>

<script></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
</body>
</html>