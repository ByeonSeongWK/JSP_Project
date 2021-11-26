<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "bbs.*" %> 
<%@ page import = "java.util.ArrayList" %>   
<%
		// 로그인 되었을 때 해당 유저의 id가 저장될 세션 변수
		String userId = null;
		
		// 세션에 userId 이름을 가지는 value가 존재하면 
		// userId 변수에 해당 value를 저장
		// 로그인 상태 확인
		if(session.getAttribute("userId") != null) {
			userId = (String) session.getAttribute("userId"); // 반환값 Object 타입이라 형변환 필수
			// 이클립스에서 빨간줄일때 컴파일 할 수가 없다는 뜻이다.
		}
		
		// 게시판 목록의 페이지 번호
		// 이 페이지가 몇 번째 페이지 인지 getParameter로 받아와 알려준다.
		int pageNumber = 1;
		
		// 'pageNumber' 라는 파라미터가 존재 하면 해당 파라미터 값으로 pageNumber 지정
		if(request.getParameter("pageNumber") != null){
			
			// 문자열을 정수형으로 바꾸기 위해 Integer Wrapper class 사용 (parse~~ 메서드)
			pageNumber = Integer.parseInt(request.getParameter("pageNumber")); 
		}
		
%>
<!DOCTYPE html>
<html>
<head>

<title>JSP 게시판</title>
<meta http-equiv="Conetent-Type" content = "text/html; charset = UTF-8">
<meta name="viewport" content = "width=device-width" initial-scale = "1">
<link rel = "stylesheet" href = "css/bootstrap.css" >
<link rel = "stylesheet" href = "css/custom.css">

<style>
		a, a:hover {
			color : #000000;
			text-decoration : none;
		}
</style>

</head>
<body>

<!-- 메인 네비게이션 -->
<!--  nav : 네비게이션 리스트 만들어주는 HTML 태그 -->
<nav class="navbar navbar-default">
		<%-- 네비게이션 헤더 --%>
		<!-- div : 웹 페이지에서 공간을 지정하는 HTML 태그 (가로 전체) -->
		<div class = "navbar-header">
				<!--button : 버튼을 만들어 주는 HTML 태그 -->
				<button type = "button" class = "navbar-toggle collapsed"
				 	data-toggle = "collapse" data-target = "#bs-navbar-collapse"
				 	arai-expaned = "false">
				 	<!-- span :  웹 페이지에서 공간을 지정하는 HTML 태그 (컨텐츠 사이즈 가로)-->
				 	<span class = "icon-bar"></span>
				 	<span class = "icon-bar"></span>
				 	<span class = "icon-bar"></span>
				 </button>
				 <!--  a : url을 이동 시켜주는 태그 href = "" 속성에 경로 지정 -->
				 <a class = "navbar-brand" href = "main.jsp">JSP 게시판</a>
		</div>
		<%-- 네비게이션 헤더 종료 --%>
		
		<%--  네비게이션 메뉴 --%>
		<div class="collapse navbar-collapse" id = "bs-navbar-collapse">
				<!-- 
					ol : order list -- 순서가 있는 리스트를 만들어 주는 태그
					ul : unorder list -순서가 없는 리스트를 만들어 주는 태그
				 -->
				 
				 <%-- 메인 메뉴 --%>
				<ul class = "nav navbar-nav">
						<!-- li : 리스트는 하나의 요소를 만들어 주는 태그 -->
						<li><a href = "bbs.jsp">게시판</a></li>	
						<li class="active"><a href="main.jsp">메인</a></li>
				</ul>
				<%-- 메인 메뉴 종료 --%>
				
				<%-- 마이 페이지 메뉴 --%>
				<!-- 로그인이 되있지 않을 때 표시 -->
				<%
						// 아이디가 입력 받지 않았을때
						if(userId == null) {
				%>
				<ul class = "nav navbar-nav navbar-right">
						<li class = "dropdown">
								<a href = "#" class = "dropdown-toggle"
										data-toggle = "dropdown" role="button"
										aria-haspopup="true" aria-expanded = "false ">
										 마이페이지<span class = "caret"></span>							
								</a>
								<ul class = "dropdown-menu">
										<li><a href = "login.jsp">로그인</a></li>
										<li><a href = "join.jsp">회원가입</a></li>
								</ul>
						</li>
				</ul>
				<%
					// 아이디가 입력 받았을때
					} else {
				%>
				 <!-- 로그인이 되었을 때 표시 -->
				<ul class = "nav navbar-nav navbar-right">
						<li class = "dropdown">
								<a href = "#" class = "dropdown-toggle"
										data-toggle = "dropdown" role="button"
										aria-haspopup="true" aria-expanded = "false ">
										 마이페이지<span class = "caret"></span>							
								</a>
								<ul class = "dropdown-menu">
										<li><a href = "logoutAction.jsp">로그아웃</a></li>
								</ul>
						</li>
				</ul>
				<%} %>
				<%-- 마이페이지 메뉴 종료 --%>
				
		</div>
		<%-- 네비게이션 메뉴 종료  --%>
		
