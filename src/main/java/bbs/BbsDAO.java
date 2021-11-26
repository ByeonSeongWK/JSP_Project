package bbs;

import java.sql.*;
import java.util.ArrayList;

import util.Database;

// BBS 테이블 데이터에 접근하는 객체를 만들기 위한 클래스
public class BbsDAO {

	private Connection con = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;

	// BbsDAO 객체가 만들어지자 마자 데이터베이스 접속
	public BbsDAO() {
		con = Database.oracleConnect();
	}
	
	// 다음 게시글 번호 불러오기 메서드
	// parameter	: 없음
	// return		: 게시글이 존재 하면 bbsID 값의 최대값 반환, 존재하지 않으면 1 반환
	public int nextBbsID() {

		// 반환할 int 변수 선언
		int result = 1;
		// SELECT SQL 문
		final String SQL = "SELECT COUNT(bbsID) FROM BBS";
									// BBS 테이블에 bbsID 컬럼값이 null이 몇개인지 반환
		
		try {
				// statement에 SQL문 작성
			pstmt = con.prepareStatement(SQL);
			
			// SQL문 실행
			rs = pstmt.executeQuery();
			
			// 반환된 bbsID 개수에 + 1
			if (rs.next()) {
				result = rs.getInt(1) + 1;
			}
			
		} catch(Exception e) {
			e.printStackTrace();
			result = -1;
		}
		
		return result;
	}
	
	// 게시글 쓰기 메서드
	// parameter	: Bbs
	// return		: 성공 -> 0, 실패(데이터베이스 오류) -> -1
	public int write(Bbs bbs) {
		
		// 반환할 int 변수 선언
		int result = 0;
		
		// 삽입문
		final String SQL = "INSERT INTO BBS VALUES(?, ?, ?, TO_DATE(?, 'YYYY-MM-DD HH24:MI'), ?, ?)";
																							
		try {
			// statement에 SQL 작성
			pstmt = con.prepareStatement(SQL);
			
			// SQL 완성
			pstmt.setInt(1, bbs.getBbsID());
			pstmt.setString(2, bbs.getBbsTitle());
			pstmt.setString(3, bbs.getBbsContent());
			// String 형이 아니라 Date타입으로 저장되어 있다.
			pstmt.setString(4, bbs.getBbsDate());
			pstmt.setString(5, bbs.getUserID());
			pstmt.setInt(6, bbs.getBbsAvailable());
			
			// SQL 실행
			pstmt.executeUpdate();
			
		} catch(Exception e) {
			e.printStackTrace();
			
			// 데이터 베이스 오류
			result = -1;
		} finally {
			// 예외처리가 나든 안나든 close 실행
			Database.close(con, pstmt);
		}
		
		return result;
	}
	
	// 게시글 목록 불러오기 메서드
	// parameter	: 페이지 번호, 다음 게시물 번호
	// return 		: 최대 10개 짜리 BBS 객체 리스트 (목록)	
	
