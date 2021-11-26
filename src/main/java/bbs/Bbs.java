package bbs;

// BBS 테이블에 대한 JavaBean 객체를 생성하기 위한 클래스
public class Bbs {
	
	// Bbs 객체의 멤버변수 선언
	// Bbs JavaBean의 프로퍼티 선언
	private int 		bbsID;
	private String 	bbsTitle;
	private String	bbsContent;
	private String	bbsDate;
	private String 	userID;
	private int 		bbsAvailable;
	
	// 기본 생성자
	public Bbs() {}

	// 모든 멤버변수를 초기화 해주는 생성자
	public Bbs(int bbsID, String bbsTitle, String bbsContent, String bbsDate, String userID, int bbsAvailable) {
		this.bbsID 			= bbsID;
		this.bbsTitle 			= bbsTitle;
		this.bbsContent		= bbsContent;
		this.bbsDate 		= bbsDate;
		this.userID 			= userID;
		this.bbsAvailable 	= bbsAvailable;
	}

	// Getter, Setter 메서드
	public int getBbsID() {
		return bbsID;
	}

	public void setBbsID(int bbsID) {
		this.bbsID = bbsID;
	}

	public String getBbsTitle() {
		return bbsTitle;
	}

	public void setBbsTitle(String bbsTitle) {
		this.bbsTitle = bbsTitle;
	}

	public String getBbsContent() {
		return bbsContent;
	}

	public void setBbsContent(String bbsContent) {
		this.bbsContent = bbsContent;
	}

	public String getBbsDate() {
		return bbsDate;
	}

	public void setBbsDate(String bbsDate) {
		this.bbsDate = bbsDate;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public int getBbsAvailable() {
		return bbsAvailable;
	}

	public void setBbsAvailable(int bbsAvailable) {
		this.bbsAvailable = bbsAvailable;
	}
	
}
