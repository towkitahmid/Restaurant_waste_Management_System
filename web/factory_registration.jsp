<%-- 1. INCLUDE THE ADMIN HEADER --%>
<%@ include file="admin_header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <title>WMS · Factory Registration</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-gray-50">

    <%-- The <header> is provided by the include file --%>

    <main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
        <div class="card p-8 bg-white shadow rounded-lg">
            <h2 class="text-2xl font-bold text-gray-800">Register Factory</h2>
            <p class="text-sm text-gray-500 mt-1">Add a new processing facility to the system.</p>

            <div class="mt-6">
                <% String message = (String) request.getAttribute("message");
                   if (message != null) {
                     String cls = message.toLowerCase().contains("success") ? "bg-green-100 text-green-800" : "bg-red-100 text-red-800";
                %>
                  <div class="<%= cls %> px-4 py-3 rounded-lg text-sm"><%= message %></div>
                <% } %>
            </div>

            <form action="FactoryServlet" method="POST" class="mt-6 space-y-6">
                
                <div>
                    <h3 class="text-lg font-semibold text-gray-700 border-b pb-2 mb-4">Factory Information</h3>
                    <div class="grid sm:grid-cols-2 gap-6">
                        <div>
                            <label class="text-sm font-medium text-gray-700 block mb-1">Factory Name</label>
                            <input name="factoryName" required class="form-input w-full border border-gray-300 rounded p-2 focus:ring-2 focus:ring-emerald-500 outline-none" placeholder="e.g., EcoPlast"/>
                        </div>
                        <div>
                            <label class="text-sm font-medium text-gray-700 block mb-1">Factory Type</label>
                            <input name="factoryType" required class="form-input w-full border border-gray-300 rounded p-2 focus:ring-2 focus:ring-emerald-500 outline-none" placeholder="e.g., Recycling"/>
                        </div>
                    </div>
                </div>

                <div class="pt-2 text-right">
                    <button type="submit" class="bg-emerald-600 hover:bg-emerald-700 text-white font-bold py-2 px-6 rounded shadow transition">
                        Register Factory
                    </button>
                </div>
            </form>
        </div>
    </main>
</body>
</html>