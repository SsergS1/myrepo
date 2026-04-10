<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Orders</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <style>

        .breadcrumb a {
            text-decoration: none;
        }
    </style>
</head>
<body style="background-color: #eee">
<form>
    <div class="container py-5">
        <div class="row">
            <div class="col">
                <nav aria-label="breadcrumb" class="bg-light rounded-3 p-3 mb-4">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="main_page.jsp">Home</a></li>
                        <li class="breadcrumb-item"><a href="profile?userId=${sessionScope.userId}">User Profile</a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page">Purchased Items</li>
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
                        <h5 class="my-3"><c:out value="${sessionScope.userName}"/> <c:out
                                value="${sessionScope.userLN}"/></h5>
                    </div>
                </div>
            </div>
            <div class="col-lg-8">
                <div class="container">
                    <h1>My Orders</h1>
                    <table class="table table-striped">
                        <thead>
                        <tr>
                            <th>№Order</th>
                            <th>Product(s) in Order</th>
                            <th>Order Address</th>
                            <th>Order Date</th>
                            <th>Order Status</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="order" items="${orders}">
                            <tr>
                                <td>${order.orderId}</td>
                                <td>
                                        ${order.bucket.product.productName} (${order.bucket.product.productPrice})
                                    <br>
                                </td>
                                <td>${order.orderAddress}</td>
                                <td>${order.formattedOrderDate}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${order.orderStatus}">
                                            Completed
                                        </c:when>
                                        <c:otherwise>
                                            Pending
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <c:if test="${!order.orderStatus}">
                                    <td>
                                        <form action="payOrder" method="post">
                                            <input type="hidden" name="orderId" value="${order.orderId}">
                                            <button type="submit" class="btn btn-primary">Pay Order</button>
                                        </form>
                                    </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>

                </div>
            </div>
        </div>
    </div>
</form>
</body>
</html>