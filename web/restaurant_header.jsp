<%-- This is restaurant_header.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // --- RESTAURANT SESSION CHECK ---
    // If 'restaurantId' is not in the session, redirect to the restaurant login page.
    String loginURI = request.getContextPath() + "/restaurant_login.jsp";
    boolean isLoginPage = request.getRequestURI().equals(loginURI);

    if (session.getAttribute("restaurantId") == null && !isLoginPage) {
        response.sendRedirect(request.getContextPath() + "/restaurant_login.jsp");
        return; // Stop processing
    }
    
    String restaurantName = (String) session.getAttribute("restaurantName");
    Integer restaurantId = (Integer) session.getAttribute("restaurantId");
%>

<header class="brand-bg text-white">
    <div class="max-w-7xl mx-auto px-4 py-4 flex items-center justify-between">
        <div class="flex items-center gap-3">
            <div class="w-9 h-9 bg-white/10 rounded-md flex items-center justify-center">
                <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M3 7h18M3 12h18M3 17h18"/></svg>
            </div>
            <div>
                <div class="font-semibold">Restaurant Portal</div>
                <div class="text-xs text-white/80">Welcome, <%= (restaurantName != null ? restaurantName : "Owner") %></div>
            </div>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/RestaurantLogoutServlet" class="text-white/90 hover:underline text-sm font-medium">
                Logout
            </a>
        </div>
    </div>
</header>