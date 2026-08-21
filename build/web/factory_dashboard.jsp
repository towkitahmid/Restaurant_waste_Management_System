<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.wms.util.DBUtil, java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>WMS · Factory Floor</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen font-sans">

    <header class="bg-purple-900 text-white p-4 shadow-lg sticky top-0 z-50">
        <div class="max-w-7xl mx-auto flex justify-between items-center">
            <div class="flex items-center gap-3">
                <div class="bg-white/10 p-2 rounded">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.384-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"></path></svg>
                </div>
                <h1 class="font-bold text-xl">Factory Production Panel</h1>
            </div>
            <a href="dashboard.jsp" class="text-purple-200 hover:text-white text-sm transition">Back to Admin</a>
        </div>
    </header>

    <main class="max-w-7xl mx-auto p-8 space-y-8">
        
        <% 
           String msg = (String) request.getAttribute("msg");
           String type = (String) request.getAttribute("msgType");
           if(msg != null) { 
               String colorClass = "success".equals(type) ? "bg-green-100 text-green-800 border-green-200" : "bg-red-100 text-red-800 border-red-200";
        %>
           <div class="<%= colorClass %> border px-4 py-3 rounded text-sm mb-4 shadow-sm">
               <%= msg %>
           </div>
        <% } %>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
            
            <div class="bg-white p-6 rounded-lg shadow border-l-4 border-gray-500">
                <h2 class="font-bold text-lg text-gray-700 mb-4 flex items-center justify-between">
                    <span class="flex items-center gap-2">
                        <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path></svg>
                        Available Raw Waste
                    </span>
                    <span class="text-xs text-green-600 bg-green-100 px-2 py-1 rounded-full">Live Stock</span>
                </h2>
                <div class="space-y-4 max-h-64 overflow-y-auto pr-2">
                    <% 
                    Connection conn = DBUtil.getConnection();
                    try {
                        // Only show batches that still have quantity remaining
                        String sql = "SELECT f.Name as Factory, z.Area, s.Current_Quantity, s.Material_Name " +
                                     "FROM Supply_Log s " +
                                     "JOIN Factory f ON s.Factory_ID = f.Factory_ID " +
                                     "JOIN Dumping_Zone z ON s.Source_Zone_ID = z.Zone_ID " +
                                     "WHERE s.Current_Quantity > 0 " +
                                     "ORDER BY s.Supply_Date ASC LIMIT 10";
                        ResultSet rs = conn.createStatement().executeQuery(sql);
                        boolean hasWaste = false;
                        while(rs.next()) {
                            hasWaste = true;
                    %>
                    <div class="flex justify-between items-center border-b pb-2 last:border-0 hover:bg-gray-50 p-2 rounded transition">
                        <div>
                            <div class="font-semibold text-gray-800"><%= rs.getString("Factory") %></div>
                            <div class="text-xs text-gray-500"><%= rs.getString("Material_Name") %> from <%= rs.getString("Area") %></div>
                        </div>
                        <div class="text-purple-700 font-bold bg-purple-100 px-2 py-1 rounded text-sm"><%= rs.getDouble("Current_Quantity") %> kg</div>
                    </div>
                    <% 
                        }
                        if(!hasWaste) out.println("<div class='text-gray-400 text-sm italic p-2'>No raw material in stock. Dispatch trucks from Admin Panel.</div>");
                    } catch(Exception e){} 
                    %>
                </div>
            </div>

            <div class="bg-white p-6 rounded-lg shadow border-t-4 border-purple-600">
                <h2 class="font-bold text-lg text-gray-700 mb-4">Manufacture Product</h2>
                <form action="ProductionServlet" method="POST" class="space-y-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-600 mb-1">Select Factory Line</label>
                        <select name="factoryName" class="w-full border p-2 rounded focus:ring-purple-500 focus:border-purple-500">
                            <%
                            try {
                                ResultSet rsFac = conn.createStatement().executeQuery("SELECT Name FROM Factory");
                                while(rsFac.next()) {
                                    out.println("<option>" + rsFac.getString("Name") + "</option>");
                                }
                            } catch(Exception e) {}
                            %>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-600 mb-1">Product Type</label>
                        <select name="productName" class="w-full border p-2 rounded focus:ring-purple-500 focus:border-purple-500 bg-white">
                            <option value="Recycled Plastic Bottles">Recycled Plastic Bottles</option>
                            <option value="Polyester Fiber (Clothing)">Polyester Fiber (Clothing)</option>
                            <option value="Plastic Lumber (Furniture)">Plastic Lumber (Furniture)</option>
                            <option value="Compost Fertilizer">Compost Fertilizer</option>
                            <option value="Refurbished Electronics">Refurbished Electronics</option>
                            <option value="Glass Tiles">Glass Tiles</option>
                        </select>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-600 mb-1">Qty Produced</label>
                            <input type="number" name="quantity" class="w-full border p-2 rounded focus:ring-purple-500 focus:border-purple-500" placeholder="e.g. 50" required>
                            <p class="text-xs text-gray-400 mt-1">Consumes 0.5kg waste/unit</p>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-600 mb-1">Unit Price ($)</label>
                            <input type="number" step="0.01" name="price" value="10.00" class="w-full border p-2 rounded focus:ring-purple-500 focus:border-purple-500">
                        </div>
                    </div>
                    <button class="w-full bg-purple-700 text-white font-bold py-2.5 rounded hover:bg-purple-800 transition shadow-lg transform hover:-translate-y-0.5">
                        Run Production Line
                    </button>
                </form>
            </div>
        </div>

        <div class="bg-white p-6 rounded-lg shadow border-t-4 border-blue-600">
            <div class="flex justify-between items-center mb-4">
                <div>
                    <h2 class="font-bold text-lg text-gray-700">Ship Finished Products to Vendor</h2>
                    <p class="text-sm text-gray-500">Send stock to distributors/wholesalers.</p>
                </div>
                <div class="bg-blue-100 p-2 rounded-full">
                    <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7h12m0 0l-4-4m4 4l-4 4m0 6H4m0 0l4 4m-4-4l4-4"></path></svg>
                </div>
            </div>
            
            <form action="FactoryShipmentServlet" method="POST" class="grid grid-cols-1 md:grid-cols-4 gap-4 items-end">
                <div>
                    <label class="block text-sm text-gray-600 mb-1">Source Factory</label>
                    <select name="factoryName" class="w-full border p-2 rounded">
                        <% 
                        ResultSet rsFac2 = conn.createStatement().executeQuery("SELECT Name FROM Factory");
                        while(rsFac2.next()) {
                            out.println("<option>" + rsFac2.getString("Name") + "</option>");
                        }
                        %>
                    </select>
                </div>
                <div>
                    <label class="block text-sm text-gray-600 mb-1">Select Vendor (Distributor)</label>
                    <select name="vendorId" class="w-full border p-2 rounded">
                        <% 
                        ResultSet rsV = conn.createStatement().executeQuery("SELECT Vendor_ID, Name FROM Vendor");
                        while(rsV.next()) {
                        %>
                        <option value="<%= rsV.getInt("Vendor_ID") %>"><%= rsV.getString("Name") %></option>
                        <% } %>
                    </select>
                </div>
                <div>
                    <label class="block text-sm text-gray-600 mb-1">Product to Ship</label>
                    <select name="productName" class="w-full border p-2 rounded bg-white">
                        <option value="Recycled Plastic Bottles">Recycled Plastic Bottles</option>
                        <option value="Polyester Fiber (Clothing)">Polyester Fiber (Clothing)</option>
                        <option value="Plastic Lumber (Furniture)">Plastic Lumber (Furniture)</option>
                        <option value="Compost Fertilizer">Compost Fertilizer</option>
                    </select>
                </div>
                <div>
                    <label class="block text-sm text-gray-600 mb-1">Quantity</label>
                    <div class="flex gap-2">
                        <input type="number" name="quantity" class="w-full border p-2 rounded" placeholder="Qty" required>
                        <button class="bg-blue-600 text-white px-6 py-2 rounded font-bold hover:bg-blue-700 shadow transition">Ship</button>
                    </div>
                </div>
            </form>
        </div>

        <div class="bg-white rounded-lg shadow overflow-hidden border border-gray-200">
            <div class="px-6 py-4 border-b border-gray-200 bg-gray-50 flex justify-between items-center">
                <h3 class="font-bold text-gray-700 text-lg">Production History</h3>
                <span class="text-xs text-gray-500 bg-white border px-2 py-1 rounded">Last 10 Batches</span>
            </div>
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">Date</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">Factory</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">Product Built</th>
                            <th class="px-6 py-3 text-right text-xs font-bold text-gray-500 uppercase tracking-wider">Quantity</th>
                            <th class="px-6 py-3 text-right text-xs font-bold text-gray-500 uppercase tracking-wider">Total Value</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <%
                        try {
                            String sqlHist = "SELECT * FROM Production_Log ORDER BY Production_Date DESC, Production_ID DESC LIMIT 10";
                            ResultSet rsHist = conn.createStatement().executeQuery(sqlHist);
                            boolean hasHist = false;
                            while(rsHist.next()) {
                                hasHist = true;
                        %>
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= rsHist.getDate("Production_Date") %></td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900"><%= rsHist.getString("Factory_Name") %></td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                                <span class="bg-purple-100 text-purple-800 py-1 px-2 rounded-full text-xs font-bold"><%= rsHist.getString("Product_Name") %></span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-right text-gray-700 font-bold"><%= rsHist.getInt("Quantity") %></td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-right text-green-600 font-bold">$<%= rsHist.getDouble("Market_Value") %></td>
                        </tr>
                        <% 
                            }
                            if(!hasHist) out.println("<tr><td colspan='5' class='px-6 py-8 text-center text-gray-400'>No production records found.</td></tr>");
                        } catch(Exception e) {
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