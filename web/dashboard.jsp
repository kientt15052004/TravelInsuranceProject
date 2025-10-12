<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi" style="height: 100vh">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard - TIS</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            :root {
                --primary-yellow: #FFD700;
                --light-yellow: #FFF9C4;
                --dark-yellow: #FFC107;
                --white: #FFFFFF;
                --text-dark: #333333;
                --sidebar-bg: #FFFDF5;
            }

            body {
                background: linear-gradient(135deg, var(--light-yellow) 0%, var(--white) 100%);
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                padding: 0;
                height: 100vh;
                overflow: hidden;
            }

            /* Top Header - Đồng bộ với staff.jsp */
            .top-header {
                background: linear-gradient(135deg, var(--dark-yellow) 0%, var(--primary-yellow) 100%);
                border-bottom: 3px solid var(--white);
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                padding: 12px 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
                height: 70px;
            }

            .header-left .logo {
                display: flex;
                align-items: center;
            }

            .logo-text {
                font-family: 'Georgia', serif;
                font-style: italic;
                font-weight: 700;
                font-size: 1.8rem;
                color: var(--text-dark);
                text-shadow: 1px 1px 2px rgba(255,255,255,0.5);
            }

            .user-dropdown {
                position: relative;
                display: flex;
                align-items: center;
                gap: 10px;
                cursor: pointer;
                padding: 8px 15px;
                border-radius: 8px;
                transition: all 0.3s;
            }

            .user-dropdown:hover {
                background: rgba(255,255,255,0.2);
            }

            .user-info {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .user-info i {
                font-size: 1.5rem;
                color: var(--text-dark);
            }

            .user-info span {
                color: var(--text-dark);
                font-weight: 600;
            }

            .dropdown-menu {
                position: absolute;
                top: 100%;
                right: 0;
                background: var(--white);
                border: 2px solid var(--primary-yellow);
                border-radius: 8px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                min-width: 180px;
                padding: 8px 0;
                display: none;
            }

            .user-dropdown:hover .dropdown-menu {
                display: block;
            }

            .dropdown-item {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 10px 15px;
                color: var(--text-dark);
                text-decoration: none;
                transition: all 0.3s;
                border-bottom: 1px solid #f0f0f0;
            }

            .dropdown-item:last-child {
                border-bottom: none;
            }

            .dropdown-item:hover {
                background-color: var(--light-yellow);
                color: var(--text-dark);
            }

            /* Main Container */
            .main-container {
                display: flex;
                margin-top: 70px;
                min-height: calc(100vh - 70px);
            }

            /* Sidebar - Đồng bộ với staff.jsp */
            .sidebar {
                width: 250px;
                background: var(--sidebar-bg);
                border-right: 1px solid var(--primary-yellow);
                box-shadow: 2px 0 10px rgba(0,0,0,0.05);
                padding: 20px 0;
                position: fixed;
                left: 0;
                top: 70px;
                bottom: 0;
                overflow-y: auto;
            }

            .sidebar-nav ul {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .nav-item {
                margin-bottom: 5px;
            }

            .nav-link {
                display: flex;
                align-items: center;
                padding: 15px 20px;
                color: var(--text-dark);
                text-decoration: none;
                transition: all 0.3s;
                border-left: 4px solid transparent;
            }

            .nav-link:hover, .nav-item.active .nav-link {
                background: linear-gradient(135deg, var(--primary-yellow) 0%, var(--light-yellow) 100%);
                border-left-color: var(--dark-yellow);
                font-weight: 600;
                transform: translateX(5px);
            }

            .nav-link i {
                width: 20px;
                margin-right: 10px;
                text-align: center;
            }

            /* Product Management Dropdown */
            .nav-item.has-dropdown {
                position: relative;
            }

            .nav-dropdown {
                display: none;
                background: var(--white);
                border-left: 4px solid var(--primary-yellow);
                margin-left: 20px;
            }

            .nav-item.has-dropdown:hover .nav-dropdown {
                display: block;
            }

            .nav-dropdown .nav-link {
                padding: 12px 20px 12px 40px;
                font-size: 0.9rem;
                border-left: none;
            }

            .nav-dropdown .nav-link:hover {
                background: var(--light-yellow);
                transform: translateX(3px);
            }

            /* Main Content */
            .main-content {
                flex: 1;
                margin-left: 250px;
                padding: 30px;
                background: transparent;
                height: calc(100vh - 70px);
                overflow-y: auto;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .sidebar {
                    width: 70px;
                }

                .main-content {
                    margin-left: 70px;
                }

                .nav-link span {
                    display: none;
                }

                .nav-link i {
                    margin-right: 0;
                }
            }

            /* Scrollbar Styling */
            ::-webkit-scrollbar {
                width: 6px;
            }

            ::-webkit-scrollbar-track {
                background: #f1f1f1;
            }

            ::-webkit-scrollbar-thumb {
                background: var(--primary-yellow);
                border-radius: 3px;
            }

            ::-webkit-scrollbar-thumb:hover {
                background: var(--dark-yellow);
            }
        </style>
    </head>
    <body style="height: 100vh">
        <!-- Top Header - Đồng bộ với staff.jsp -->
        <div class="top-header">
            <div class="header-left">
                <div class="logo">
                    <div class="logo-text">
                        <span class="logo-main">TIS</span>
                    </div>
                </div>
            </div>
            <div class="header-right">
                <div class="user-dropdown">
                    <div class="user-info">
                        <i class="fas fa-user-circle"></i>
                        <span>Admin</span>
                    </div>
                    <i class="fas fa-chevron-down dropdown-arrow"></i>
                    <div class="dropdown-menu">
                        <a href="#" class="dropdown-item">
                            <i class="fas fa-user"></i>
                            Profile
                        </a>
                        <a href="#" class="dropdown-item">
                            <i class="fas fa-cog"></i>
                            Settings
                        </a>
                        <a href="${pageContext.request.contextPath}/logout" class="dropdown-item">
                            <i class="fas fa-sign-out-alt"></i>
                            Đăng xuất
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="main-container">
            <!-- Sidebar - Đồng bộ với staff.jsp -->
            <div class="sidebar">
                <nav class="sidebar-nav">
                    <ul>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/navigate?page=home" class="nav-link">
                                <i class="fas fa-home"></i>
                                <span>Home Page</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/navigate?page=user" class="nav-link">
                                <i class="fas fa-users"></i>
                                <span>User Management</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/navigate?page=report" class="nav-link">
                                <i class="fas fa-chart-bar"></i>
                                <span>Daily Report</span>
                            </a>
                        </li>
                        <li class="nav-item has-dropdown">
                            <a href="#" class="nav-link">
                                <i class="fas fa-cube"></i>
                                <span>Product Management</span>
                                <i class="fas fa-chevron-down ms-auto"></i>
                            </a>
                            <div class="nav-dropdown">
                                <a href="${pageContext.request.contextPath}/navigate?page=create" class="nav-link">
                                    <i class="fas fa-plus-circle"></i>
                                    <span>Create Product</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/view_product" class="nav-link">
                                    <i class="fas fa-eye"></i>
                                    <span>View Products</span>
                                </a>
                            </div>
                        </li>
                    </ul>
                </nav>
            </div>

            <!-- Main Content - Giữ nguyên logic include của bạn -->
            <div class="main-content">
                <div style="height: 100%; overflow-y: auto; padding: 20px; background: linear-gradient(135deg, var(--light-yellow) 0%, var(--white) 100%); border-radius: 15px;">
                    <jsp:include page="${empty page ? 'home.jsp' : page}"/>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    </body>
</html>