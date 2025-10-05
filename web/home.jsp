<%-- 
    Document   : home
    Created on : Oct 5, 2025, 2:31:42 AM
    Author     : kient
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
    <h2>Xin chào, ${sessionScope.user.fullname}!</h2>
    <p>Vai trò của bạn: ${sessionScope.user.role}</p>
    <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">Đăng xuất</a>
</body>
</html>
