<%@ page language="java" import="java.sql.*,java.util.*" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<link rel="stylesheet" href="css/style.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.3/Chart.min.js" integrity="sha512-s+xg36jbIujB2S2VKfpGmlC3T5V2TF3lY48DX7u2r9XzGzgPsa6wTpOQA7J9iffvdeBN0q9tKzRxVxw1JviZPg==" crossorigin="anonymous"></script>
</head>
<body>
<%!
	String currUserEmailId,currUserName,userType;
	int postCount = 0;
	boolean recordFound = false;
%>

<%
	currUserEmailId = (String)session.getAttribute("user-email");
	currUserName = (String)session.getAttribute("user-name");
	userType = (String)session.getAttribute("user-type");
%>

<div class="nav-background"></div>
	<div class="dealer-home">
		<nav class="main-nav">	
			<div class="logo"><img src="assets/logo.png"></div>
		
			<ul>
				<li><a href="#dashboard">DashBoard</a></li>
				<li><a href="#">Contact Us</a></li>
				<li class="username"><span class="dealer-logo"><img src="assets/truck-solid.svg"></span><%= currUserName%></li>
				<li><a href="logout.jsp">Logout</a></li>
			</ul>
		</nav>
		<div class="post-feed">
			<div class="feed-header">
				<h1>Post Feed</h1>
			</div>
			<div class="post-cards">
			<%
				Class.forName("com.mysql.jdbc.Driver");
				String url2 = "jdbc:mysql://localhost:3306/database";
				Connection connect2 = DriverManager.getConnection(url2,"root","");
				
				PreparedStatement pst2 = connect2.prepareStatement("select date(post_date),time(post_date),post_quantity,post_price,industry_name,post_id,post_status from post,industry where industry.industry_email = post.industry_email order by post_date DESC");
				ResultSet rst2 = pst2.executeQuery();
				postCount=0;
				
					while(rst2.next()){
						int postStatus = rst2.getInt(7);
						postCount++;
						if(postCount <= 3){
							if(postStatus == -1 || postStatus == 0){
						%>
							<div class="post-card-item">
								<div class="post-date">
									<h3 class="date">Date : <%= rst2.getString(1)%></h3>
									<h3 class="time">Time : <%= rst2.getString(2)%></h3>
								</div>	
								<h3 class="post-company">Company : <span class="company-name"><%= rst2.getString(5)%></span></h3> 			
								<table id="post-table">
									<tr>
										<th>Trash Type</th>
										<th>Total Quantity</th>
										<th>Total Price</th>
									</tr>
									<tr>
										<td>Combined</td>
										<td><%= rst2.getDouble(3)%> kg</td>
										<td>Rs <%= rst2.getDouble(4)%></td>		
									</tr>
								</table>
							<%
								switch(postStatus){
									case -1: %><h3 class="post-status-published"><%= "published"%></h3><%
											break;
									case 0: %><h3 class="post-status-ongoing"><%= "requested"%></h3><%
											break;
									case 1: %><h3 class="post-status-assigned"><%= "assigned"%></h3><%
											break;
									case 2: %><h3 class="post-status-completed"><%= "completed"%></h3><%
											break;
								}
							%>
							<%
								if(postStatus == 0 || postStatus == -1 || postStatus == 1 || postStatus == 2){
							%>
								<form action="postDetails.jsp" method="post">
									<input type="hidden" name="post_id" value="<%= rst2.getInt(6)%>">
									<input type="hidden" name="post_status" value="<%= rst2.getInt(7)%>">
									<input class="btn-view" type="submit" value="View Details">
								</form>
							<%
							}
							%>
						</div>
						<%	
						}
					}	
				}
				
				if(postCount == 0){	
					%>
						<div class="post-card-item">
							<h3>No new posts yet!</h3>
						</div>
					<%
				}
			%>
			<%
				if(postCount != 0){	
			%> 
					<a class="link-seeMore" href="allPosts.jsp">See All Posts</a>
			<%
				}	
			%> 
			</div>	
			<span class="post-count"><%= postCount%></span><br>
			<hr class="seperator">
		</div>
		
		<div class="posts-assigned">
			<div class="feed-header">
					<h1>You're Assigned Posts</h1>
			</div>
			<div class="post-cards">
			<% 
				PreparedStatement pst = connect2.prepareStatement("select date(post_date),time(post_date),post_quantity,post_price,industry_name,post_id from post,industry where industry.industry_email = post.industry_email and post_status = ? and post_id in (select post_id from deal where dealer_email=?) order by post_date DESC");
				pst.setInt(1,1);
				pst.setString(2,currUserEmailId);
				ResultSet rst = pst.executeQuery();
				postCount = 0;
						
				while(rst.next()){
					postCount++;
					
					if(postCount <= 3) {
				%>
					<div class="post-card-item">
						<div class="post-date">
							<h3 class="date">Date : <%= rst.getString(1)%></h3>
							<h3 class="time">Time : <%= rst.getString(2)%></h3>
						</div>	
						<h3 class="post-company">Company : <span class="company-name"><%= rst.getString(5)%></span></h3> 					
						<table id="post-table">
							<tr>
								<th>Trash Type</th>
								<th>Total Quantity</th>
								<th>Total Price</th>
							</tr>
							<tr>
								<td>E-waste</td>
								<td><%= rst.getDouble(3)%> kg</td>
								<td>Rs <%= rst.getDouble(4)%></td>		
							</tr>
						</table>
						<form action="postDetails.jsp" method="post">
								<input type="hidden" name="post_id" value="<%= rst.getInt(6)%>">
								<input type="hidden" name="post_status" value="1">
								<input class="btn-view" type="submit" value="View Details">
						</form>
						<form action="completePost.jsp" method="post">
								<input type="hidden" name="post_id" value="<%= rst.getInt(6)%>">
								<input type="hidden" name="post_status" value="1">
								<input class="btn-complete" type="submit" value="Mark as Complete">
						</form>
					</div>
					<%	
					}
				}
				
				
				if(postCount == 0){	
					%>
						<div class="post-card-item">
							<h3>Nothing assigned yet!</h3>
						</div>
					<%
				}
				%>
				<%
				if(postCount != 0){	
				%> 
					<a class="link-seeMore" href="allPosts.jsp">See All Posts</a>
				<%
				}	
				%> 
			</div>
			<span class="post-count"><%= postCount%></span><br>
			<hr class="seperator">
		</div>
		
		<div class="posts-requested">
			<div class="feed-header">
					<h1>Your're Requested Posts</h1>
			</div>
			<div class="post-cards">
			<% 	
				PreparedStatement pst3 = connect2.prepareStatement("select date(post_date),time(post_date),post_quantity,post_price,industry_name,post_id from post,industry where industry.industry_email = post.industry_email and post_status = ? and post_id in (select post_id from request where dealer_email=?)order by post_date DESC");
				pst3.setInt(1,0);
				pst3.setString(2,currUserEmailId);
				ResultSet rst3 = pst3.executeQuery();
				postCount = 0;
						
		
				while(rst3.next()){
					postCount++;
					if(postCount <= 3) {
				%>
					<div class="post-card-item">
						<div class="post-date">
							<h3 class="date">Date : <%= rst3.getString(1)%></h3>
							<h3 class="time">Time : <%= rst3.getString(2)%></h3>
						</div>	
						<h3 class="post-company">Company : <span class="company-name"><%= rst3.getString(5)%></span></h3> 				
						<table id="post-table">
							<tr>
								<th>Trash Type</th>
								<th>Total Quantity</th>
								<th>Total Price</th>
							</tr>
							<tr>
								<td>E-waste</td>
								<td><%= rst3.getDouble(3)%> kg</td>
								<td>Rs <%= rst3.getDouble(4)%></td>		
							</tr>
						</table>
						<form action="postDetails.jsp" method="post">
								<input type="hidden" name="post_id" value="<%= rst3.getInt(6)%>">
								<input type="hidden" name="post_status" value="0">
								<input class="btn-view" type="submit" value="View Details">
						</form>
					</div>
					<%	
					}
				}

				if(postCount == 0){	
					%>
						<div class="post-card-item">
							<h3>No new requests made yet!</h3>
						</div>
					<%
				}
			%>
			<%
				if(postCount != 0){	
			%> 
					<a class="link-seeMore" href="allPosts.jsp">See All Posts</a>
			<%
				}	
			%> 
			</div>
			<span class="post-count"><%= postCount%></span><br>
			<hr class="seperator">
		</div>
		
		
		<main id="dashboard">
		   <h1 class="header-dashboard">Dashboard</h1>
           <div class="cards">
               <div class="card card-report">
                   <h1>Trash Collected</h1>
                   <p>This will give you a glimpse of you're collected trash so far</p>
                   <canvas id="trashReport">
                   		
                   </canvas>
               </div>
               <div class="card card-post">
       
               </div>
               <div class="card card-recent">
                   <h1>You're Latest Deals</h1>
               </div>
           </div>
    	</main>
	</div>
