<%@ page language="java" import="java.util.*,java.sql.*" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<link rel="stylesheet" href="css/style.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.3/Chart.min.js" integrity="sha512-s+xg36jbIujB2S2VKfpGmlC3T5V2TF3lY48DX7u2r9XzGzgPsa6wTpOQA7J9iffvdeBN0q9tKzRxVxw1JviZPg==" crossorigin="anonymous"></script>
</head>
<body class="body-home">
	<%! 
		double plasticQ ,metalQ, rubberQ;
		String currUserEmailId;
		String currUserName;
		String userType;	
		TreeSet<String> yourPosts = new TreeSet<String>();
		String postTime;
		boolean recordFound = false;
		int postCount;
		int postStatus=0;
		int post_id=0;
	%>
	<% 
		currUserEmailId = (String)session.getAttribute("user-email");
		currUserName = (String)session.getAttribute("user-name");
		userType = (String)session.getAttribute("user-type");
		postCount=0;
	%>
	<div class="nav-background"></div>
	<div class="home">
		
		<nav class="main-nav">	
			<div class="logo"><img src="assets/logo.png"></div>
		
			<ul>
				<li><a href="#dashboard">Dashboard</a></li>
				<li><a href="#">Contact Us</a></li>
				<li class="username"><span class="industry-logo"><img src="assets/industry-solid.svg"></span><%= currUserName%></li>
				<li><a href="logout.jsp">Logout</a></li>
			</ul>
		</nav>
		<%
			Class.forName("com.mysql.jdbc.Driver");
			String url2 = "jdbc:mysql://localhost:3306/database";
			Connection connect2 = DriverManager.getConnection(url2,"root","");
			
			PreparedStatement pst2 = connect2.prepareStatement("select post_date from post where industry_email = ? order by post_date DESC");
			pst2.setString(1,currUserEmailId);
			ResultSet result2 = pst2.executeQuery();
			while(result2.next()){
				yourPosts.add(result2.getString(1));
			}
			session.setAttribute("yourPosts",yourPosts);
		%>
		
		<div class="section-posts">
			<h1>Your Recent Posts</h1>

			<div class="post-cards">
			<%
				if(!yourPosts.isEmpty()){
					recordFound = false;
					Class.forName("com.mysql.jdbc.Driver");
					String url = "jdbc:mysql://localhost:3306/database";
					Connection connect = DriverManager.getConnection(url,"root","");
					
					Iterator<String> itr = yourPosts.descendingIterator();
					while(itr.hasNext()){
						String currDate = itr.next();
						PreparedStatement pst = connect.prepareStatement("select post_quantity,post_price,post_status,post_id from post where post_date=? and industry_email=?");
						pst.setString(1,currDate);
						pst.setString(2,currUserEmailId);
						ResultSet rst = pst.executeQuery();
						
						if(rst.next()){
							postCount++;
							recordFound = true;
							rst.previous();
						}else{
							recordFound = false;
						}
						
						if(recordFound && postCount <= 3){
						%>
							<div class="post-card-item">
							<div class="post-date">
								<h3>Posted On:</h3>
								<h3 class="date">Date : <%= currDate%></h3>
							</div>				
							<table id="post-table">
								<tr>
									<th>Total Quantity</th>
									<th>Total Price</th>
								</tr>
								<tr>
								
									<% while(rst.next()){ %>
										<td><%= rst.getDouble(1)%> kg</td>
										<td>Rs <%= rst.getDouble(2)%></td>
										
									
								</tr>
							</table>
							
							
							<%
								postStatus = rst.getInt(3);
							 	post_id = rst.getInt(4);
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
						<%}
							if(postStatus == 0){
							%>
								<form action="request.jsp" method="post">
									<input type="hidden" name="post_id" value="<%= post_id%>">
									<input class="btn-view" type="submit" value="See Requests">
								</form>
							<% 
							}
							%>
							
							<%
							if(postStatus == -1 || postStatus == 1 || postStatus == 2){
							%>
							
								<form action="postDetails.jsp" method="post">
									<input type="hidden" name="post_id" value="<%= post_id%>">
									<input type="hidden" name="post_status" value="<%= postStatus%>">
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
							<h3>No posts done yet!</h3>
						</div>
					<%
				}
				%>
				
			</div>
			<%
				if(postCount != 0){	
			%>
					<a class="link-seeMore" href="industryPosts.jsp">See All Posts</a>
			<%
				}
			%>
			<span class="post-count"><%= postCount%></span>
		</div>
		
		 <main id="dashboard">
		   <h1 class="header-dashboard">Dashboard</h1>
           <div class="cards">
               <div class="card card-report">
                   <h1>Trash Produced</h1>
                   <p>This will give you a glimpse of you're produced trash so far</p>
                   <canvas id="trashReport">
                   		
                   </canvas>
               </div>
               <div class="card card-post">
                   <h1>Trash Piling Up?</h1>
                   <p>Let the dealers know by making a post</p>
                   <form action="PostModule.jsp" method="post">
                   		<input class="btn-post btn-primary" type="submit" value="Post" name="post">
                   </form>
               </div>
               <div class="card card-recent">
                   <h1>You're Notes</h1>
                  	
               </div>
           </div>
        </main>
        
		<footer>
			
		</footer>
	</div>
</body>

<%
	Class.forName("com.mysql.jdbc.Driver");
	String url = "jdbc:mysql://localhost:3306/database";
	Connection connect = DriverManager.getConnection(url,"root","");
	
	PreparedStatement plasticPST = connect.prepareStatement("select sum(quantity) from trash where industry_email=? and type in(select type from trash where type=?)");
	plasticPST.setString(1,currUserEmailId);
	plasticPST.setString(2,"Plastic");
	ResultSet resultPlastic = plasticPST.executeQuery();
	while(resultPlastic.next()){
		plasticQ = resultPlastic.getDouble(1);
	}
	
	PreparedStatement metalPST = connect.prepareStatement("select sum(quantity) from trash where industry_email=? and type in(select type from trash where type=?)");
	metalPST.setString(1,currUserEmailId);
	metalPST.setString(2,"Metal");
	ResultSet resultMetal = metalPST.executeQuery();
	while(resultMetal.next()){
		metalQ = resultMetal.getDouble(1);
	}
	
	PreparedStatement rubberPST = connect.prepareStatement("select sum(quantity) from trash where industry_email=? and type in(select type from trash where type=?)");
	rubberPST.setString(1,currUserEmailId);
	rubberPST.setString(2,"Rubber");
	ResultSet resultRubber = rubberPST.executeQuery();
	while(resultRubber.next()){
		rubberQ = resultRubber.getDouble(1);
	}
%>
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