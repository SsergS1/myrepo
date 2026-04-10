<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Auction Requests</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    <style>
        .request-card {
            border: 1px solid #ddd;
            padding: 15px;
            margin-bottom: 20px;
            background-color: #f9f9f9;
        }

        .request-image {
            max-width: 100px;
            max-height: 100px;
            object-fit: cover;
            cursor: pointer;
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
                        <li class="breadcrumb-item"><a href="profile?userId=${sessionScope.userId}">User Profile</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Auction Requests</li>
                    </ol>
                </nav>
            </div>
        </div>
        <div class="container py-5">
            <h1 class="mb-4">Auction Requests</h1>
            <c:forEach var="request" items="${auctionRequests}">
                <div class="request-card">
                    <div class="row">
                        <div class="col-md-2">
                            <img src="${request.product.productPic}" alt="Product Image" class="request-image"
                                 onclick="openImageModal(this.src)"
                                 onerror="this.onerror=null;this.style.display='none'; this.insertAdjacentHTML('afterend', '<div>Image issues</div>');">
                        </div>
                        <div class="col-md-7">
                            <h3>${request.product.productName}</h3>
                            <p><strong>Price:</strong> ${request.product.productPrice}</p>
                            <p><strong>Category:</strong> ${request.product.category.categoryName}</p>
                            <p><strong>Info:</strong> ${request.product.productInfo}</p>
                            <p><strong>Seller:</strong> ${request.user.userEmail}</p>
                        </div>
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}/createAuction?productId=${request.product.productId}" class="btn btn-success mb-2">Go to create</a>
                            <form action="processAuctionRequest" method="post">
                                <a href="rejectAuctionRequest?requestId=${request.requestID}" class="btn btn-danger" onclick="return confirm('Are you sure you want to reject this request?');">Reject</a>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- Modal for fullscreen image -->
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

</form>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
    function openImageModal(imageSrc) {
        document.getElementById('fullScreenImage').src = imageSrc;
        var imageModal = new bootstrap.Modal(document.getElementById('imageModal'));
        imageModal.show();
    }
</script>
</body>
</html>