</body>
<script type="text/javascript">
	Chart.defaults.global.defaultFontFamily="Montserrat";
	Chart.defaults.global.defaultFontSize = 18;
	var ctx = document.getElementById('trashReport').getContext('2d');
	var chart = new Chart(ctx, {
	    // The type of chart we want to create
	    type: 'bar',
	
	    // The data for our dataset
	    data: {
	        labels: ["Metal","Plastic","Rubber"],
	        datasets: [{
	            label: 'Trash Collection',
	            backgroundColor: [
	                'rgba(255, 99, 132, 0.5)',
	                'rgba(54, 162, 235, 0.5)',
	                'rgba(255, 206, 86, 0.5)'
	            ],
	            data: <%out.println("[100,200,300]");%>
	        }]
	    },
	
	    // Configuration options go here
	    options: {
        scales: {
            yAxes: [{
                ticks: {
                    beginAtZero: true
                }
            }]
        }
    }
	});
</script>
<script>
const btn = document.querySelector(".completeBtn");
const popup = document.querySelector(".pop-up");
const body = document.querySelector('body');
const confirmBtn = document.querySelector('.confirm');

btn.addEventListener('click',(e)=>{
  body.classList.add('hide');
  popup.classList.add('pop');
  btn.classList.add('hide-button');
});

confirmBtn.addEventListener('click',(e)=>{
  body.classList.remove('hide');
  popup.classList.remove('pop');
  btn.classList.remove('hide-button');
});
</script>
</html>