<%-- This is admin_header.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.wms.util.DBUtil, com.wms.model.*, java.sql.*, java.util.*, java.text.*" %>

<%
    String loginURI_admin = request.getContextPath() + "/login.jsp";
    boolean isLoginPage_admin = request.getRequestURI().equals(loginURI_admin);

    if (session.getAttribute("adminUser") == null && !isLoginPage_admin) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return; 
    }
    
    String adminName = (String) session.getAttribute("adminUser");
    String adminRole = (String) session.getAttribute("adminRole");
%>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

<style>
  :root {
    --brand-50: #F0FDF4;
    --brand-100: #DCFCE7;
    --brand-200: #BBF7D0;
    --brand-500: #22C55E;
    --brand-600: #16A34A;
    --brand-700: #15803D;
    --brand-800: #166534;
    --brand-900: #14532D;
    --brand-950: #0C2D1F;
    --dark: #1f2937;
    --light: #f9fafb;
    --muted: #6b7280;
  }
  body {
    font-family: 'Inter', sans-serif;
    background-color: var(--light);
    color: var(--dark);
  }
  .brand-bg {
    background-color: var(--brand-950); /* Darker green for Admin */
  }
  .card { 
    background: #ffffff; 
    border-radius: 12px; 
    box-shadow: 0 6px 18px rgba(7,12,14,0.06); 
  }
  .form-input { 
    border: 1px solid #e2e8f0; 
    border-radius: 8px; 
    padding: .75rem .9rem; 
    background:#fdfdfd; 
    transition: all 0.2s;
  }
  .form-input:focus { 
    box-shadow: 0 0 0 4px rgba(34,197,94,0.15); 
    outline:none; 
    background:#fff; 
    border-color: var(--brand-500);
  }
  .btn-primary {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    border-radius: 8px;
    background-color: var(--brand-600);
    color: white;
    font-weight: 600;
    padding: 0.75rem 1.25rem;
    box-shadow: 0 4px 10px rgba(22, 163, 74, 0.2);
    transition: all 0.2s;
  }
  .btn-primary:hover {
    background-color: var(--brand-700);
    box-shadow: 0 6px 15px rgba(22, 163, 74, 0.3);
  }
</style>

<header class="brand-bg text-white shadow-md">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16">
            <div class="flex items-center gap-3">
                <a href="${pageContext.request.contextPath}/dashboard.jsp" class="flex items-center gap-2">
                    <img src="${pageContext.request.contextPath}/wms_logo.png" alt="WMS Logo" class="h-8 w-auto">
                    <div>
                        <div class="font-bold">WMS Admin Panel</div>
                        <div class="text-xs text-gray-300">Welcome, <%= (adminName != null ? adminName : "Guest") %></div>
                    </div>
                </a>
            </div>

            <nav class="hidden md:flex items-center gap-4 text-sm">
                <a href="${pageContext.request.contextPath}/dashboard.jsp" class="text-gray-200 hover:text-white transition-colors">Dashboard</a>
                <a href="${pageContext.request.contextPath}/index.jsp" class="text-gray-200 hover:text-white transition-colors">Restaurants</a>
                <a href="${pageContext.request.contextPath}/employee_registration.jsp" class="text-gray-200 hover:text-white transition-colors">Employees</a>
                <a href="${pageContext.request.contextPath}/collection_log.jsp" class="text-gray-200 hover:text-white transition-colors">Collections</a>
                <a href="${pageContext.request.contextPath}/vendor_registration.jsp" class="text-gray-200 hover:text-white transition-colors">Vendors</a>
                <a href="${pageContext.request.contextPath}/factory_registration.jsp" class="text-gray-200 hover:text-white transition-colors">Factories</a>
                <a href="${pageContext.request.contextPath}/dumping_zone_registration.jsp" class="text-gray-200 hover:text-white transition-colors">Zones</a>
                <a href="${pageContext.request.contextPath}/admin_registration.jsp" class="text-white bg-white/10 px-3 py-1 rounded-md font-medium hover:bg-white/20 transition-colors">Create Admin</a>
            </nav>

            <div>
                <% if (adminName != null) { %>
                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="text-gray-200 hover:text-white text-sm font-medium transition-colors">
                        Logout
                    </a>
                <% } %>
            </div>
        </div>
    </div>
</header>