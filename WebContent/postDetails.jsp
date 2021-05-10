<%@ page language="java" import="java.sql.*" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<link rel="stylesheet" href="css/style.css">
</head>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.3/Chart.min.js" integrity="sha512-s+xg36jbIujB2S2VKfpGmlC3T5V2TF3lY48DX7u2r9XzGzgPsa6wTpOQA7J9iffvdeBN0q9tKzRxVxw1JviZPg==" crossorigin="anonymous"></script>
<body>
<div class="nav-background"></div>
<div class="postDetails">
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
		boolean check;
	%>
	<%
		currUserEmailId = (String)session.getAttribute("user-email");
		currUserName = (String)session.getAttribute("user-name");
		currUserType = (String)session.getAttribute("user-type");
		check = false;
		metalQ = 0;
		plasticQ = 0;
		rubberQ = 0;
	%>
	<nav class="main-nav">	
			<div class="logo"><img src="assets/logo.png"></div>
		
			<ul>
				<%if(currUserType.equals("industry")){ %>
					<li><a href="home.jsp">Home</a></li>
				<%}%>
				<%if(currUserType.equals("dealer")){ %>
					<li><a href="dealer-home.jsp">Home</a></li>
				<%}%>
				<li><a href="#">Contact Us</a></li>
				<%if(currUserType.equals("industry")){ %>
				<li class="username"><span class="industry-logo"><img src="assets/industry-solid.svg"></span><%= currUserName%></li>
				<%}%>
				<%if(currUserType.equals("dealer")){ %>
				<li class="username"><span class="dealer-logo"><img src="assets/truck-solid.svg"></span><%= currUserName%></li>
				<%}%>
				<li><a href="logout.jsp">Logout</a></li>
			</ul>
	</nav>
	
	<div class="post-header">
		<h1>Post Details</h1>
	</div>
	
	<div class="container-postDetails">
	<%
		post_id = Integer.valueOf(request.getParameter("post_id"));
		postStatus =  Integer.valueOf(request.getParameter("post_status"));
		Class.forName("com.mysql.jdbc.Driver");
		String url = "jdbc:mysql://localhost:3306/database";
		Connection connect = DriverManager.getConnection(url,"root","");
		
		PreparedStatement pst = connect.prepareStatement("select date(post_date),time(post_date),industry_name,post_quantity,post_price,post.industry_email from post,industry where industry.industry_email = post.industry_email and post_id = ?");
		pst.setInt(1,post_id);
		ResultSet rst = pst.executeQuery();
		while(rst.next()){
			date = rst.getString(1) + " " + rst.getString(2);
			industryEmail = rst.getString(6);
	%>
		
			<table class="table-postDetails">
				<tr>
					<th>Date</th><td><%= rst.getString(1)%></td>
					<th>Time</th><td><%= rst.getString(2)%></td>
				</tr>
				<tr><th>Company</th><td colspan=4><%= rst.getString(3)%></td></tr>
				<tr>
					<th colspan=2>Total Quantity</th>
					<th colspan=2>Total Price</th>
				</tr>
				<tr>
					<td colspan=2><%= rst.getDouble(4)%> kg</td>
					<td colspan=2>Rs <%= rst.getDouble(5)%></td>
				</tr>
			</table>
	<%
		}
	%>
	<%
		PreparedStatement pst2 = connect.prepareStatement("select type,quantity,price,recyclability,total_price from trash where industry_email=? and date=?");
		pst2.setString(1,industryEmail);
		pst2.setString(2,date);
		ResultSet rst2 = pst2.executeQuery();
	%>
			<table class="table-postDetails">
				<tr>
					<th>Trash Type</th>
					<th>Quantity(in kg)</th>
					<th>Price per kg</th>
					<th>Recylability</th>
					<th>Total Cost</th>
				</tr>
	<% 
		while(rst2.next()){
	%>
				<% 
					String choice = rst2.getString(1); 
					switch(choice){
						case "Metal": metalQ = rst2.getDouble(2);
									  break;
						case "Plastic": plasticQ = rst2.getDouble(2);
									    break;
						case "Rubber": rubberQ = rst2.getDouble(2);
										break;		
					}
		
				%>
				<tr>
					<td><%= rst2.getString(1)%></td>
					<td><%= rst2.getDouble(2)%> kg</td>
					<td>Rs <%=rst2.getDouble(3)%> /kg</td>
					<td><%= rst2.getInt(4)%> %</td>
					<td>Rs <%= rst2.getDouble(5)%></td>
				</tr>
	<%
		}
	%>
			</table>
	
	</div>
	<%
		if(postStatus == 0){
			String sqlQuery = "select date(request_date),time(request_date),request.dealer_email,dealer_name,dealer_contact,dealer_address,dealer_city,dealer_pincode from request,dealer where dealer.dealer_email = request.dealer_email and post_id=?";
			PreparedStatement pst3 = connect.prepareStatement(sqlQuery);
			pst3.setInt(1,post_id);
			ResultSet rst3 = pst3.executeQuery();
	%>
	<h1 class="main-header">Request Details</h1>
	<div class="requested-posts">
		<table class="table-managePosts">
			<tr>
				<th>Date of Request</th>
				<th>Time</th>
				<th>Dealer Name</th>
				<th>Dealer Email</th>
				
				<%if(currUserType.equals("industry")){ %>
					<th>Contact Number</th>
					<th>Address</th>
					<th>City</th>
					<th>Pincode</th>
					<th>Actions</th>
				<%}%>
			</tr>
	<% 
		while(rst3.next()){
			dealerEmail = rst3.getString(3);
	%>
		<tr>
			<td><%= rst3.getString(1)%></td>
			<td><%= rst3.getString(2)%></td>
			<td><%= rst3.getString(4)%></td>
			<td><%= rst3.getString(3)%></td>
			
			<%if(currUserType.equals("industry")){ %>
				<td><%= rst3.getString(5)%></td>
				<td><%= rst3.getString(6)%></td>
				<td><%= rst3.getString(7)%></td>
				<td><%= rst3.getString(8)%></td>
				<td>
					<form action="acceptRequest.jsp" method="post">
						<input type="hidden" name="post_id" value="<%= post_id%>">
						<input type="hidden" name="dealer_email" value="<%= dealerEmail%>">
						<input class="btn-red" type="submit" value="Accept Request">
					</form>
				</td>
			<%}%>
		</tr>
	<%
		}
	%>
		</table>
	<%
	}
	%>
	</div>
	<%
		if(postStatus == 1 || postStatus == 2){
	%>
		<h1 class="assign-header">Assigned Details</h1>
		<div class="assigned-posts">
	<% 
			PreparedStatement getDealerPST = connect.prepareStatement("select dealer_email from deal where post_id=?");
			getDealerPST.setInt(1,post_id);
			ResultSet resultD = getDealerPST.executeQuery();
			while(resultD.next()){
				dealerEmail = resultD.getString(1);
			}
			PreparedStatement pst4 = connect.prepareStatement("select date(deal_date),time(deal_date),deal.dealer_email,dealer_name,dealer_contact,dealer_address,dealer_city,dealer_pincode,deal_status from deal,dealer where dealer.dealer_email = deal.dealer_email and post_id in (select post_id from deal where post_id=? and dealer_email = ?)");
			pst4.setInt(1,post_id);
			pst4.setString(2,dealerEmail);
			ResultSet rst4 = pst4.executeQuery();
			
			if(dealerEmail.equals(currUserEmailId)){
				check = true;
			}
	%>
			<table class="table-managePosts">
			<tr>
				<th>Assigned Date</th>
				<th>Time</th>
				<th>Dealer Name</th>
				<th>Dealer Email</th>
				<%if(currUserType.equals("dealer") && postStatus < 2 && check){%>
					<th>View Industry Location</th>
					<th>Action</th>
				<%}%>
				
				<%if(currUserType.equals("industry")){ %>
					<th>Contact Number</th>
					<th>Address</th>
					<th>City</th>
					<th>Pincode</th>
					<th>Status</th>
				<%}%>
			</tr>
	<% 
			while(rst4.next()){
	%>
			<tr>
				<td><%= rst4.getString(1)%></td>
				<td><%= rst4.getString(2)%></td>
				<td><%= rst4.getString(4)%></td>
				<td><%= rst4.getString(3)%></td>
			
					<%
						if((postStatus == 1 ) && currUserType.equals("dealer") && check	){
					%>
					<td>
						<form class="locationForm" action="map.jsp" method="post">
							<input type="hidden" name="post_id" value="<%= post_id%>">
							<input type="hidden" name="post_status" value="1">
							<input class="btn-primary" type="submit" value="Location">
						</form>
					</td>
					<td>
						<form class="completeForm" action="completePost.jsp" method="post">
							<input type="hidden" name="post_id" value="<%= post_id%>">
							<input type="hidden" name="post_status" value="1">
							<input class="btn-red" type="submit" value="Mark as Complete">
						</form>
					</td>
					
					<%
						}
					%>
				
				
			<%if(currUserType.equals("industry")){ %>
				<td><%= rst4.getString(5)%></td>
				<td><%= rst4.getString(6)%></td>
				<td><%= rst4.getString(7)%></td>
				<td><%= rst4.getString(8)%></td>
				
				<%
					deal_status = Integer.valueOf(rst4.getString(9));
					if(deal_status == 0){%>	
					<td><span class="incomplete-msg"><%= "not completed"%></span></td>
				<% 	}else{ %>
					<td><span class="complete-msg"><%= "completed"%></span></td>
				<% 	} %>
				
			<%}%>
			</tr>
	<%	
			}
	%>
		</table>
	<%
	}
	%>
	</div>
	
	<div class="postAnalytics">
			<canvas id="postChart" width=400 height=90></canvas>
	</div>
	
	<%
		PreparedStatement checkPST = connect.prepareStatement("select 1 from request where post_id=? and dealer_email=?");
		checkPST.setInt(1,post_id);
		checkPST.setString(2,currUserEmailId);
		ResultSet checkResult = checkPST.executeQuery();
		if(checkResult.next()){
			flag = false;
		}else{
			flag = true;
		}
		
		if((postStatus == -1 || postStatus == 0) && currUserType.equals("dealer") && flag){
	%>
	
			<form class="form-sendRequest" action="sendRequest.jsp" method="POST">
				<input type="hidden" name="post_id" value="<%= post_id%>">
				<input type="hidden" name="industry_email" value="<%= industryEmail%>">
				<input class="btn-red" type="submit" value="Accept and Send Request">
			</form>
	<%
		}
	%>
	

	
	<%
		if(currUserType.equals("industry")){
	%>
			<a class="back-button" href="home.jsp"><button class="btn-back">Go to Home</button></a>
		
	<%
		}else if(currUserType.equals("dealer")){
	%>
			<a class="back-button" href="dealer-home.jsp"><button class="btn-back">Go to Home</button></a>
	<%
		}
	%>
	
