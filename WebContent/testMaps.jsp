<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
  <head>
  <link rel="stylesheet" href="map.css">
   <script src="index.js"></script>
    <title>Add Map</title>
    <script
      src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAziSBHQU9sN-jbPbmjO8Gh8jRoAkaATMs&callback=initMap&libraries=&v=weekly"
      defer
    ></script>
    <link rel="stylesheet" href="map.css" >
  </head>
  <body>
    <h3>My Google Maps Demo</h3>
   
    <div id="map"></div>
  </body>
  <script>
	  function initMap() {
		  // The location 
		  const location = { lat: 18.637497, lng: 73.836021 };
		  
		  // The map, centered 
		  const map = new google.maps.Map(document.getElementById("map"), {
		    zoom: 10,
		    center: location	
		  });
		  // The marker, positioned 
		  const marker = new google.maps.Marker({
		    position: location,
		    map: map,
		  });
	}
  </script>
</html>