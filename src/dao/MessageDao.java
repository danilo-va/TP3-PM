package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import jdbc.ConnectionFactory;
import models.Message;

public class MessageDao {
private Connection connection;
	
	public MessageDao(){
		this.connection = new ConnectionFactory().getConnection();
	}
	
	public void recordMessage(Message message){
		String sql = "INSERT INTO message "
				+ "(sender_id, recipient_id, content, delivery_time) "+
				"VALUES(?, ?, ?, ?)";
		try {
			// Prepared statement to insertion
			PreparedStatement stmt = connection.prepareStatement(sql);
			String formatedDateTime= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(message.getDelivery_time());
			
			stmt.setInt(1, message.getSenderId());
			stmt.setInt(2, message.getRecipientId());
			stmt.setString(3, message.getContent());
			stmt.setString(4, formatedDateTime);
						
			// Execute insertion operation
			stmt.execute();
			stmt.close();
			
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
	}
	
	public ArrayList<String> getUnreadMessages(int userId, int contactId){
		ArrayList<String> messages = new ArrayList<String>();
		ArrayList<Integer>messagesDelivered = new ArrayList<Integer>();
		String sql = "SELECT * FROM message WHERE sender_id = " + contactId + " AND recipient_id = " + userId + " AND delivered = 0";
		PreparedStatement stmt;
		try {
			stmt = this.connection.prepareStatement(sql);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				messages.add(rs.getString("content"));
				messagesDelivered.add(rs.getInt("id"));
			}
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
		// Setar msgs pra lida
		for(int messageId : messagesDelivered){
			sql = "UPDATE message SET delivered = '1' WHERE message.id = " + messageId;
			try {
				stmt = connection.prepareStatement(sql);
				// Execute update operation
				stmt.execute();
				stmt.close();
			} catch (SQLException e) {
				throw new RuntimeException(e);
			}
		}
		
		return messages;
	}
}
