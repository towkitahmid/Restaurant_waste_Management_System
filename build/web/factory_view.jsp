<%@ include file="admin_header.jsp" %>
<%@ page import="com.wms.util.DBUtil, com.wms.util.ReportDAO, java.sql.*, java.util.*" %>

<main class="max-w-6xl mx-auto px-4 py-10">
    
    <!-- 1. PRODUCT OVERVIEW -->
    <div class="card p-6 mb-8">
        <h2 class="text-xl font-bold mb-4">Factory Production Output</h2>
        <%
            List<List<String>> prodData = ReportDAO.fetchTableData("Product");
            if(prodData.size() > 1) {
        %>
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
                <tr>
                    <% for(String h : prodData.get(0)) { %> <th><%= h %></th> <% } %>
                </tr>
            </thead>
            <tbody>
                <% for(int i=1; i<prodData.size(); i++) { %>
                <tr>
                    <% for(String c : prodData.get(i)) { %> <td class="px-4 py-2"><%= c %></td> <% } %>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } else { %> <p>No products manufactured yet.</p> <% } %>
    </div>

    <!-- 2. PRODUCTION FORM -->
    <div class="card p-8">
        <h2 class="text-xl font-bold">Start Production</h2>
        <p class="text-sm text-muted">Record new products manufactured by factories.</p>
        
        <%
            Connection conn = DBUtil.getConnection();
            ResultSet rsF = conn.createStatement().executeQuery("SELECT Factory_ID, Name FROM Factory");
            List<String[]> factories = new ArrayList<>();
            while(rsF.next()) factories.add(new String[]{rsF.getString(1), rsF.getString(2)});
            DBUtil.closeConnection(conn);
        %>

        <form action="ProductionServlet" method="POST" class="mt-6 grid sm:grid-cols-2 gap-4">
            <div>
                <label class="text-sm font-medium">Select Factory</label>
                <select name="factoryId" class="form-input w-full">
                    <% for(String[] f : factories) { %> <option value="<%= f[0] %>"><%= f[1] %></option> <% } %>
                </select>
            </div>
            <div>
                <label class="text-sm font-medium">Product Name</label>
                <input name="productName" placeholder="e.g. Recycled Bottles" class="form-input w-full" required/>
            </div>
            <div>
                <label class="text-sm font-medium">Quantity Produced</label>
                <input name="quantity" type="number" class="form-input w-full" required/>
            </div>
            <div>
                <label class="text-sm font-medium">Price per Unit</label>
                <input name="price" type="number" step="0.01" class="form-input w-full" required/>
            </div>
            <div class="sm:col-span-2">
                <button type="submit" class="btn-primary w-full">Record Production</button>
            </div>
        </form>
    </div>
</main>