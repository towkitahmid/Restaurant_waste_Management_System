<%-- 1. INCLUDE THE ADMIN HEADER --%>
<%@ include file="admin_header.jsp" %>
<%@ page import="com.wms.util.DBUtil, java.sql.*, java.util.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>WMS · Register Truck</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-gray-50">

    <main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
        <div class="card p-8 bg-white shadow rounded-lg border-l-4 border-blue-600">
            <h2 class="text-2xl font-bold text-gray-800">Register Truck</h2>
            <p class="text-sm text-gray-500 mt-1">Add a new vehicle to the logistics fleet.</p>

            <div class="mt-6">
                <% String message = (String) request.getAttribute("message");
                   if (message != null) {
                     String cls = message.toLowerCase().contains("success") ? "bg-green-100 text-green-800" : "bg-red-100 text-red-800";
                %>
                  <div class="<%= cls %> px-4 py-3 rounded-lg text-sm"><%= message %></div>
                <% } %>
            </div>

            <form action="TruckServlet" method="POST" class="mt-6 space-y-6">
                
                <div class="grid sm:grid-cols-2 gap-6">
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Truck Type</label>
                        <select name="type" required class="form-input w-full border border-gray-300 rounded p-2 mt-1">
                            <option>Compactor</option>
                            <option>Dump Truck</option>
                            <option>Recycling Van</option>
                            <option>Flatbed</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Capacity (Tons)</label>
                        <input type="number" step="0.1" name="capacity" required class="form-input w-full border border-gray-300 rounded p-2 mt-1" placeholder="e.g. 5.5"/>
                    </div>
                </div>

                <div class="grid sm:grid-cols-2 gap-6">
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Registration Area</label>
                        <input name="regArea" required class="form-input w-full border border-gray-300 rounded p-2 mt-1" placeholder="e.g. North Zone"/>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Assign Driver</label>
                        <select name="driverId" required class="form-input w-full border border-gray-300 rounded p-2 mt-1">
                            <option value="" disabled selected>-- Select Driver --</option>
                            <% 
                            Connection conn = null; Statement stmt = null; ResultSet rs = null;
                            try {
                                conn = DBUtil.getConnection();
                                stmt = conn.createStatement();
                                // Select only employees who are Drivers
                                rs = stmt.executeQuery("SELECT Emp_ID, First_Name, Last_Name FROM Employee WHERE Role='Driver'");
                                while(rs.next()){
                                    out.println("<option value='"+rs.getInt("Emp_ID")+"'>"+rs.getString("First_Name")+" "+rs.getString("Last_Name")+"</option>");
                                }
                            } catch(Exception e){} finally { if(conn!=null) DBUtil.closeConnection(conn); }
                            %>
                        </select>
                        <p class="text-xs text-gray-400 mt-1">Only employees with 'Driver' role appear here.</p>
                    </div>
                </div>

                <div class="pt-2 text-right">
                    <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded shadow transition">
                        Add Vehicle
                    </button>
                </div>
            </form>
        </div>
    </main>
</body>
</html>