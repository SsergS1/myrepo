<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Product Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .navbar {
            background-color: #224d99;
        }

        .navbar-light .navbar-nav .nav-link {
            color: white;
        }

        .navbar-brand {
            font-weight: bold;
            color: white !important;
        }

        .product-details {
            display: flex;
            align-items: flex-start;
            justify-content: center;
            flex-wrap: wrap;
        }

        .product-image-large {
            width: 100%;
            max-width: 300px;
            height: auto;
            object-fit: cover;
        }

        .product-info {
            flex: 1;
            padding-left: 30px;
        }

        .info-header {
            margin-top: 30px;
            font-size: 1.5rem;
            font-weight: bold;
        }

        .info-content {
            margin-top: 15px;
        }
    </style>
</head>
<nav class="navbar navbar-expand-lg navbar-light sticky-top mt-0">
    <div class="container">
        <a class="navbar-brand" href="marketplace">Artplace</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item dropdown">
                    <c:choose>
                        <c:when test="${sessionScope.userName != null && sessionScope.userLN != null}">
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
                               data-toggle="dropdown"
                               aria-haspopup="true" aria-expanded="false">
                                <i class="fa fa-user-circle" aria-hidden="true"></i>
                            </a>
                            <div class="dropdown-menu dropdown-menu-right" aria-labelledby="userDropdown">
                                <a class="dropdown-item">User: ${sessionScope.userName}</a>
                                <a class="dropdown-item" href="Profile.jsp">Profile</a>
                                <a class="dropdown-item" href="LogoutServlet">Sign out</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a class="nav-link" href="login.jsp">Sign in</a>
                        </c:otherwise>
                    </c:choose>
                </li>
            </ul>
        </div>
    </div>
</nav>
<body style="background-color: #eee">
<div class="container my-5">
    <div class="product-details">
        <img src="${product.productPic}" class="product-image-large" alt="Product Image">
        <div class="product-info">
            <h2>${product.productName}</h2>
            <p>Price: $${product.productPrice}</p>
            <p>Category: ${product.category.categoryName}</p>
            <div class="info-header">Information about product</div>
            <div class="info-content">
                <p>${product.productInfo}</p>
            </div>
            <div class="info-content">
                <p><a style="font-weight: bold">Seller:</a> ${product.seller.userName} ${product.seller.userLn}</p>
            </div>
            <c:if test="${param.source != 'purchasedItems' && param.source != 'orderList'}">
                <form id="addToCartForm" action="addToCart" method="post">
                    <input type="hidden" name="productId" value="${product.productId}">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-cart-shopping"></i> Add to Cart
                    </button>
                </form>
            </c:if>
        <%-- Back to some pages--%>
            <c:choose>
                <c:when test="${param.source == 'purchasedItems'}">
                    <a href="purchasedItems" class="btn btn-secondary mt-3">Back to Purchased Items</a>
                </c:when>
                <c:when test="${param.source == 'orderList'}">
                    <a href="orderList" class="btn btn-secondary mt-3">Back to Order list</a>
                </c:when>
                <c:otherwise>
                    <a href="marketplace" class="btn btn-secondary mt-3">Back to Marketplace</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe"
        crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
