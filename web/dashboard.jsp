<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi" style="height: 100vh">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard - TIS</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="CSS/admin.css">
    </head>
    <body style="height: 100vh">
        <!-- Top Header -->
        <jsp:include page="component/admin-header.jsp"/>

        <div class="main-container">
            <!-- Sidebar -->
            <jsp:include page="component/admin-sidebar.jsp">
                <jsp:param name="activePage" value="${param.activePage}"/>
            </jsp:include>

            <!-- Main Content -->
            <div class="main-content">
                <div>
                    <jsp:include page="${empty page ? 'home.jsp' : page}"/>
                </div>
            </div>
        </div>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    </body>
</html>