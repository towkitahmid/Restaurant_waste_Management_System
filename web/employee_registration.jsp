<%-- 1. INCLUDE THE HEADER (This must be the first line) --%>
<%@ include file="public_header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <title>WMS · Employee Registration</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .brand-bg { background: linear-gradient(90deg,#064e3b,#047857 60%); }
        .card { background:#fff;border-radius:12px;box-shadow:0 6px 18px rgba(7,12,14,0.06); }
        .form-input { border:1px solid #e6eef0;border-radius:8px;padding:.75rem .9rem;background:#f8faf9; }
        .form-input:focus{ box-shadow:0 0 0 4px rgba(4,120,87,0.08); outline:none;border-color:#10b981; background:#fff;}
    </style>
</head>
<body class="min-h-screen bg-gray-50">

    <%-- The <header> is now provided by the include file --%>

    <main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
        <div class="card p-8">
            <h2 class="text-2xl font-bold">Register Employee</h2>
            <p class="text-sm text-gray-500 mt-1">Add drivers, managers and specialists to the system.</p>
            
            <% 
                String message = (String) request.getAttribute("message");
                if (message != null) {
                  String cls = message.toLowerCase().contains("success") ? "bg-green-50 border border-green-100 text-green-800" : "bg-red-50 border border-red-100 text-red-800";
            %>
              <div class="mt-6 <%= cls %> px-4 py-3 rounded-md"><%= message %></div>
            <% } %>

            <%
                List<Management> managers = new ArrayList<>();
                Connection conn = null; Statement stmt = null; ResultSet rs = null;
                String fetchMessage = null;
                try {
                  conn = DBUtil.getConnection();
                  stmt = conn.createStatement();
                  rs = stmt.executeQuery("SELECT Manager_ID, Name FROM Management");
                  managers.add(new Management(0, "-- Select Manager --"));
                  while (rs.next()) {
                    managers.add(new Management(rs.getInt("Manager_ID"), rs.getString("Name")));
                  }
                } catch (SQLException e) {
                  fetchMessage = "Unable to load manager list. Ensure Management table exists and DB is running.";
                } finally {
                  if (rs != null) try { rs.close(); } catch (SQLException e) {}
                  if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
                  com.wms.util.DBUtil.closeConnection(conn);
                }
            %>

            <% if (fetchMessage != null) { %>
                <div class="mt-4 bg-yellow-50 border border-yellow-100 text-yellow-800 px-4 py-3 rounded-md"><%= fetchMessage %></div>
            <% } %>

            <form action="EmployeeServlet" method="POST" class="mt-6 grid grid-cols-1 gap-4">
                <div class="grid sm:grid-cols-2 gap-4">
                    <div>
                        <label class="text-sm font-medium">First Name</label>
                        <input id="firstName" name="firstName" required class="form-input w-full"/>
                    </div>
                    <div>
                        <label class="text-sm font-medium">Last Name</label>
                        <input id="lastName" name="lastName" required class="form-input w-full"/>
                    </div>
                </div>

                <div class="grid sm:grid-cols-3 gap-4">
                    <div>
                        <label class="text-sm font-medium">Role</label>
                        <select id="role" name="role" required class="form-input w-full">
                            <option value="">-- Select Role --</option>
                            <option>Driver</option>
                            <option>Storehouse Manager</option>
                            <option>Recycling Specialist</option>
                        </select>
                    </div>
                    <div>
                        <label class="text-sm font-medium">Gender</label>
                        <select id="gender" name="gender" required class="form-input w-full">
                            <option value="">-- Select --</option>
                            <option value="M">Male</option><option value="F">Female</option><option value="O">Other</option>
                        </select>
                    </div>
                    <div>
                        <label class="text-sm font-medium">Salary</label>
                        <input id="salary" name="salary" type="number" step="0.01" min="0" required class="form-input w-full"/>
                    </div>
                </div>

                <div>
                    <label class="text-sm font-medium">Supervisor (Manager)</label>
                    <select id="managerId" name="managerId" required class="form-input w-full">
                        <% for (Management mgr : managers) {
                             if (mgr.getManagerId() == 0) {
                               out.println("<option value='' selected disabled>" + mgr.getName() + "</option>");
                             } else {
                               out.println("<option value='" + mgr.getManagerId() + "'>" + mgr.getName() + " (ID: " + mgr.getManagerId() + ")</option>");
                             }
                           } %>
                    </select>
                    <p class="text-xs text-gray-400 mt-1">Make sure you inserted managers into the <strong>Management</strong> table first.</p>
                </div>

                <div class="pt-2">
                    <button type="submit" class="inline-flex items-center px-5 py-3 rounded-md bg-emerald-600 text-white font-semibold">Register Employee</button>
                </div>
            </form>
        </div>
    </main>
</body>
</html>