<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.io.PrintWriter" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "bbs.BbsDAO" %>
<%@ page import = "util.Utiles" %>
<%-- Character Encoding을 UTF-8로 설정 --%>
<% request.setCharacterEncoding("UTF-8"); %>

<%-- Bbs JavaBean 객체 생성 --%>
<%-- bbsTitle : 게시물 제목 --%>
<%-- bbsContent : 게시물 내용 --%>
<jsp:useBean id = "bbs" class = "bbs.Bbs" scope = "page" />
<jsp:setProperty name = "bbs" property = "bbsTitle"/>
<jsp:setProperty name = "bbs" property = "bbsContent"/>

<%
		// 세션에 userId 이름의 value가 존재 하는지 검사
		if(session.getAttribute("userId") != null) {
			// userId 세션값이 null이 아니면 실행
			
			// 로그인 상태면 bbs 객체의 UserID 프로퍼티에 userId value 저장
			bbs.setUserID((String) session.getAttribute("userId"));   
		}

		// 로그인 상태가 아니면 로그인 페이지로 이동
		if(bbs.getUserID() == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 필요합니다.');");
			script.println("location.href = 'login.jsp';");
			script.println("</script>");
		}
		
		// BBS 테이블 Data Access Object 생성
		BbsDAO dao = new BbsDAO();
		
		// 삭제 여부 0으로 초기화
		// 삭제여부 : 0이면 삭제 x, 1이면 삭제 o
		bbs.setBbsAvailable(0);
		
		// 게시물 작성일을 현재 시간으로 초기화
				bbs.setBbsDate(Utiles.getToday());
		///////////////// 아래 코드를 따로 Utiles 클래스로 빼놔서 한줄로 코드를 쭐임 /////////////////
		// 현재 시간 반환
		// Date now = new Date();
		//
		// 시간 타입 yyyy-MM-dd HH:mm으로 변환하여 bbsDate에 저장(초기화)
		// SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		//
		// 게시물 작성일을 현재 시간으로 초기화
		// 							  format (어떠한 형식의 데이터를 집어넣을 것인지)
		// bbs.setBbsDate(sdf.format(now));
		//////////////////////////////////////////////////////////////////////////////////
		// 게시물 번호 초기화
		bbs.setBbsID(dao.nextBbsID());
		
		// 글쓰기 기능 실행
		// 성공 : 0, 실패 : -1
		int result = dao.write(bbs);
		
		// 글쓰기 성공
		if(result == 0) {
			
			// 성공시 게시판 목록으로 이동
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href = 'bbs.jsp';");
			script.println("</script>");
		}
		// 글쓰기 실패
		else {
			
			// 실패시 알림창을 띄운 뒤, 뒤로 보냄
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생했습니다');");
			script.println("history.back();");
			script.println("</script>");
		}
		
		
%>
