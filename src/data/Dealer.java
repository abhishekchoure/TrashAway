package data;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class Dealer extends DatabaseAPI{
	private String name;
	private String owner;
	private String email;
	private String contact;
	private String password;
	private String address;
	private String city;
	private String pincode;
	private Report trashReport;
	private TrashCollection trashCollected;
	private Request newRequest;
	private String destination;
	private static Connection connect;
	private static PreparedStatement insertStatement;
	private static String insertQuery;
	private String token,status;
	
	public Dealer(String name, String owner, String email, String password, String contact, String address, String city, String pincode,String token,String status) {
		super();
		this.name = name;
		this.owner = owner;
		this.email = email;
		this.password = password;
		this.contact = contact;
		this.address = address;
		this.city = city;
		this.pincode = pincode;
		this.token = token;
		this.status = status;
	}
	
	
	public String getOwner() {
		return owner;
	}


	public void setOwner(String owner) {
		this.owner = owner;
	}


	public String getContact() {
		return contact;
	}

	public void setContact(String contact) {
		this.contact = contact;
	}

	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public String getPincode() {
		return pincode;
	}
	public void setPincode(String pincode) {
		this.pincode = pincode;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Report getTrashReport() {
		return trashReport;
	}
	public void setTrashReport(Report trashReport) {
		this.trashReport = trashReport;
	}
	public TrashCollection getTrashCollected() {
		return trashCollected;
	}
	public void setTrashCollected(TrashCollection trashCollected) {
		this.trashCollected = trashCollected;
	}
	public Request getNewRequest() {
		return newRequest;
	}
	public void setNewRequest(Request newRequest) {
		this.newRequest = newRequest;
	}
	public String getDestination() {
		return destination;
	}
	public void setDestination(String destination) {
		this.destination = destination;
	}


	@Override
	public void addToDatabase() throws SQLException, ClassNotFoundException {
		Class.forName("com.mysql.jdbc.Driver");
		connect = DriverManager.getConnection(url,user,DatabaseAPI.password);

		if(connect == null){
			System.out.println("Connection unsuccessfull!");
		}else {
			insertQuery = "insert into dealer values(?,?,?,?,?,?,?,?,?,?,?,?)";
			insertStatement = connect.prepareStatement(insertQuery);
			insertStatement.setString(1,name);
			insertStatement.setString(2,owner);
			insertStatement.setString(3,email);
			insertStatement.setString(4,password);
			insertStatement.setString(5,contact);
			insertStatement.setString(6,address);
			insertStatement.setString(7,city);
			insertStatement.setString(8,pincode);	
			insertStatement.setString(11,token);	
			insertStatement.setString(12,status);	
			insertStatement.setFloat(9,0.0f);
			insertStatement.setFloat(10,0.0f);
			int result = insertStatement.executeUpdate();
			if(result > 0) {
				System.out.println("Dealer added to database!");
			}else {
				System.out.println("Couldn't add dealer to database!");
			}
		}
	}

	@Override
	public void deleteFromDatabase() throws SQLException, ClassNotFoundException {
		
		
	}
}
