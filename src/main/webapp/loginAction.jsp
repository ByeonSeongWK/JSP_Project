<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.io.PrintWriter" %>
<%@ page import = "users.UsersDAO" %>

<%-- Character Encoding을 UTF-8로 설정 --%>
<% request.setCharacterEncoding("UTF-8"); %>

<%-- login.jsp 페이지에서 파라미터를 받아와 bean 객체에 저장 --%>
<%-- userId		: 유저 아이디 		--%>
<%-- userPw	: 유저 패스워드 	--%>
<jsp:useBean id = "users" class = "users.Users" scope = "page" />
<jsp:setProperty name = "users" property = "userId" />
<jsp:setProperty name = "users" property = "userPw" />

<%
		// 세션의 userId 이름을 가지는 value를 저장할 변수 선언
		String userId = null;
		
		// 세션의 'userId'라는 이름을 가지는 value가 존재 하는지 검증
		if(session.getAttribute("userId") != null) {
			userId = (String) session.getAttribute("userId");
		}
		
		// 세션에 'userId'라는 이름을 가지는 value가 존재 할 경우
		// (로그인 되있는 상태)
		 if(userId != null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 로그인 되어있습니다.')");
			script.println("location.href = 'main.jsp';");
			script.println("</script>");
		}

		// 입력 값 검증
		// 입력받은 userId 값이 users(Bean)에 저장된다 그래서 users.getUser?? 으로 검증
		if(users.getUserId() == null || users.getUserPw() == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('모든 값을 입력하세요.')");
			script.println("history.back()");
			script.println("</script>");
		}
		
		// Users 테이블 data access object 생성
		UsersDAO dao = new UsersDAO();
		// 생성되자마자 로드와 접속이 된다. 기본생성자에 만들어 놨기 때문에
		
		// dao.login 메서드 호출 후 결과값 반환 받아옴
		// 반환값 : 0 - 로그인 성공, 1 - 로그인 정보 불일치, -1  - 데이터베이스 오류
		int result = dao.login(users);
		
		///////
		// 반환값 0 : 로그인 성공
		if(result == 0) {
			// 로그인 성공시 session에 'userId'라는 이름으로 users.UserId value를 저장
			session.setAttribute("userId", users.getUserId());
			
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href = 'main.jsp';");
			script.println("</script>");
		}
		
		// 반환값 1 : 로그인 정보 불일치
		else if(result == 1) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인 정보가 일치하지 않습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		
		// 반환값 -1 : 데이터베이스 오류
		else if(result == -1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생했습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		/////////
		// 로그인하는 행위에서 아이디나 비밀번호가 틀렸다고 표시하면 안되고
		// 어떤 것이 불일치 한지 모르게 로그인 정보가 불일치하다고 표시해야함.
%>

