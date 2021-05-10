package data;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class Trash {
	private String type;
	private double quantity;
	private double price;
	private double total_price;
	private double recyclability;
	private static Connection connect;
	private static PreparedStatement insertStatement;
	private static String insertQuery;
	private static final String url = "jdbc:mysql://localhost:3306/trashaway";

	public Trash(String type, double quantity, double price,double recyclability) {
		super();
		this.type = type;
		this.quantity = quantity;
		this.price = price;
		this.recyclability = recyclability;
		this.total_price = this.quantity * this.price;
	}
	

	
	public double getRecyclability() {
		return recyclability;
	}



	public void setRecyclability(double recyclability) {
		this.recyclability = recyclability;
	}



	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public double getQuantity() {
		return quantity;
	}
	public void setQuantity(double quantity) {
		this.quantity = quantity;
	}
	public double getPrice() {
		return price;
	}
	public void setPrice(double price) {
		this.price = price;
	}
	
	public double getTotalPrice() {
		return total_price;
	}
	
	public void addToDatabase()throws SQLException, ClassNotFoundException {
		Class.forName("com.mysql.jdbc.Driver");
		connect = DriverManager.getConnection(url,"root","");

		if(connect == null){
			System.out.println("Connection unsuccessfull!");
		}else {
			System.out.println("Connection successfull!");
			insertQuery = "insert into trash (type,quantity,price,recyclability,total_price)values(?,?,?,?,?)";
			insertStatement = connect.prepareStatement(insertQuery);
			insertStatement.setString(1,type);
			insertStatement.setDouble(2,quantity);
			insertStatement.setDouble(3,price);
			insertStatement.setDouble(4,recyclability);
			double totalPrice = quantity * price;
			insertStatement.setDouble(5,totalPrice);
			
			int result = insertStatement.executeUpdate();
			if(result > 0) {
				System.out.println("Trash added to database!");
			}else {
				System.out.println("Couldn't add Trash to database!");
			}
		}
	}
	
}
