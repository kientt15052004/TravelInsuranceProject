
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" style="height: 100vh">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>dashboard</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            li:hover{
                background: #333333;
                border-radius: 5px;
                font-weight: bold;
            }

            .dropdown-item:hover{
                font-family: sans-serif;
                font-weight: bold;
                background-color: #ffcc00;
                color: black;
            }

            .dropdown-menu {
                background-color: black;
            }

            .dropdown-item{
                color: white;

            }
        </style>
    </head>
    <body style="height: 100vh">
        <div class="container-fluid d-flex justify-content-between" style="position: fixed; background: linear-gradient(#ffcc33, #ffcc00, #cc9900); border-bottom: 5px solid black; z-index: 999">
            <h1 style="font-family: serif; font-style: italic; letter-spacing: 5px"><i class="fas fa-suitcase mx-3"></i>TIS</h1>
            <div class="dropdown">
                <button type="button" class="btn dropdown-toggle" data-bs-toggle="dropdown">
                    <i class="fa-solid fa-bars" style="font-size: 30px; text-align: end"></i>
                </button>

                <ul class="dropdown-menu" style="z-index: 1000">
                    <li><a class="dropdown-item" href="#">Profile</a></li>
                    <li><a class="dropdown-item" href="#">link2</a></li>
                    <li><a class="dropdown-item" href="#">Sign out</a></li>
                </ul>

            </div>
        </div>

        <div class="row" style="height: 100vh">

            <div class="col-2 bg-black position-fixed" style="margin-top: 57.5px; height: 100vh; border-right: 5px solid black; padding: 0">
                <ul class="py-5 list-unstyled">
                    <a class="text-decoration-none text-reset" href="/home/navigate?page=home"><li class="py-3 text-center text-light fs-5 mx-3" style="border-radius: 25px">Home Page</li></a>
                    <a class="text-decoration-none text-reset" href="/home/navigate?page=user"><li class="py-3 text-center text-light fs-5 mx-3" style="border-radius: 25px">User Management</li></a>
                    <a class="text-decoration-none text-reset" href="/home/navigate?page=report"><li class="py-3 text-center text-light fs-5 mx-3" style="border-radius: 25px">Daily Report</li></a>
                    <a class="text-decoration-none text-reset" href="/home/navigate?page=create"><li class="py-3 text-center text-light fs-5 mx-3" style="border-radius: 25px">Product Management</li></a>
                </ul>
            </div>

            <div class="col-10 container px-5 position-relative" style="margin-top: 57.5px; height: calc(100vh -57.5px); margin-left: 308px; width: calc(100vw - 308px); background: linear-gradient(90deg, #1a1a1a, #3c3c3c); z-index: 888">
                <jsp:include page="${empty page ? 'home.jsp' : page}"/>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    </body>
</html>
