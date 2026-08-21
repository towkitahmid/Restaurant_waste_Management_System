<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.wms.util.DBUtil, com.wms.util.ReportDAO, java.sql.*, java.util.*" %>

<%
    // ==========================================
    // 1. STATS CALCULATION LOGIC
    // ==========================================
    int totalRestaurants = 0;
    int totalTrucks = 0;
    double todayCollection = 0.0;
    double monthCollection = 0.0;
    double yearCollection = 0.0;

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        conn = DBUtil.getConnection();
        stmt = conn.createStatement();

        // A. Total Restaurants
        rs = stmt.executeQuery("SELECT COUNT(*) FROM Restaurant");
        if (rs.next()) { totalRestaurants = rs.getInt(1); }
        rs.close();

        // B. Active Trucks
        rs = stmt.executeQuery("SELECT COUNT(*) FROM Waste_Collection_Truck");
        if (rs.next()) { totalTrucks = rs.getInt(1); }
        rs.close();

        // C. Today's Collection
        rs = stmt.executeQuery("SELECT SUM(Waste_Weight) FROM Collection_Log WHERE Collection_Date = CURDATE()");
        if (rs.next()) { todayCollection = rs.getDouble(1); }
        rs.close();

        // D. This Month's Collection
        rs = stmt.executeQuery("SELECT SUM(Waste_Weight) FROM Collection_Log WHERE MONTH(Collection_Date) = MONTH(CURDATE()) AND YEAR(Collection_Date) = YEAR(CURDATE())");
        if (rs.next()) { monthCollection = rs.getDouble(1); }
        rs.close();

        // E. This Year's Collection
        rs = stmt.executeQuery("SELECT SUM(Waste_Weight) FROM Collection_Log WHERE YEAR(Collection_Date) = YEAR(CURDATE())");
        if (rs.next()) { yearCollection = rs.getDouble(1); }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
        DBUtil.closeConnection(conn);
    }
%>

