<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Auction purchases</title>
    <style>
        .product-list li {
            margin-bottom: 10px;
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

        .purchased-items-container {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
            max-height: 400px;
            overflow-y: auto;
        }

        .purchased-item-card {
            margin-bottom: 20px;
        }

        .breadcrumb a {
            text-decoration: none;
        }
        .card-title:hover {
            color: #224d99;
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
                        <li class="breadcrumb-item active" aria-current="page">Auction purchases</li>
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
                <!-- Purchased Items -->
                <h1 class="mb-4">Won items in auctions</h1>
                <div class="purchased-items-container">
                    <div class="row">
                        <c:forEach var="auction" items="${auctions}">
                            <div class="col-md-4">
                                <div class="card mb-4 purchased-item-card" style="border-color: #ababab">
                                    <img src="${auction.product.productPic}" class="product-image" alt="Product Image">
                                    <div class="card-body">
                                        <div>
                                            <a href="productDetails?productId=${auction.product.productId}&source=purchasedItems"
                                               style="font-weight: bold; text-decoration: none; color: black;">
                                                <h5 class="card-title">${auction.product.productName}</h5>
                                            </a>
                                        </div>

                                        <p class="card-text">Price:${winningBids[auction.auctionId]}</p>

                                        <p class="card-text">Wining bid: ${auctionLastBidTimes[auction.auctionId]}</p>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>
</body>
</html>
