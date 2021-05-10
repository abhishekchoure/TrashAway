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
import javax.servlet.http.HttpSession;

@WebServlet("/LoginValidation")
public class LoginValidation extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static String emailId;
	private static String password;
	private static String type;
	private static String user;
	private static Connection connect;
	private static PreparedStatement checkStatement;
	private static String checkQuery;
	private static ResultSet result;
	private static boolean isValid;
	private static RequestDispatcher requestDispatch;
	private static PrintWriter out;
    private static final String url = "jdbc:mysql://localhost:3306/database";
    private static String status;
    
    public LoginValidation() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		emailId = request.getParameter("emailId");
		password = request.getParameter("password");	
		try {
			isValid = validateUser();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		out = response.getWriter();
		if(isValid) {		
			try {
				PreparedStatement pst = connect.prepareStatement("select status from " + type + " where " + type + "_email = ?");
				pst.setString(1,emailId);
				ResultSet rst = pst.executeQuery();
				if(rst.next()) {
					status = rst.getString(1);
				}
				System.out.println(status);
				/*
				 * if(status.equals("inactive")) { out.
				 * println("<script>alert('Please verfiy your emailID by clicking the link in the email sent to you!')</script>"
				 * ); }
				 */
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
			if(status.equals("active")) {
				HttpSession session = request.getSession();
				session.setAttribute("user-email", emailId);
				session.setAttribute("user-type", type);
				session.setAttribute("user-name", user);
				if(type.equals("industry")) {
					out.println("<script>alert('Login Successfull')</script>");
					requestDispatch = request.getRequestDispatcher("home.jsp");
					requestDispatch.include(request, response);
				}else if(type.equals("dealer")){
					out.println("<script>alert('Login Successfull')</script>");
					requestDispatch = request.getRequestDispatcher("dealer-home.jsp");
					requestDispatch.include(request, response);
				}
			}else{
				requestDispatch = request.getRequestDispatcher("login.html");
				out.println("<script>alert('Please verfiy your emailID by clicking the link in the email sent to you!')</script>");
				requestDispatch.include(request, response);
			}
			
		}else{
			requestDispatch = request.getRequestDispatcher("login.html");
			out.println("<script>alert('Invalid Credentials!')</script>");
			requestDispatch.include(request, response);
		}
	}
	
	private static boolean validateUser()throws SQLException {
		connect = DriverManager.getConnection(url,"root", "");
		if(connect == null) {
			System.out.println("Connection failed!");
		}else {
			checkQuery = "select industry_name from industry where industry_email=? and industry_password=?";
			checkStatement = connect.prepareStatement(checkQuery);
			checkStatement.setString(1, emailId);
			checkStatement.setString(2, password);
			result = checkStatement.executeQuery();
			if(result.next()) {
				user = result.getString(1);
				type = "industry";
				return true;
			}else {
				checkQuery = "select dealer_name from dealer where dealer_email=? and dealer_password=?";
				checkStatement = connect.prepareStatement(checkQuery);
				checkStatement.setString(1, emailId);
				checkStatement.setString(2, password);
				result = checkStatement.executeQuery();
				if(result.next()) {
					user = result.getString(1);
					type = "dealer";
					return true;
				}
			}
		}
		return false;
	}

}
