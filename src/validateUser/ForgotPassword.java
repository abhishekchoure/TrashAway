package validateUser;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ForgotPassword")
public class ForgotPassword extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private static Connection connect;
    private static String userType;
    private static String userEmailId; 
    private static PrintWriter out;
    private static String passwd,confirmPwd;
    int rst;
    
    public ForgotPassword() {
        super();
    }

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			String url = "jdbc:mysql://localhost:3306/database";
			String user = "root";
			connect  = DriverManager.getConnection(url,user,"");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		if("Change Password".equals(request.getParameter("new-password"))){
			passwd = request.getParameter("password");
			confirmPwd = request.getParameter("confirmPassword");
			userType = request.getParameter("userType");
			if(passwd.length() < 6 && passwd.length() > 25){
				out.println("<script>alert('Password must be between 6-25 characters in length!')</script>");
				response.sendRedirect("passwordRecovery.jsp");
			}else if(passwd.equals("password")){
				out.println("<script>alert('Password cannot be set as password')</script>");
			}else{
				if(passwd.equals(confirmPwd)){
					PreparedStatement checkPST;
					try {
						checkPST = connect.prepareStatement("update " + userType + " set " + userType + "_password" + "= ? where " + userType +  "_email = ?");
						checkPST.setString(1,passwd);
						checkPST.setString(2,userEmailId);
						rst = checkPST.executeUpdate();
					} catch (SQLException e) {
						e.printStackTrace();
					}
					if(rst > 0){
						out.println("<script>alert('New Password has ben set successfully!')</script>");
						RequestDispatcher rd = request.getRequestDispatcher("login.html");
						rd.include(request,response);
					}else{
					}
				}else{
					out.println("<script>alert('Password Mismatch')</script>");
				}
			}	
		}
	}

}
