<%-- 1. INCLUDE THE PUBLIC HEADER --%>
<%@ include file="public_header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <title>WMS · Home</title>
    <script src="https://cdn.tailwindcss.com"></script>
    
    <style>
        .hero-section {
            /* Dark overlay + Image */
            background-image: linear-gradient(rgba(12, 45, 31, 0.85), rgba(12, 45, 31, 0.75)), url('https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?q=80&w=2670&auto=format&fit=crop');
            background-size: cover;
            background-position: center;
        }
    </style>
</head>
<body class="min-h-screen bg-gray-50 font-sans">

    <%-- The <header> is provided by public_header.jsp --%>

    <div class="hero-section text-white py-20">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <h1 class="text-4xl md:text-5xl font-extrabold leading-tight tracking-tight mb-4">
                Smart Waste Management Ecosystem
            </h1>
            <p class="text-lg md:text-xl text-gray-300 max-w-2xl mx-auto mb-8">
                Connecting Restaurants, Logistics, and Recycling Factories to create a sustainable supply chain for shopping malls and industries.
            </p>
            <div class="flex justify-center gap-4">
                <a href="restaurant_signup.jsp" class="btn-primary bg-white text-emerald-900 hover:bg-gray-100 border-0">
                    Join as Partner
                </a>
                <a href="login.jsp" class="btn-primary bg-transparent border border-white hover:bg-white/10">
                    Admin Access
                </a>
            </div>
        </div>
    </div>

    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 -mt-10 relative z-10">
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

            <section class="lg:col-span-2 space-y-6">
                
                <div class="card p-8 bg-white shadow-lg border-t-4 border-emerald-500">
                    <h2 class="text-2xl font-bold text-gray-800 mb-2">How It Works</h2>
                    <p class="text-gray-500 mb-8">A complete lifecycle approach to municipal waste management.</p>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                        <div class="flex items-start gap-4">
                            <div class="bg-emerald-100 p-3 rounded-full text-emerald-600">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path></svg>
                            </div>
                            <div>
                                <h3 class="font-bold text-gray-800">1. Collection</h3>
                                <p class="text-sm text-gray-600 mt-1">Restaurants report daily waste generation. Trucks are assigned to collect materials based on volume.</p>
                            </div>
                        </div>

                        <div class="flex items-start gap-4">
                            <div class="bg-blue-100 p-3 rounded-full text-blue-600">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16V6a1 1 0 00-1-1H4a1 1 0 00-1 1v10a1 1 0 001 1h1m8-1a1 1 0 01-1 1H9m4-1V8a1 1 0 011-1h2.586a1 1 0 01.707.293l3.414 3.414a1 1 0 01.293.707V16a1 1 0 01-1 1h-1m-6-1a1 1 0 001 1h1M5 17a2 2 0 104 0m-4 0a2 2 0 114 0m6 0a2 2 0 104 0m-4 0a2 2 0 114 0"></path></svg>
                            </div>
                            <div>
                                <h3 class="font-bold text-gray-800">2. Logistics & Zones</h3>
                                <p class="text-sm text-gray-600 mt-1">Waste is transported to specific Dumping Zones, sorted, and prepared for industrial processing.</p>
                            </div>
                        </div>

                        <div class="flex items-start gap-4">
                            <div class="bg-purple-100 p-3 rounded-full text-purple-600">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.384-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"></path></svg>
                            </div>
                            <div>
                                <h3 class="font-bold text-gray-800">3. Manufacturing</h3>
                                <p class="text-sm text-gray-600 mt-1">Factories convert raw waste into usable products like recycled bottles, fibers, and fertilizer.</p>
                            </div>
                        </div>

                        <div class="flex items-start gap-4">
                            <div class="bg-orange-100 p-3 rounded-full text-orange-600">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path></svg>
                            </div>
                            <div>
                                <h3 class="font-bold text-gray-800">4. Distribution</h3>
                                <p class="text-sm text-gray-600 mt-1">Vendors receive finished goods and distribute them to shopping malls and retail chains.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card p-8 bg-gradient-to-r from-emerald-800 to-teal-900 text-white shadow-lg relative overflow-hidden">
                    <svg class="absolute -right-10 -bottom-10 w-48 h-48 text-white opacity-10 transform rotate-12" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M4 2a2 2 0 00-2 2v11a3 3 0 106 0V4a2 2 0 00-2-2H4zm1 14a1 1 0 100-2 1 1 0 000 2zm5-1.757l4.9-4.9a2 2 0 000-2.828L13.485 5.1a2 2 0 00-2.828 0L10 5.757v8.486zM16 18H9.071l6-6H16a2 2 0 012 2v2a2 2 0 01-2 2z" clip-rule="evenodd"></path></svg>
                    
                    <div class="relative z-10">
                        <svg class="w-10 h-10 text-emerald-300 mb-4 opacity-80" fill="currentColor" viewBox="0 0 24 24"><path d="M14.017 21L14.017 18C14.017 16.8954 13.1216 16 12.017 16H6.01699V21H14.017ZM16.017 21H20.017V16C20.017 14.3431 18.6738 13 17.017 13H12.017V11H17.017C18.6738 11 20.017 9.65685 20.017 8V3H16.017V6H14.017V3H6.01699V8C6.01699 9.65685 7.36014 11 9.01699 11H10.017V13H9.01699C7.36014 13 6.01699 14.3431 6.01699 16V21H2.01699V3H4.01699V1H22.017V3H24.017V21H20.017Z"></path></svg>
                        <blockquote class="text-xl md:text-2xl font-light italic leading-relaxed">
                            "There is no such thing as 'away'. When we throw anything away, it must go somewhere."
                        </blockquote>
                        <div class="mt-4 flex items-center gap-2 text-emerald-200">
                            <span class="h-px w-8 bg-emerald-400"></span>
                            <span class="font-bold uppercase tracking-wider text-sm">Annie Leonard</span>
                        </div>
                    </div>
                </div>

            </section>

            <aside class="space-y-6 pt-8 lg:pt-0">
                
                <div class="card p-6 border-l-4 border-emerald-500 shadow-md">
                    <div class="flex items-center justify-between mb-2">
                        <div class="text-lg font-bold text-gray-800">Restaurants</div>
                        <svg class="w-5 h-5 text-emerald-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path></svg>
                    </div>
                    <p class="text-xs text-gray-500 mb-4">Manage waste collection requests and view history.</p>
                    <div class="space-y-2">
                        <a href="${pageContext.request.contextPath}/restaurant_signup.jsp" class="block w-full text-center bg-emerald-600 hover:bg-emerald-700 text-white font-semibold py-2 rounded transition text-sm shadow">Sign Up</a>
                        <a href="${pageContext.request.contextPath}/restaurant_login.jsp" class="block w-full text-center border border-emerald-600 text-emerald-600 hover:bg-emerald-50 font-semibold py-2 rounded transition text-sm">Login Portal</a>
                    </div>
                </div>

                <div class="card p-6 border-l-4 border-orange-500 shadow-md">
                    <div class="flex items-center justify-between mb-2">
                        <div class="text-lg font-bold text-gray-800">Distributors</div>
                        <svg class="w-5 h-5 text-orange-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>
                    </div>
                    <p class="text-xs text-gray-500 mb-4">Receive finished products and distribute to shopping malls.</p>
                    <div class="space-y-2">
                        <a href="${pageContext.request.contextPath}/vendor_signup.jsp" class="block w-full text-center bg-orange-600 hover:bg-orange-700 text-white font-semibold py-2 rounded transition text-sm shadow">Partner Sign Up</a>
                        <a href="${pageContext.request.contextPath}/vendor_login.jsp" class="block w-full text-center border border-orange-600 text-orange-600 hover:bg-orange-50 font-semibold py-2 rounded transition text-sm">Vendor Login</a>
                    </div>
                </div>

                <div class="card p-5 bg-gray-900 text-white shadow-md text-center">
                    <div class="text-2xl font-bold mb-1">Eco-Friendly</div>
                    <p class="text-xs text-gray-400">100% of collected waste is sorted and processed.</p>
                </div>

            </aside>

        </div>
    </main>
</body>
</html>