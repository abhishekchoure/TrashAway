<%@ page language="java" import="java.sql.*,java.util.*,java.text.*" contentType="text/html; charset=ISO-8859-1"
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
		String currUserName,currUserEmailId,dealerEmail;
		int post_id=0;
%>
<%
		currUserEmailId = (String)session.getAttribute("user-email");
		currUserName = (String)session.getAttribute("user-name");
		post_id = Integer.valueOf(request.getParameter("post_id"));
%>
<div class="nav-background"></div>
	<div class="requestPage">
	<nav class="main-nav">	
			<div class="logo"><img src="assets/logo.png"></div>
		
			<ul>
				<li><a href="home.jsp">Home</a></li>
				<li><a href="#">Contact Us</a></li>
				<li class="username"><span class="industry-logo"><img src="assets/industry-solid.svg"></span><%= currUserName%></li>
				<li><a href="logout.jsp">Logout</a></li>
			</ul>
	</nav>
	<% 
		Class.forName("com.mysql.jdbc.Driver");
		String url = "jdbc:mysql://localhost:3306/database";
		Connection connect = DriverManager.getConnection(url,"root","");
		
		PreparedStatement pst = connect.prepareStatement("select date(request_date),time(request_date),request.dealer_email,dealer_name,dealer_contact,dealer_address,dealer_city,dealer_pincode from request,dealer where dealer.dealer_email = request.dealer_email and post_id=?");
		pst.setInt(1,post_id);
		ResultSet rst = pst.executeQuery();
		
	%>
	<table class="table-managePosts">
		<tr colspan=3><h1>Request Details</h1></tr>
		<tr>
			<th>Date of Request</th>
			<th>Time</th>
			<th>Dealer Name</th>
			<th>Dealer Email</th>
			<th>Contact Number</th>
			<th>Address</th>
			<th>City</th>
			<th>Pincode</th>
			<th>Actions</th>
		</tr>
	<% 
		while(rst.next()){
			dealerEmail = rst.getString(3);
	%>
		<tr>
			<td><%= rst.getString(1)%></td>
			<td><%= rst.getString(2)%></td>
			<td><%= rst.getString(4)%></td>
			<td><%= rst.getString(3)%></td>
			<td><%= rst.getString(5)%></td>
			<td><%= rst.getString(6)%></td>
			<td><%= rst.getString(7)%></td>
			<td><%= rst.getString(8)%></td>
			<td>
				<form action="acceptRequest.jsp" method="POST">
					<input type="hidden" name="post_id" value="<%= post_id%>">
					<input type="hidden" name="dealer_email" value="<%= dealerEmail%>">
					<input class="btn-primary" type="submit" value="Accept Request">
				</form>
			</td>
		</tr>
	<%
		}
	%>
	
		</table>
		<a class="back-button" href="home.jsp"><button class="btn-back">Back</button></a>
	</div>
</body>
</html>