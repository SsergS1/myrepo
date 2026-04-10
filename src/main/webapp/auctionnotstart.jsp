<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Auction</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
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
        body {
            font-family: 'Montserrat', sans-serif;
            text-align: center;
            margin-top: 20vh; /* Центрируем по вертикали */
        }
        h1 {
            font-weight: 700;
            font-size: 24px;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        .btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body style="background-color: #eee">
<h1>The auction hasn’t started yet, or is over, please select another auction.</h1>
<a href="auctions" class="btn">Select another auction</a>
</body>
</html>
