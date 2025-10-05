<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Product" %>
<%@page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en" style="height: 100vh">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Tạo Hợp Đồng Bảo Hiểm Thủ Công</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            /* Sidebar styling */
            .sidebar {
                background: #f8f9fa;
                box-shadow: 2px 0 15px rgba(0, 0, 0, 0.1);
                border-right: 1px solid #e0e0e0;
                position: relative;
            }
            
            .sidebar::before {
                content: '';
                position: absolute;
                top: 0;
                right: 0;
                width: 1px;
                height: 100%;
                background: linear-gradient(to bottom, transparent, #e0e0e0, transparent);
            }
            
            /* Menu items styling */
            .sidebar li {
                margin: 5px 10px;
                border-radius: 8px;
                transition: all 0.3s ease;
                position: relative;
            }
            
            li:hover{
                background: #ffd700;
                color: #333;
                font-weight: 500;
                box-shadow: 0 2px 8px rgba(255, 215, 0, 0.3);
                transform: translateX(3px);
            }
            
            li:hover::before {
                content: '';
                position: absolute;
                left: -10px;
                top: 50%;
                transform: translateY(-50%);
                width: 3px;
                height: 60%;
                background: #ffd700;
                border-radius: 0 3px 3px 0;
            }

            .dropdown-item:hover{
                background-color: #ffd700;
                color: #333;
                font-weight: 500;
            }

            .dropdown-menu {
                background-color: white;
                border: 1px solid #e0e0e0;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }

            .dropdown-item{
                color: #666;
            }
            
            /* Main content area */
            .main-content {
                background: white;
                margin-left: 16.67%; /* Bootstrap col-2 = 16.67% */
            }

            /* Contract Management specific styles */
            .contract-card {
                background: white;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 20px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }

            .form-section {
                margin-bottom: 30px;
                padding: 20px;
                border: 1px solid #e9ecef;
                border-radius: 10px;
                background-color: #f8f9fa;
            }

            .section-title {
                color: #495057;
                font-weight: 600;
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 2px solid #dee2e6;
            }

            .form-control {
                border-radius: 6px;
                border: 1px solid #ddd;
            }

            .form-control:focus {
                border-color: #ffd700;
                box-shadow: 0 0 0 0.2rem rgba(255, 215, 0, 0.25);
            }

            .btn-primary {
                background-color: #ffd700;
                border-color: #ffd700;
                color: #333;
                font-weight: 500;
            }

            .btn-primary:hover {
                background-color: #e6c200;
                border-color: #e6c200;
                color: #333;
            }

            .btn-secondary {
                border-radius: 8px;
                padding: 12px 30px;
                font-weight: 500;
            }

            .required {
                color: #dc3545;
            }

            .product-card {
                border: 1px solid #dee2e6;
                border-radius: 10px;
                padding: 15px;
                margin-bottom: 10px;
                transition: all 0.3s ease;
                cursor: pointer;
            }

            .product-card:hover {
                border-color: #ffd700;
                box-shadow: 0 5px 15px rgba(255, 215, 0, 0.1);
            }

            .product-card.selected {
                border-color: #ffd700;
                background-color: #fff8e1;
            }

            .product-name {
                font-weight: 600;
                color: #495057;
                margin-bottom: 5px;
            }

            .product-description {
                color: #6c757d;
                font-size: 0.9em;
            }

            .form-check {
                padding: 15px;
                border: 2px solid #e9ecef;
                border-radius: 10px;
                margin-bottom: 10px;
                transition: all 0.3s ease;
                cursor: pointer;
            }

            .form-check:hover {
                border-color: #ffd700;
                background-color: #fff8e1;
            }

            .form-check-input:checked + .form-check-label {
                color: #ffd700;
                font-weight: 600;
            }

            .form-check-input:checked ~ .form-check {
                border-color: #ffd700;
                background-color: #fff8e1;
            }

            .form-check-label {
                cursor: pointer;
                font-size: 1.1em;
            }

            .form-check-label i {
                margin-right: 8px;
                font-size: 1.2em;
            }

            .alert {
                border-radius: 10px;
                border: none;
                padding: 15px 20px;
            }

            .alert-success {
                background: linear-gradient(135deg, #28a745, #20c997);
                color: white;
            }

            .alert-danger {
                background: linear-gradient(135deg, #dc3545, #fd7e14);
                color: white;
            }
        </style>
    </head>
    <body style="height: 100vh">
        <div class="container-fluid d-flex justify-content-between" style="position: fixed; background: #fff700; border-bottom: 1px solid #e0e0e0; z-index: 999">
            <h1 style="font-family: serif; font-style: italic; letter-spacing: 5px; color: #333"><i class="fas fa-suitcase mx-3" style="color: #ffd700"></i>TIS</h1>
            <div class="dropdown">
                <button type="button" class="btn dropdown-toggle" data-bs-toggle="dropdown" style="color: #666; border: none; background: transparent">
                    <i class="fa-solid fa-bars" style="font-size: 30px; text-align: end; color: #666"></i>
                </button>

                <ul class="dropdown-menu" style="z-index: 1000">
                    <li><a class="dropdown-item" href="#">Profile</a></li>
                    <li><a class="dropdown-item" href="#">Settings</a></li>
                    <li><a class="dropdown-item" href="#">Sign out</a></li>
                </ul>
            </div>
        </div>

        <div class="row" style="height: 100vh">
            <div class="col-2 position-fixed sidebar" style="margin-top: 57.5px; height: 100vh; padding: 0; z-index: 100">
                <ul class="list-unstyled">
                    <a class="text-decoration-none text-reset" href="/Insurance/Staff"><li class="py-3 text-center fs-5" style="color: #333; font-weight: 600; background: #ffd700;">Dashboard</li></a>
                    <a class="text-decoration-none text-reset" href="/Insurance/CreateContract"><li class="py-3 text-center fs-5" style="color: #666; font-weight: 400">Tạo Hợp Đồng</li></a>
                    <a class="text-decoration-none text-reset" href="/Insurance/ContractManagement"><li class="py-3 text-center fs-5" style="color: #666; font-weight: 400">Quản Lý Hợp Đồng</li></a>
                </ul>
            </div>

            <div class="col-10 container px-5 position-relative" style="margin-top: 57.5px; height: calc(100vh -57.5px); margin-left: 308px; width: calc(100vw - 308px); background: white; z-index: 888; overflow-y: auto;">
                
                <div class="py-4">
                    <h2 class="mb-4"><i class="fas fa-tachometer-alt me-3" style="color: #ffd700"></i>Staff Dashboard</h2>
                    
                    <!-- Dashboard content will be added here later -->
                    <div class="row">
                        <div class="col-md-12">
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle"></i> 
                                <strong>Staff Dashboard!</strong><br>
                                Coming soon...
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    </body>
</html>
