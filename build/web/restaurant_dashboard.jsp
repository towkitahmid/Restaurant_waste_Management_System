<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.wms.model.Restaurant, com.wms.util.DBUtil, java.sql.*, java.text.SimpleDateFormat" %>

<%
    // 1. Security Check: Ensure user is logged in
    Restaurant currentRest = (Restaurant) session.getAttribute("restaurant");
    if (currentRest == null) {
        response.sendRedirect("restaurant_login.jsp");
        return;
    }

    // 2. Fetch History & Calculate Totals Logic
    double totalWasteKg = 0.0;
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <title>Restaurant Portal</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 min-h-screen font-sans">

    <nav class="bg-emerald-800 text-white p-4 shadow-md sticky top-0 z-50">
        <div class="max-w-6xl mx-auto flex justify-between items-center">
            <div class="flex items-center gap-3">
                <div class="bg-white/10 p-2 rounded">
                    <svg class="w-5 h-5 text-emerald-100" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path></svg>
                </div>
                <div>
                    <h1 class="font-bold text-lg"><%= currentRest.getName() %></h1>
                    <div class="text-xs text-emerald-200">Restaurant Partner Portal</div>
                </div>
            </div>
            <div class="flex items-center gap-4">
                <div class="text-sm text-right hidden sm:block">
                    <div class="text-emerald-200 text-xs">Logged in as</div>
                    <div class="font-semibold"><%= currentRest.getName() %></div>
                </div>
                <a href="RestaurantLogoutServlet" class="bg-red-600 hover:bg-red-500 text-white text-sm px-4 py-2 rounded transition shadow">Logout</a>
            </div>
        </div>
    </nav>

    <main class="max-w-6xl mx-auto p-6 space-y-8">
        
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            
            <div class="bg-white p-6 rounded-lg shadow border-l-4 border-blue-500">
                <div class="flex items-center justify-between mb-4">
                    <h2 class="text-xl font-bold text-gray-800">Update Profile</h2>
                    <span class="text-xs font-semibold bg-blue-100 text-blue-800 px-2 py-1 rounded">Settings</span>
                </div>
                <p class="text-sm text-gray-500 mb-4">Set your average daily waste generation for administrative planning.</p>
                
                <form action="RestaurantUpdateServlet" method="POST">
                    <div class="mb-4">
                        <label class="block text-sm font-medium text-gray-700">Average Daily Waste (kg)</label>
                        <input type="number" step="0.01" name="dailyWaste" value="<%= currentRest.getDailyWasteQuantity() %>" class="w-full border border-gray-300 p-2 rounded mt-1 focus:ring-2 focus:ring-blue-500 outline-none transition">
                    </div>
                    <button type="submit" class="w-full bg-blue-600 text-white font-medium py-2 rounded hover:bg-blue-700 transition shadow-sm">Save Profile</button>
                </form>
                
                <% String updateMsg = (String) request.getAttribute("updateMessage");
                   if (updateMsg != null) { %>
                   <div class="mt-4 p-3 bg-blue-50 text-blue-700 text-sm rounded border border-blue-100 flex items-center gap-2">
                       <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                       <%= updateMsg %>
                   </div>
                <% } %>
            </div>

            <div class="bg-white p-6 rounded-lg shadow border-l-4 border-emerald-500">
                <div class="flex items-center justify-between mb-4">
                    <h2 class="text-xl font-bold text-gray-800">Request Collection</h2>
                    <span class="text-xs font-semibold bg-emerald-100 text-emerald-800 px-2 py-1 rounded">New Pickup</span>
                </div>
                <p class="text-sm text-gray-500 mb-4">Submit a request for a truck to pick up today's waste.</p>
                
                <form action="CollectionRequestServlet" method="POST" class="space-y-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Collection Date</label>
                        <input type="date" name="date" required class="w-full border border-gray-300 p-2 rounded mt-1 focus:ring-2 focus:ring-emerald-500 outline-none transition">
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700">Waste Type</label>
                            <select name="type" class="w-full border border-gray-300 p-2 rounded mt-1 bg-white">
                                <option>Organic</option><option>Plastic</option><option>Paper</option><option>Metal</option><option>Glass</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700">Weight (kg)</label>
                            <input type="number" step="0.01" name="weight" required class="w-full border border-gray-300 p-2 rounded mt-1 focus:ring-2 focus:ring-emerald-500 outline-none transition">
                        </div>
                    </div>
                    <button type="submit" class="w-full bg-emerald-600 text-white font-medium py-2 rounded hover:bg-emerald-700 transition shadow-sm">Submit Request</button>
                </form>

                <% String reqMsg = (String) request.getAttribute("reqMessage");
                   if (reqMsg != null) { %>
                   <div class="mt-4 p-3 bg-green-50 text-green-700 text-sm rounded border border-green-100 flex items-center gap-2">
                       <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                       <%= reqMsg %>
                   </div>
                <% } %>
            </div>
        </div>

        <div class="bg-white rounded-lg shadow overflow-hidden border border-gray-200">
            <div class="px-6 py-4 border-b border-gray-100 bg-gray-50 flex justify-between items-center">
                <h2 class="text-lg font-bold text-gray-700">Collection History</h2>
                <span class="text-xs text-gray-500">Real-time Status Updates</span>
            </div>
            
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-white">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">Date</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">Type</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">Weight (kg)</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">Status</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-100">
                        <% 
                        try {
                            conn = DBUtil.getConnection();
                            // Query now includes Status column
                            String sql = "SELECT * FROM Collection_Log WHERE Restaurant_ID = ? ORDER BY Collection_Date DESC";
                            ps = conn.prepareStatement(sql);
                            ps.setInt(1, currentRest.getRestaurantId());
                            rs = ps.executeQuery();
                            
                            boolean hasData = false;
                            while (rs.next()) { 
                                hasData = true;
                                double weight = rs.getDouble("Waste_Weight");
                                totalWasteKg += weight;
                                
                                // --- STATUS LOGIC ---
                                String status = rs.getString("Status"); 
                                if(status == null) status = "Pending"; // Default for older records
                                
                                String statusClass = "";
                                String statusLabel = "";
                                
                                if ("Collected".equalsIgnoreCase(status)) {
                                    statusClass = "bg-green-100 text-green-800";
                                    statusLabel = "Collected";
                                } else {
                                    statusClass = "bg-yellow-100 text-yellow-800";
                                    statusLabel = "Pending Pickup";
                                }
                        %>
                        <tr class="hover:bg-gray-50 transition">
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700 font-medium">
                                <%= rs.getDate("Collection_Date") %>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                                <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-gray-100 text-gray-800">
                                    <%= rs.getString("Waste_Type") %>
                                </span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 font-bold">
                                <%= weight %>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm">
                                <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full <%= statusClass %>">
                                    <%= statusLabel %>
                                </span>
                            </td>
                        </tr>
                        <% 
                            } 
                            if (!hasData) {
                        %>
                            <tr><td colspan="4" class="px-6 py-8 text-center text-sm text-gray-400 italic">No collection requests found. Start by submitting one above!</td></tr>
                        <%
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='4' class='text-red-500 p-4 text-center'>Error loading history: " + e.getMessage() + "</td></tr>");
                        } finally {
                            if(rs != null) try { rs.close(); } catch(Exception e){}
                            if(ps != null) try { ps.close(); } catch(Exception e){}
                            DBUtil.closeConnection(conn);
                        }
                        %>
                    </tbody>
                    <tfoot class="bg-gray-50">
                        <tr>
                            <td colspan="2" class="px-6 py-3 text-right text-sm font-bold text-gray-600">Lifetime Waste Generated:</td>
                            <td class="px-6 py-3 text-left text-sm font-bold text-emerald-700"><%= String.format("%.2f", totalWasteKg) %> kg</td>
                            <td></td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>

    </main>
</body>
</html>