</div>
</body>
<script type="text/javascript">
	Chart.defaults.global.defaultFontFamily="Montserrat";
	Chart.defaults.global.defaultFontSize = 18;
	var ctx = document.getElementById('postChart').getContext('2d');
	var chart = new Chart(ctx, {
	    // The type of chart we want to create
	    type: 'horizontalBar',
	
	    // The data for our dataset
	    data: {
	        labels: ["Metal","Plastic","Rubber"],
	        datasets: [{
	            label: 'Trash Produced',
	            backgroundColor: [
	                'rgba(255, 99, 132, 0.5)',
	                'rgba(54, 162, 235, 0.5)',
	                'rgba(255, 206, 86, 0.5)'
	            ],
	            data:<% out.println("["+ metalQ + "," + plasticQ + ","+ rubberQ + "," + "]");%>
	        }]
	    },
	
	    // Configuration options go here
	    options: {
	    	responsive: true,
	    	legend: {
	    		position:"bottom",
	    		labels:{
	    			padding:30,
	    			fontColor:"black"
	    		}
	    	},
	    	scales: {
	             yAxes: [{
	                 ticks: {
	                     beginAtZero: true
	                 },
	                 scaleLabel: {
	                     display: true,
	                     labelString: 'Quantity (in kg)'
	                  }
	             }]
	         }
	    }
	});
</script>
</html>