<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <title>WMS · Master Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .brand-bg { background: linear-gradient(90deg,#064e3b,#047857 60%); }
        .card { background:#fff;border-radius:12px;box-shadow:0 6px 18px rgba(7,12,14,0.06); }
        .table-wrap { overflow-x:auto; -webkit-overflow-scrolling: touch; }
        .anchor-offset { scroll-margin-top: 140px; }
    </style>
</head>
<body class="min-h-screen bg-gray-50 font-sans">

    <header class="brand-bg text-white sticky top-0 z-50 shadow-md">
        <div class="max-w-7xl mx-auto px-4 py-3">
            
            <div class="flex flex-col md:flex-row items-center justify-between gap-4 mb-2">
                <div class="flex items-center gap-3">
                    <div class="w-9 h-9 bg-white/10 rounded-md flex items-center justify-center">
                        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M3 7h18M3 12h18M3 17h18"/></svg>
                    </div>
                    <div>
                        <div class="font-semibold leading-tight">WMS Admin</div>
                        <div class="text-xs text-white/80">System Data Overview</div>
                    </div>
                </div>

                <div class="flex flex-wrap gap-2 justify-center">
                    <a href="admin_logistics.jsp" class="text-xs bg-emerald-800 hover:bg-emerald-700 px-3 py-1.5 rounded transition">Logistics</a>
                    <a href="factory_dashboard.jsp" class="text-xs bg-emerald-800 hover:bg-emerald-700 px-3 py-1.5 rounded transition">Factory Panel</a>
                    <a href="admin_registration.jsp" class="text-xs bg-emerald-900 hover:bg-emerald-800 px-3 py-1.5 rounded transition">+ Admin</a>
                </div>

                <div class="flex items-center gap-2">
                    <a href="admin_collection_report.jsp" class="text-xs bg-white/10 hover:bg-white/20 px-3 py-1.5 rounded transition">Reports</a>
                    <a href="LogoutServlet" class="text-xs bg-red-600 hover:bg-red-500 px-3 py-1.5 rounded transition">Logout</a>
                </div>
            </div>

            <div class="border-t border-white/10 pt-2">
                <nav class="flex flex-wrap justify-center gap-4 text-sm font-medium opacity-90">
                    <a href="#Restaurant" class="hover:text-emerald-200">Restaurants</a>
                    <a href="#Employee" class="hover:text-emerald-200">Employees</a>
                    <a href="#Vendor" class="hover:text-emerald-200">Vendors</a>
                    <a href="#Factory" class="hover:text-emerald-200">Factories</a>
                    <a href="#Dumping_Zone" class="hover:text-emerald-200">Zones</a>
                    <a href="#Collection_Log" class="hover:text-emerald-200">Logs</a>
                </nav>
            </div>
        </div>
    </header>

    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-10">

        <div>
            <h2 class="text-lg font-bold text-gray-700 mb-3">System Infrastructure Setup</h2>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                
                <a href="factory_registration.jsp" class="flex items-center justify-center gap-2 bg-white p-4 rounded-lg shadow-sm border border-gray-200 hover:border-purple-500 hover:text-purple-700 hover:shadow-md transition group">
                    <div class="bg-purple-100 p-2 rounded-full group-hover:bg-purple-200">
                        <svg class="w-5 h-5 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path></svg>
                    </div>
                    <span class="font-semibold text-sm">Add Factory</span>
                </a>

                <a href="dumping_zone_registration.jsp" class="flex items-center justify-center gap-2 bg-white p-4 rounded-lg shadow-sm border border-gray-200 hover:border-orange-500 hover:text-orange-700 hover:shadow-md transition group">
                    <div class="bg-orange-100 p-2 rounded-full group-hover:bg-orange-200">
                        <svg class="w-5 h-5 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 21v-8a2 2 0 012-2h14a2 2 0 012 2v8M3 13l9-10 9 10m-9-10v20"></path></svg>
                    </div>
                    <span class="font-semibold text-sm">Add Dumping Zone</span>
                </a>

                <a href="truck_registration.jsp" class="flex items-center justify-center gap-2 bg-white p-4 rounded-lg shadow-sm border border-gray-200 hover:border-blue-500 hover:text-blue-700 hover:shadow-md transition group">
                    <div class="bg-blue-100 p-2 rounded-full group-hover:bg-blue-200">
                        <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17a2 2 0 11-4 0 2 2 0 014 0zM19 17a2 2 0 11-4 0 2 2 0 014 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16V6a1 1 0 00-1-1H4a1 1 0 00-1 1v10a1 1 0 001 1h1m8-1a1 1 0 01-1 1H9m4-1V8a1 1 0 011-1h2.586a1 1 0 01.707.293l3.414 3.414a1 1 0 01.293.707V16a1 1 0 01-1 1h-1m-6-1a1 1 0 001 1h1"/></svg>
                    </div>
                    <span class="font-semibold text-sm">Add Truck</span>
                </a>

                <a href="employee_registration.jsp" class="flex items-center justify-center gap-2 bg-white p-4 rounded-lg shadow-sm border border-gray-200 hover:border-emerald-500 hover:text-emerald-700 hover:shadow-md transition group">
                    <div class="bg-emerald-100 p-2 rounded-full group-hover:bg-emerald-200">
                        <svg class="w-5 h-5 text-emerald-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"></path></svg>
                    </div>
                    <span class="font-semibold text-sm">Add Employee</span>
                </a>
            </div>
        </div>
        
        <div>
            <h2 class="text-xl font-bold text-gray-800 mb-4 flex items-center gap-2">
                <span class="w-3 h-3 bg-yellow-500 rounded-full animate-pulse"></span>
                Incoming Collection Requests
            </h2>
            <div class="bg-white rounded-lg shadow overflow-hidden border border-gray-200">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">Date</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">Restaurant</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">Waste</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">Status</th>
                            <th class="px-6 py-3 text-right text-xs font-bold text-gray-500 uppercase tracking-wider">Action</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100 bg-white">
                        <%
                        try {
                            if(conn == null || conn.isClosed()) conn = DBUtil.getConnection();
                            String sql = "SELECT cl.Log_ID, cl.Collection_Date, r.Name, cl.Waste_Type, cl.Waste_Weight " +
                                         "FROM Collection_Log cl JOIN Restaurant r ON cl.Restaurant_ID = r.Restaurant_ID " +
                                         "WHERE cl.Status = 'Pending' ORDER BY cl.Collection_Date ASC";
                            Statement stmtP = conn.createStatement();
                            ResultSet rsP = stmtP.executeQuery(sql);
                            boolean hasPending = false;
                            while(rsP.next()) {
                                hasPending = true;
                        %>
                        <tr class="hover:bg-yellow-50 transition">
                            <td class="px-6 py-4 text-sm text-gray-600"><%= rsP.getDate("Collection_Date") %></td>
                            <td class="px-6 py-4 text-sm font-bold text-gray-900"><%= rsP.getString("Name") %></td>
                            <td class="px-6 py-4 text-sm text-gray-600">
                                <%= rsP.getDouble("Waste_Weight") %>kg <span class="text-xs bg-gray-100 border px-1 rounded ml-1"><%= rsP.getString("Waste_Type") %></span>
                            </td>
                            <td class="px-6 py-4 text-sm"><span class="px-2 py-1 rounded-full text-xs font-bold bg-yellow-100 text-yellow-800">Needs Action</span></td>
                            <td class="px-6 py-4 text-right">
                                <a href="admin_logistics.jsp?logId=<%= rsP.getInt("Log_ID") %>" class="bg-emerald-600 hover:bg-emerald-700 text-white px-4 py-2 rounded text-xs font-bold uppercase tracking-wide shadow-sm transition">
                                    Assign Truck & Zone
                                </a>
                            </td>
                        </tr>
                        <% } 
                           if(!hasPending) { %>
                           <tr><td colspan="5" class="px-6 py-8 text-center text-gray-400 italic">All caught up! No pending requests.</td></tr>
                        <% }
                        } catch(Exception e) { e.printStackTrace(); } 
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <div>
            <h2 class="text-xl font-bold text-gray-800 mb-4 flex items-center gap-2">
                <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16V6a1 1 0 00-1-1H4a1 1 0 00-1 1v10a1 1 0 001 1h1m8-1a1 1 0 01-1 1H9m4-1V8a1 1 0 011-1h2.586a1 1 0 01.707.293l3.414 3.414a1 1 0 01.293.707V16a1 1 0 01-1 1h-1m-6-1a1 1 0 001 1h1M5 17a2 2 0 104 0m-4 0a2 2 0 114 0m6 0a2 2 0 104 0m-4 0a2 2 0 114 0"></path></svg>
                Fleet Overview
            </h2>
            <div class="bg-white rounded-lg shadow overflow-hidden border border-gray-200">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">Truck Type</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">Registration Area</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">Capacity</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">Assigned Driver</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100 bg-white">
                        <%
                        try {
                            if(conn == null || conn.isClosed()) conn = DBUtil.getConnection();
                            String sqlTrucks = "SELECT t.Type, t.Reg_Area, t.Capacity, CONCAT(e.First_Name, ' ', e.Last_Name) AS DriverName " +
                                               "FROM Waste_Collection_Truck t " +
                                               "LEFT JOIN Employee e ON t.Driver_Emp_ID = e.Emp_ID";
                            Statement stmtT = conn.createStatement();
                            ResultSet rsT = stmtT.executeQuery(sqlTrucks);
                            boolean hasTrucks = false;
                            while(rsT.next()) {
                                hasTrucks = true;
                        %>
                        <tr class="hover:bg-blue-50 transition">
                            <td class="px-6 py-4 text-sm font-medium text-gray-900"><%= rsT.getString("Type") %></td>
                            <td class="px-6 py-4 text-sm text-gray-600"><%= rsT.getString("Reg_Area") %></td>
                            <td class="px-6 py-4 text-sm text-gray-600"><%= rsT.getDouble("Capacity") %> Tons</td>
                            <td class="px-6 py-4 text-sm text-gray-800 font-medium">
                                <%= (rsT.getString("DriverName") != null ? rsT.getString("DriverName") : "<span class='text-red-400 italic'>No Driver</span>") %>
                            </td>
                        </tr>
                        <% } 
                           if(!hasTrucks) { %>
                           <tr><td colspan="4" class="px-6 py-8 text-center text-gray-400 italic">No trucks registered in the system.</td></tr>
                        <% }
                        } catch(Exception e) { e.printStackTrace(); } 
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="mt-8 card p-6">
            <div class="flex items-center justify-between border-b pb-2 mb-4">
                <h2 class="text-xl font-semibold">Database Records</h2>
                <span class="text-xs text-gray-400">Scroll or use Navbar to navigate</span>
            </div>

            <%
               String[] tables = { "Restaurant", "Employee", "Waste_Collection_Truck", "Storehouse", "Collection_Log", "Vendor", "Factory", "Product", "Dumping_Zone", "Supply_Log", "Segregation_Log" };

               for (String table : tables) {
                   List<List<String>> tableData = ReportDAO.fetchTableData(table);
                   if (tableData == null || tableData.size() <= 1) continue;
            %>

            <div id="<%= table %>" class="mt-10 anchor-offset">
                <div class="flex items-center gap-2 mb-3">
                    <h3 class="text-md font-bold text-gray-700 uppercase tracking-wide text-xs bg-gray-100 px-2 py-1 rounded inline-block"><%= table.replace("_", " ") %></h3>
                </div>
                
                <div class="table-wrap rounded-md border border-gray-200">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <% 
                                if (!tableData.isEmpty()) {
                                    List<String> headers = tableData.get(0);
                                    for (String head : headers) { %>
                                     <th class="px-4 py-3 text-left text-xs font-bold text-gray-500 uppercase tracking-wider"><%= head %></th>
                                <%  } 
                                } 
                                %>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-100">
                            <% 
                            if (!tableData.isEmpty()) {
                                for (int r=1; r<tableData.size(); r++) {
                                     List<String> row = tableData.get(r); %>
                                     <tr class="hover:bg-gray-50">
                                         <% for (String cell : row) { %>
                                            <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-700"><%= (cell==null?"":cell) %></td>
                                         <% } %>
                                     </tr>
                                <% }
                            }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

            <% } %>

        </div>
    </main>
    
    <% DBUtil.closeConnection(conn); %>
</body>
</html>