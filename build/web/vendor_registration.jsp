<%-- 1. INCLUDE THE ADMIN HEADER (This must be the first line) --%>
<%@ include file="admin_header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <title>WMS · Vendor Registration</title>
    <script src="https://cdn.tailwindcss.com"></script>
    
    <%-- Styles are now in the header file --%>
</head>
<body class="min-h-screen">

    <%-- The <header> is now provided by the include file --%>

    <main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
        <div class="card p-8">
            <h2 class="text-2xl font-bold text-dark">Register Vendor</h2>
            <p class="text-sm text-muted mt-1">Add new recycling or supply vendors to the system.</p>

            <div class="mt-6">
                <% String message = (String) request.getAttribute("message");
                   if (message != null) {
                     String cls = message.toLowerCase().contains("success") ? "bg-green-100 text-green-800" : "bg-red-50 text-red-800";
                %>
                  <div class="<%= cls %> px-4 py-3 rounded-lg text-sm"><%= message %></div>
                <% } %>
            </div>

            <form action="VendorServlet" method="POST" class="mt-6 grid grid-cols-1 gap-4">
                <div>
                    <label class="text-sm font-medium text-dark">Vendor Name</label>
                    <input name="name" required class="form-input w-full mt-1" placeholder="e.g., Dhaka Recyclers"/>
                </div>
                
                <div class="grid sm:grid-cols-2 gap-4">
                    <div>
                        <label class="text-sm font-medium text-dark">Category</label>
                        <select name="category" required class="form-input w-full mt-1">
                            <option value="">-- Select Category --</option>
                            <option value="Plastic Recycler">Plastic Recycler</option>
                            <option value="Paper Mill">Paper Mill</option>
                            <option value="Organic Composter">Organic Composter</option>
                            <option value="Metal Scrapper">Metal Scrapper</option>
                        </select>
                    </div>
                    <div>
                        <label class="text-sm font-medium text-dark">License Number</label>
                        <input name="licenseNo" required class="form-input w-full mt-1" placeholder="e.g., DNCC-LIC-8812"/>
                    </div>
                </div>

                <div class="pt-2">
                    <button type="submit" class="btn-primary">Register Vendor</button>
                </div>
            </form>
        </div>
    </main>
</body>
</html>