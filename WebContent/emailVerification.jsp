<%@ page language="java" import="java.sql.*" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<meta http-equiv="refresh" content="5; url=http://localhost:6750/TrashAway/login.html">
<title>Insert title here</title>
</head>
<body>
<%!
	String token;
	String type;
	String status;
	Connection connect;
	PreparedStatement pst;
	ResultSet rst;
%>

<%
	token = request.getParameter("token");
	type = request.getParameter("type");
	Class.forName("com.mysql.jdbc.Driver");
	String url = "jdbc:mysql://localhost:3306/database";
	String user = "root";
	connect  = DriverManager.getConnection(url,user,"");
	
	pst = connect.prepareStatement("select status from " + type + " where token = ?");
	pst.setString(1,token);
	rst = pst.executeQuery();
	if(rst.next()){
		status = rst.getString(1);
	}
	
	if(status.equals("inactive")){
			pst = connect.prepareStatement("update " + type + " set status=? where token=?");
			pst.setString(1,"active");
			pst.setString(2,token);
			int res = pst.executeUpdate();
			if(res > 0){
	%>
			<div class="success-message">Your Email-Id is verified</div>
			<div id="redirect-message"></div>
	<% 	
			}
	}else{
	
	%>
			<div class="success-message">Your Email-Id has already been verified!</div>
			<div id="redirect-message"></div>
	<%
	}
	%>
	
</body>
<script>
	var seconds = 6;
	function displaySeconds(){
		seconds -= 1;
		document.getElementById("redirect-message").innerHTML = "Do not go back or click REFRESH<br>Page will redirect to Login Page " + seconds + " seconds ...";
	}
	setInterval(displaySeconds,1000);
</script>
</html>