<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.wms.util.DBUtil, java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <title>WMS · Collection Log</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .brand-bg { background: linear-gradient(90deg,#064e3b,#047857 60%); }
    </style>
</head>
<body class="min-h-screen bg-gray-50">

    <header class="brand-bg text-white shadow-md">
        <div class="max-w-7xl mx-auto px-4 py-4 flex items-center justify-between">
            <div class="flex items-center gap-3">
                <div class="w-9 h-9 bg-white/10 rounded-md flex items-center justify-center">
                    <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M3 7h18M3 12h18M3 17h18"/></svg>
                </div>
                <div>
                    <div class="font-semibold">WMS · Master Log</div>
                    <div class="text-xs text-white/80">System-wide Collection History</div>
                </div>
            </div>
            <div><a href="dashboard.jsp" class="text-white/90 hover:underline text-sm font-medium">Back to Dashboard</a></div>
        </div>
    </header>

    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
        
        <div class="bg-white rounded-lg shadow-lg overflow-hidden border border-gray-200">
            <div class="px-6 py-5 border-b border-gray-100 bg-gray-50 flex justify-between items-center">
                <div>
                    <h2 class="text-xl font-bold text-gray-800">Live Collection Feed</h2>
                    <p class="text-sm text-gray-500">Real-time status of all waste collection requests.</p>
                </div>
                <div class="flex items-center gap-2">
                    <span class="w-2 h-2 rounded-full bg-green-500 animate-pulse"></span>
                    <span class="text-xs font-semibold text-gray-600 uppercase tracking-wide">Live</span>
                </div>
            </div>
            
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">Date</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">Restaurant</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">Waste</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">Assigned Truck</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">Destination Zone</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">Status</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-100">
                        <%
                        Connection conn = null;
                        try {
                            conn = DBUtil.getConnection();
                            
                            // Complex Query to get readable names instead of IDs
                            // Joins Restaurant, Truck, and Zone tables
                            String sqlList = "SELECT cl.Collection_Date, r.Name AS RestName, cl.Waste_Type, cl.Waste_Weight, " +
                                             "t.Type AS TruckType, t.Reg_Area AS TruckArea, dz.Area AS ZoneName, cl.Status " +
                                             "FROM Collection_Log cl " +
                                             "JOIN Restaurant r ON cl.Restaurant_ID = r.Restaurant_ID " +
                                             "LEFT JOIN Waste_Collection_Truck t ON cl.Truck_ID = t.Truck_ID " +
                                             "LEFT JOIN Dumping_Zone dz ON cl.Zone_ID = dz.Zone_ID " +
                                             "ORDER BY cl.Collection_Date DESC, cl.Log_ID DESC LIMIT 100";
                            
                            Statement stmtList = conn.createStatement();
                            ResultSet rsList = stmtList.executeQuery(sqlList);
                            boolean hasData = false;
                            
                            while(rsList.next()) {
                                hasData = true;
                                String status = rsList.getString("Status");
                                if(status == null) status = "Pending";
                                
                                String badge = "";
                                if (status.equalsIgnoreCase("Collected")) {
                                    badge = "bg-green-100 text-green-800 border border-green-200";
                                } else {
                                    badge = "bg-yellow-100 text-yellow-800 border border-yellow-200";
                                }
                        %>
                        <tr class="hover:bg-gray-50 transition duration-150">
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                                <%= rsList.getDate("Collection_Date") %>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-semibold text-gray-900">
                                <%= rsList.getString("RestName") %>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                                <strong><%= rsList.getDouble("Waste_Weight") %> kg</strong> 
                                <span class="text-xs text-gray-500 ml-1 bg-gray-100 px-1.5 py-0.5 rounded"><%= rsList.getString("Waste_Type") %></span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                                <% if(rsList.getString("TruckType") != null) { %>
                                    <%= rsList.getString("TruckType") %> <span class="text-xs text-gray-400">(<%= rsList.getString("TruckArea") %>)</span>
                                <% } else { %>
                                    <span class="text-gray-400 italic text-xs">-- Not Assigned --</span>
                                <% } %>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                                <% if(rsList.getString("ZoneName") != null) { %>
                                    <%= rsList.getString("ZoneName") %>
                                <% } else { %>
                                    <span class="text-gray-400 italic text-xs">-- Pending --</span>
                                <% } %>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm">
                                <span class="px-2.5 py-1 rounded-full text-xs font-bold <%= badge %>">
                                    <%= status %>
                                </span>
                            </td>
                        </tr>
                        <% 
                            }
                            if(!hasData) {
                        %>
                            <tr><td colspan="6" class="px-6 py-12 text-center text-gray-400 italic">No collection records found in the system.</td></tr>
                        <%
                            }
                        } catch(Exception e) {
                            out.println("<tr><td colspan='6' class='p-4 text-red-500 text-center'>Error loading table: " + e.getMessage() + "</td></tr>");
                        } finally {
                            DBUtil.closeConnection(conn);
                        }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

    </main>
</body>
</html>