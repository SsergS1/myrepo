<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Cart</title>
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
        .product-image {
            width: 150px;
            height: 150px;
            object-fit: cover;
        }
        .table th, .table td {
            padding: 0.5rem;
        }
        .order-button {
            float: right;
            margin-top: 10px;
            padding: 10px 20px;
        }
        a {
            text-decoration: none;
            color: inherit;
        }
        a:hover {
            color: #224d99;
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
                       data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <i class="fa fa-user-circle" aria-hidden="true"></i>
                    </a>
                    <div class="dropdown-menu dropdown-menu-right" aria-labelledby="userDropdown">
                        <a class="dropdown-item">User: ${sessionScope.userName}</a>
                        <a class="dropdown-item" href="Profile.jsp">Profile</a>
                        <a class="dropdown-item" href="LogoutServlet">Sign out</a>
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
<div class="container mt-5">
    <h1><c:out value="${sessionScope.userName}"/>'s Cart</h1>
    <table class="table table-bordered mt-3" style="border: #ababab">
        <thead>
        <tr>
            <th style="width: 60%;">Product Name</th>
            <th>Price</th>
            <th>Quantity</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="item" items="${bucketItems}">
            <tr>
                <td>
                    <img src="${item.product.productPic}" alt="${item.product.productName}" class="product-image">
                    <a href="productDetails?productId=${item.product.productId}" style="font-weight: bold">${item.product.productName}</a>
                </td>
                <td>${item.product.productPrice}</td>
                <td>${item.quantity}</td>
                <td>
                    <form action="removeFromCart" method="post" onsubmit="return confirm('Are you sure you want to remove this item?');">
                        <input type="hidden" name="bucketItemId" value="${item.bucketItemId}">
                        <button type="submit" class="btn btn-danger btn-sm"><i class="fas fa-times"></i></button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        <tr>
            <td colspan="2" style="font-weight: bold;">Total:</td>
            <td colspan="2" style="font-weight: bold;">${totalPrice}</td>
        </tr>
        </tbody>
    </table>
    <form action="OrderServlet" method="post">
        <button type="submit" class="btn btn-primary order-button">Order</button>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe"
        crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
