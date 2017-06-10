package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jdbc.ConnectionFactory;
import models.User;

public class UserDao {
	// Connection with database
	private Connection connection;
	
	public UserDao(){
		this.connection = new ConnectionFactory().getConnection();
	}
	
	public void addUser(User user){
		String sql = "INSERT INTO user "
				+ "(name, user_name, email, password_hash) "+
				"VALUES(?, ?, ?, ?)";
		try {
			// Prepared statement to insertion
			PreparedStatement stmt = connection.prepareStatement(sql);
			
			stmt.setString(1, user.getName());
			stmt.setString(2, user.getUserName());
			stmt.setString(3, user.getEmail());
			stmt.setString(4, user.getPasswordHash());
			
			// Execute insertion operation
			stmt.execute();
			stmt.close();
			
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
	}
}
