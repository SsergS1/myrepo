<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Edit information</title>
</head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<style>
    .breadcrumb a {
        text-decoration: none;
    }
</style>
<body style="background-color: #eee">
<form id="profileForm" action="update" method="post">
    <div class="container py-5">
        <div class="row">
            <div class="col">
                <nav aria-label="breadcrumb" class="bg-light rounded-3 p-3 mb-4">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="main_page.jsp">Home</a></li>
                        <li class="breadcrumb-item active"><a href="Profile.jsp">User Profile</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Edit information</li>
                    </ol>
                </nav>
            </div>
        </div>
        <input type="hidden" id="userId" name="userId" value="<c:out value='${sessionScope.userId}' />">
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
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger" role="alert">
                                    ${errorMessage}
                            </div>
                        </c:if>
                        <div class="row">
                            <div class="col-sm-3">
                                <label for="userName" class="form-label">Name</label>
                            </div>
                            <div class="col-sm-9">
                                <input type="text" name="user_Name" id="userName" class="form-control"  value="<c:out value='${sessionScope.userName}' />"
                                       pattern="[A-Z][a-zA-Z]{0,14}" title="Name must start with a capital letter and have a maximum length of 15 characters.">
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-sm-3">
                                <label for="userLn" class="form-label">Surname</label>
                            </div>
                            <div class="col-sm-9">
                                <input type="text" name="user_Ln" id="userLn" class="form-control" value="<c:out value='${sessionScope.userLN}' />"
                                       pattern="[A-Z][a-zA-Z]{0,14}" title="Surname must start with a capital letter and have a maximum length of 15 characters.">
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-sm-3">
                                <label for="userEmail" class="form-label">Email</label>
                            </div>
                            <div class="col-sm-9">
                                <input type="text" name="user_email" id="userEmail" class="form-control" value="<c:out value='${sessionScope.userEmail}' />"
                                       pattern="[^@\s]+@[^@\s]+\.[a-zA-Z]{2,}" title="Please enter a valid email address.">
                            </div>
                        </div>
                        <hr>
                        <c:if test="${sessionScope.userRole == 'Seller'}">
                            <div class="row">
                                <div class="col-sm-3">
                                    <label for="userInfo" class="form-label">Your Information</label>
                                </div>
                                <div class="col-sm-9">
                                    <textarea name="user_info" id="userInfo" class="form-control" rows="4"><c:out value='${sessionScope.userInfo}' /></textarea>
                                </div>
                            </div>
                        </c:if>
                        <div class="row">
                            <div class="col-sm-12">
                                <button type="submit" class="btn btn-primary">Save changes</button>
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
</body>
</html>
