<%-- 
    Document   : staff
    Created on : Dec 8, 2024
    Author     : Staff Page
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Dashboard - Hệ thống quản lý bảo hiểm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/staff.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
  <body>
      <!-- Top Header -->
      <div class="top-header">
          <div class="header-left">
              <div class="logo">
                  <i class="fas fa-briefcase"></i>
                  <div class="logo-text">
                      <span class="logo-main">Logo</span>
                  </div>
              </div>
          </div>
          <div class="header-right">
              <div class="user-dropdown">
                  <div class="user-info">
                      <i class="fas fa-user-circle"></i>
                      <span>Staff</span>
                  </div>
                  <i class="fas fa-chevron-down dropdown-arrow"></i>
                  <div class="dropdown-menu">
                      <a href="${pageContext.request.contextPath}/logout" class="dropdown-item">
                          <i class="fas fa-sign-out-alt"></i>
                          Đăng xuất
                      </a>
                  </div>
              </div>
          </div>
      </div>

      <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <nav class="sidebar-nav">
                <ul>
                    <li class="nav-item active">
                        <a href="${pageContext.request.contextPath}/staff" class="nav-link">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/CreateContractServlet" class="nav-link">
                            <i class="fas fa-plus-circle"></i>
                            <span>Tạo hợp đồng mới</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/staff/manage-contracts" class="nav-link">
                            <i class="fas fa-file-contract"></i>
                            <span>Quản lý hợp đồng</span>
                        </a>
                    </li>
                </ul>
            </nav>
            <div class="sidebar-footer">
                <!-- Empty footer for now -->
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="content-header">
                <h1>Dashboard</h1>
                <p>Coming Soon</p>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/JS/staff.js"></script>
</body>
</html>
