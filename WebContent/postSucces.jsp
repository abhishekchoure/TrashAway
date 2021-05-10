<%@ page language="java" import="java.util.ArrayList,java.time.LocalDate,data.Trash,java.sql.*,java.text.*" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<meta http-equiv="refresh" content="5; url=http://localhost:6750/TrashAway/home.jsp">
<title>Insert title here</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
	<div class="redirectHome">
		<%!
					LocalDate currLocalDate = LocalDate.now();
					java.sql.Date sqlDate = Date.valueOf(currLocalDate);
					double sumPrice = 0;
					double sumQuantity = 0;
					String currUserEmailId;
		%>
		
		<%
			java.util.Date currUtilDate = new java.util.Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String currTime = sdf.format(currUtilDate);
			currUserEmailId = (String)session.getAttribute("user-email");
			session.setAttribute("postTime",currTime);
		%>
		<div class="popup-success">
			<div class="post-success">
				<p><b><%= currTime%></b></p>
				<h2>ThankYou for posting! Dealers will now be notified</h2>
				<h3>Here are your post details : </h3>
			</div>
				
			<table class="post-details">
							
				<tr>
					<th>Trash Type</th>
					<th>Quantity in kg</th>
					<th>Price per kg</th>
					<th>Recylability</th>
					<th>Total Price</th>
				</tr>
				
				
				<%
					ArrayList<Trash> trashList = (ArrayList<Trash>)session.getAttribute("trash-post");
					if(trashList != null){
						sumPrice = 0;
						sumQuantity = 0;
						Class.forName("com.mysql.jdbc.Driver");
						String url = "jdbc:mysql://localhost:3306/database";
						Connection connect = DriverManager.getConnection(url,"root","");
						
						for(int i=0;i<trashList.size();i++){
							PreparedStatement pst = connect.prepareStatement("insert into trash (type,date,quantity,price,recyclability,total_price,industry_email) values (?,?,?,?,?,?,?)");
							pst.setString(1,trashList.get(i).getType());
							pst.setString(2,currTime);
							pst.setDouble(3,trashList.get(i).getQuantity());
							pst.setDouble(4,trashList.get(i).getPrice());
							pst.setDouble(5,trashList.get(i).getRecyclability());
							double total_price = trashList.get(i).getQuantity() * trashList.get(i).getPrice();
							pst.setDouble(6,total_price);
							pst.setString(7,(String)session.getAttribute("user-email"));
						
							int res = pst.executeUpdate();
						}
					%>
					<%
	
						
							for(int i=0;i<trashList.size();i++){
								sumPrice += trashList.get(i).getTotalPrice();
								sumQuantity += trashList.get(i).getQuantity();
					%>
								
						<tr>
							<td><%= trashList.get(i).getType()%></td>
							<td><%= trashList.get(i).getQuantity()%></td>
							<td><%= trashList.get(i).getPrice()%></td>
							<td><%= trashList.get(i).getRecyclability()%></td>
							<td><%= trashList.get(i).getTotalPrice()%></td>
						</tr>
								
					<%
						}
					
					%>	
					
					<tr>
						<th>Total Quantity</th>
						<td><%= sumQuantity%></td>
						<td></td>
						<th>Total Price</th>
						<td><%= sumPrice%></td>
					</tr>
					<%
						PreparedStatement insertPost = connect.prepareStatement("insert into post (post_date,industry_email,post_status,post_quantity,post_price) values (?,?,?,?,?)");
						insertPost.setString(1,currTime);
						insertPost.setString(2,currUserEmailId);
						insertPost.setInt(3,-1);
						insertPost.setDouble(4,sumQuantity);
						insertPost.setDouble(5,sumPrice);
						
						int flag = insertPost.executeUpdate();
					%>
				</table>
			<%
				}
			%>
			
			
		
		</div>
		<div id="redirect-message"></div>
	</div>
</body>
<script>
	var seconds = 6;
	function displaySeconds(){
		seconds -= 1;
		document.getElementById("redirect-message").innerHTML = "Do not go back or click REFRESH<br>Page will redirect to HOME in " + seconds + " seconds ...";
	}
	setInterval(displaySeconds,1000);
</script>
</html>