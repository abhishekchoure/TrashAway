<%@ page language="java" import="java.sql.*,java.util.*" contentType="text/html; charset=ISO-8859-1"
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
		
		TreeSet<String> yourPosts = new TreeSet<String>();
		String currUserName , currUserEmailId ;
		int postCount = 0;
		boolean recordFound = false;
	%>
	<%
		currUserName = (String)session.getAttribute("user-name");
		currUserEmailId = (String)session.getAttribute("user-email");
		yourPosts = (TreeSet<String>)session.getAttribute("yourPosts");
	%>
	<div class="industryPosts">
		<div class="nav-background"></div>
		<nav class="main-nav">	
			<div class="logo"><img src="assets/logo.png"></div>
		
			<ul>
				<li><a href="home.jsp">Home</a></li>
				<li><a href="#">Contact Us</a></li>
				<li class="username"><span class="industry-logo"><img src="assets/industry-solid.svg"></span><%= currUserName%></li>
				<li><a href="logout.jsp">Logout</a></li>
			</ul>
		</nav>
		
		<div class="posts-header">
			<h1>Manage your Posts</h1>
			<p>These are all the posts you have done so far!</p>
		</div>
		
		<div class="allPosts">
			<table class="table-managePosts">
								<tr>
									<th>Post Date</th>
									<th>Time</th>
									<th>Total Quantity</th>
									<th>Total Price</th>
									<th>Status</th>
									<th>Actions</th>
								</tr>
			<%
				Iterator<String> itr = yourPosts.descendingIterator();
				Class.forName("com.mysql.jdbc.Driver");
				String url = "jdbc:mysql://localhost:3306/database";
				Connection connect = DriverManager.getConnection(url,"root","");
				while(itr.hasNext()){
					PreparedStatement pst = connect.prepareStatement("select date(post_date),time(post_date),post_quantity,post_price,post_status,post_id from post where post_date=? and industry_email=?");
					pst.setString(1,itr.next());
					pst.setString(2,currUserEmailId);
					
					ResultSet rst = pst.executeQuery();

					while(rst.next()){
					%>
								<tr>
									<td><%= rst.getString(1)%></td>
									<td><%= rst.getString(2)%></td>
									<td><%= rst.getDouble(3)%></td>
									<td><%= rst.getDouble(4)%></td>
									<td>
									<%
										int postStatus = rst.getInt(5);
										switch(postStatus){
											case -1: %><span class="published"><%= "published"%></span><%
													break;
											case 0: %><span class="ongoing"><%= "requested"%></span><%
													break;
											case 1: %><span class="assigned"><%= "assigned"%></span><%
													break;
											case 2: %><span class="completed"><%= "completed"%></span><%
													break;
										}		
									%>
									</td>
									<td>
										<form action="postDetails.jsp" method="post">
											<input type="hidden" name="post_id" value="<%= rst.getInt(6)%>">
											<input type="hidden" name="post_status" value="<%= postStatus%>">
											<input class="btn-details" type="submit" value="Details" name="details">
											<%
											if(postStatus != 1 && postStatus != 2){
											%>
											<input class="btn-cancel" type="submit" value="Delete" name="cancel">
											<%
											}
											%>
										</form>
									</td>
								</tr>
					<% 
					}
				}
			%>
			</table>
		</div>
		<a class="back-button" href="home.jsp"><button class="btn-back">Back</button></a>
	</div>
</body>
</html>