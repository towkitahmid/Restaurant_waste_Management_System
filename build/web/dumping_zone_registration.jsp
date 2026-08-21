<%-- 1. INCLUDE THE ADMIN HEADER (This must be the first line) --%>
<%@ include file="admin_header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <title>WMS · Dumping Zone</title>
    <script src="https://cdn.tailwindcss.com"></script>
    
    <%-- Styles are now in the header file --%>
</head>
<body class="min-h-screen">

    <%-- The <header> is now provided by the include file --%>

    <main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
        <div class="card p-8">
            <h2 class="text-2xl font-bold text-dark">Register Dumping Zone</h2>
            <p class="text-sm text-muted mt-1">Add new landfill or disposal areas to the system.</p>

            <div class="mt-6">
                <% String message = (String) request.getAttribute("message");
                   if (message != null) {
                     String cls = message.toLowerCase().contains("success") ? "bg-green-100 text-green-800" : "bg-red-50 text-red-800";
                %>
                  <div class="<%= cls %> px-4 py-3 rounded-lg text-sm"><%= message %></div>
                <% } %>
            </div>

            <form action="DumpingZoneServlet" method="POST" class="mt-6 grid grid-cols-1 gap-4">
                
                <div class="grid sm:grid-cols-3 gap-4">
                    <div>
                        <label class="text-sm font-medium text-dark">Area Name</label>
                        <input name="area" required class="form-input w-full mt-1" placeholder="e.g., Amin Bazar Landfill"/>
                    </div>
                    <div>
                        <label class="text-sm font-medium text-dark">Zone Type</label>
                        <select name="type" required class="form-input w-full mt-1">
                            <option value="">-- Select Type --</option>
                            <option value="Landfill">Landfill</option>
                            <option value="Temporary">Temporary</option>
                            <option value="Hazardous">Hazardous</option>
                        </select>
                    </div>
                    <div>
                        <label class="text-sm font-medium text-dark">Capacity (tons)</label>
                        <input name="capacity" type="number" step="0.01" min="0" required class="form-input w-full mt-1"/>
                    </div>
                </div>

                <div class="pt-2">
                    <button type="submit" class="btn-primary">Register Zone</button>
                </div>
            </form>
        </div>
    </main>
</body>
</html>