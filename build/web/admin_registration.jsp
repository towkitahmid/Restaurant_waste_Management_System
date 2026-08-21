<%-- 1. INCLUDE THE ADMIN HEADER (This must be the first line) --%>
<%@ include file="admin_header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <title>WMS · Create Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    
    <%-- Styles are now in the header file --%>
</head>
<body class="min-h-screen">

    <%-- The <header> is now provided by the include file --%>

    <main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
        <div class="card p-8">
            <h2 class="text-2xl font-bold text-dark">Create New Admin User</h2>
            <p class="text-sm text-muted mt-1">This user will have access to the admin dashboard.</p>
            
            <div class="mt-6">
                <% String message = (String) request.getAttribute("message");
                   if (message != null) {
                     String cls = message.toLowerCase().contains("success") ? "bg-green-100 text-green-800" : "bg-red-50 text-red-800";
                %>
                  <div class="<%= cls %> px-4 py-3 rounded-lg text-sm"><%= message %></div>
                <% } %>
            </div>

            <form action="AdminRegistrationServlet" method="POST" class="mt-6 grid grid-cols-1 gap-4">
                
                <div class="grid sm:grid-cols-2 gap-4">
                    <div>
                        <label class="text-sm font-medium text-dark">Full Name</label>
                        <input name="name" required class="form-input w-full mt-1" placeholder="e.g., Jane Doe"/>
                    </div>
                    <div>
                        <label class="text-sm font-medium text-dark">Contact Number</label>
                        <input name="contact" type="tel" required class="form-input w-full mt-1" placeholder="+8801..."/>
                    </div>
                </div>

                <div>
                    <label class="text-sm font-medium text-dark">Role</label>
                    <input name="role" required class="form-input w-full mt-1" placeholder="e.g., Regional Supervisor"/>
                </div>

                <hr class="my-2 border-gray-200"/>
                
                <div>
                    <label class="text-sm font-medium text-dark">Create a Password</label>
                    <input name="password" type="password" required class="form-input w-full mt-1" placeholder="Set a temporary password"/>
                </div>

                <div class="pt-2">
                    <button type="submit" class="btn-primary">Create Admin Account</button>
                </div>
            </form>
        </div>
    </main>
</body>
</html>