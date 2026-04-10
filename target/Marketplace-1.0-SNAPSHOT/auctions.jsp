<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Auctions</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
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
        #sidebar {
            position: fixed;
            top: 60px; /* Высота вашего навбара */
            left: 0;
            height: calc(100vh - 60px); /* Высота вашего навбара */
            width: 250px;
            background-color: #f8f9fa;
            padding: 20px;
            overflow-y: auto;
        }
        .auction-container {
            width: 220px;
            height: auto;
            border: 1px solid #ccc;
            border-radius: 5px;
            padding: 10px;
            margin-bottom: 20px;
        }

        .product-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }
        .auction-container {
            position: relative;
            width: 220px;
            height: auto;
            border: 1px solid #ccc;
            border-radius: 5px;
            padding: 10px;
            margin-bottom: 20px;
        }

        .product-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        .ended-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: calc(100% - 40px); /* Оставляем место для кнопки */
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
            font-size: 24px;
            font-weight: bold;
        }
    </style>
</head>
<nav class="navbar navbar-expand-lg navbar-light sticky-top mt-0">
    <div class="container">
        <a class="navbar-brand" href="main_page.jsp">Artplace</a>
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
                                <i class="fa fa-user-circle" aria-hidden="true"> ${sessionScope.userName}</i>
                            </a>
                            <div class="dropdown-menu dropdown-menu-right" aria-labelledby="userDropdown">

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
    <!-- Filter Options -->
    <div id="sidebar">
        <h3>Filters</h3>
        <form method="GET" action="auctions">
            <div class="col-md-10">
                <label for="category">Category</label>
                <select name="category" id="category" class="form-control">
                    <option value="">All</option>
                    <c:forEach var="category" items="${categories}">
                        <option value="${category.categoryId}" ${category.categoryId == selectedCategory ? 'selected' : ''}>${category.categoryName}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-10">
                <label for="priceOrder">Price Order</label>
                <select name="priceOrder" id="priceOrder" class="form-control">
                    <option value="">Price</option>
                    <option value="asc" ${selectedPriceOrder == 'asc' ? 'selected' : ''}>Low to High</option>
                    <option value="desc" ${selectedPriceOrder == 'desc' ? 'selected' : ''}>High to Low</option>
                </select>
            </div>
            <div class="col-md-10">
                <label for="status">Status</label>
                <select name="status" id="status" class="form-control">
                    <option value="">All</option>
                    <option value="Pending" ${selectedStatus == 'Upcoming' ? 'selected' : ''}>Upcoming</option>
                    <option value="Active" ${selectedStatus == 'Active' ? 'selected' : ''}>Active</option>
                    <option value="End" ${selectedStatus == 'Ended' ? 'selected' : ''}>Ended</option>
                </select>
            </div>
            <div class="col-md-1 d-flex align-items-end" style="margin-top: 10px;">
                <button type="submit" class="btn btn-primary btn-block">Search</button>
            </div>
        </form>
    </div>

    <div class="row">
        <c:choose>
            <c:when test="${not empty auctions}">
                <c:forEach var="auction" items="${auctions}">
                    <div class="col-md-3">
                        <div class="auction-container" style="border-color: #ababab">
                            <img src="${auction.product.productPic}" class="product-image" alt="Product Image">
                            <h6 class="mt-2">${auction.auctionName}</h6>
                            <p class="mb-2">Start price: ${auction.product.productPrice}</p>
                            <p class="mb-2">Starts: ${auction.formattedStartTime}</p>
                            <p class="mb-2">Ends: ${auction.formattedEndTime}</p>
                            <c:choose>
                                <c:when test="${auction.ended}">
                                    <div class="ended-overlay">Ended</div>
                                    <a href="auction?id=${auction.auctionId}" class="btn btn-secondary btn-sm mt-2">Check the bids</a>
                                </c:when>
                                <c:when test="${auction.notStarted}">
                                    <a href="auction?id=${auction.auctionId}" class="btn btn-info btn-sm">View details</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="auction?id=${auction.auctionId}" class="btn btn-primary btn-sm">Go to auction</a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="col-12">
                    <h1 style="text-align: center">Sorry, there are no auctions at the moment</h1>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe"
        crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
