<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Change Password</title>
</head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<style>
    .breadcrumb a {
        text-decoration: none;
    }
    .password-input-wrapper {
        position: relative;
    }
    .password-toggle {
        position: absolute;
        top: 50%;
        right: 10px;
        transform: translateY(-50%);
        cursor: pointer;
        color: black;
        font-size: 18px;
        z-index: 10;
    }
    .form-control {
        padding-right: 35px;
    }
</style>
<body style="background-color: #eee">
<form id="changePasswordForm" action="updatePassword" method="post">
    <div class="container py-5">
        <div class="row">
            <div class="col">
                <nav aria-label="breadcrumb" class="bg-light rounded-3 p-3 mb-4">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="main_page.jsp">Home</a></li>
                        <li class="breadcrumb-item active"><a href="Profile.jsp">User Profile</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Change Password</li>
                    </ol>
                </nav>
            </div>
        </div>
        <input type="hidden" id="userId" name="userId" value="<c:out value='${sessionScope.userId}' />">
        <div class="row">
            <div class="col-lg-4">
                <div class="card mb-4">
                    <div class="card-body text-center">
                        <img src="https://www.pngmart.com/files/21/Account-Avatar-Profile-PNG-Photo.png" alt="avatar" class="rounded-circle img-fluid" style="width: 150px;">
                        <h5 class="my-3"><c:out value="${sessionScope.userName}"/> <c:out value="${sessionScope.userLN}"/></h5>
                    </div>
                </div>
            </div>
            <div class="col-lg-8 mb-4">
                <h4 style="font-weight: bold">Change password</h4>
                <div class="card mb-4">
                    <div class="card-body">
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger" role="alert">
                                    ${errorMessage}
                            </div>
                        </c:if>
                        <div class="row">
                            <div class="col-sm-3">
                                <label for="newPassword" class="form-label">New Password</label>
                            </div>
                            <div class="col-sm-9">
                                <div class="password-input-wrapper">
                                    <input type="password" name="newPassword" id="newPassword" class="form-control"
                                           pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$"
                                           required title="Password must be at least 8 characters long, include an uppercase letter, a lowercase letter, and a number">
                                    <i class="fas fa-eye-slash password-toggle" onclick="togglePassword('newPassword')"></i>
                                </div>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-sm-3">
                                <label for="confirmPassword" class="form-label">Confirm Password</label>
                            </div>
                            <div class="col-sm-9">
                                <div class="password-input-wrapper">
                                    <input type="password" name="confirmPassword" id="confirmPassword" class="form-control"
                                           pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$"
                                           required title="Passwords must match">
                                    <i class="fas fa-eye-slash password-toggle" onclick="togglePassword('confirmPassword')"></i>
                                </div>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-sm-12">
                                <button type="submit" class="btn btn-primary">Change Password</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>
<script>
    document.getElementById('changePasswordForm').addEventListener('submit', function (e) {
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        if (newPassword !== confirmPassword) {
            e.preventDefault();
            alert('Passwords do not match!');
        }
    });
    function togglePassword(inputId) {
        const passwordInput = document.getElementById(inputId);
        const icon = passwordInput.nextElementSibling;

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
