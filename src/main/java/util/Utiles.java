package util;

import java.util.Date;
import java.text.SimpleDateFormat;

public class Utiles {

	// 현재 날짜를 yyyy-MM-dd HH:mm 형식의 문자열로 반환하는 메서드
	// parameter	: 없음
	// return 		: 현재 시간의 yyyy-MM-dd HH:mm 포멧의 문자열
	public static String getToday() {
		// 현재 시간 반환
		Date now = new Date();

		// 시간 타입 yyyy-MM-dd HH:mm으로 변환하여 bbsDate에 저장(초기화)
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");

		// 데이트 포멧으로 바뀐 문자열 반환
		return sdf.format(now);

	}
}
