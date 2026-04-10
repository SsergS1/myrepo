<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Auction</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    <style>
        .error-message {
            text-align: center;
            margin-top: 50px;
        }
    </style>
</head>
<body style="background-color: #eee">
<div class="container">
    <div class="row">
        <div class="col-md-6 offset-md-3">
            <div class="error-message">
                <h1>Your bid amount is lower than the starting price of the auction.</h1>
                <a>Please go back and enter a bid amount greater than or equal to the starting price.</a>
                <a href="auction?id=${param.id}" class="btn btn-primary">Go Back to Auction</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>