package users;
// Users 테이블의 JavaBean
public class Users {
	// 처음 개발 습관 주석 꼭 달기
	private String userId;			// 유저 아이디
	private String userPw;			// 유저 비밀번호
	private String userName;		// 유저 이름
	private String userGender;	// 유저 성별
	private String userEmail;		// 유저 이메일

	// 기본 생성자
	public Users() {}
	
	// 모든 멤버변수 초기화하는 생성자
	public Users(String userId, String userPw, String userName, String userGender, String userEmail) {
		this.userId 			= userId;
		this.userPw 			= userPw;
		this.userName 	 	= userName;
		this.userGender 	= userGender;
		this.userEmail 		= userEmail;
	}

	// 각 멤버변수들의 Getters and Setters
	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserPw() {
		return userPw;
	}

	public void setUserPw(String userPw) {
		this.userPw = userPw;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserGender() {
		return userGender;
	}

	public void setUserGender(String userGender) {
		this.userGender = userGender;
	}

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}
	
	
}
