package models;

public class ContactList {
	private int id;
	private int userId;
	private int contactId;
	private boolean accpeted;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public int getContactId() {
		return contactId;
	}
	public void setContactId(int contactId) {
		this.contactId = contactId;
	}
	public boolean isAccpeted() {
		return accpeted;
	}
	public void setAccpeted(boolean accpeted) {
		this.accpeted = accpeted;
	}
}
