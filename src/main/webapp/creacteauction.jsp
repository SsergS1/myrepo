<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Create Auction</title>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .breadcrumb a {
            text-decoration: none;
        }
        .image{
            width: 200px;
            height: 200px;
        }
    </style>
</head>
<body style="background-color: #eee">
<form method="post" action="submitAuction">
    <div class="container py-5">
        <div class="row">
            <!-- Навигационная панель -->
            <div class="col">
                <nav aria-label="breadcrumb" class="bg-light rounded-3 p-3 mb-4">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="main_page.jsp">Home</a></li>
                        <li class="breadcrumb-item active"><a href="Profile.jsp">User Profile</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Create Auction</li>
                    </ol>
                </nav>
            </div>
        </div>
        <div class="row">
            <!-- Профиль пользователя -->
            <div class="col-lg-4">
                <div class="card mb-4">
                    <div class="card-body text-center">
                        <img src="https://www.pngmart.com/files/21/Account-Avatar-Profile-PNG-Photo.png" alt="avatar"
                             class="rounded-circle img-fluid" style="width: 150px;">
                        <h5 class="my-3">
                            <c:out value="${sessionScope.userName}"/>
                            <c:out value="${sessionScope.userLN}"/>
                        </h5>
                    </div>
                </div>
            </div>
            <!-- Форма создания аукциона -->
            <div class="col-lg-8 mb-4">
                <div class="card mb-4">
                    <div class="card-body">
                        <!-- Поле ввода названия аукциона -->
                        <div class="row">
                            <div class="col-sm-3">
                                <label for="auctionName" class="form-label">Auction Name</label>
                            </div>
                            <div class="col-sm-9">
                                <input type="text" id="auctionName" name="auctionName" class="form-control"
                                       pattern="^[A-Z][a-zA-Z]*(\s[a-zA-Z]+)*$" required
                                       title="First letter must be capitalized, only letters allowed">
                            </div>
                        </div>
                        <hr>
                        <!-- Поле выбора даты и времени начала аукциона -->
                        <div class="row">
                            <div class="col-sm-3">
                                <label for="auctionStart" class="form-label">Auction Start (Date & Time)</label>
                            </div>
                            <div class="col-sm-9">
                                <input type="datetime-local" id="auctionStart" name="auctionStart" class="form-control"
                                       required title="Select auction start time">
                            </div>
                        </div>
                        <hr>
                        <!-- Поле выбора даты и времени окончания аукциона -->
                        <div class="row">
                            <div class="col-sm-3">
                                <label for="auctionEnd" class="form-label">Auction End (Date & Time)</label>
                            </div>
                            <div class="col-sm-9">
                                <input type="datetime-local" id="auctionEnd" name="auctionEnd" class="form-control"
                                       required title="Select auction end time">
                            </div>
                        </div>
                        <hr>
                        <!-- Выпадающий список с продуктами -->
                        <div class="row">
                            <div class="col-sm-3">
                                <label class="form-label">Product</label>
                            </div>
                            <div class="col-sm-9">
                                <img src="${product.productPic}" alt="Product Image" class="product-image mb-3 image">
                                <h5>${product.productName}</h5>
                                <p><strong>Price:</strong> ${product.productPrice}</p>
                                <p><strong>Category:</strong> ${product.category.categoryName}</p>
                                <p><strong>Info:</strong> ${product.productInfo}</p>
                                <input type="hidden" name="productID" value="${product.productId}">
                            </div>
                        </div>
                        <hr>
                        <!-- Кнопка для создания аукциона -->
                        <div class="row">
                            <div class="col-sm-12">
                                <button type="submit" class="btn btn-primary">Create Auction</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </div>
</form>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
