<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Approve Products</title>
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
        .breadcrumb a {
            text-decoration: none;
        }
        .modal-fullscreen .modal-content {
            height: 100%;
            border: 0;
            border-radius: 0;
            background-color: transparent;
        }
        .modal-fullscreen .modal-body {
            overflow-y: auto;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .modal-fullscreen img {
            max-width: 100%;
            max-height: 100vh;
            object-fit: contain;
        }
        .modal-backdrop.show {
            opacity: 0.8;
            background-color: rgba(128, 128, 128, 0.5);
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
                        <li class="breadcrumb-item active" aria-current="page">Approved products</li>
                    </ol>
                </nav>
            </div>
        </div>
        <div class="container py-5">
            <h1 class="mb-4">Approve Products</h1>
            <table class="table">
                <thead>
                <tr>
                    <th>Product Name</th>
                    <th>Product Image</th>
                    <th>Product Price</th>
                    <th>Product Info</th>
                    <th>Seller</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="product" items="${products}">
                    <tr>
                        <td><c:out value="${product.productName}"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty product.productPic}">
                                    <img src="<c:out value='${product.productPic}' />" alt="Product Image"
                                         style="max-width: 100px; max-height: 100px; cursor: pointer;"
                                         onclick="openImageModal(this.src)"
                                         onerror="this.onerror=null;this.style.display='none'; this.insertAdjacentHTML('afterend', '<div>Image issues</div>');">
                                </c:when>
                                <c:otherwise>
                                    <div><a style="color: red">Image not exist</a></div>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td><c:out value="${product.productPrice}"/></td>
                        <td><c:out value="${product.productInfo}"/></td>
                        <td><c:out value="${product.seller.userEmail}"/></td>
                        <td>
                            <a href="approve?productId=<c:out value="${product.productId}" />"
                               class="btn btn-success">Approve</a>
                            <a href="reject?productId=<c:out value="${product.productId}" />" class="btn btn-danger"
                               onclick="return confirmation()">Reject</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
        <!-- Модальное окно для полноэкранного просмотра -->
        <div class="modal fade modal-fullscreen" id="imageModal" tabindex="-1" aria-labelledby="imageModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-fullscreen">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <img id="fullScreenImage" src="" alt="Full Screen Image">
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe"
                crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script type="text/javascript">
            function confirmation() {
                return confirm('Are you sure you want to do this?');
            }

            function openImageModal(imageSrc) {
                document.getElementById('fullScreenImage').src = imageSrc;
                var imageModal = new bootstrap.Modal(document.getElementById('imageModal'));
                imageModal.show();
            }
        </script>
    </div>
</form>
</body>
</html>
