<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.io.PrintWriter" %>
<%@ page import = "bbs.*" %>
		
<%
		// 세션값 저장하는 userId 변수 생성
		String userId = null;
		
		// 로그인 상태인지 검사
		if(session.getAttribute("userId") != null) {
			userId = (String) session.getAttribute("userId");
		}
		
		// 로그인 상태가 아니면 main으로 이동
		if(userId == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 필요합니다.');");
			script.println("location.href = 'main.jsp';");
			script.println("</script>");
		}
		
		// bbsID 파라미터를 저장할 변수 선언
		int bbsID = 0;
		
		// bbsID 파라미터가 존재 하는지 검사
		if(request.getParameter("bbsID") != null) {
			bbsID = Integer.parseInt(request.getParameter("bbsID"));			
		}
		
		// bbsID 파라미터를 받아오지 못하면 bbs로 이동
		if(bbsID == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('적절한 게시물 번호가 아닙니다.');");
			script.println("location.href = 'bbs.jsp';");
			script.println("</script>");
			}
		
		// BBS 테이블 DataAccessObject 객체 생성
		// 작성자와 로그인한 세션값이 같아야한다.
		BbsDAO dao = new BbsDAO();
		
		// 해당 게시글 번호에 해당하는 bbs 객체 불러오기
		Bbs bbs = dao.getBbs(bbsID); 
		
		// bbs 객체가 null 인지 검사
		if(bbs == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('존재하지 않는 게시물입니다.');");
			script.println("location.href = 'bbs.jsp';");
			script.println("</script>");
		}
		
		// 로그인된 유저와 게시물 작성자가 동일한지 검사
		else if(!userId.equals(bbs.getUserID())) { // 동일하지 않으면 실행!
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('작성자만 삭제를 할 수 있습니다.');");
			script.println("location.href = 'bbs.jsp';");
			script.println("</script>");
			
		} else {
			

			// 삭제 기능 수행
			// 0 : 성공, -1 : 실패
			int result = dao.delete(bbsID);
		
			// 삭제 성공시 bbs로 이동
			if(result == 0) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('삭제 완료!');");
				script.println("location.href = 'bbs.jsp';");
				script.println("</script>");
			}
			
			// 삭제 실패시 이전 페이지로 이동
			else if (result == -1) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('삭제에 실패했습니다.');");
				script.println("history.back()");
				script.println("</script>");
			}
			
		}
		
		
%>