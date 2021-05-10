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
<%!
		String currUserName,currUserEmailId,dealerEmail;
		int post_id=0;
%>
<%
		currUserEmailId = (String)session.getAttribute("user-email");
		currUserName = (String)session.getAttribute("user-name");
		post_id = Integer.valueOf(request.getParameter("post_id"));
		dealerEmail = request.getParameter("dealer_email");
%>
<div class="nav-background"></div>
	<div class="acceptRequestPage">
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
		java.util.Date currUtilDate = new java.util.Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String currTime = sdf.format(currUtilDate);

		Class.forName("com.mysql.jdbc.Driver");
		String url = "jdbc:mysql://localhost:3306/database";
		Connection connect = DriverManager.getConnection(url,"root","");
		
		PreparedStatement pst = connect.prepareStatement("insert into deal (deal_date,post_id,industry_email,dealer_email,deal_status) values(?,?,?,?,?)");
		pst.setString(1,currTime);
		pst.setInt(2,post_id);
		pst.setString(3,currUserEmailId);
		pst.setString(4,dealerEmail);
		pst.setInt(5,0);
		
		int result = pst.executeUpdate();
		if(result > 0){
	%>
		<div class="success-message">
			<h2>Request Accepted Successfully!</h2>
			<p>Click on Home to go to you're Home Page</p>
		</div>
	<%
		}else{
	%>
		<div class="error-message">
			<h2>Error</h2>
			<p>Click on Home to go to you're Home Page</p>
		</div>
	<%
		}
	%>
	
	<%
		PreparedStatement updatePST = connect.prepareStatement("update post set post_status = ? where post_id=?");
		updatePST.setInt(1,1);
		updatePST.setInt(2,post_id);
		int res = updatePST.executeUpdate();
		if(res > 0){
	%>
		
	<%
		}else{
	%>
		<div class="error-message">
			<h2>Error Updating post status</h2>
			<p>Click on Home to go to you're Home Page</p>
		</div>
	<%
		}
	%>
	
	<a class="back-button" href="home.jsp"><button class="btn-back">Go to Home</button></a>
	</div>
</body>
</html>