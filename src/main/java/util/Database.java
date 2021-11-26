package util;

import java.sql.*;

// 데이터베이스와 관련된 기능을 모아둔 클래스
public class Database {
			
		/***** 오라클 127.0.0.1:1521:xe, dba_user 접속하는 메소드 *****/
		public static Connection oracleConnect() {
			
			// 반환할 Connection 객체 선언
			Connection con = null;
			// null 값으로 선언을 해줘야 한다. 그래야 밑에서 사용 가능
			
			// 정확하게 하려면 final을 붙여줘야 한다.(바뀌면 안되는 변수기 때문에 상수로 선언해줘야한다.)
			// 상수 형태로 데이터베이스 url, 데이터베이스 사용자 id, 데이터 베이스 사용자 패스워드 선언.
			final String URL	= "jdbc:oracle:thin:@127.0.0.1:1521:xe";
			final String ID 	= "dba_user";
			final String PW 	= "6546";
			
			// 데이터베이스 접속 시도
			try {
			// 오라클 jdbc 로드
			Class.forName("oracle.jdbc.driver.OracleDriver");
			
			// 데이터베이스 접속
			con = DriverManager.getConnection(URL, ID, PW);
			
			} catch(Exception e) {
				e.printStackTrace();
			}
			return con;	// Connection 객체 꼭 반환
		}
		
		// executeUpdate 실행 후 close 메소드 /// 오버 로딩
		public static void close(Connection con, PreparedStatement pstmt) {	// void라서 return은 따로 해줄 필요가 없다.
			try {
				if(pstmt 	!= null) pstmt.close(); 	// prepareStatement close
				if(con 		!= null) con.close();		// connection close
			} catch(Exception e) {
				e.printStackTrace();
			}
		}
		// executeQuery 실행 후 close 메소드 	/// 오버 로딩
		public static void close(Connection con, PreparedStatement pstmt, ResultSet rs) {
			try {
				if(rs		!= null) rs.close();		// resultset close
				if(pstmt	!= null) pstmt.close(); 	// preparestatement close
				if(con 	!= null) con.close();		// connection close
			} catch(Exception e) {
				e.printStackTrace();
			}
		}
	
}
