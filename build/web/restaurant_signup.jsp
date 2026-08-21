<%-- 1. INCLUDE THE HEADER (This must be the first line) --%>
<%@ include file="public_header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <title>WMS · Restaurant Sign Up</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .hero-section {
            background-image: linear-gradient(rgba(12, 45, 31, 0.7), rgba(12, 45, 31, 0.7)), url('${pageContext.request.contextPath}/hero_bg_waste.png');
            background-size: cover;
            background-position: center;
        }
    </style>
</head>
<body class="min-h-screen">

    <%-- The <header> is now provided by the include file --%>

    <div class="hero-section text-white py-16">
        <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <h1 class="text-3xl md:text-4xl font-extrabold leading-tight tracking-tight">Join Our Network</h1>
            <p class="mt-3 text-base md:text-lg text-gray-200 max-w-xl mx-auto">Create your restaurant's account to start tracking waste and access your personalized dashboard.</p>
        </div>
    </div>

    <main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10 -mt-16 relative z-20">
        <div class="card p-8">
            <h2 class="text-2xl font-bold text-dark">Create Your Restaurant Account</h2>
            <p class="text-sm text-muted mt-1">Sign up to access your waste tracking dashboard.</p>
            
            <div class="mt-6">
                <% String message = (String) request.getAttribute("message");
                   if (message != null) {
                     String cls = message.toLowerCase().contains("success") ? "bg-green-100 text-green-800" : "bg-red-100 text-red-800";
                %>
                  <div class="<%= cls %> px-4 py-3 rounded-lg text-sm"><%= message %></div>
                <% } %>
            </div>

            <form action="RestaurantSignUpServlet" method="POST" class="mt-6 grid grid-cols-1 gap-4">
                
                <div class="grid sm:grid-cols-2 gap-4">
                    <div>
                        <label class="text-sm font-medium text-dark">Restaurant Name</label>
                        <input name="name" required class="form-input w-full" placeholder="e.g., Green Fork"/>
                    </div>
                    <div>
                        <label class="text-sm font-medium text-dark">Contact Number</label>
                        <input name="contactNo" type="tel" required class="form-input w-full" placeholder="+8801XXXXXXXXX"/>
                    </div>
                </div>
                
                <div>
                    <label class="text-sm font-medium text-dark">Location / Address</label>
                    <input name="location" required class="form-input w-full" placeholder="Street, City, Postal"/>
                </div>

                <div>
                    <label class="text-sm font-medium text-dark">Daily Waste Quantity (Estimated kg)</label>
                    <input type="number" name="wasteQuantity" step="0.01" min="0" required class="form-input w-full" placeholder="e.g., 35.50"/>
                </div>
                
                <hr class="my-4 border-gray-200"/>
                
                <div>
                    <label class="text-sm font-medium text-dark">Create a Password</label>
                    <input name="password" type="password" required class="form-input w-full" placeholder="Create a secure password"/>
                </div>

                <div class="pt-2">
                    <button type="submit" class="btn-primary">Create Account</button>
                </div>

                <p class="text-sm text-muted mt-4 text-center">Already have an account? <a href="${pageContext.request.contextPath}/restaurant_login.jsp" class="text-green-600 hover:underline">Log in here</a>.</p>
            </form>
        </div>
    </main>
</body>
</html>