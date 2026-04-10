<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Orders</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .breadcrumb a {
            text-decoration: none;
        }

        .product-image {
            width: 50px;
            height: 50px;
            object-fit: cover;
            margin-right: 10px;
        }

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
        .product-link {
            font-weight: bold;
            text-decoration: none;
            color: #224d99;
            transition: color 0.3s ease;
        }
        .product-link:hover {
            color: #50afe0;
        }
    </style>
</head>
<body style="background-color: #eee">
<nav class="navbar navbar-expand-lg navbar-light sticky-top mt-0">
    <div class="container">
        <a class="navbar-brand" href="main_page.jsp">Artplace</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fa fa-user-circle" aria-hidden="true"></i> ${sessionScope.userName}
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                        <li><a class="dropdown-item" href="profile?userId=${sessionScope.userId}">Profile</a></li>
                        <li><a class="dropdown-item" href="LogoutServlet">Sign out</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container py-5">
    <div class="row">
        <div class="col">
            <nav aria-label="breadcrumb" class="bg-light rounded-3 p-3 mb-4">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="main_page.jsp">Home</a></li>
                    <li class="breadcrumb-item"><a href="profile?userId=${sessionScope.userId}">User Profile</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Purchased Items</li>
                </ol>
            </nav>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <div class="card mb-4">
                <div class="card-body">
                    <h2 class="mb-4">Orders List</h2>
                    <div class="accordion" id="orderAccordion">
                        <c:forEach var="order" items="${orders}">
                            <div class="accordion-item">
                                <h2 class="accordion-header" id="heading${order.orderId}">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                            data-bs-target="#collapse${order.orderId}" aria-expanded="false"
                                            aria-controls="collapse${order.orderId}">
                                        <div class="d-flex align-items-center">
                                            <c:forEach var="bucketItem" items="${order.bucketItems}">
                                                <img src="${bucketItem.product.productPic}"
                                                     alt="${bucketItem.product.productName}" class="product-image">
                                            </c:forEach>
                                            <div class="ms-3">
                                                <strong>Order ID: ${order.orderId}</strong>
                                            </div>
                                            <div class="ms-3">
                                                <strong>Price: ${order.totalPriceWithDelivery}</strong>
                                            </div>
                                        </div>
                                    </button>
                                </h2>
                                <div id="collapse${order.orderId}" class="accordion-collapse collapse"
                                     aria-labelledby="heading${order.orderId}" data-bs-parent="#orderAccordion">
                                    <div class="accordion-body">
                                        <table class="table table-striped table-hover">
                                            <thead>
                                            <tr>
                                                <th>Products</th>
                                                <th>Address</th>
                                                <th>Date</th>
                                                <th>Total Price (With Delivery)</th>
                                                <th>Status</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <tr>
                                                <td>
                                                    <c:forEach var="bucketItem" items="${order.bucketItems}">
                                                        <div class="d-flex align-items-center mb-2">
                                                            <div>
                                                                <a href="productDetails?productId=${bucketItem.product.productId}&source=orderList"
                                                                   style="font-weight: bold; text-decoration: none; color: black;">
                                                                    <img src="${bucketItem.product.productPic}"
                                                                         alt="${bucketItem.product.productName}"
                                                                         class="product-image">
                                                                </a>
                                                            </div>
                                                            <div>
                                                                <a href="productDetails?productId=${bucketItem.product.productId}&source=orderList"
                                                                   class="product-link"
                                                                   title="Переход на страницу заказов" >
                                                                        ${bucketItem.product.productName}
                                                                </a>
                                                                <br>
                                                                Price: ${bucketItem.product.productPrice}<br>
                                                                Quantity: ${bucketItem.quantity}
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </td>
                                                <td>${order.orderAddress}</td>
                                                <td>${order.formattedOrderDate}</td>
                                                <td>${order.totalPriceWithDelivery}</td>
                                                <td>${order.orderStatus ? 'Paid' : 'Pending'}</td>
                                                <td>
                                                    <c:if test="${!order.orderStatus}">
                                                        <form action="payOrder" method="post">
                                                            <input type="hidden" name="orderId"
                                                                   value="${order.orderId}">
                                                            <button type="submit" class="btn btn-primary btn-sm">Pay
                                                                order
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                </td>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe"
        crossorigin="anonymous"></script>
</body>
</html>
