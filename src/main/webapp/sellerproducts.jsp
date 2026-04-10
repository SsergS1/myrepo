<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Seller Products</title>
    <style>
        .product-list {
            list-style-type: none;
            padding: 0;
        }

        .product-list li {
            margin-bottom: 10px;
        }

        .product-card {
            border: 1px solid #ddd;
            padding: 10px;
            background-color: #f9f9f9;
            display: flex;
        }

        .product-card img {
            width: 100px;
            margin-left: 20px;
        }

        .product-card .product-details {
            flex-grow: 1;
        }

        .product-card h3 {
            margin-top: 0;
        }

        .product-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
        }

        .breadcrumb a {
            text-decoration: none;
        }

        .product-container {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .product-actions {
            margin-right: 20px;
        }

        .product-actions a {
            margin-left: 10px;
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
                        <li class="breadcrumb-item"><a href="profile?userId=${sessionScope.userId}">User Profile</a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page">My product</li>
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
                <h2>Your Products</h2>
                <ul class="product-list">
                    <c:forEach var="product" items="${products}">
                        <li>
                            <div class="product-card">
                                <div class="product-details">
                                    <div class="product-container">
                                        <h3>${product.productName}</h3>
                                        <div class="product-actions">
                                            <a href="editProduct?productId=${product.productId}" title="Edit Product">
                                                <i class="fa fa-pencil"></i>
                                            </a>
                                            <a href="#" onclick="confirmDelete(${product.productId})"
                                               title="Delete Product" style="margin-left: 20px">
                                                <i class="fa fa-times" style="color: red"></i>
                                            </a>
                                        </div>
                                    </div>
                                    <p>Price: ${product.productPrice}</p>
                                    <p>Info: ${product.productInfo}</p>
                                    <p>Category: ${product.category.categoryName}</p>
                                    <p>Status:
                                        <c:choose>
                                            <c:when test="${product.approved}">
                                                <span style="color: green; font-weight: bold;">Approved</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: red; font-weight: bold;">Not Approved</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                    <c:choose>
                                        <c:when test="${product.approved}">
                                            <c:choose>
                                                <c:when test="${product.ordered}">
                                                    <span style="color: blue; font-weight: bold;">SOLD</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:choose>
                                                        <c:when test="${product.auctionRequestStatus == 'REJECT'}">
                                                            <a href="#" onclick="confirmSendToAuction(${product.productId})" class="btn btn-primary">Send to auction</a>
                                                        </c:when>
                                                        <c:when test="${product.auctionRequestStatus == 'PENDING'}">
                                                            <a>Auction Status: </a><span style="color: orange; font-weight: bold;">Pending</span>
                                                        </c:when>
                                                        <c:when test="${product.auctionRequestStatus == 'ON_THE_AUCTION'}">
                                                            <a>Auction Status: </a><span style="color: green; font-weight: bold;">On the Auction</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="#" onclick="confirmSendToAuction(${product.productId})" class="btn btn-primary">Send to auction</a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                    </c:choose>
                                </div>
                                <img class="product-image" src="${product.productPic}" alt="Product Image">
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </div>
    </div>
</form>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    function confirmDelete(productId) {
        if (confirm("Are you sure you want to do this?")) {
            window.location.href = "deleteProduct?productId=" + productId;
        }
    }

    function confirmSendToAuction(productId) {
        if (confirm("Do you want to send this product to auction?")) {
            $.ajax({
                url: 'sendAuctionRequest',
                type: 'GET',
                data: {productId: productId},
                success: function (response) {
                    location.reload();
                    alert("Auction request sent successfully!");
                },
                error: function (xhr, status, error) {
                    alert("Error sending auction request: " + xhr.responseText);
                }
            });
        }
    }
</script>
</body>
</html>
