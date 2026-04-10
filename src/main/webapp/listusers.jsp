<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>List of users</title>
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

        .role-label p {
            display: inline;
            margin: 0;
            padding: 0;
        }

        .hidden {
            display: none;
        }

        .btn-transparent {
            background-color: transparent;
            border: none;
            color: #000;
            font-weight: bold;
            margin-right: 5px;
        }

        .btn-transparent:focus, .btn-transparent.active {
            border-bottom: 3px solid blue;
            background-color: #c7c7c7;
        }

        .admin-button {
            float: right;
            margin-top: 10px;
            padding: 10px 20px;
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
                        <li class="breadcrumb-item active" aria-current="page">List of users</li>
                    </ol>
                </nav>
            </div>
        </div>
        <a href="Register.jsp?type=admin" class="btn btn-primary btn-sm admin-button">New Admin</a>
        <div class="container py-5">
            <h1 class="mb-4">Users</h1>
            <div class="mb-4">
                <input type="text" id="searchInput" class="form-control" placeholder="Search by name or last name or email">
            </div>
            <div class="mb-4" style="text-align: center">
                <button type="button" class="btn btn-transparent" onclick="filterUsers('All', this)">All</button>
                <button type="button" class="btn btn-transparent" onclick="filterUsers('Buyer', this)">Buyers</button>
                <button type="button" class="btn btn-transparent" onclick="filterUsers('Seller', this)">Sellers</button>
                <button type="button" class="btn btn-transparent" onclick="filterUsers('Admin', this)">Admins</button>
            </div>
            <table class="table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Role</th>
                    <th>Name</th>
                    <th>Last Name</th>
                    <th>Email</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="user" items="${users}">
                    <tr class="${user.role.roleName}">
                        <td><c:out value="${user.userId}"/></td>
                        <td><c:out value="${user.role.roleName}"/></td>
                        <td><c:out value="${user.userName}"/></td>
                        <td><c:out value="${user.userLn}"/></td>
                        <td><c:out value="${user.userEmail}"/></td>
                        <td class="role-label">
                            <c:choose>
                                <c:when test="${user.isbanned == 0}">
                                    <p style="color: green; font-weight: bold">Active</p>
                                </c:when>
                                <c:when test="${user.isbanned == 1}">
                                    <p style="color: red; font-weight: bold">Banned</p>
                                </c:when>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${user.userId == sessionScope.userId}">
                                    <p>It's you</p>
                                </c:when>
                                <c:when test="${user.isbanned == 0}">
                                    <button type="button" class="btn btn-danger" data-userid="${user.userId}"
                                            onclick="banUser(this)">Ban
                                    </button>
                                </c:when>
                                <c:when test="${user.isbanned == 1}">
                                    <button type="button" class="btn btn-success" data-userid="${user.userId}"
                                            onclick="unbanUser(this)">Unban
                                    </button>
                                </c:when>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</form>
</body>
<script>
    function filterUsers(role, button) {
        var rows = document.querySelectorAll("tbody tr");
        rows.forEach(row => {
            if (role === 'All' || row.classList.contains(role)) {
                row.classList.remove('hidden');
            } else {
                row.classList.add('hidden');
            }
        });

        var buttons = document.querySelectorAll('.btn-transparent');
        buttons.forEach(btn => btn.classList.remove('active'));
        button.classList.add('active');
    }


    function banUser(button) {
        var userId = button.getAttribute('data-userid');
        console.log('Button clicked to ban user with ID:', userId);
        if (confirm('Are you sure you want to ban user with ID ' + userId + '?')) {
            fetch('${pageContext.request.contextPath}/banUser', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'userId=' + userId
            })
                .then(response => {
                    console.log('Response status:', response.status);
                    if (response.ok) {
                        location.reload();
                    } else {
                        response.text().then(text => {
                            console.error('Error response:', text);
                            alert('Failed to ban user: ' + text);
                        });
                    }
                })
                .catch(error => {
                    console.error('Fetch error:', error);
                });
        }
    }

    function unbanUser(button) {
        var userId = button.getAttribute('data-userid');
        console.log('Button clicked to unban user with ID:', userId);
        if (confirm('Are you sure you want to unban user with ID ' + userId + '?')) {
            fetch('${pageContext.request.contextPath}/unbanUser', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'userId=' + userId
            })
                .then(response => {
                    console.log('Response status:', response.status);
                    if (response.ok) {
                        location.reload();
                    } else {
                        response.text().then(text => {
                            console.error('Error response:', text);
                            alert('Failed to unban user: ' + text);
                        });
                    }
                })
                .catch(error => {
                    console.error('Fetch error:', error);
                });
        }
    }

    function searchUsers() {
        const searchInput = document.getElementById('searchInput');
        const filter = searchInput.value.toLowerCase();
        const rows = document.querySelectorAll("tbody tr");

        rows.forEach(row => {
            const name = row.querySelector('td:nth-child(4)').textContent.toLowerCase();
            const lastName = row.querySelector('td:nth-child(5)').textContent.toLowerCase();
            const email = row.querySelector('td:nth-child(6)').textContent.toLowerCase();
            if (name.includes(filter) || lastName.includes(filter)|| email.includes(filter)) {
                row.style.display = "";
            } else {
                row.style.display = "none";
            }
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        const searchInput = document.getElementById('searchInput');
        searchInput.addEventListener('input', searchUsers);

    });

</script>
</html>
