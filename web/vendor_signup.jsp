<%-- 1. INCLUDE THE HEADER --%>
<%@ include file="public_header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <title>WMS · Vendor Sign Up</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .hero-section {
            background-image: linear-gradient(rgba(124, 45, 18, 0.8), rgba(124, 45, 18, 0.8)), url('https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?auto=format&fit=crop&q=80');
            background-size: cover;
            background-position: center;
        }
    </style>
</head>
<body class="min-h-screen bg-gray-50">

    <%-- Header provided by include --%>

    <div class="hero-section text-white py-16">
        <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <h1 class="text-3xl md:text-4xl font-extrabold leading-tight tracking-tight">Become a Distribution Partner</h1>
            <p class="mt-3 text-base md:text-lg text-orange-100 max-w-xl mx-auto">Join our network to receive recycled products and distribute them to retail outlets.</p>
        </div>
    </div>

    <main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10 -mt-16 relative z-20">
        <div class="card p-8 bg-white rounded-lg shadow-lg">
            <h2 class="text-2xl font-bold text-gray-800">Register New Vendor Account</h2>
            <p class="text-sm text-gray-500 mt-1">Create an account to access the Vendor Distributor Portal.</p>
            
            <div class="mt-6">
                <% String message = (String) request.getAttribute("message");
                   if (message != null) {
                     String cls = message.toLowerCase().contains("success") ? "bg-green-100 text-green-800" : "bg-red-100 text-red-800";
                %>
                  <div class="<%= cls %> px-4 py-3 rounded-lg text-sm"><%= message %></div>
                <% } %>
            </div>

            <form action="VendorSignUpServlet" method="POST" class="mt-6 grid grid-cols-1 gap-6">
                
                <div class="grid sm:grid-cols-2 gap-6">
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Vendor / Company Name</label>
                        <input name="name" required class="form-input w-full mt-1 border-gray-300 rounded-md shadow-sm" placeholder="e.g., City Retailers"/>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700">License Number</label>
                        <input name="licenseNo" required class="form-input w-full mt-1 border-gray-300 rounded-md shadow-sm" placeholder="e.g., LIC-998811"/>
                    </div>
                </div>
                
                <div>
                    <label class="block text-sm font-medium text-gray-700">Category</label>
                    <select name="category" required class="form-input w-full mt-1 border-gray-300 rounded-md shadow-sm bg-white">
                        <option value="Distributor">Distributor</option>
                        <option value="Wholesaler">Wholesaler</option>
                        <option value="Retail Chain">Retail Chain</option>
                        <option value="Recycling Partner">Recycling Partner</option>
                    </select>
                </div>
                
                <hr class="border-gray-200"/>
                
                <div>
                    <label class="block text-sm font-medium text-gray-700">Create Password</label>
                    <input name="password" type="password" required class="form-input w-full mt-1 border-gray-300 rounded-md shadow-sm" placeholder="Secure password"/>
                </div>

                <div class="pt-2">
                    <button type="submit" class="w-full flex justify-center py-3 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-orange-600 hover:bg-orange-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-orange-500 transition">
                        Register Account
                    </button>
                </div>

                <p class="text-sm text-gray-500 mt-4 text-center">Already have an account? <a href="vendor_login.jsp" class="text-orange-600 hover:underline">Log in here</a>.</p>
            </form>
        </div>
    </main>
</body>
</html>