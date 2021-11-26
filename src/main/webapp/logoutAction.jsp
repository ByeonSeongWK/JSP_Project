<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

		// 로그아웃을 위해 모든 세션 종료
		session.invalidate();
		response.sendRedirect("main.jsp");

%>