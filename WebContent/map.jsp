<%@ page language="java" import="java.sql.*" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
  <head>
  <link rel="stylesheet" href="css/map.css">
  <link rel="stylesheet" href="css/style.css">
    <title>Add Map</title>
    <!-- <script
      src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAziSBHQU9sN-jbPbmjO8Gh8jRoAkaATMs&callback=initMap&libraries=&v=weekly"
      defer
    ></script> -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css"
   integrity="sha512-xodZBNTC5n17Xt2atTPuE1HxjVMSvLVW9ocqUKLsCC5CXdbqCmblAshOMAS6/keqq/sMZMZ19scR4PsZChSR7A=="
   crossorigin=""/>
   <script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js"
   integrity="sha512-XQoYMqMTK8LvdxXYG3nZ448hOEQiglfqkJs1NOQV44cWnUrBc8PkAOcXy20w0vlaXaVUearIOBhiXZ5V3ynxwA=="
   crossorigin=""></script>
    <link rel="stylesheet" href="css/map.css" >
    <style>
    	#mapid { height: 300px; }
    </style>
  </head>
  <%!
  		int post_id;
  		int postStatus;
  		String currUserEmailId,currUserName;
  		float lat,lng;
  		String industryName;
  %>
  <%
  		Class.forName("com.mysql.jdbc.Driver");
		String url = "jdbc:mysql://localhost:3306/database";
		Connection connect = DriverManager.getConnection(url,"root","");
		post_id = Integer.valueOf(request.getParameter("post_id"));
		postStatus = Integer.valueOf(request.getParameter("post_status"));
		currUserEmailId = (String)session.getAttribute("user-email");
		currUserName = (String)session.getAttribute("user-name");
		PreparedStatement pst = connect.prepareStatement("select lat,lng,industry_name from industry,deal where industry.industry_email = deal.industry_email and deal.industry_email in (select industry_email from deal where post_id=? and dealer_email = ?)");
		pst.setInt(1,post_id);
		pst.setString(2,currUserEmailId);
		ResultSet rst = pst.executeQuery();
		if(rst.next()){
			lat = rst.getFloat(1);
			lng = rst.getFloat(2);
			industryName = rst.getString(3);
		}
  %>
  
  <body>
  	<div class="nav-background"></div>
  	<div class="mapPage">
		<nav class="main-nav">	
			<div class="logo"><img src="assets/logo.png"></div>
		
			<ul>
				<li><a href="dealer-home.jsp">Home</a></li>
				<li><a href="#">Contact Us</a></li>
				<li class="username"><span class="dealer-logo"><img src="assets/truck-solid.svg"></span><%= currUserName%></li>
				<li><a href="logout.jsp">Logout</a></li>
			</ul>
		</nav>
	    <h1 class="post-header">Location of <%= industryName%> :	</h1><br>
	   <!-- 	<div id="map"></div><br> -->
	   	<div id="mapid"></div><br><br>
	   	<button class="btn-primary" onclick="goBack()">Go Back</button>
   	</div>
  </body>	
  <script>
  		
  	   function goBack() {
	  		window.history.back();
	   }
	 <%--  function initMap() {
		  // The location of Uluru
		 const location = { lat: <%= lat%>, lng: <%= lng%>};
		  // The map, centered at Uluru
		  const map = new google.maps.Map(document.getElementById("map"), {
		    zoom: 10,
		    center: location,	
		  });
		  // The marker, positioned at Uluru
		  const marker = new google.maps.Marker({
		    position: location,
		    map: map,
		  });
		}
	   --%>
	  	var mymap = L.map('mapid').setView([<%= lat%>, <%= lng%>], 14);
	  	
	  	L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
	  	    attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
	  	    maxZoom: 18,
	  	    id: 'mapbox/streets-v11',
	  	    tileSize: 512,
	  	    zoomOffset: -1,
	  	    accessToken: 'sk.eyJ1IjoiYWJoaXNoZWtjaG91cmUiLCJhIjoiY2toNzlhNzd3MDFiajJ5bWluYmVrY3kwcSJ9.qgnfrpdrRXp39jtEV-7yMA'
	  	}).addTo(mymap);
	  	
	  	var marker = L.marker([<%= lat%>, <%= lng%>]).addTo(mymap);
  </script>
</html>