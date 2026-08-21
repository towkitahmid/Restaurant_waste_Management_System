<%@ include file="admin_header.jsp" %>
<%@ page import="com.wms.util.DBUtil, com.wms.util.ReportDAO, java.sql.*, java.util.*" %>

<main class="max-w-6xl mx-auto px-4 py-10">
    <!-- 1. ZONE STATUS -->
    <div class="card p-6 mb-8">
        <h2 class="text-xl font-bold mb-4">Dumping Zone Status</h2>
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
                <tr><th>Zone Name</th><th>Type</th><th>Current Load (kg)</th><th>Capacity</th></tr>
            </thead>
            <tbody>
                <% 
                List<List<String>> zoneData = ReportDAO.fetchTableData("Dumping_Zone"); 
                // Skip header row 0
                for(int i=1; i<zoneData.size(); i++) {
                    List<String> row = zoneData.get(i);
                %>
                <tr>
                    <td class="px-4 py-2"><%= row.get(3) %></td> <!-- Area -->
                    <td class="px-4 py-2"><%= row.get(1) %></td> <!-- Type -->
                    <td class="px-4 py-2 font-bold text-green-600"><%= row.get(4) %></td> <!-- Current Load (Make sure to update ReportDAO to fetch this new column or use raw query here) -->
                    <td class="px-4 py-2"><%= row.get(2) %></td> <!-- Capacity -->
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <!-- 2. ASSIGN VENDOR -->
    <div class="card p-8">
        <h2 class="text-xl font-bold">Segregation: Assign Vendor</h2>
        <p class="text-sm text-muted mt-1">Select a vendor to collect waste from a zone.</p>
        
        <%
            Connection conn = DBUtil.getConnection();
            Statement stmt = conn.createStatement();
            ResultSet rsZ = stmt.executeQuery("SELECT Zone_ID, Area, Current_Load FROM Dumping_Zone WHERE Current_Load > 0");
            List<String[]> zones = new ArrayList<>();
            while(rsZ.next()) zones.add(new String[]{rsZ.getString(1), rsZ.getString(2) + " (" + rsZ.getString(3) + "kg available)"});
            rsZ.close();
            
            ResultSet rsV = stmt.executeQuery("SELECT Vendor_ID, Name, Category FROM Vendor");
            List<String[]> vendors = new ArrayList<>();
            while(rsV.next()) vendors.add(new String[]{rsV.getString(1), rsV.getString(2) + " (" + rsV.getString(3) + ")"});
            DBUtil.closeConnection(conn);
        %>

        <form action="SegregationServlet" method="POST" class="mt-6 grid sm:grid-cols-2 gap-4">
            <div>
                <label class="text-sm font-medium">From Zone</label>
                <select name="zoneId" class="form-input w-full">
                    <% for(String[] z : zones) { %> <option value="<%= z[0] %>"><%= z[1] %></option> <% } %>
                </select>
            </div>
            <div>
                <label class="text-sm font-medium">Assign Vendor</label>
                <select name="vendorId" class="form-input w-full">
                    <% for(String[] v : vendors) { %> <option value="<%= v[0] %>"><%= v[1] %></option> <% } %>
                </select>
            </div>
            <div>
                <label class="text-sm font-medium">Quantity (kg)</label>
                <input type="number" name="amount" class="form-input w-full" required />
            </div>
            <div>
                <label class="text-sm font-medium">Material Type</label>
                <select name="material" class="form-input w-full">
                    <option>Plastic</option><option>Metal</option><option>Organic</option>
                </select>
            </div>
            <div class="sm:col-span-2">
                <button type="submit" class="btn-primary w-full">Assign Vendor to Collection</button>
            </div>
        </form>
    </div>
</main>