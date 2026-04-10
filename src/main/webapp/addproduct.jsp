<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Add Product</title>
</head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
<style>
    .breadcrumb a {
        text-decoration: none;
    }
    #imagePreview {
        max-width: 200px;
        max-height: 200px;
        margin-top: 10px;
    }
</style>
<body style="background-color: #eee">
<form action="addproduct" method="post">
    <div class="container py-5">
        <div class="row">
            <div class="col">
                <nav aria-label="breadcrumb" class="bg-light rounded-3 p-3 mb-4">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="main_page.jsp">Home</a></li>
                        <li class="breadcrumb-item active"><a href="Profile.jsp">User Profile</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Add Product</li>
                    </ol>
                </nav>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-4">
                <div class="card mb-4">
                    <div class="card-body text-center">
                        <img src="https://www.pngmart.com/files/21/Account-Avatar-Profile-PNG-Photo.png" alt="avatar" class="rounded-circle img-fluid" style="width: 150px;">
                        <h5 class="my-3"> <c:out value="${sessionScope.userName}"/>  <c:out value="${sessionScope.userLN}" /></h5>
                    </div>
                </div>

                <div style="display: flex;">
                </div>
            </div>
            <div class="col-lg-8 mb-4">
                <div class="card mb-4">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-sm-3">
                                <label for="productName" class="form-label">Product Name</label>
                            </div>
                            <div class="col-sm-9">
                                <input type="text" id="productName" name="productName" class="form-control" title="Start with uppercase"
                                       pattern="[A-Z0-9][a-zA-Z0-9\s]*" required>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-sm-3">
                                <label for="productImage" class="form-label">Product Image URL</label>
                            </div>
                            <div class="col-sm-9">
                                <input type="text" id="productImage" name="productImage" class="form-control" title="Start with http:// or https://"
                                       pattern="(http:\/\/|https:\/\/).*" required>
                                <img id="imagePreview" src="" alt="Product Image Preview" style="display: none;">
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-sm-3">
                                <label for="productPrice" class="form-label">Product Price</label>
                            </div>
                            <div class="col-sm-9">
                                <input type="text" id="productPrice" name="productPrice" class="form-control" title="Example:49.99"
                                       pattern="\d{1,3}\.\d{2}" required>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-sm-3">
                                <label for="productInfo" class="form-label">Product Information</label>
                            </div>
                            <div class="col-sm-9">
                                <textarea id="productInfo" name="productInfo" class="form-control" rows="4"></textarea>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-sm-3">
                                <label for="productCategory" class="form-label">Product Category</label>
                            </div>
                            <div class="col-sm-9">
                                <select id="productCategory" name="productCategory" class="form-select">
                                    <c:forEach var="category" items="${categories}">
                                        <option value="${category.categoryId}">${category.categoryName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-12">
                                <button type="submit" class="btn btn-primary">Add to Marketplace</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        $('#productImage').on('input', function() {
            var imageUrl = $(this).val();
            var $preview = $('#imagePreview');
            if (imageUrl) {
                $preview.attr('src', imageUrl);
                $preview.on('load', function() {
                    $(this).show();
                }).on('error', function() {
                    $(this).hide();
                });
            } else {
                $preview.hide();
            }
        });
    });
</script>
</body>
</html>
