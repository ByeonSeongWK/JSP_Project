<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.io.PrintWriter" %>
<%@ page import = "bbs.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%-- update.jsp 페이지로 부터 파라미터를 받아와서 bean 객체 생성 및 초기화 --%>
<%-- bbsID 			: 게시물 번호 --%>
<%-- bbsTitle 		: 게시물 제목 --%>
<%-- bbsContent 	: 게시물 내용--%>
<jsp:useBean id = "bbs" class = "bbs.Bbs" scope = "page" />
<jsp:setProperty name = "bbs" property = "bbsID" />
<jsp:setProperty name = "bbs" property = "bbsTitle" />
<jsp:setProperty name = "bbs" property = "bbsContent" />
<jsp:setProperty name = "bbs" property = "userID" />

<%
		//  세션 검증 - 세션 없으면 main으로 돌려 보냄
		String userId = null;
		if(session.getAttribute("userId") != null) {
			userId = (String) session.getAttribute("userId");
		}

		//ㆍbean 객체의 bbsID, bbsTitle, bbsContent, userID 값중 하나라도 null인지 검증
		//└─ null이면 올바르지 않은 접근이라 알려주고 bbs로 돌려보냄
		
		if(bbs.getBbsID() == 0 || bbs.getBbsTitle() == null || bbs.getBbsContent() == null || bbs.getUserID() == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('올바르지 않은 접근입니다.');");
			script.println("location.href = 'bbs.jsp';");
			script.println("</script>");
		}
		
		// ㆍ로그인 유저와 작성자 비교
		// └─ 다르면 작성자만 수정할 수 있다 알려주고 bbs로 돌려보냄
		if(!userId.equals(bbs.getUserID())) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('작성자만 수정할 수 있습니다.');");
			script.println("location.href = 'bbs.jsp';");
			script.println("</script>");
		}
		// DAO 객체 dao에서 update 메서드 실행하고 결과 받음
		// 0	이면 성공이니 , view.jsp에 parameter name : bbsID, value : bbs.bbsID 값을 전달 받음
		// -1 이면 실패이니 실패라 알려주고 이전 페이지로 돌려보냄
		BbsDAO dao = new BbsDAO();
		
		int result = dao.update(bbs);
		 
		if(result == 0){
			PrintWriter script = response.getWriter();
			script.println("<script>");									//   ↓ 이렇게 받아와야 올바른 값이 전달된다.  
			script.println("location.href = 'view.jsp?bbsID=" + bbs.getBbsID() + "';");
			// ? 파라미터 이름 = 전달할 value(값) 
			script.println("</script>");
		} 
		else if(result == -1) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('게시물 수정에 실패했습니다.');");
			script.println("history.back()");
			script.println("</script>");
		}
		
%>