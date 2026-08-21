<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.wms.util.DBUtil, java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>WMS · Admin Collection Report</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-gray-50 text-gray-800 font-sans">

    <header class="bg-emerald-800 text-white shadow-lg">
        <div class="max-w-7xl mx-auto px-4 py-4 flex items-center justify-between">
            <h1 class="text-lg font-bold">Admin Reports</h1>
            <nav class="text-sm space-x-4">
                <a href="dashboard.jsp" class="hover:text-emerald-200 transition">Back to Dashboard</a>
            </nav>
        </div>
    </header>

    <main class="max-w-7xl mx-auto px-4 py-8">
        
        <div class="bg-white rounded-lg shadow p-6 mb-8 border border-gray-100">
            <h2 class="text-lg font-semibold text-gray-700 mb-4 border-b pb-2">Filter Records</h2>
            
            <form method="GET" action="admin_collection_report.jsp" class="grid grid-cols-1 md:grid-cols-4 gap-4 items-end">
                
                <div>
                    <label class="block text-sm font-medium text-gray-600 mb-1">Restaurant</label>
                    <select name="restaurantId" class="w-full border p-2 rounded focus:outline-none focus:border-emerald-500">
                        <option value="ALL">All Restaurants</option>
                        <%
                            Connection conn = null;
                            Statement stmt = null;
                            ResultSet rs = null;
                            String selectedRestId = request.getParameter("restaurantId");
                            if(selectedRestId == null) selectedRestId = "ALL";

                            try {
                                conn = DBUtil.getConnection();
                                stmt = conn.createStatement();
                                rs = stmt.executeQuery("SELECT Restaurant_ID, Name FROM Restaurant ORDER BY Name");
                                while(rs.next()){
                                    String rId = String.valueOf(rs.getInt("Restaurant_ID"));
                                    String rName = rs.getString("Name");
                                    String isSelected = rId.equals(selectedRestId) ? "selected" : "";
                        %>
                                <option value="<%= rId %>" <%= isSelected %>><%= rName %></option>
                        <%
                                }
                            } catch(Exception e) {
                                out.println("<option disabled>Error loading</option>");
                            } finally {
                                if(rs!=null) rs.close();
                                if(stmt!=null) stmt.close();
                                // Connection kept open for next query
                            }
                        %>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-600 mb-1">From Date</label>
                    <input type="date" name="startDate" value="<%= request.getParameter("startDate") == null ? "" : request.getParameter("startDate") %>" class="w-full border p-2 rounded">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-600 mb-1">To Date</label>
                    <input type="date" name="endDate" value="<%= request.getParameter("endDate") == null ? "" : request.getParameter("endDate") %>" class="w-full border p-2 rounded">
                </div>

                <div>
                    <button type="submit" class="w-full bg-emerald-600 text-white font-medium py-2 px-4 rounded hover:bg-emerald-700 transition">
                        Apply Filter
                    </button>
                </div>
            </form>
        </div>

        <div class="bg-white rounded-lg shadow overflow-hidden">
            <div class="px-6 py-4 border-b bg-gray-50 flex justify-between items-center">
                <h3 class="font-bold text-gray-700">Detailed Logs</h3>
            </div>
            
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Date</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Restaurant</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Type</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Status</th>
                            <th class="px-6 py-3 text-right text-xs font-bold text-gray-500 uppercase">Weight (kg)</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <%
                            PreparedStatement ps = null;
                            ResultSet rsReport = null;
                            double totalWeight = 0.0;
                            boolean hasResults = false;

                            try {
                                // Dynamic SQL Builder
                                StringBuilder sql = new StringBuilder();
                                sql.append("SELECT cl.Collection_Date, r.Name, cl.Waste_Type, cl.Waste_Weight, t.Type AS TruckType ");
                                sql.append("FROM Collection_Log cl ");
                                sql.append("JOIN Restaurant r ON cl.Restaurant_ID = r.Restaurant_ID ");
                                sql.append("LEFT JOIN Waste_Collection_Truck t ON cl.Truck_ID = t.Truck_ID ");
                                sql.append("WHERE 1=1 "); // base clause

                                List<Object> params = new ArrayList<>();

                                // 1. Filter by Restaurant
                                if (!selectedRestId.equals("ALL")) {
                                    sql.append("AND cl.Restaurant_ID = ? ");
                                    params.add(Integer.parseInt(selectedRestId));
                                }

                                // 2. Filter by Start Date
                                String startDate = request.getParameter("startDate");
                                if (startDate != null && !startDate.isEmpty()) {
                                    sql.append("AND cl.Collection_Date >= ? ");
                                    params.add(java.sql.Date.valueOf(startDate));
                                }
                                
                                // 3. Filter by End Date
                                String endDate = request.getParameter("endDate");
                                if (endDate != null && !endDate.isEmpty()) {
                                    sql.append("AND cl.Collection_Date <= ? ");
                                    params.add(java.sql.Date.valueOf(endDate));
                                }

                                sql.append("ORDER BY cl.Collection_Date DESC");

                                ps = conn.prepareStatement(sql.toString());
                                for (int i = 0; i < params.size(); i++) {
                                    ps.setObject(i + 1, params.get(i));
                                }

                                rsReport = ps.executeQuery();

                                while (rsReport.next()) {
                                    hasResults = true;
                                    double w = rsReport.getDouble("Waste_Weight");
                                    totalWeight += w;
                                    String truck = rsReport.getString("TruckType");
                                    String status = (truck == null) ? "Pending" : "Collected";
                                    String statusClass = (truck == null) ? "text-yellow-600 bg-yellow-100" : "text-green-800 bg-green-100";
                        %>
                                <tr>
                                    <td class="px-6 py-4 text-sm text-gray-600"><%= rsReport.getDate("Collection_Date") %></td>
                                    <td class="px-6 py-4 text-sm font-medium text-gray-900"><%= rsReport.getString("Name") %></td>
                                    <td class="px-6 py-4 text-sm text-gray-600"><%= rsReport.getString("Waste_Type") %></td>
                                    <td class="px-6 py-4 text-sm">
                                        <span class="px-2 py-1 rounded-full text-xs font-bold <%= statusClass %>"><%= status %></span>
                                    </td>
                                    <td class="px-6 py-4 text-sm text-right font-bold text-gray-700"><%= w %></td>
                                </tr>
                        <%
                                }
                            } catch (Exception e) {
                                out.println("<tr><td colspan='5' class='p-4 text-red-500'>Error: " + e.getMessage() + "</td></tr>");
                            } finally {
                                if (rsReport != null) try { rsReport.close(); } catch (SQLException e) {}
                                if (ps != null) try { ps.close(); } catch (SQLException e) {}
                                DBUtil.closeConnection(conn);
                            }
                        %>
                        <% if (!hasResults) { %>
                            <tr><td colspan="5" class="px-6 py-10 text-center text-gray-400 italic">No records found.</td></tr>
                        <% } %>
                    </tbody>
                    <tfoot class="bg-gray-100">
                        <tr>
                            <td colspan="4" class="px-6 py-3 text-right text-sm font-bold text-gray-700">TOTAL:</td>
                            <td class="px-6 py-3 text-right text-sm font-bold text-emerald-700"><%= String.format("%.2f", totalWeight) %> kg</td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </main>
</body>
</html>