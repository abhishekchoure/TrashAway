package validateUser;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import data.Dealer;
import data.Industry;
import email.SendEmail;
import security.SecureTokenGenerator;

@WebServlet("/Validation")
public class Validation extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private static String email;
    private static String contact;
    private static String address;
    private static String password;
    private static String confirmPassword;
    private static String[] city = new String[1];
    private static String name;
    private static String firstName;
    private static String lastName;
    private static String pincode;
    private static String[] type = new String[1];
    private static RequestDispatcher requestDispatch;
    private static boolean isValidUser = false;
    private static boolean isValidContact = false;
    private static PrintWriter out;
    private static Connection connect;
    private static PreparedStatement pst;
    private static final String url = "jdbc:mysql://localhost:3306/database";
    
    public Validation() {
        super();
    }
    
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		type = request.getParameterValues("userType");
		name = request.getParameter("name");
		firstName = request.getParameter("firstName");
		lastName = request.getParameter("lastName");
		email = request.getParameter("email");
		contact = request.getParameter("contact");
		address = request.getParameter("address");
		pincode = request.getParameter("pincode");
		password = request.getParameter("password");
		confirmPassword = request.getParameter("confirm-password");
		city = request.getParameterValues("city");	
		
		out = response.getWriter();
		
		try {
			isValidUser = validateUser();
			isValidContact = validateContact();
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println(isValidUser + " " + isValidContact);
		if(isValidUser) {
			if(isValidContact) {
				try {
					addUserToDatabase(type[0]);
					String token = getTokenFromUser(type[0]);
					String msg = "Click the link to verify you're email : " + "http://localhost:6750/TrashAway/emailVerification.jsp?&token=" + token + "&type=" + type[0];
					String subject = "Email Verification";
					SendEmail.sendEmailTo(email, subject, msg);
					System.out.println("Email sent successfully!");
				} catch (ClassNotFoundException | SQLException e) {
					e.printStackTrace();
				}
				requestDispatch = request.getRequestDispatcher("login.html");
				out.println("<script>alert('Registeration successfull!')</script>");
				out.println("<script>alert('Email has been sent to your emailId for verification.')</script>");
				requestDispatch.include(request, response);
			}else {
				requestDispatch = request.getRequestDispatcher("signup.html");
				out.println("<script>alert('Contact number already exists!')</script>");
				requestDispatch.include(request, response);
			}	
		}else {
			requestDispatch = request.getRequestDispatcher("signup.html");
			out.println("<script>alert('User already exists!')</script>");
			requestDispatch.include(request, response);
		}
	}
	
	
	private static boolean validateUser()throws SQLException,ClassNotFoundException{
		Class.forName("com.mysql.jdbc.Driver");
		connect = DriverManager.getConnection(url,"root","");
		if(connect == null) {
			System.out.println("Connection failed!");
		}else {
			pst = connect.prepareStatement("select 1 from industry where industry_email=?");
			pst.setString(1, email);
			ResultSet result = pst.executeQuery();
			if(result.next()) {
				return false;
			}else {
				pst = connect.prepareStatement("select 1 from dealer where dealer_email=?");
				pst.setString(1, email);
				ResultSet res = pst.executeQuery();
				if(res.next()) {
					return false;
				}
			}
		}
		return true;
	}
	
	private static boolean validateContact()throws SQLException,ClassNotFoundException{
		Class.forName("com.mysql.jdbc.Driver");
		connect = DriverManager.getConnection(url,"root","");
		if(connect == null) {
			System.out.println("Connection failed!");
		}else {
			pst = connect.prepareStatement("select 1 from industry where industry_contact=?");
			pst.setString(1, contact);
			ResultSet result = pst.executeQuery();
			if(result.next()) {
				return false;
			}else {
				pst = connect.prepareStatement("select 1 from dealer where dealer_contact=?");
				pst.setString(1, contact);
				ResultSet res = pst.executeQuery();
				if(res.next()) {
					return false;
				}
			}
		}
		return true;
	}
	
	private static void addUserToDatabase(String type)throws SQLException, ClassNotFoundException {
		if(type.equals("industry")) {
			String owner = firstName + " " + lastName; 
			String newToken = SecureTokenGenerator.generateNewToken();
			String status = "inactive";
			Industry industry = new Industry(name,owner,email,password,contact,address,city[0],pincode,newToken,status);
			industry.addToDatabase();
		}else if(type.equals("dealer")){
			String owner = firstName + " " + lastName; 
			String newToken = SecureTokenGenerator.generateNewToken();
			String status = "inactive";
			Dealer dealer = new Dealer(name,owner,email,password,contact,address,city[0],pincode,newToken,status);
			dealer.addToDatabase();
		}else {
			System.out.println("ERROR 404!");
		}
	}
	
	private static String getTokenFromUser(String userType) throws ClassNotFoundException, SQLException {
		Class.forName("com.mysql.jdbc.Driver");
		connect = DriverManager.getConnection(url,"root","");
		String token;
		PreparedStatement pst = connect.prepareStatement("select token from " + userType + " where " + userType + "_email = ?");
		pst.setString(1,email);
		ResultSet rst = pst.executeQuery();
		if(rst.next()) {
			token = rst.getString(1);
			return token;
		}
		return null;
	}
	
}
