package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import jdbc.ConnectionFactory;
import models.ContactList;
import models.User;

public class ContactListDao {
	private Connection connection;
	
	public ContactListDao(){
		this.connection = new ConnectionFactory().getConnection();
	}
	
	public void recordContactRequest(ContactList contactList){
		String sql = "INSERT INTO contact_list "
				+ "(user_id, contact_id, accepted) "+
				"VALUES(?, ?, ?)";
		try {
			// Prepared statement to insertion
			PreparedStatement stmt = connection.prepareStatement(sql);
			
			stmt.setInt(1, contactList.getUserId());
			stmt.setInt(2, contactList.getContactId());
			stmt.setBoolean(3, contactList.isAccpeted());
						
			// Execute insertion operation
			stmt.execute();
			stmt.close();
			
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
	}
	
	public ArrayList<ContactList> getContactListRequest(int userId){
		ArrayList<ContactList> contactListRequest = new ArrayList<ContactList>();
		PreparedStatement stmt;
		String sql = "SELECT * FROM contact_list WHERE contact_id = " + userId + " AND accepted = 0";
		ContactListDao clDao = new ContactListDao();
		try {
			stmt = this.connection.prepareStatement(sql);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				// Creating object user
				//User u = userDao.getUser(rs.getInt("user_id"));
				ContactList cl = new ContactList();
				cl.setId(rs.getInt("id"));
				cl.setUserId(rs.getInt("user_id"));
				cl.setContactId(rs.getInt("contact_id"));
				cl.setAccpeted(rs.getBoolean("accepted"));
				contactListRequest.add(cl);
			}
			return contactListRequest;
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
	}
	
	public ArrayList<User> getContactsRequest(int userId){
		ArrayList<User> contactsRequest = new ArrayList<User>();
		PreparedStatement stmt;
		String sql = "SELECT * FROM contact_list WHERE contact_id = " + userId + " AND accepted = 0";
		UserDao userDao = new UserDao();
		try {
			stmt = this.connection.prepareStatement(sql);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				// Creating object user
				User u = userDao.getUser(rs.getInt("user_id"));
				contactsRequest.add(u);
			}
			return contactsRequest;
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
	}
	
	public ArrayList<User> getContacts(int userId){
		ArrayList<User> contacts = new ArrayList<User>();
		PreparedStatement stmt;
		String sql = "SELECT * FROM contact_list WHERE user_id = ? AND accepted = 1";
		UserDao userDao = new UserDao();
		try {
			stmt = this.connection.prepareStatement(sql);
			stmt.setInt(1, userId);;
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				// Creating object user
				User u = userDao.getUser(rs.getInt("contact_id"));
				contacts.add(u);
			}
			return contacts;
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
	}
	
	public ContactList getContactList(int clId){
		String sql = "SELECT * FROM contact_list WHERE id = ?";
		PreparedStatement stmt;
		try {
			stmt = this.connection.prepareStatement(sql);
			stmt.setInt(1, clId);
			ResultSet rs = stmt.executeQuery();
			ContactList cl = new ContactList();
			while (rs.next()) {
				// Creating object ContactList				
				cl.setId(rs.getInt("id"));
				cl.setUserId(rs.getInt("user_id"));
				cl.setContactId(rs.getInt("contact_id"));
				cl.setAccpeted(rs.getBoolean("accepted"));
			}
			return cl;
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
	}
	
	public void acceptContactRequest(int reqId){
		String sql1 = "UPDATE contact_list SET accepted = '1' WHERE contact_list.id = ?";
		ContactList cl = this.getContactList(reqId);
		System.out.println(cl.getId());
		String sql2 = "INSERT INTO contact_list(user_id, contact_id, accepted) VALUES (?, ?, 1);";
		try {
			PreparedStatement stmt = this.connection.prepareStatement(sql1);
			stmt.setInt(1, reqId);
			stmt.executeUpdate();
			stmt = this.connection.prepareStatement(sql2);
			stmt.setInt(1, cl.getContactId());
			stmt.setInt(2, cl.getUserId());
			stmt.executeUpdate();
			stmt.close();
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
	}
	
	public void deleteContactRequest(int reqId){
		String sql = "DELETE FROM `contact_list` WHERE `id` = ?";
		try {
			PreparedStatement stmt = this.connection.prepareStatement(sql);
			stmt.setInt(1, reqId);
			stmt.executeUpdate();
			stmt.close();
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
	}
}
