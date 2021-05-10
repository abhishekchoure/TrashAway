package validateUser;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import email.SendEmail;

@WebServlet("/EmailVerification")
public class EmailVerification extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private static String userEmailId;
    private static String userType;
    private static String token;
    private static PrintWriter out;
    private static Connection connect;
    
    public EmailVerification() {
        super();
    }


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		out = response.getWriter();
		try {
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException e1) {
			e1.printStackTrace();
		}
		String url = "jdbc:mysql://localhost:3306/database";
		String user = "root";
		try {
			connect  = DriverManager.getConnection(url,user,"");
			if("Verify Email".equals(request.getParameter("verify-email"))){
					userEmailId = request.getParameter("emailId");
					PreparedStatement checkPST = connect.prepareStatement("select token from industry where industry_email = ? and status= ?");
					checkPST.setString(1,userEmailId);
					checkPST.setString(2,"active");
					ResultSet rst = checkPST.executeQuery();
					if(rst.next()){
						userType = "industry";
						token = rst.getString(1);
						String msg = "Click the link to reset your password : " + "http://localhost:6750/TrashAway/newPassword.jsp?&token=" + token + "&type=" + userType;
						SendEmail.sendEmailTo(userEmailId,"Reset Password",msg);
						out.println("<script>alert('Link has been sent to your email to reset your password!')</script>");
						RequestDispatcher rd = request.getRequestDispatcher("login.html");
						rd.include(request, response);
					}else{
						PreparedStatement checkPST2 = connect.prepareStatement("select token from dealer where dealer_email = ? and status= ?");
						checkPST2.setString(1,userEmailId);
						checkPST2.setString(2,"active");
						ResultSet rst2 = checkPST2.executeQuery();
						if(rst2.next()){
							userType= "dealer";
							token = rst2.getString(1);
							String msg = "Click the link to reset your password : " + "http://localhost:6750/TrashAway/newPassword.jsp?&token=" + token + "&type=" + userType;
							SendEmail.sendEmailTo(userEmailId,"Reset Password",msg);
							out.println("<script>alert('Link has been sent to your email to reset your password!')</script>");
							RequestDispatcher rd = request.getRequestDispatcher("login.html");
							rd.include(request, response);
						}else{
							out.println("<script>alert('Invalid User!Please verify your email first.')</script>");
							RequestDispatcher rd = request.getRequestDispatcher("login.html");
							rd.include(request, response);
						}
					}
				}
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
}
