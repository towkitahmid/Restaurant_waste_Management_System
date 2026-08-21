<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.wms.util.DBUtil, com.wms.model.*, java.sql.*, java.util.*, java.text.*" %>

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
    background-color: var(--brand-900);
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
                <a href="${pageContext.request.contextPath}/index.jsp" class="flex items-center gap-2">
                    <img src="${pageContext.request.contextPath}/wms_logo.png" alt="WMS Logo" class="h-8 w-auto">
                    <div>
                        <div class="text-lg font-bold">Restaurant Waste Management System</div>
                        <div class="text-xs text-gray-300">Municipal Waste Tracking</div>
                    </div>
                </a>
            </div>

            <nav class="hidden md:flex items-center gap-6 text-sm">
                <a href="${pageContext.request.contextPath}/index.jsp" class="text-gray-200 hover:text-white transition-colors">Register Restaurant</a>
                <a href="${pageContext.request.contextPath}/collection_log.jsp" class="text-gray-200 hover:text-white transition-colors">Log Collection</a>
            </nav>

            <div class="flex items-center gap-4">
                <a href="${pageContext.request.contextPath}/restaurant_signup.jsp" class="text-gray-200 text-sm font-medium hover:text-white transition-colors">
                    Restaurant Sign Up
                </a>
                <a href="${pageContext.request.contextPath}/restaurant_login.jsp" class="text-gray-200 text-sm font-medium hover:text-white transition-colors">
                    Restaurant Login
                </a>
                <a href="${pageContext.request.contextPath}/login.jsp" class="inline-flex items-center px-4 py-2 rounded-md bg-white bg-opacity-10 text-white text-sm font-semibold hover:bg-opacity-20 transition-colors">
                    Admin Dashboard
                </a>
            </div>
        </div>
    </div>
</header>