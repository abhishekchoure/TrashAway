<%@ page language="java" import="java.sql.*" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
<%!
	Connection connect;
	PreparedStatement pst;
	ResultSet rst;
	String userType,token;
	String password,confirmPassword;
	boolean flag = true;
%>
		<div class="login">
			<form id="newPwdForm" class="form-login" method="POST" action="newPassword.jsp">
			<%
			if(flag){
					Class.forName("com.mysql.jdbc.Driver");
					String url = "jdbc:mysql://localhost:3306/database";
					String user = "root";
			
					connect  = DriverManager.getConnection(url,user,"");
					token = request.getParameter("token");
					userType = request.getParameter("type");
					pst = connect.prepareStatement("select * from " + userType + " where token=?");
					pst.setString(1,token);
					rst = pst.executeQuery();
					if(rst.next()){
			%>
				<div id="user-message">Welcome user!</div>
			<%
						flag=false;
					}else{
			%>
				<div id="user-message">Error!</div>
			<%		}
				}
			%>
			
				<h1 style="color:var(--darkblue);font-size:1.8rem">Set a New Password :</h1><br><br>
				<div>
					<label class="label-password" for="password">New Password :</label>
					<input id="input-password" name="password" type="password" placeholder="Password" required /> 
				</div>
				<div>
					<label class="label-password" for="password">Confirm New Password :</label>
					<input id="input-confirmPassword" name="confirmPassword" type="password" placeholder="Re-enter Password" required /> 
				</div>
				<br>
				<input id="btnPwd" class="btn-red" style="padding:0.8rem 2rem" type="submit" value="Change Password" name="new-password"/>
				<%
					if("Change Password".equals(request.getParameter("new-password"))){
						
						password = request.getParameter("password");
						confirmPassword = request.getParameter("confirmPassword");
						
						if(password.length() < 6 || password.length() > 25){
				%>	
							<div id="error-message">Password must be between 6 -25 characters in length!</div>	
				<% 		}else if(!(password.equals(confirmPassword))){
				%>
							<div id="error-message">Password mismatch!</div>
				<%
						}else{
							if(password.equals("password")){
				%>
								<div id="error-message">Password cannot be a password!</div>
				<%
							}else{
								pst = connect.prepareStatement("update " + userType + " set " + userType + "_password = ? where token = ?");
								pst.setString(1,password);
								pst.setString(2,token);
								int res = pst.executeUpdate();
								if(res > 0){
									out.println("<script>alert('Password has been set successfully!')</script>");
									response.sendRedirect("login.html");
								}
							}
						}
					}
				%>
			</form>
			<div class="sideDiv"></div>
		</div>
</body>
</html>