</nav>
<%-- 메인 네비게이션 종료 --%>

<%-- 메인 게시판 --%>
<div class = "container">
		<div class = "row">
				<table class = "table table-striped" style = "text-align: center; border: 1px solid #bbbbbb">
							<thead><!-- 테이블의 컬럼이나 제목 지정할때 thead 사용 -->
									<tr>
											<th style="background-color: #dddddd; text-align: center;">번호</th>
											<th style="background-color: #dddddd; text-align: center;">제목</th>
											<th style="background-color: #dddddd; text-align: center;">작성자</th>
											<th style="background-color: #dddddd; text-align: center;">작성일</th>
									</tr>
							</thead>
							<tbody>
							<%
									// BBS DataAccess Object
									BbsDAO dao = new BbsDAO();
									
									// 게시물 목록 받아옴		
									ArrayList<Bbs> list = dao.getList(pageNumber, dao.nextBbsID());
									
									// 목록 개수만큼 반복해서 각 요소를 출력
									for(int i = 0; i < list.size(); i++) {
							%>
									<tr>									<!-- .get(i) 해당 인덱스에 대한 객체 -->
											<td><%= list.get(i).getBbsID()		%></td>
																		<!--        ↓ 식별자 -->
											<td><a href = "view.jsp?bbsID=<%= list.get(i).getBbsID() %>" ><%= list.get(i).getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll(" < ", "&lt;").replaceAll(" > ", "&gt;").replaceAll(" /n ", "<br>") %></a></td>
											
											<td><%= list.get(i).getUserID()		%></td>
											<td><%= list.get(i).getBbsDate()	%></td>
									</tr>
							<%							
									}
							%>
							
							</tbody>
							
				</table>
				
				<%	// 이전 페이지
						// 페이지 번호가 1번이 아니면
						if(pageNumber != 1) {
				%>
						<%-- GET 방식 전송 : URL에 ? 찍고, 파라미터 = 데이터 & 파라미터 = 데이터 --%>
						<a href = "bbs.jsp?pageNumber=<%= pageNumber - 1 %>" class = "btn btn-success btn-arrow-left">이전</a>		
				
				<%
						}
						// 다음 페이지											↓ 다음 번호 불러오기
						if(dao.isNextPage(pageNumber + 1, dao.nextBbsID())) {
				%>
						<a href = "bbs.jsp?pageNumber=<%= pageNumber + 1 %>" class = "btn btn-success btn-arrow-left">다음</a>
				<%
						}
				%>
				
				<a href = "write.jsp" class = "btn btn-default pull-right">글쓰기</a>
		</div>
</div>
<%-- 메인 게시판 종료 --%>

<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src= "js/bootstrap.js"></script>
</body>
</html>
