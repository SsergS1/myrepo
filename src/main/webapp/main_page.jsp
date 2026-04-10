<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>
<!DOCTYPE html>
<html>
<head>
    <title>Artplace</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <style>
    	body {
        background-color: #F4F4F8; 
    	}
    	
        #header {
            background-image: url(./Main-paint.jpg);
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            border-radius: 0;
            filter: brightness(70%);
        }
        #header-text {
            filter: brightness(100%); /* This counteracts the darkening effect for the text and buttons */
            color: white;
        }

        #header-text {
            filter: brightness(100%);
            color: white;
        }

        section {
            padding-top: 50px;
            padding-bottom: 50px;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #f9f9f9;
            min-width: 160px;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            z-index: 1;
            right: 0; 
         }

        .dropdown-content a {
            color: black;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
        }

        .dropdown:hover .dropdown-content {
            display: block;
            left: -400%;
        }
       .navbar {
        background-color: #224d99;
    	}

    	.navbar-light .navbar-nav .nav-link {
        color: white;
    	}
    	footer {
	    background-color: #E6E6EA;
		}
		.navbar-brand {
        font-weight: bold;
        color: white !important;
    }
        .about-list a {
            color: #007bff;
            text-decoration: none;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light sticky-top mt-0">
    <div class="container">
        <a class="navbar-brand" href="#">Artplace</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <a class="nav-link" href="#section1">About Us</a>
                </li>
<%--                <li class="nav-item dropdown">--%>
<%--                    <a class="nav-link dropdown-toggle" href="#" id="languageDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">--%>
<%--                        <c:choose>--%>
<%--                            <c:when test="${param.lang == 'ua'}">UA</c:when>--%>
<%--                            <c:otherwise>EN</c:otherwise>--%>
<%--                        </c:choose>--%>
<%--                    </a>--%>
<%--                    <div class="dropdown-menu" aria-labelledby="languageDropdown">--%>
<%--                        <!-- Добавляем ссылки для выбора языка -->--%>
<%--                        <c:choose>--%>
<%--                            <c:when test="${param.lang == 'ua'}">--%>
<%--                                <a class="dropdown-item" href="?lang=en">EN</a>--%>
<%--                            </c:when>--%>
<%--                            <c:otherwise>--%>
<%--                                <a class="dropdown-item" href="?lang=ua">UA</a>--%>
<%--                            </c:otherwise>--%>
<%--                        </c:choose>--%>
<%--                    </div>--%>
<%--                </li>--%>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item dropdown">
                    <c:choose>
                        <c:when test="${sessionScope.isLoggedIn}">
                            <!-- Dropdown меню для пользователя -->
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-toggle="dropdown"
                               aria-haspopup="true" aria-expanded="false">
                                <i class="fa fa-user-circle" aria-hidden="true">${sessionScope.userName}</i>
                            </a>
                            <div class="dropdown-menu dropdown-menu-right" aria-labelledby="userDropdown">
                                <input type="hidden" id="userId" name="userId" value="<c:out value='${sessionScope.userId}' />">

                                <a class="dropdown-item" href="profile?userId=${sessionScope.userId}">Profile</a>
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



<header class="bg-dark text-white py-5" id="header">
    <div class="container text-center py-5" id="header-text">
        <h1 class="display-4 text-white">Artplace</h1>
        <p class="lead text-white">Welcome to Artplace, get art today.</p>
        <a href="marketplace" class="btn btn-light text-dark">Market</a>
        <a href="auctions" class="btn btn-light text-dark">Auctions</a>
    </div>
</header>

<div id="logout-message" class="alert alert-warning" style="display: none;">You have successfully logged out!</div>
<c:if test="${sessionScope.loginSuccess}">
    <div id="login-message" class="alert alert-success">
        You have successfully logged in!
    </div>
    <script>
        setTimeout(function() {
            document.getElementById("login-message").style.display = "none";
        }, 5000);
    </script>
    <% session.removeAttribute("loginSuccess"); %>
</c:if>
<div id="login-message" class="alert alert-success" style="display: none;">You have successfully logged in!</div>

<section id="section1">
    <div class="container">
        <h2 class="mb-4">About Us</h2>
        <p style="font-family: Arial, sans-serif; font-size: 16px; line-height: 1.6; color: #333;">Welcome to our Marketplace of Fine Art, where creativity meets commerce. We are a platform dedicated to connecting art lovers with talented artists from around the world. Whether you're an avid collector, a budding enthusiast, or an artist seeking to showcase your work, we provide a vibrant space for exploration and appreciation of artistic expression.
            <br>
            At our marketplace, we believe in the power of art to inspire, provoke thought, and enrich lives. Our mission is to make the world of fine art accessible to all, fostering a community where creativity thrives and artists are celebrated for their unique visions.
            <br>
            With a curated selection of artworks spanning various styles, mediums, and genres, we strive to cater to diverse tastes and preferences. From traditional paintings to contemporary sculptures, from established masters to emerging talents, there's something for everyone to discover and cherish.
        </p>

    </div>
</section>


<section id="section2">
    <div class="container">
        <h2 class="mb-4">Why you should choose Us</h2>
        <ul class="about-list">
            <li style="font-family: Arial, sans-serif; font-size: 16px; line-height: 1.6; color: #333;">Diverse Selection: Explore a curated range of styles and mediums.</li>
            <li style="font-family: Arial, sans-serif; font-size: 16px; line-height: 1.6; color: #333;">Quality Assurance: Rigorous screening for authenticity and excellence.</li>
            <li style="font-family: Arial, sans-serif; font-size: 16px; line-height: 1.6; color: #333;">Support for Artists: A platform for artists to showcase their talents.</li>
            <li style="font-family: Arial, sans-serif; font-size: 16px; line-height: 1.6; color: #333;">Convenient Transactions: User-friendly tools and secure payments.</li>
            <li style="font-family: Arial, sans-serif; font-size: 16px; line-height: 1.6; color: #333;">Personalized Experience: Tailored assistance for a satisfying journey.</li>
        </ul>
    </div>
</section>

<footer class="py-5">
    <div class="container text-center">
        <h4>Contact Us</h4>
        <p>123 Main Street, Massachusetts, USA</p>
        <p>Email: info@artplace.com</p>
        <p>Phone: +1 123-456-7890</p>
    </div>
</footer>
<c:if test="${sessionScope.signed_in == 1}">
    <script>
            document.getElementById("login-message").style.display = "block";
            setTimeout(function() {
                document.getElementById("login-message").style.display = "none";
            }, 5000);
    </script>
    <% session.setAttribute("signed_in", 0); %>
</c:if>
<c:if test="${not empty logoutMessage}">
    <script>
        document.getElementById("logout-message").style.display = "block";
        setTimeout(function() {
            document.getElementById("logout-message").style.display = "none";
        }, 5000);
    </script>
</c:if>

	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
	</body>
</html>
