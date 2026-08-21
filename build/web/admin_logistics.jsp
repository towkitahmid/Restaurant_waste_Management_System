<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.wms.util.DBUtil, java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>WMS · Logistics</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans pb-20">

    <nav class="bg-white shadow px-6 py-4 flex justify-between items-center sticky top-0 z-50">
        <h1 class="font-bold text-xl text-gray-800">Logistics & Zone Management</h1>
        <a href="dashboard.jsp" class="text-sm text-blue-600 hover:underline">Back to Dashboard</a>
    </nav>

    <main class="max-w-6xl mx-auto mt-8 space-y-12">

        <% 
        String logId = request.getParameter("logId");
        if (logId != null) { 
            Connection conn = DBUtil.getConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT r.Name, cl.Waste_Weight, cl.Waste_Type FROM Collection_Log cl JOIN Restaurant r ON cl.Restaurant_ID = r.Restaurant_ID WHERE cl.Log_ID = ?");
            ps.setInt(1, Integer.parseInt(logId));
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
        %>
        <div class="bg-white p-8 rounded-lg shadow-lg border-l-4 border-blue-600">
            <h2 class="text-xl font-bold mb-4">Assign Logistics for Pickup</h2>
            <div class="mb-6 p-4 bg-blue-50 rounded text-sm text-blue-800">
                <p><strong>Restaurant:</strong> <%= rs.getString("Name") %></p>
                <p><strong>Load to Add:</strong> <%= rs.getDouble("Waste_Weight") %>kg (<%= rs.getString("Waste_Type") %>)</p>
            </div>

            <form action="LogisticsServlet" method="POST" class="grid grid-cols-1 md:grid-cols-3 gap-6 items-end">
                <input type="hidden" name="action" value="assignPickup">
                <input type="hidden" name="logId" value="<%= logId %>">

                <div>
                    <label class="block text-sm font-medium text-gray-700">Select Truck</label>
                    <select name="truckId" class="w-full border p-2 rounded mt-1" required>
                        <% 
                        Statement stmt = conn.createStatement();
                        ResultSet rsT = stmt.executeQuery("SELECT Truck_ID, Type, Reg_Area FROM Waste_Collection_Truck");
                        while(rsT.next()) {
                        %>
                        <option value="<%= rsT.getInt("Truck_ID") %>"><%= rsT.getString("Type") %> (<%= rsT.getString("Reg_Area") %>)</option>
                        <% } %>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700">Select Destination (Zone)</label>
                    <select name="zoneId" class="w-full border p-2 rounded mt-1" required>
                        <% 
                        // Show current capacity in dropdown
                        ResultSet rsZ = stmt.executeQuery("SELECT Zone_ID, Area, Type, Current_Waste FROM Dumping_Zone");
                        while(rsZ.next()) {
                        %>
                        <option value="<%= rsZ.getInt("Zone_ID") %>">
                            <%= rsZ.getString("Area") %> (Curr: <%= rsZ.getDouble("Current_Waste") %> kg)
                        </option>
                        <% } %>
                    </select>
                </div>

                <button type="submit" class="bg-blue-600 text-white font-bold py-2 rounded hover:bg-blue-700">Confirm & Add Waste</button>
            </form>
        </div>
        <% 
            }
            DBUtil.closeConnection(conn);
        } 
        %>

        <div class="bg-white p-8 rounded-lg shadow border-l-4 border-purple-600">
            <h2 class="text-xl font-bold mb-4 text-gray-800">Transfer Waste: Zone ➔ Factory</h2>
            <p class="text-sm text-gray-500 mb-6">Move accumulated waste from dumping zones to factories.</p>

            <form action="LogisticsServlet" method="POST" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 items-end">
                <input type="hidden" name="action" value="transferToFactory">
                
                <div>
                    <label class="block text-sm font-medium text-gray-700">Source Zone</label>
                    <select name="sourceZoneId" class="w-full border p-2 rounded mt-1" required>
                        <option value="" disabled selected>Select Zone</option>
                        <% 
                        Connection conn2 = DBUtil.getConnection();
                        // UPDATED QUERY: Shows Current Waste
                        ResultSet rsZones = conn2.createStatement().executeQuery("SELECT Zone_ID, Area, Current_Waste FROM Dumping_Zone");
                        while(rsZones.next()) {
                            double waste = rsZones.getDouble("Current_Waste");
                            String style = (waste > 0) ? "font-weight:bold; color:green;" : "color:gray;";
                        %>
                        <option value="<%= rsZones.getInt("Zone_ID") %>" style="<%= style %>">
                            <%= rsZones.getString("Area") %> (Avail: <%= waste %> kg)
                        </option>
                        <% } %>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700">Target Factory</label>
                    <select name="factoryId" class="w-full border p-2 rounded mt-1" required>
                        <option value="" disabled selected>Select Factory</option>
                        <% 
                        ResultSet rsFac = conn2.createStatement().executeQuery("SELECT Factory_ID, Name, Type FROM Factory");
                        while(rsFac.next()) {
                        %>
                        <option value="<%= rsFac.getInt("Factory_ID") %>"><%= rsFac.getString("Name") %> (<%= rsFac.getString("Type") %>)</option>
                        <% } 
                        DBUtil.closeConnection(conn2);
                        %>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700">Amount to Move (kg)</label>
                    <input type="number" step="0.1" name="amount" class="w-full border p-2 rounded mt-1" placeholder="e.g. 500" required>
                </div>

                <button type="submit" class="bg-purple-600 text-white font-bold py-2 rounded hover:bg-purple-700">Dispatch Truck</button>
            </form>
        </div>

    </main>
</body>
</html>