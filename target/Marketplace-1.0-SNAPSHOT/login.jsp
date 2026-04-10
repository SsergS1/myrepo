<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <title>Login</title>
    <link rel="stylesheet" href="../css/styles.css">
    <style>
        .password-input-wrapper {
            position: relative;
        }

        .password-toggle {
            position: absolute;
            top: 50%;
            right: 10px;
            transform: translateY(-50%);
            cursor: pointer;
            color: #adb5bd;
            font-size: 16px;
            z-index: 10;
        }

        .form-control-lg {
            padding-right: 35px;
        }
    </style>
</head>
<body>
<form class="vh-100 login-background" method="post" action="LoginServlet">
    <div class="container py-5 h-100">
        <div class="row d-flex justify-content-center align-items-center h-100">
            <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                <div class="card bg-dark text-white" style="border-radius: 1rem;">
                    <div class="card-body p-5 text-center">
                        <div class="mb-md-5 mt-md-4 pb-5">
                            <h2 class="fw-bold mb-2 text-uppercase">Login</h2>
                            <p class="text-white-50 mb-5">Please enter your email and password!</p>
                            <div class="form-outline form-white mb-4">
                                <input type="email" id="userEmail" name="userEmail" class="form-control form-control-lg" />
                                <label class="form-label" for="userEmail">Email</label>
                            </div>
                            <div class="form-outline form-white mb-4">
                                <div class="password-input-wrapper">
                                    <input type="password" id="password" name="password" class="form-control form-control-lg" />
                                    <i class="fas fa-eye-slash password-toggle" onclick="togglePassword()"></i>
                                </div>
                                <label class="form-label" for="password">Password</label>
                            </div>
                            <input class="btn btn-outline-light btn-lg px-5" type="submit" value="Login">
                        </div>
                        <div class="mb-md-1 mt-md-1 pb-1">
                            <c:if test="${not empty errorMessage}">
                                <p id="errorMessage" class="text-danger">${errorMessage}</p>
                            </c:if>
                        </div>
                        <div>
                            <p class="mb-0">Don't have an account? <a href="Register.jsp" class="text-white-50 fw-bold">Sign Up</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>
<script>
    setTimeout(function () {
        var errorMessageElement = document.getElementById("errorMessage");
        if (errorMessageElement) {
            errorMessageElement.style.display = "none";
        }
    }, 5000);
    setTimeout(function() {
        var errorMessageElement = document.getElementById("errorMessage");
        if (errorMessageElement) {
            errorMessageElement.style.display = "none";
        }
    }, 5000);

    function togglePassword() {
        const passwordInput = document.getElementById('password');
        const icon = document.querySelector('.password-toggle');

        if (passwordInput.type === "password") {
            passwordInput.type = "text";
            icon.classList.replace("fa-eye-slash", "fa-eye");
        } else {
            passwordInput.type = "password";
            icon.classList.replace("fa-eye", "fa-eye-slash");
        }
    }
</script>
</body>
</html>
