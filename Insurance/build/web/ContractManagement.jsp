<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" style="height: 100vh">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản Lý Hợp Đồng</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="CSS/Staff.css">
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
                    <a class="text-decoration-none text-reset" href="/Insurance/Staff"><li class="py-3 text-center fs-5" style="color: #666; font-weight: 400;">Dashboard</li></a>
                    <a class="text-decoration-none text-reset" href="/Insurance/Staff/CreateContract"><li class="py-3 text-center fs-5" style="color: #666; font-weight: 400">Tạo Hợp Đồng</li></a>
                    <a class="text-decoration-none text-reset" href="/Insurance/Staff/ContractManagement"><li class="py-3 text-center fs-5" style="color: #333; font-weight: 600; background: #ffd700;">Quản Lý Hợp Đồng</li></a>
                </ul>
            </div>

            <div class="col-10 container px-5 position-relative" style="margin-top: 57.5px; height: calc(100vh -57.5px); margin-left: 308px; width: calc(100vw - 308px); background: white; z-index: 888; overflow-y: auto;">
                
                <div class="py-4">
                    <h2 class="mb-4"><i class="fas fa-clipboard-list me-3" style="color: #ffd700"></i>Quản Lý Hợp Đồng</h2>
                    
                    <!-- Contract Management Content -->
                </div>
            </div>
        </div>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    </body>
</html>
