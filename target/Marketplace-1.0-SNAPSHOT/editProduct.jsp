<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Product</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        #imagePreview {
            max-width: 200px;
            max-height: 200px;
            margin-top: 10px;
        }

        .breadcrumb a {
            text-decoration: none;
        }
    </style>
</head>
<body style="background-color: #eee;">
<div class="container py-5">
    <div class="row">
        <div class="col">
            <nav aria-label="breadcrumb" class="bg-light rounded-3 p-3 mb-4">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="main_page.jsp">Home</a></li>
                    <li class="breadcrumb-item"><a href="profile?userId=${sessionScope.userId}">User Profile</a></li>
                    <li class="breadcrumb-item"><a href="listproduct">My Product</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Edit Product</li>
                </ol>
            </nav>
        </div>
    </div>
    <div class="container mt-5">
        <h2>Edit Product</h2>
        <form action="editProduct" method="post">
            <input type="hidden" name="productId" value="${product.productId}">
            <div class="mb-3">
                <label for="productName" class="form-label">Product Name</label>
                <input type="text" class="form-control" id="productName" name="productName"
                       value="${product.productName}"
                       required>
            </div>
            <div class="mb-3">
                <label for="productPrice" class="form-label">Price</label>
                <input type="number" step="0.01" class="form-control" id="productPrice" name="productPrice"
                       value="${product.productPrice}" required>
            </div>
            <div class="mb-3">
                <label for="productInfo" class="form-label">Product Info</label>
                <textarea class="form-control" id="productInfo" name="productInfo" rows="3"
                          required>${product.productInfo}</textarea>
            </div>
            <div class="mb-3">
                <label for="productPic" class="form-label">Product Image URL</label>
                <input type="url" class="form-control" id="productPic" name="productPic" value="${product.productPic}"
                       required>
                <img id="imagePreview" src="${product.productPic}" alt="Product Image Preview"
                     onerror="this.style.display='none'">
            </div>
            <div class="alert alert-info" role="alert">
                Attention! After changes are made, the product will be sent for re-approval by the administrator.
            </div>
            <button type="submit" class="btn btn-primary">Save Changes</button>
            <a href="listproduct" class="btn btn-secondary">Cancel</a>
        </form>
    </div>
</div>
<script>
    $(document).ready(function () {
        $('#productPic').on('input', function () {
            var imageUrl = $(this).val();
            var $preview = $('#imagePreview');
            if (imageUrl) {
                $preview.attr('src', imageUrl);
                $preview.on('load', function () {
                    $(this).show();
                }).on('error', function () {
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