package data;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Date;
import java.util.Hashtable;

public class Industry extends DatabaseAPI{
	private String name;
	private String owner;
	private String email;
	private String contact;
	private String password;
	private String address;
	private String city;
	private String pincode;
	private String token;
	private Report trashReport;
	private TrashProduction trashProduce;
	private Hashtable<Date,Request> dealersRequest;
	private String status;
	private static Connection connect;
	private static PreparedStatement insertStatement;
	private static String insertQuery;
	
	
	public Industry(String name, String owner, String email, String password,String contact, String address, String city, String pincode,String token,String status) {
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
	public Report getTrashReport() {
		return trashReport;
	}
	public void setTrashReport(Report trashReport) {
		this.trashReport = trashReport;
	}
	public TrashProduction getTrashProduce() {
		return trashProduce;
	}
	public void setTrashProduce(TrashProduction trashProduce) {
		this.trashProduce = trashProduce;
	}
	public Hashtable<Date, Request> getDealersRequest() {
		return dealersRequest;
	}
	public void setDealersRequest(Hashtable<Date, Request> dealersRequest) {
		this.dealersRequest = dealersRequest;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}

	public void addToDatabase()throws SQLException, ClassNotFoundException {
		Class.forName("com.mysql.jdbc.Driver");
		connect = DriverManager.getConnection(url,user,DatabaseAPI.password);

		if(connect == null){
			System.out.println("Connection unsuccessfull!");
		}else {
			System.out.println("Connection successfull!");
			insertQuery = "insert into industry values(?,?,?,?,?,?,?,?,?,?,?,?)";
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
			insertStatement.setFloat(9,0.00f);	
			insertStatement.setFloat(10,0.00f);
			
			int result = insertStatement.executeUpdate();
			if(result > 0) {
				System.out.println("Industry added to database!");
			}else {
				System.out.println("Couldn't add Industry to database!");
			}
		}
	}
	
	public void deleteFromDatabase() {
	
		
	}	
}