	public ArrayList<Bbs> getList(int pageNumber, int nextId) {
		
		// 반환 할 Bbs 리스트 선언 및 생성
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		
		// SQL문
		final String SQL = "SELECT * FROM( SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 0 ORDER BY bbsID DESC ) WHERE ROWNUM <= 10";
		
		try {
			// statement에 SQL문 작성
			pstmt = con.prepareStatement(SQL);
			
			// SQL 문 완성
								// 게시물 목록 공식 (총 페이지 목록 - (현재 페이지 - 1 ) * 나타낼 페이지 개수)
			pstmt.setInt(1, nextId - (pageNumber - 1) * 10);
			 
			// SQL 문 실행
			rs = pstmt.executeQuery();
			// executeQuery에 반환값은 ResultSet이다.
			
			// 검색한 결과를 리스트에 담음
			while(rs.next()) {
				
				// 리스트 요소로 담을 객체 생성
				Bbs bbs = new Bbs();
				
				// bbs 객체 초기화
				bbs.setBbsID				(rs.getInt(1));
				bbs.setBbsTitle			(rs.getString(2));
				bbs.setBbsContent	(rs.getString(3));
				bbs.setBbsDate			(rs.getString(4));
				bbs.setUserID			(rs.getString(5));
				bbs.setBbsAvailable	(rs.getInt(6));
				
				// 완성된 bbs 객체를 리스트에 추가
				list.add(bbs);				
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return list;
		
	}
	
	// 다음 게시판 목록이 존재하는지 확인하는 메서드
	// parameter	: 페이지 번호, 다음 게시글 번호
	// return 		: 존재 - true, 존재하지 않음 - false
	public boolean isNextPage(int pageNum, int nextId) {
		
		// 반환할 boolean 타입 변수 선언
		boolean result = false;
		
		// SQL문
		final String SQL = "SELECT * FROM( SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 0 ORDER BY bbsID DESC ) WHERE ROWNUM <= 10";
		
		try {
			// statement에 SQL문 작성
			pstmt = con.prepareStatement(SQL);
			
			// SQL문 완성
			pstmt.setInt(1, nextId - (pageNum - 1) * 10);

			// SQL문 실행
			rs = pstmt.executeQuery();
			
			// 만약에 결과가 존재한다면 반환값을 true로 바꿈
			if(rs.next()) result = true;
			
		} catch(Exception e) {
			e.printStackTrace();
		} 
		
		return result;
		
	}
	
	// 게시물 번호를 기준으로 해당 게시물의 내용을 불러오는 메서드
	// parameter	: 해당 게시물 번호
	// return		: 해당 게시물의 Bbs 객체
	public Bbs getBbs(int bbsID) {
		
		// 반환할 Bbs 객체 선언
		Bbs bbs = null;
		
		// SQL문																		↓ 구분자에 대해선 1 or 0개가 나온다.
		final String SQL = "SELECT * FROM BBS WHERE bbsID = ?";
		
		try {
			// statement에 SQL문 작성
			pstmt = con.prepareStatement(SQL);
			
			// SQL문 완성
			pstmt.setInt(1, bbsID);
			
			// SQL문 실행
			rs = pstmt.executeQuery();

			// 결과가 존재하는지 검사
			if(rs.next()) {
				// 존재 한다면 bbs 객체에 데이터 초기화
				bbs = new Bbs(
						rs.getInt(1),
						rs.getString(2), 
						rs.getString(3), 
						rs.getString(4), 
						rs.getString(5), 
						rs.getInt(6)
						);
				
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return bbs;
		
	}
	
	// 게시물 삭제 메서드
	// parameter	: 게시물 번호 
	// return		: 성공 : 0, 실패 : -1
	public int delete(int bbsID) {
		
		// 반환할 int 변수 선언
		int result = 0;
		
		// SQL 문				// 지우더라도 기록을 남기기 위해서 UPDATE 구분
		final String SQL = "UPDATE BBS SET bbsAvailable = 1 WHERE bbsID = ? ";
		
		try {
			
			// statement에 SQL문 작성
			pstmt = con.prepareStatement(SQL);
			
			// SQL 완성
			pstmt.setInt(1, bbsID); // -> ?에 들어갈 값
		
			// SQL 실행
			pstmt.executeUpdate();
			
		} catch(Exception e) {
			e.printStackTrace();
			// 실패시 -1 반환
			result =  -1;
		} finally {
			Database.close(con, pstmt);
		}
		return result;
	}
	
	// 게시물 수정 메서드
	// parameter	: 게시물 번호
	// return 		: 성공 : 0 , 실패 : -1 
	public int update(Bbs bbs) {
		
		// 반환할 int 변수 선언
		int result = 0;
		
		// SQL문 
		final String SQL = "UPDATE BBS SET bbsTitle = ?, bbsContent = ? WHERE bbsID = ?";
		
		try {
		
			// statement에 SQL 작성
			pstmt = con.prepareStatement(SQL);
			
			// SQL문 완성
			pstmt.setString(1, bbs.getBbsTitle());
			pstmt.setString(2, bbs.getBbsContent());
			pstmt.setInt(3, bbs.getBbsID());
			
			// SQL문 실행
			pstmt.executeUpdate();
			
		} catch(Exception e) {
			e.printStackTrace();
			// 실패시 -1
			result = -1;
		} finally {
			Database.close(con, pstmt);
		}	// 이 객체에서 Connection 객체를 쓰느냐 마느냐에 따라 close를 유무
			// 다른 작업을 하기 위해 불러온 것들은 close를 해버리면 DAO에 있는 전체가 닫혀버린다(없어져버림).
			// 다 달아주고 싶으면 일회성 dao를 만들어서 해줘야 한다.
		
		return result;
	}
	
}
