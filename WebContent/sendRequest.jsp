<%@ page language="java" import="java.sql.*,java.text.*" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="nav-background"></div>
<%!
		int post_id = 0;
		String currUserEmailId,industryEmail;
		String currUserName;
%>
<%
	currUserName = (String)session.getAttribute("user-name");
	java.util.Date currUtilDate = new java.util.Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String currTime = sdf.format(currUtilDate);

%>
<div class="sendRequest">
		<nav class="main-nav">	
			<div class="logo"><img src="assets/logo.png"></div>
		
			<ul>
				<li><a href="dealer-home.jsp">Home</a></li>
				<li><a href="#">Contact Us</a></li>
				<li class="username"><span class="dealer-logo"><img src="assets/truck-solid.svg"></span><%= currUserName%></li>
				<li><a href="logout.jsp">Logout</a></li>
			</ul>
		</nav>
	
	<%
		currUserEmailId = (String)session.getAttribute("user-email");
		post_id = Integer.valueOf(request.getParameter("post_id"));
		industryEmail = request.getParameter("industry_email");
		
		Class.forName("com.mysql.jdbc.Driver");
		String url = "jdbc:mysql://localhost:3306/database";
		Connection connect = DriverManager.getConnection(url,"root","");
		
		PreparedStatement checkPST = connect.prepareStatement("select 1 from deal where post_id=?");
		checkPST.setInt(1,post_id);
		ResultSet result = checkPST.executeQuery();
		if(result.next()){
	%>
		<div class="error">
			
		</div>
	<%
		}else{	
			PreparedStatement insertPST = connect.prepareStatement("insert into request (request_date,post_id,dealer_email,industry_email) values(?,?,?,?)");
			insertPST.setString(1,currTime);
			insertPST.setInt(2,post_id);
			insertPST.setString(3,currUserEmailId);
			insertPST.setString(4,industryEmail);
			int res = insertPST.executeUpdate();
			if(res > 0){
	%>
			<div class="success-message">
				<h2>You're request has been sent successfully!</h2>
				<p>Click on Home to go you're home page</p>
			</div>
	<% 
			}
			PreparedStatement statusPST = connect.prepareStatement("update post set post_status = ? where post_id=?");
			statusPST.setInt(1,0);
			statusPST.setInt(2,post_id);
			int statusChanged = statusPST.executeUpdate();
			if(statusChanged > 0){
				
			}else{
				out.println("ERROR updating status!");
			}
		}
	%>
	<a class="back-button" href="dealer-home.jsp"><button class="btn-back">Go to Home</button></a>
</div>
</body>
</html>