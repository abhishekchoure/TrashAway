<%@ page language="java" import="java.sql.*,email.*" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<link rel="stylesheet" href="css/style.css">
</head>
<%-- <%!
	String securityQuestion;
	String userType;
	String userEmailId;
	Connection connect;
	String token;
%> --%>


<body>
	<div class="login">
		<%-- <%
		Class.forName("com.mysql.jdbc.Driver");
		String url = "jdbc:mysql://localhost:3306/database";
		String user = "root";
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
					response.sendRedirect("login.html");
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
						response.sendRedirect("login.html");
					}else{
						out.println("<script>alert('Invalid User!Please verify your email first.')</script>");
						
					}
				}
		}
%> --%>
		<div id="user-message"></div>
		<form id="emailForm" class="form-login" method="POST" action="EmailVerification">
			<h1 style="color:var(--darkblue);font-size:1.8rem">Please enter your Email-ID :</h1><br><br>
			<div>
				<label class="label-username" for="username">Enter your Email Id :</label>
				<input id="input-emailId" name="emailId" type="email" placeholder="abc@example.com" required /> 
			</div><br>
			
			<input class="btn-red" style="padding:0.8rem 2rem" type="submit" value="Verify Email" name="verify-email">
		</form>	
		
		<div class="sideDiv"></div>
	</div>
<script>
	
</script>
</body>
</html>