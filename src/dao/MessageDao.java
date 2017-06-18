package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import jdbc.ConnectionFactory;
import models.Message;
import models.User;

public class MessageDao {
private Connection connection;
//private PreparedStatement stmt;
	
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
	
	public ArrayList<Message> getAllUnreadMessages(int userId){
		ArrayList<Message> messages = new ArrayList<Message>();
		String sql = "SELECT * FROM message WHERE recipient_id = ? AND delivered = 0";
		PreparedStatement stmt = null;
		try {
			stmt = this.connection.prepareStatement(sql);
			stmt.setInt(1, userId);			
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				Message m = new Message();
				m.setId(Integer.parseInt(rs.getString("id")));
				m.setSenderId(Integer.parseInt(rs.getString("sender_id")));
				m.setRecipientId(Integer.parseInt(rs.getString("recipient_id")));
				m.setContent(rs.getString("content"));
				m.setDelivery_time(rs.getTimestamp("delivery_time"));
				m.setDelivered(rs.getBoolean("delivered"));
				messages.add(m);
			}
			return messages;
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}finally{
			try {
				stmt.close();
				//this.connection.close();
			} catch (SQLException e) {
				throw new RuntimeException(e);
			}
		}
	}
	
	public ArrayList<String> getUnreadMessagesFromContact(int userId, int contactId){
		ArrayList<String> messages = new ArrayList<String>();
		ArrayList<Integer>messagesDelivered = new ArrayList<Integer>();
		String sql = "SELECT * FROM message WHERE sender_id = " + contactId + " AND recipient_id = " + userId + " AND delivered = 0";
		PreparedStatement stmt = null;
		try {
			stmt = this.connection.prepareStatement(sql);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				messages.add(rs.getString("content"));
				messagesDelivered.add(rs.getInt("id"));
			}
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}finally{
			try {
				stmt.close();
				//this.connection.close();
			} catch (SQLException e) {
				throw new RuntimeException(e);
			}
		}
		// Setar msgs pra lida
		for(int messageId : messagesDelivered){
			this.connection = new ConnectionFactory().getConnection();
			sql = "UPDATE message SET delivered = '1' WHERE message.id = " + messageId;
			try {
				stmt = connection.prepareStatement(sql);
				// Execute update operation
				stmt.execute();
				
			} catch (SQLException e) {
				throw new RuntimeException(e);
			}finally{
				try {
					stmt.close();
					//this.connection.close();
				} catch (SQLException e) {
					throw new RuntimeException(e);
				}
			}
		}
		
		return messages;
	}
	
	public ArrayList<Message> getPreviousMessages(int userId, int contactId){
		ArrayList<Message> messages = new ArrayList<Message>();
		String sql = "SELECT * FROM message WHERE ((sender_id = ? AND recipient_id = ?) OR (sender_id = ? AND recipient_id = ?)) ORDER BY delivery_time";
		PreparedStatement stmt = null;
		try {
			stmt = this.connection.prepareStatement(sql);
			stmt.setInt(1, userId);
			stmt.setInt(2, contactId);
			stmt.setInt(3, contactId);
			stmt.setInt(4, userId);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				Message m = new Message();
				m.setId(Integer.parseInt(rs.getString("id")));
				m.setSenderId(Integer.parseInt(rs.getString("sender_id")));
				m.setRecipientId(Integer.parseInt(rs.getString("recipient_id")));
				m.setContent(rs.getString("content"));
				m.setDelivery_time(rs.getDate("delivery_time"));
				m.setDelivered(rs.getBoolean("delivered"));
				messages.add(m);
			}
			return messages;
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}finally{
			try {
				stmt.close();
				//this.connection.close();
			} catch (SQLException e) {
				throw new RuntimeException(e);
			}
		}
	}
	
	public ArrayList<User> getRecentUsers(int userId){
		ArrayList<User> users = new ArrayList<User>();
		String sql = "SELECT DISTINCT sender_id FROM (SELECT sender_id FROM message WHERE recipient_id = ? ORDER BY delivery_time ASC) AS recent_messsages";
		UserDao uDao = new UserDao();
		PreparedStatement stmt = null;
		try {
			stmt = this.connection.prepareStatement(sql);
			stmt.setInt(1, userId);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				User u = uDao.getUser(rs.getInt("sender_id"));
				users.add(u);
			}
			return users;
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}finally{
			try {
				stmt.close();
				//this.connection.close();
			} catch (SQLException e) {
				throw new RuntimeException(e);
			}
		}
	}
}
