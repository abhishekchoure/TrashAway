<%@ page import="java.util.*,data.Trash,java.sql.*" language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
	<div class="nav-background"></div>
	<% String currUserName = (String)session.getAttribute("user-name"); %>
	<div class="post-module">
		<nav class="main-nav">	
				<div class="logo"><img src="assets/logo.png"></div>
			
				<ul>
					<li><a href="home.jsp">Home</a></li>
					<li><a href="#">Contact Us</a></li>
					<li class="username"><%= currUserName%></li>
					<li><a href="logout.jsp">Logout</a></li>
				</ul>
		</nav>
		<form id="postForm" class="form-post" action="PostModule.jsp" method="post">
			<h2>Enter the Trash Details</h2>
			<div class="group-inputs">
				<div class="label-input">
					<label for="type">Type</label><br>
					<select name="trash-type" >
						<option value="Plastic">Plastic</option>
						<option value="Rubber">Rubber</option>
						<option value="Metal">Metal</option>
					</select>
				</div>
				
				<div class="label-input">
					<label for="quantity">Quantity(in kg)</label><br>
					<input id="input-quantity" type="text" name="trash-quantity" >
				</div>
				
				<div class="label-input">
					<label for="price">Price per kg(in Rs)</label><br>
					<input id="input-price" type="text" name="trash-price" >
				</div>
				
				<div class="label-input">
					<label for="recyclability">Recyclability(in %)</label><br>
					<input id="input-recycle" type="text" name="trash-recycle" >
				</div>
			</div>
			
			<div class="group-btn">
				<button class="btn-add btn-primary" value="Add" name="add">Add</button>
				<button class="btn-clear btn-primary" value="Clear" name="clear">Clear</button>
			</div>
			
			<%! 
				String type[] = null;
				Double quantity = null;
				Double price = null;
				Double recyclability = null;
				ArrayList<Trash> trashList = new ArrayList<Trash>(); 
			%>
		
		
	
		<% 
		  	String checkRequest = request.getParameter("add");
		  	if("Add".equals(checkRequest)){
				type = request.getParameterValues("trash-type");
				quantity = Double.parseDouble(request.getParameter("trash-quantity"));
				price =  Double.parseDouble(request.getParameter("trash-price"));
				recyclability = Double.parseDouble(request.getParameter("trash-recycle"));
				
				if(type!=null && quantity!=null && price!=null){
					Trash trash = new Trash(type[0],quantity,price,recyclability);
					trashList.add(trash);
				}
			}
		  	if("Clear".equals(request.getParameter("clear"))){
		  		trashList.clear();
		  	}
		  	
		  	String deleteBtn = request.getParameter("delete");
			if(deleteBtn!=null){
				for(int i=0;i<trashList.size();i++){
					if(deleteBtn.equals(i + "-Delete")){
						String token[] = deleteBtn.split("-");
						int key = Integer.valueOf(token[0]);
						if(key == i){
							trashList.remove(i);
						}	
					}
				}
			}
		%>
		
		
			<div class="trash-list">
				<table>
					<tr>
						<th>Trash Type</th><th>Quantity(in kg)</th><th>Price per kg</th><th>Recyclability</th>
					</tr>
					
					<%
						if(trashList.isEmpty()){
					%>
						<tr><td colspan="4">No items added yet</td></tr>
					<%
							
						}else{
							for(int i=0;i<trashList.size();i++){
					%>
							
							<tr>
								<td><%= trashList.get(i).getType()%></td>
								<td><%= trashList.get(i).getQuantity()%></td>
								<td><%= trashList.get(i).getPrice()%></td>
								<td><%= trashList.get(i).getRecyclability()%></td>
								<td><button class="btn-delete" name="delete" value="<%= i%>-Delete">X</button></td>
							</tr>
							
					<%
							}
						}
					%>	
					
				</table>	
			</div>
			
			<% if(!trashList.isEmpty()) { %>
				<div class="group-btn">
					<input class="btn-primary btn-submit" type="submit" value="Submit" name="submit">
					<button class="btn-back btn-primary" name="back" value="Back">Back</button>
				</div>	
			<% } %>
		</form> 
		
		<%
			
			checkRequest = request.getParameter("submit");
		  	if("Submit".equals(checkRequest)){
		  		ArrayList<Trash> submitList = new ArrayList<Trash>(trashList);
		  		session.setAttribute("trash-post",submitList);
		  		trashList.clear();
		  		response.sendRedirect("postSucces.jsp");
		  	}
			checkRequest = request.getParameter("back");
			if("Back".equals(checkRequest)){
				  trashList.clear();
				  response.sendRedirect("home.jsp");
			}
		%>
		
		</div>
	</div>
	
</body>
<script>
	/*const postForm = document.getElementById("postForm");
	const inputQuantity = document.getElementById("input-quantity");
	const inputPrice = document.getElementById("input-price");
	const inputRecycle = document.getElementById("input-recycle");

	
		postForm.addEventListener('submit',(e)=>{
		let errorMessages = [];
    	let regex = /^\d+$/;
		
		
    	if(inputQuantity.value === "" || inputPrice.value === "" || inputRecycle.value === ""){
    		errorMessages.push("Please fill all the fields !");
    	}else{ 
    		
	    	if(!regex.test(inputQuantity.value) || inputQuantity.value <= 0){
	    		errorMessages.push("Enter a valid Quantity(in kg) !");
	    	}
	    	
	    	if(!regex.test(inputPrice.value) || inputPrice.value <= 0){
	    		errorMessages.push("Enter a valid Price(per kg) !");
	    	}
	    	
	    	if(!regex.test(inputRecycle.value) || inputRecycle.value <= 0){
	    		errorMessages.push("Enter a valid Recyclability(1-100%) !");
	    	}
    	
    	if(errorMessages.length > 0){
    		e.preventDefault();
    		for(let i=0 ; i < errorMessages.length ; i++){
    			alert(errorMessages[i]);
    		}
    	}
	}); */
</script>
</html>