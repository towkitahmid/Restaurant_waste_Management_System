<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.wms.util.DBUtil, java.sql.*" %>
<%
    Integer vendorId = (Integer) session.getAttribute("vendorId");
    String vendorName = (String) session.getAttribute("vendorName");
    if (vendorId == null) { response.sendRedirect("vendor_login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Vendor Distributor</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen font-sans">

    <nav class="bg-blue-900 text-white p-4 shadow-md sticky top-0 z-50">
        <div class="max-w-6xl mx-auto flex justify-between items-center">
            <div class="flex items-center gap-3">
                <div class="bg-white/20 p-2 rounded">
                    <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path></svg>
                </div>
                <div>
                    <h1 class="font-bold text-xl"><%= vendorName %></h1>
                    <div class="text-xs text-blue-200">Product Distributor</div>
                </div>
            </div>
            <a href="VendorLogoutServlet" class="text-sm bg-blue-800 hover:bg-blue-700 px-4 py-2 rounded transition shadow">Logout</a>
        </div>
    </nav>

    <main class="max-w-6xl mx-auto p-6 space-y-8">

        <% String msg = (String) request.getAttribute("msg");
           String type = (String) request.getAttribute("msgType");
           if(msg != null) { 
               String colorClass = "success".equals(type) ? "bg-green-100 text-green-800 border-green-200" : "bg-red-100 text-red-800 border-red-200";
        %>
           <div class="<%= colorClass %> border px-4 py-3 rounded text-sm font-medium shadow-sm">
               <%= msg %>
           </div>
        <% } %>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
            
            <div class="bg-white p-6 rounded-lg shadow border-l-4 border-blue-500">
                <h2 class="font-bold text-lg text-gray-700 mb-4 flex items-center justify-between border-b pb-2">
                    <span>Available Inventory</span>
                    <span class="text-xs text-blue-600 bg-blue-100 px-2 py-1 rounded-full">Ready to Ship</span>
                </h2>
                <ul class="space-y-3 max-h-64 overflow-y-auto">
                    <% 
                    Connection conn = DBUtil.getConnection();
                    try {
                        String sqlInv = "SELECT Product_Name, Quantity FROM Vendor_Product_Inventory WHERE Vendor_ID = ? AND Quantity > 0";
                        PreparedStatement ps = conn.prepareStatement(sqlInv);
                        ps.setInt(1, vendorId);
                        ResultSet rs = ps.executeQuery();
                        boolean hasData = false;
                        while(rs.next()) { hasData = true;
                    %>
                    <li class="flex justify-between items-center p-3 bg-gray-50 hover:bg-gray-100 rounded transition">
                        <span class="font-medium text-gray-800"><%= rs.getString("Product_Name") %></span>
                        <span class="bg-blue-600 text-white px-3 py-1 rounded-full text-sm font-bold shadow-sm"><%= rs.getInt("Quantity") %> units</span>
                    </li>
                    <% } if(!hasData) out.print("<li class='text-gray-400 text-sm text-center py-4'>No products in stock. Wait for factory shipment.</li>");
                    } catch(Exception e){} %>
                </ul>
            </div>

            <div class="bg-white p-6 rounded-lg shadow border-t-4 border-orange-500">
                <h2 class="font-bold text-lg text-gray-700 mb-4">Distribute to Shopping Mall</h2>
                <form action="VendorDistributionServlet" method="POST" class="space-y-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-600 mb-1">Select Product to Ship</label>
                        <select name="productName" class="w-full border p-2 rounded focus:ring-orange-500 focus:border-orange-500">
                            <% 
                            // Re-query for dropdown to ensure only available items are shown
                            PreparedStatement psDrop = conn.prepareStatement("SELECT Product_Name, Quantity FROM Vendor_Product_Inventory WHERE Vendor_ID = ? AND Quantity > 0");
                            psDrop.setInt(1, vendorId);
                            ResultSet rsDrop = psDrop.executeQuery();
                            boolean hasStock = false;
                            while(rsDrop.next()) {
                                hasStock = true;
                                out.println("<option value='" + rsDrop.getString("Product_Name") + "'>" + rsDrop.getString("Product_Name") + " (Stock: " + rsDrop.getInt("Quantity") + ")</option>");
                            }
                            if(!hasStock) out.println("<option disabled selected>No stock available</option>");
                            %>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-600 mb-1">Shopping Mall Name</label>
                        <input type="text" name="mallName" class="w-full border p-2 rounded focus:ring-orange-500 focus:border-orange-500" placeholder="e.g. Jamuna Future Park" required>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-600 mb-1">Quantity</label>
                        <input type="number" name="quantity" class="w-full border p-2 rounded focus:ring-orange-500 focus:border-orange-500" required>
                    </div>
                    <button class="w-full bg-orange-600 hover:bg-orange-700 text-white font-bold py-2.5 rounded shadow transition transform hover:-translate-y-0.5">
                        Deliver to Mall
                    </button>
                </form>
            </div>
        </div>

        <div class="bg-white rounded-lg shadow overflow-hidden border border-gray-200">
            <div class="px-6 py-4 bg-gray-50 border-b border-gray-200 flex justify-between items-center">
                <h2 class="font-bold text-gray-700">Distribution History</h2>
                <span class="text-xs text-gray-500">Outbound Logs</span>
            </div>
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-white">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Date</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Mall</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Product</th>
                            <th class="px-6 py-3 text-right text-xs font-bold text-gray-500 uppercase">Qty</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-100">
                        <%
                        String sqlHist = "SELECT * FROM Mall_Distribution WHERE Vendor_ID = ? ORDER BY Dist_Date DESC LIMIT 10";
                        PreparedStatement psHist = conn.prepareStatement(sqlHist);
                        psHist.setInt(1, vendorId);
                        ResultSet rsHist = psHist.executeQuery();
                        boolean hasHistory = false;
                        while(rsHist.next()) {
                            hasHistory = true;
                        %>
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-4 text-sm text-gray-500"><%= rsHist.getDate("Dist_Date") %></td>
                            <td class="px-6 py-4 text-sm font-medium text-gray-900"><%= rsHist.getString("Mall_Name") %></td>
                            <td class="px-6 py-4 text-sm text-gray-600"><%= rsHist.getString("Product_Name") %></td>
                            <td class="px-6 py-4 text-sm text-right font-bold text-green-600"><%= rsHist.getInt("Quantity") %></td>
                        </tr>
                        <% 
                        } 
                        if(!hasHistory) out.println("<tr><td colspan='4' class='px-6 py-8 text-center text-gray-400 italic'>No past distributions found.</td></tr>");
                        DBUtil.closeConnection(conn); 
                        %>
                    </tbody>
                </table>
            </div>
        </div>

    </main>
</body>
</html>