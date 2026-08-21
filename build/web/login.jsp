<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <title>WMS Admin Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
      :root {
        --brand-500: #22C55E;
        --brand-600: #16A34A;
        --brand-950: #0C2D1F;
        --dark: #1f2937;
        --light: #f9fafb;
      }
      body {
        font-family: 'Inter', sans-serif;
        background-color: var(--light);
        color: var(--dark);
      }
      .brand-bg {
        background-color: var(--brand-950);
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
      }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center py-10 px-4">

    <div class="max-w-md w-full">
        <div class="flex items-center justify-center gap-3 mb-6">
            <a href="${pageContext.request.contextPath}/index.jsp" class="flex items-center gap-2">
                <img src="${pageContext.request.contextPath}/wms_logo.png" alt="WMS Logo" class="h-10 w-auto">
                <div class="text-2xl font-bold text-dark">Admin Panel</div>
            </a>
        </div>

        <div class="card p-8">
            <h2 class="text-xl font-bold text-center text-dark">Admin Sign In</h2>
            
            <% 
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="bg-red-100 text-red-800 p-3 rounded-lg my-4 text-sm">
                    <%= error %>
                </div>
            <% } %>

            <form action="AdminLoginServlet" method="POST" class="space-y-5 mt-6">
                <div>
                    <label class="text-sm font-medium mb-1 block text-dark">Manager Name</label>
                    <input name="username" required class="form-input w-full" placeholder="Enter your manager name"/>
                </div>
                <div>
                    <label class="text-sm font-medium mb-1 block text-dark">Password</label>
                    <input name="password" type="password" required class="form-input w-full" placeholder="Enter your password"/>
                </div>
                <div class="pt-2">
                    <button type="submit" class="btn-primary w-full">
                        Sign In
                    </button>
                </div>
            </form>
        </div>
        <p class="text-sm text-muted mt-6 text-center">Not an admin? <a href="${pageContext.request.contextPath}/index.jsp" class="text-green-600 hover:underline">Return to public site</a>.</p>
    </div>
</body>
</html>