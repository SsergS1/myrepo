<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    <style>
        .product-image {
            width: 50px;
            height: 50px;
            object-fit: cover;
        }
        .order-button {
            float: right;
            margin-top: 10px;
            padding: 10px 20px;
        }
    </style>
</head>
<body style="background-color: #eee">
<div class="container mt-5">
    <h1>Order Details</h1>
    <p>Name: <c:out value="${sessionScope.userName}"/> <c:out value="${sessionScope.userLN}"/></p>
    <form action="SubmitOrderServlet" method="post">
        <div class="form-group">
            <label for="orderAddress">Shipping Address:</label>
            <input type="text" class="form-control" id="orderAddress" name="orderAddress" placeholder="City, Street 123"
                   pattern="^[A-Z][a-z]+(?:\s[A-Z][a-z]+)*,\s[A-Z][a-z]+(?:\s[A-Z][a-z]+)*\s\d+$" title="Address format: City, Street 123" required>
        </div>
        <table class="table table-bordered mt-3" style="border-color: #ababab">
            <thead>
            <tr>
                <th>Product Image</th>
                <th>Product Name</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Subtotal</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="item" items="${bucketItems}">
                <tr>
                    <td><img src="${item.product.productPic}" alt="${item.product.productName}" class="product-image"></td>
                    <td>${item.product.productName}</td>
                    <td><fmt:formatNumber value="${item.product.productPrice}" type="currency" currencySymbol=""/></td>
                    <td>${item.quantity}</td>
                    <td><fmt:formatNumber value="${item.product.productPrice * item.quantity}" type="currency" currencySymbol=""/></td>
                </tr>
            </c:forEach>
            <tr>
                <td colspan="4" style="font-weight: bold;">Delivery payment:</td>
                <td style="font-weight: bold;">20.00</td>
            </tr>
            <tr>
                <td colspan="4" style="font-weight: bold;">Total:</td>
                <td style="font-weight: bold;">
                    <c:set var="totalWithDelivery" value="${totalPrice + 20}"/>
                    <fmt:formatNumber value="${totalWithDelivery}" type="currency" currencySymbol=""/>
                </td>
            </tr>
            </tbody>
        </table>
        <input type="hidden" name="totalPrice" value="${totalWithDelivery}">
        <button type="submit" class="btn btn-primary order-button">Submit Order</button>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe"
        crossorigin="anonymous"></script>
</body>
</html>
