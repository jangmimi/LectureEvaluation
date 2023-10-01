package util;

import java.security.MessageDigest;

public class SHA256 {

	public static String getSHA256(String input) {
		StringBuffer result = new StringBuffer();
		
		try {
			MessageDigest digest = MessageDigest.getInstance("SHA-256");
//			byte[] salt = "Hello! This is Salt.".getBytes();
//			digest.reset();
//			digest.update(salt);
//			byte[] chars = digest.digest(input.getBytes("UTF-8"));
//			for(int i=0; i<chars.length; i++) {
//				String hex = Integer.toHexString(0xff & chars[i]);
//				if(hex.length() == 1) result.append("0");
//				result.append(hex);
//			}
			// 데이터(패스워드 평문)를 한다. 즉 '암호화'와 유사한 개념
			digest.update(input.getBytes("UTF-8"));
			
			// 바이트 배열로 해쉬를 반환한다.
			byte[] sha256Hash = digest.digest();
			
			// StringBuffer 객체는 계속해서 append를 해도 객체는 오직 하나만 생성된다. => 메모리 낭비 개선
			StringBuffer hexSHA256hash = new StringBuffer();
			
			// 256비트로 생성 => 32Byte => 1Byte(8bit) => 16진수 2자리로 변환 => 16진수 한 자리는 4bit
			for(byte b : sha256Hash) {
				String hexString = String.format("%02x", b);
				hexSHA256hash.append(hexString);
			}
			result = hexSHA256hash;
		} catch(Exception e) {
			e.printStackTrace();
		}
		return result.toString();
	}
}
