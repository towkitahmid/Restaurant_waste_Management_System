<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>WMS · Restaurant Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 h-screen flex items-center justify-center">
    <div class="bg-white p-8 rounded-lg shadow-lg w-96">
        <h2 class="text-2xl font-bold mb-6 text-emerald-800">Restaurant Portal</h2>
        
        <% String error = (String) request.getAttribute("error"); 
           if (error != null) { %>
            <div class="bg-red-100 border text-red-700 px-4 py-2 rounded mb-4 text-sm"><%= error %></div>
        <% } %>

        <form action="RestaurantLoginServlet" method="POST" class="space-y-4">
            <div>
                <label class="block text-sm font-medium text-gray-700">Restaurant Name</label>
                <input type="text" name="name" required class="mt-1 block w-full border border-gray-300 rounded-md p-2" placeholder="e.g. Green Fork">
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700">Password</label>
                <input type="password" name="password" required class="mt-1 block w-full border border-gray-300 rounded-md p-2">
            </div>
            <button type="submit" class="w-full bg-emerald-600 text-white py-2 rounded-md hover:bg-emerald-700">Login</button>
        </form>
        <div class="mt-4 text-center text-sm">
            <a href="index.jsp" class="text-emerald-600 hover:underline">Back to Home</a>
        </div>
    </div>
</body>
</html>