package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import util.DatabaseUtil;

public class UserDAO {

	public int login(String userID, String userPwd) {
		String sql = "SELECT userPwd FROM USER WHERE userID = ?";
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getString(1).equals(userPwd)) {
					return 1;
				} else {
					return 0;	// 아이디 존재, 비밀번호 틀림
				}
			}
			return -1;	// 아이디 없음
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if(conn != null) { try { conn.close(); } catch (SQLException e) { e.printStackTrace(); } }
			if(pstmt != null) { try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); } }
			if(rs != null) { try { rs.close(); } catch (SQLException e) { e.printStackTrace(); } }
		}
		return -2;	// DB 오류
	}
	
	public int join(UserDTO user) {
		String sql = "INSERT INTO USER VALUES (?, ?, ?, ?, false)";
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPwd());
			pstmt.setString(3, user.getUserEmail());
			pstmt.setString(4, user.getUserEmailHash());

			return pstmt.executeUpdate();	
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if(conn != null) { try { conn.close(); } catch (SQLException e) { e.printStackTrace(); } }
			if(pstmt != null) { try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); } }
			if(rs != null) { try { rs.close(); } catch (SQLException e) { e.printStackTrace(); } }
		}
		return -1;	// 회원가입 실패
	}
}
