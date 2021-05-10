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
		int post_id = 0;
		int deal_status=0;
		String date,industryEmail;
		String currUserName;
		String dealerEmail;
		String currUserType;
		String currUserEmailId;
		int postStatus = 0;
		boolean flag=true;
		double metalQ,plasticQ,rubberQ;
	%>
	<%
		currUserEmailId = (String)session.getAttribute("user-email");
		currUserName = (String)session.getAttribute("user-name");
		currUserType = (String)session.getAttribute("user-type");
		post_id = Integer.valueOf(request.getParameter("post_id"));
		postStatus = Integer.valueOf(request.getParameter("post_status"));
	%>
	
	<%
		Class.forName("com.mysql.jdbc.Driver");
		String url = "jdbc:mysql://localhost:3306/database";
		Connection connect = DriverManager.getConnection(url,"root","");
		
		PreparedStatement updatePST = connect.prepareStatement("update post set post_status = ? where post_id = ?");
		updatePST.setInt(1,2);
		updatePST.setInt(2,post_id);
		
		int resultUpdate = updatePST.executeUpdate();
		
		PreparedStatement updatePST2 = connect.prepareStatement("update deal set deal_status = ? where post_id = ?");
		updatePST2.setInt(1,1);
		updatePST2.setInt(2,post_id);
		
		int resultUpdate2 = updatePST2.executeUpdate();
		
		PreparedStatement pst = connect.prepareStatement("select industry_email from deal where post_id= ?");
		pst.setInt(1,post_id);
		ResultSet rst = pst.executeQuery();
		if(rst.next()){
			industryEmail = rst.getString(1);
		}
	%>
	<div class="nav-background"></div>
	<div class="completePostPage">
		<nav class="main-nav">	
			<div class="logo"><img src="assets/logo.png"></div>
		
			<ul>
				<li><a href="dealer-home.jsp">Home</a></li>
				<li><a href="#">Contact Us</a></li>
				<li class="username"><span class="dealer-logo"><img src="assets/dealer-solid.svg"></span><%= currUserName%></li>
				<li><a href="logout.jsp">Logout</a></li>
			</ul>
		</nav>
		<div class="success-message">
			<h2>Bravo! we will notify to : <%= industryEmail%> about the success!</h2>
		</div>
	</div>
	
	<a class="back-button" href="dealer-home.jsp"><button class="btn-back">Go to Home</button></a>	
</body>
</html>