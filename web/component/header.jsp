<%@page contentType="text/html" pageEncoding="UTF-8"%>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - InsureTravel</title>
    <link rel="stylesheet" href="./CSS/header.css">
</head>

<header class="header">
    <div class="logo">InsureTravel</div>
    <nav class="nav">
        <a href="${pageContext.request.contextPath}/Home" class="nav-link">Home</a>
        <a href="${pageContext.request.contextPath}/InsuranceList" class="nav-link">Products</a>
        <a href="${pageContext.request.contextPath}/About" class="nav-link">About</a>
        <a href="${pageContext.request.contextPath}/Contact" class="nav-link">Contact</a>
    </nav>
    <div class="user-icon">
        <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
        <circle cx="10" cy="6" r="4" stroke="currentColor" stroke-width="2"/>
        <path d="M4 18c0-3.314 2.686-6 6-6s6 2.686 6 6" stroke="currentColor" stroke-width="2"/>
        </svg>
    </div>
</header>
