package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import jdbc.ConnectionFactory;
import models.User;
import security.Hashing;

public class UserDao {
	// Connection with database
	private Connection connection;
	
	public UserDao(){
		this.connection = new ConnectionFactory().getConnection();
	}
	
	public void addUser(User user){
		String sql = "INSERT INTO user "
				+ "(name, user_name, email, password_hash, registration_date, photo_file) "+
				"VALUES(?, ?, ?, ?, ?, ?)";
		try {
			// Prepared statement to insertion
			PreparedStatement stmt = connection.prepareStatement(sql);
			String formatedDate= new SimpleDateFormat("yyyy-MM-dd").format(user.getRegistrationDate());
			
			stmt.setString(1, user.getName());
			stmt.setString(2, user.getUserName());
			stmt.setString(3, user.getEmail());
			stmt.setString(4, user.getPasswordHash());
			stmt.setString(5, formatedDate);
			stmt.setString(6, user.getPhotoFile());
			
			// Execute insertion operation
			stmt.execute();
			stmt.close();
			
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
	}
	
	public User authUser(String userName, String password){
        String passwordHash = Hashing.getMD5Hash(password);
		PreparedStatement stmt;
		try {
			stmt = this.connection.
					prepareStatement("SELECT * FROM user WHERE user_name LIKE '" + userName +
							"' AND password_hash LIKE '" + passwordHash + "'");
			ResultSet rs = stmt.executeQuery();
			if(!rs.isBeforeFirst()){ // User was not found
				return null;
			}else{
				User u = new User();
				while (rs.next()) {
					// Creating object user
					u.setId(rs.getInt("id"));
					u.setName(rs.getString("name"));
					u.setUserName(rs.getString("user_name"));
					u.setEmail(rs.getString("email"));
					u.setPasswordHash(rs.getString("password_hash"));
				}
				return u;
			}
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
	}

	public User getUser(int userID){
		PreparedStatement stmt;
		try {
			stmt = this.connection.
					prepareStatement("SELECT * FROM user WHERE id = " + userID);
			ResultSet rs = stmt.executeQuery();
			if(!rs.isBeforeFirst()){ // User was not found
				return null;
			}else{
				User u = new User();
				while (rs.next()) {
					// Creating object user
					u.setId(rs.getInt("id"));
					u.setName(rs.getString("name"));
					u.setUserName(rs.getString("user_name"));
					u.setEmail(rs.getString("email"));
					u.setPasswordHash(rs.getString("password_hash"));
					u.setRegistrationDate(rs.getDate("registration_date"));
					u.setPhotoFile(rs.getString("photo_file"));
				}
				return u;
			}
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
	}

	public void updateUserInfo(User user){
		String sql = "UPDATE user SET name = ?, user_name = ?, email = ? WHERE user.id = ?;";
		// Prepared statement to update
		try {
			PreparedStatement stmt = connection.prepareStatement(sql);
			stmt.setString(1, user.getName());
			stmt.setString(2, user.getUserName());
			stmt.setString(3, user.getEmail());
			stmt.setInt(4, user.getId());
			
			// Execute update operation
			stmt.execute();
			stmt.close();
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
	}
	
	public void updateUserPassword(User user){
		String sql = "UPDATE user SET password_hash = ? WHERE user.id = ?;";
		try {
			PreparedStatement stmt = connection.prepareStatement(sql);
			
			stmt.setString(1, user.getPasswordHash());
			stmt.setInt(2, user.getId());
			
			// Execute update operation
			stmt.execute();
			stmt.close();
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
	}
	
	public void updateUserStatus(int userID, String status){
		String sql = "UPDATE user SET status = ? WHERE user.id = ?;";
		try {
			PreparedStatement stmt = connection.prepareStatement(sql);
			
			stmt.setString(1, status);
			stmt.setInt(2, userID);
			
			// Execute update operation
			stmt.execute();
			stmt.close();
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
	}
}
