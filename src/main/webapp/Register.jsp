<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<c:set var="isAdminRegistration" value="${param.type eq 'admin'}" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    <title>Register page</title>
    <link rel="stylesheet" href="../css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
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
            color: black;
            font-size: 18px;
            z-index: 10;
        }

        .form-control-lg {
            padding-right: 35px;
        }
    </style>
</head>
<body>

<form class="h-100 h-custom login-background" method="post" action="RegisterServlet">
    <div class="container py-5 h-100">
        <div class="row d-flex justify-content-center align-items-center h-100">
            <div class="col-6">
                <div class="card card-registration card-registration-2"
                     style="border-radius: 15px; background-color: #212529;">
                    <div class="card-body p-5 text-white">
                        <div class="text-center">
                            <h3 class="fw-bold mb-2 text-uppercase">Registration</h3>
                            <p class="text-white-50 mb-5">Please enter all fields!</p>
                        </div>
                        <c:if test="${not empty errorMessage}">
                            <div id="error-message" class="alert alert-danger" role="alert">
                                    ${errorMessage}
                            </div>
                        </c:if>
                        <div class="mb-4 pb-2">
                            <c:choose>
                                <c:when test="${isAdminRegistration}">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="role" id="adminCheckbox" value="Admin" checked>
                                        <label class="form-check-label" for="adminCheckbox">Admin</label>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="role" id="buyerCheckbox" value="Buyer">
                                        <label class="form-check-label" for="buyerCheckbox">Buyer</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="role" id="sellerCheckbox" value="Seller">
                                        <label class="form-check-label" for="sellerCheckbox">Seller</label>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-4 pb-2">
                                <div class="form-outline">
                                    <input type="text" name="first_name" class="form-control form-control-lg" pattern="^[A-Z][a-zA-Z]*$" required title="First letter must be capitalized, only letters allowed"/>
                                    <label class="form-label">First name</label>

                                </div>
                            </div>
                            <div class="col-md-6 mb-4 pb-2">
                                <div class="form-outline">
                                    <input type="text" name="last_name" class="form-control form-control-lg" pattern="^[A-Z][a-zA-Z]*$" required title="First letter must be capitalized, only letters allowed"/>
                                    <label class="form-label">Last name</label>
                                </div>
                            </div>
                        </div>
                        <div class="mb-4">
                            <div class="form-outline">
                                <input type="email" name="email" class="form-control form-control-lg"
                                       pattern="[^@\s]+@[^@\s]+\.[a-zA-Z]{2,}"
                                       required
                                       title="Enter a valid email address (e.g., name@example.com)"/>
                                <label class="form-label">Your Email</label>
                            </div>
                        </div>
                        <div class="mb-4 pb-2">
                            <div class="form-outline">
                                <div class="password-input-wrapper">
                                    <input type="password" name="password" id="password" class="form-control form-control-lg" pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$" required title="Password must be at least 8 characters long, include an uppercase letter, a lowercase letter, and a number"/>
                                    <i class="fas fa-eye-slash password-toggle" onclick="togglePassword('password')"></i>
                                </div>
                                <label class="form-label" for="password">Password</label>
                            </div>
                        </div>
                        <div class="mb-4 pb-2">
                            <div class="form-outline">
                                <div class="password-input-wrapper">
                                    <input type="password" name="repeat_password" id="repeat_password" class="form-control form-control-lg" required title="Repeat the password entered above"/>
                                    <i class="fas fa-eye-slash password-toggle" onclick="togglePassword('repeat_password')"></i>
                                </div>
                                <label class="form-label" for="repeat_password">Repeat password</label>
                            </div>
                        </div>

                        <div class="text-center">
                            <button type="submit" class="btn btn-light btn-lg" data-mdb-ripple-color="dark">Register
                            </button>
                        </div>
                        <br>
                        <div class="text-center">
                            <p class="mb-0">Do you have an account?<a href="login.jsp" class="text-white-50 fw-bold"
                                                                      style=""> Sign
                                in</a></p>
                        </div>
                    </div>

                </div>

            </div>
        </div>
    </div>
</form>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe"
        crossorigin="anonymous"></script>
<script>
    window.onload = function () {
        const alertBox = document.getElementById('error-message');
        if (alertBox) {
            setTimeout(() => {
                alertBox.style.display = 'none';
            }, 5000); // 10000 milliseconds = 10 seconds
        }
    };
    function togglePassword(inputId) {
        const passwordInput = document.getElementById(inputId);
        const icon = passwordInput.nextElementSibling.nextElementSibling;

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
