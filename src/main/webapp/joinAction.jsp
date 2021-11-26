<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.io.PrintWriter" %>
<%@ page import = "users.UsersDAO" %>
<%-- join.jsp 페이지에서 파라미터를 받아와 bean 객체에 저장 --%>
<jsp:useBean id = "users" class = "users.Users" scope = "page" />
<%-- userId 		: 유저 아이디 		--%>
<%-- userPw 		: 유저 패스워드	--%>
<%-- userName 	: 유저 이름 		--%>
<%-- userGender	: 유저 성별 		--%>
<%-- userEmail	: 유저 이메일 		--%>
<jsp:setProperty name = "users" property = "userId"/> 
<jsp:setProperty name = "users" property = "userPw"/> 
<jsp:setProperty name = "users" property = "userName"/> 
<jsp:setProperty name = "users" property = "userGender"/> 
<jsp:setProperty name = "users" property = "userEmail"/>
<!-- input에서 name 과 setProperty의 property가 값이 같지 않으면 param을 적어줘야 한다.-->

<%
		// 세션의 userId 값을 저장하기 위한 변수
		String userId =  null;
		
		// 세션 값을 확인해서 값을 userId 변수에 저장
		if(session.getAttribute("userId") != null) {
			// Object로 받아와 형변환을 해줘야 한다.
			userId = (String) session.getAttribute("userId");
			// request.getParameter() -> 반환값 문자열
		}
		// userId 값이 null이 아니면 로그인된 상태 
		if(userId != null) {
			// html 문서에 html 태그를 작성하기 위한 객체 생성
			PrintWriter script = response.getWriter();
			script.println("<script>");
			// alert() -> 알림창 표시 javaScript 구문
			script.println("alert('이미 로그인 되어 있습니다.');");
			// location.href = '변경할 페이지'; -> 현재 url 주소 변경(페이지 이동) javaScript 구문
			script.println("location.href = 'main.jsp';");
			script.println("</script>");
		}
		
		// 입력 값 검증(앞에서도 해주고 뒤에서도 해주는게 제일 좋다.)
		if (users.getUserId()  			== null ||
			users.getUserPw()  			== null ||
			users.getUserName() 		== null ||
			users.getUserGender()		== null ||
			users.getUserEmail()		== null) {
			
			// 입력값이 하나라도 빈 값이면 되돌려 보낸다.
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('모든 값을 입력하세요.')");
			script.println("history.back('join.jsp')");	// history.back() -> 페이지를 뒤로 돌려보내는 JavaScript 메서드
			script.println("</script>");
		}
		
		// users dao 객체를 생성
		UsersDAO dao = new UsersDAO();
		
		// dao.join 메서드 호출 후 결과값 반환 받아온다.
		// 반환값 0 : 성공, -1 : 실패(아이디 중복)
		int result = dao.join(users);		
		
		// 아이디 중복 처리
		if(result == -1) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 존재하는 아이디입니다.')");
			script.println("history.back('join.jsp')");
			script.println("</script>");
		} else {
			// 세션에 'userId' 라는 이름으로 users.userId의 value를 저장
			// 로그인 처리
			session.setAttribute("userId", users.getUserId());
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href = 'main.jsp';");
			script.println("</script>");
			// 로그인 완료 시 main.jsp 페이지로 돌아간다.
		}

%>