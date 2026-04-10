<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Personal Cabinet</title>
    <style>

        btn-no-padding {
            padding: 0;
        }

        .btn-full-width {
            width: 100%;
        }

        .btn-vertical-padding {
            padding-top: 15px;
            padding-bottom: 15px;
        }

        .breadcrumb a {
            text-decoration: none;
        }

        .change-button {
            float: right;
            margin-top: 10px;
            padding: 10px 20px;
        }
        .btn {
            margin-bottom: 10px;
        }
    </style>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">


</head>
<body style="background-color: #eee;">
<form>
    <div class="container py-5">
        <div class="row">
            <div class="col">
                <nav aria-label="breadcrumb" class="bg-light rounded-3 p-3 mb-4">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="main_page.jsp">Home</a></li>
                        <li class="breadcrumb-item active" aria-current="page">User Profile</li>
                    </ol>
                </nav>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-4">
                <div class="card mb-4">
                    <div class="card-body text-center">
                        <img src="https://www.pngmart.com/files/21/Account-Avatar-Profile-PNG-Photo.png" alt="avatar"
                             class="rounded-circle img-fluid" style="width: 150px;">
                        <c:choose>
                            <c:when test="${sessionScope.userRole == 'Seller'}">
                                <br>
                                <h6 style="color: green">Seller</h6>
                            </c:when>
                            <c:when test="${sessionScope.userRole == 'Admin'}">
                                <br>
                                <h6 style="color: red">Admin</h6>
                            </c:when>
                        </c:choose>
                        <h5 class="my-3"><c:out value="${sessionScope.userName}"/> <c:out
                                value="${sessionScope.userLN}"/></h5>
                        <c:choose>
                            <c:when test="${sessionScope.userRole == 'Seller'}">
                                <hr>
                                <div class="text-center">
                                    <a href="addproduct" type="button" class="btn btn-primary">Add product</a>
                                    <a href="listproduct" type="button" class="btn btn-primary">My product</a>
                                </div>
                            </c:when>
                            <c:when test="${sessionScope.userRole == 'Buyer'}">
                                <hr>
                                <div class="text-center">
                                    <a href="purchasedItems" type="button" class="btn btn-primary">Auction purchases</a>
                                    <a href="orderList" type="button" class="btn btn-primary">My Orders</a>
                                </div>
                            </c:when>
                            <c:when test="${sessionScope.userRole == 'Admin'}">
                                <hr>
                                <div class="text-center">
                                    <a href="approveproducts" type="button" class="btn btn-primary">Approve products</a>
                                    <a href="auctionRequests" type="button" class="btn btn-primary">Auction Requests</a>
                                    <a href="userlist" type="button" class="btn btn-primary">List users</a>
                                </div>
                            </c:when>
                        </c:choose>
                    </div>
                </div>

                <div style="display: flex;">
                </div>
            </div>
            <div class="col-lg-8 mb-4">
                <div class="card mb-4">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-sm-3">
                                <p class="mb-0">Full Name</p>
                            </div>
                            <div class="col-sm-9">
                                <p class="text-muted mb-0"><c:out value="${sessionScope.userName}"/> <c:out
                                        value="${sessionScope.userLN}"/></p>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-sm-3">
                                <p class="mb-0">Email</p>
                            </div>
                            <div class="col-sm-9">
                                <p class="text-muted mb-0"><c:out value="${sessionScope.userEmail}"/></p>
                            </div>
                        </div>
                        <hr>
                        <c:if test="${sessionScope.userRole == 'Seller'}">
                        <div class="row">
                            <div class="col-sm-3">
                                <p class="mb-0">Information about you</p>
                            </div>
                            <div class="col-sm-8">
                                <p class="text-muted mb-0"><c:out value="${sessionScope.userInfo}"/></p>
                            </div>
                            </c:if>
                            <div class="col-sm-1">
                                <button type="button" class="btn btn-link btn-sm" onclick="redirectToEditProfile()">
                                    <i class="fa fa-pencil"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <a href="changePassword.jsp" class="btn btn-primary btn-sm change-button">Change Password</a>
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
    function redirectToEditProfile() {
        // Получаем userId из сессии
        var userId = "${sessionScope.userId}";

        // Перенаправляем пользователя на страницу редактирования профиля с передачей параметра userId
        window.location.href = "editprofile.jsp?userId=" + userId;
    }
</script>
</body>
</html>
