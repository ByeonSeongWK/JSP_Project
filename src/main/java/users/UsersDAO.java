package users;

import java.sql.*;

import util.Database;

// Data access Object
// Users 테이블과 관련된 데이터베이스 접근 객체 생성을 위한 클래스
public class UsersDAO {

		// 어떠한 메소드에서도 사용할 수 있게 전역 변수 선언
		private Connection con 					= null;	// 커넥션 멤버 객체 선언
		private PreparedStatement pstmt 	= null;	// statement 멤버 객체 선언
		private ResultSet rs 						= null; 	// ResultSet 멤버 객체 선언
		private String sql 							= null;	// sql 문을 설정할 멤버변수 선언
//		private : 외부에선 사용할 수 없도록 선언
		
		// UsersDAO 생성자
		public UsersDAO() {
				con = Database.oracleConnect();
		}
	
		// 회원가입 기능 메소드
		// parameter	: Users
		// return 		: 성공시 -> 0, 아이디 중복(데이터베이스 오류) -> -1, 
		public int join(Users users) {
			
			// 반환할 int 변수 선언
			int result = 0;
			
			// SQL문 초기화
			sql = "INSERT INTO USERS VALUES (?, ?, ?, ?, ?)";
			
			// SELECT sql 실행 시도
			try {
				
				// sql문 작성
				pstmt = con.prepareStatement(sql); 
			
				// sql문 완성
				pstmt.setString(1, users.getUserId());		// 1번째 물음표에 user에 있는 getUserId 메소드에서 받아온 값을 넣겠다.
				pstmt.setString(2, users.getUserPw());
				pstmt.setString(3, users.getUserName());
				pstmt.setString(4, users.getUserName());
				pstmt.setString(5, users.getUserEmail());
				
				// statement에 작성된 sql문 실행
				pstmt.executeUpdate();
				
			// 예외 발생시 실행될 구문
			} catch(Exception e) {				
				e.printStackTrace();
				result = -1;
				// 에러가 났을땐 result를 -1로 초기화
				
			} finally {
				// 사용한 자원 반납
				// 오류가 나든 안나든 close는 해줘야 한다.
				// └──> 그래서 finally(오류가 나든 안나든 실행해주는 구문)에  넣어둔다
				Database.close(con, pstmt);
			}
			return result;
		
		}
		// 로그인 기능에 대한 메서드
		// parameter	: Users
		// return 		: 0 - 로그인 성공, 1 - 로그인 정보 불일치, -1  - 데이터베이스 오류
		public int login(Users users) { // Users users를 잘 봐야한다. 어디서 써야하는지 ★
			
			// 반환할 int 선언
			int result = 0;
			
			// USERS 테이블에 해당 userID, userPassword 값에 대한 행이 존재하는지 검사하는 sql문 작성
			sql = "SELECT * FROM USERS WHERE userID = ? AND userPassword = ?";
			
			try {
			
				// statement에 sql문 작성
				pstmt = con.prepareStatement(sql);
				
				// sql문 완성 
				pstmt.setString(1, users.getUserId());
				pstmt.setString(2, users.getUserPw());
				// ★ 여기서 사용
				
				// sql문 실행
				// SELECT sql 문이라서 ResultSet 으로 받음, executeQuery() 사용
				rs = pstmt.executeQuery();
			
				// ResultSet에 다음 커서가 존재하지 않을 경우
				// (검색결과가 없음) - 로그인 정보 불일치 
				if(!rs.next()) {
					result = 1;
				}
				// 검색했을때 아무것도 나오지 않는 상태(빈 테이블값)
				
			} catch(Exception e) {
					e.printStackTrace();
					
					// 데이터베이스 오류
					result = -1;
			} finally {
				Database.close(con, pstmt, rs); // SELECT 구문이라 ResultSet까지 close() 해준다.
			}
			
			return result;
			
		}

}
// DB에서 오류나는 것은 PRIMARY KEY 에서 말고는 없다. /// 아이디 중복