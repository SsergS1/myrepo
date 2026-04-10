<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Marketplace</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
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

        .product-container {
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

        .cart-dropdown {
            position: absolute;
            top: 100%;
            right: 0;
            width: 200px;
            background-color: #fff;
            border: 1px solid #ccc;
            border-top: none;
            display: none;
            z-index: 999;
        }

        .cart-dropdown.active {
            display: block;
        }
    </style>
</head>
<nav class="navbar navbar-expand-lg navbar-light sticky-top mt-0">
    <div class="container">
        <a class="navbar-brand" href="main_page.jsp">Artplace</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <%--Bucket--%>
        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link cart-button" href="my-bucket">
                    <i class="fas fa-shopping-cart"></i>
                </a>
            </li>
        </ul>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item dropdown">
                    <c:choose>
                        <c:when test="${sessionScope.userName != null && sessionScope.userLN != null}">
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
                               data-bs-toggle="dropdown" aria-expanded="false">
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
<div id="sidebar">
    <h3 style="margin-bottom: 20px;">Filters</h3>
    <form id="filterForm" action="marketplace" method="get">
        <div class="mb-3">
            <input type="text" id="searchInput" name="searchQuery" class="form-control" placeholder="Search products..."
                   value="${param.searchQuery}">
        </div>
        <div class="mb-3">
            <select id="categorySelect" name="category" class="form-select">
                <option value="">All category</option>
                <c:forEach var="category" items="${categories}">
                    <option value="${category.categoryId}" ${param.category == category.categoryId ? 'selected' : ''}>${category.categoryName}</option>
                </c:forEach>
            </select>
        </div>
        <div class="mb-3">
            <select id="priceOrderSelect" name="priceOrder" class="form-select">
                <option value="">Price</option>
                <option value="asc" ${param.priceOrder == 'asc' ? 'selected' : ''}>Price: Low to High</option>
                <option value="desc" ${param.priceOrder == 'desc' ? 'selected' : ''}>Price: High to Low</option>
            </select>
        </div>
        <button type="submit" class="btn btn-primary w-100">Search</button>
    </form>
</div>
<div class="container my-5">
    <div class="row" id="productContainer">
        <c:forEach var="product" items="${products}">
            <div class="col-md-4 product-item" data-category="${product.category.categoryName}">
                <div class="product-container" style="border-color: #ababab">
                    <img src="${product.productPic}" class="product-image" alt="Product Image">
                    <h6 class="mt-2 product-name">${product.productName}</h6>
                    <p class="mb-2">Price: ${product.productPrice}</p>
                    <p class="mb-2">Category: ${product.category.categoryName}</p>
                    <a href="productDetails?productId=${product.productId}" class="btn btn-primary btn-sm">Product
                        Page</a>
                    <br>
                    <br>
                    <form id="addToCartForm" action="addToCart" method="post">
                        <input type="hidden" name="productId" value="${product.productId}">
                        <button type="submit">
                            <i class="fas fa-cart-plus"></i> Add to Cart
                        </button>
                    </form>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
<script>
    document.getElementById('filterForm').addEventListener('submit', function (event) {
        event.preventDefault();

        // Получаем значения фильтров
        var category = document.getElementById('categorySelect').value;
        var priceOrder = document.getElementById('priceOrderSelect').value;
        var searchQuery = document.getElementById('searchInput').value;

        // Генерируем URL с фильтрами
        var url = 'marketplace?';
        if (category) {
            url += 'category=' + category + '&';
        }
        if (priceOrder) {
            url += 'priceOrder=' + priceOrder + '&';
        }
        if (searchQuery) {
            url += 'searchQuery=' + encodeURIComponent(searchQuery) + '&';
        }

        // Переход на URL с фильтрами
        window.location.href = url;
    });

    // Функция для обновления URL и отправки формы
    function applyFilters() {
        var category = document.getElementById('categorySelect').value;
        var priceOrder = document.getElementById('priceOrderSelect').value;
        var searchQuery = document.getElementById('searchInput').value;

        var url = 'marketplace?';
        if (category) {
            url += 'category=' + category + '&';
        }
        if (priceOrder) {
            url += 'priceOrder=' + priceOrder + '&';
        }
        if (searchQuery) {
            url += 'searchQuery=' + encodeURIComponent(searchQuery) + '&';
        }

        window.location.href = url;
    }

    // Обработчик события для отправки формы
    document.getElementById('filterForm').addEventListener('submit', function (event) {
        event.preventDefault();
        applyFilters();
    });

    // Устанавливаем значения фильтров из URL при загрузке страницы
    window.addEventListener('load', function () {
        var urlParams = new URLSearchParams(window.location.search);
        document.getElementById('categorySelect').value = urlParams.get('category') || '';
        document.getElementById('priceOrderSelect').value = urlParams.get('priceOrder') || '';
        document.getElementById('searchInput').value = urlParams.get('searchQuery') || '';
    });
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe"
        crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.7/dist/umd/popper.min.js"
        integrity="sha384-oBqDVmMz4fnFO9gybBogGzC5VDE5P9ZP4l26J7CjTBiKvdIe0P7FSCzBiq7UU4We"
        crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.min.js"
        integrity="sha384-QFJW2Atv8U6l1Wexs+62th60YVqVJp7rLHpSRF0i14BTvGKNJRd8p3mo6K5c1vdz"
        crossorigin="anonymous"></script>
</body>
</html>
