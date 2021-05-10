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
		String currUserName , currUserEmailId ;
		int postCount = 0;
		boolean recordFound = false;
	%>
	<%
		currUserName = (String)session.getAttribute("user-name");
		currUserEmailId = (String)session.getAttribute("user-email");
	%>
	<div class="industryPosts">
		<div class="nav-background"></div>
		<nav class="main-nav">	
			<div class="logo"><img src="assets/logo.png"></div>
		
			<ul>
				<li><a href="dealer-home.jsp">Home</a></li>
				<li><a href="#">Contact Us</a></li>
				<li class="username"><span class="dealer-logo"><img src="assets/truck-solid.svg"></span><%= currUserName%></li>
				<li><a href="logout.jsp">Logout</a></li>
			</ul>
		</nav>
		
		<div class="posts-header">
			<h1>See all Posts</h1>
			<p>These are all the trash posted by industries</p>
		</div>
		
		<div class="allPosts">
			<table class="table-managePosts">
								<tr>
									<th>Post Date</th>
									<th>Time</th>
									<th>Industry Name</th>
									<th>Total Quantity</th>
									<th>Total Price</th>
									<th>Status</th>
									<th>Actions</th>
								</tr>
			<%
				Class.forName("com.mysql.jdbc.Driver");
				String url = "jdbc:mysql://localhost:3306/database";
				Connection connect = DriverManager.getConnection(url,"root","");
					PreparedStatement pst = connect.prepareStatement("select date(post_date),time(post_date),industry_name,post_quantity,post_price,post_status,post_id from post,industry where industry.industry_email = post.industry_email order by post_date DESC");	
					ResultSet rst = pst.executeQuery();

					while(rst.next()){
					%>
								<tr>
									<td><%= rst.getString(1)%></td>
									<td><%= rst.getString(2)%></td>
									<td><%= rst.getString(3)%></td>
									<td><%= rst.getDouble(4)%></td>
									<td><%= rst.getDouble(5)%></td>
									<td>
									<%
										int postStatus = rst.getInt(6);
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
										<form class="allPostsComplete" action="postDetails.jsp" method="post">
											<input type="hidden" name="post_id" value="<%= rst.getInt(7)%>">
											<input type="hidden" name="post_status" value="<%= postStatus%>">
											<input class="btn-details" type="submit" value="Details" name="details">
											<% if(postStatus < 2) {%>
												<input class="btn-cancel" type="submit" value="Cancel" name="cancel">
											<%}%>
										</form>
									</td>
								</tr>
					<% 
					}
				
			%>
			</table>
		</div>
		<a class="back-button" href="dealer-home.jsp"><button class="btn-back">Back</button></a>
	</div>
</body>
</html>