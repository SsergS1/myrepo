<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Auction</title>
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

        .container {
            margin-top: 50px;
        }

        .auction-item {
            border: 1px solid #ccc;
            border-radius: 5px;
            padding: 20px;
            margin-bottom: 30px;
        }

        .auction-image {
            width: 200px;
            /*max-width: 250px;*/
            height: 200px;
            margin-bottom: 20px;
        }

        .auction-info {
            display: flex;
            flex-direction: row;
        }

        .auction-details {
            flex: 1;
            margin-left: 20px;
        }

        .auction-details p {
            margin-bottom: 10px;
        }

        .auction-actions {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
        }

        .auction-actions .btn {
            margin-bottom: 10px;
        }

        .bid-form {
            display: flex;
            flex-direction: row;
            align-items: center;
        }

        .button-group {
            display: flex;
            flex-direction: row;
            margin-top: 10px;
        }

        .button-group .btn {
            margin-right: 10px;
        }
    </style>
</head>
<body style="background-color: #eee">
<nav class="navbar navbar-expand-lg navbar-light sticky-top mt-0">
    <div class="container">
        <a class="navbar-brand" href="auctions">Artplace</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
    </div>
</nav>
<div class="container">
    <div class="row justify-content-center">
        <!-- Левый контейнер с информацией о продукте -->
        <div class="col-md-4 pe-md-4">
            <div class="auction-item">
                <h2><c:out value="${auction.auctionName}"/></h2>
                <p>Information about product: <c:out value="${auction.product.productInfo}"/></p>
            </div>
        </div>
        <!-- Центральный контейнер с фото продукта -->
        <div class="col-md-5">
            <div class="auction-item text-center">
                <img src="<c:out value="${auction.product.productPic}" />" class="img-fluid" alt="Auction Item"
                     style="max-height: 400px; width: auto;">

                <p style="margin-top: 24px; text-align: left">Starting Price: $<c:out value="${auction.product.productPrice}"/></p>
                <form id="bidForm" class="bid-form" action="placeBid" method="post" onsubmit="return validateBid()">
                    <input type="hidden" id="auctionId" name="liveAuctionId"
                           value="<c:out value="${auction.auctionId}" />">
                    <div class="input-group mb-3">
                        <span class="input-group-text">$</span>
                        <input type="number" id="bidAmount" class="form-control" name="bidAmount"
                               placeholder="Enter your bid" value="${maxBid}" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Place Bid</button>
                </form>
                <div class="button-group">
                    <button class="btn btn-primary" onclick="increaseBid(10)">Bid +$10</button>
                    <button class="btn btn-primary" onclick="increaseBid(20)">Bid +$20</button>
                    <button class="btn btn-primary" onclick="increaseBid(50)">Bid +$50</button>
                </div>
            </div>
        </div>

        <!-- Правый контейнер со списком ставок -->
        <div class="col-md-3">
            <div class="auction-item">
                <h3>Bid List</h3>
                <div class="bid-list" style="overflow-y: auto; max-height: 500px;" id="bidsContainer">
                    <p style="font-weight: bold">Users:</p>
                    <c:forEach var="bid" items="${bids}">
                        <div class="bid-item">
                            <c:out value="${bid.user.userName}"/> ${bid.bidAmount}$ <br>
                            <c:out value="${bid.formattedBidTime}"/>
                        </div>
                        <hr>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>
<input type="hidden" id="winner" value="<c:out value="${auction.buyer.userName}" />">
<input type="hidden" id="productName" value="<c:out value="${auction.product.productName}" />">
<input type="hidden" id="maxBid" value="${maxBid}">
<script>
    let winner = document.getElementById('winner').value;
    let productName = document.getElementById('productName').value;

    // Получаем время окончания аукциона из JSP
    let auctionEndTime = "<c:out value='${auction.auctionEndTime}' />";

    // Преобразуем строку времени окончания аукциона в объект Date
    let endTime = new Date(auctionEndTime);

    // Получаем текущее время
    let currentTime = new Date();

    // Проверяем, прошло ли текущее время за время окончания аукциона
    if (currentTime > endTime) {
        // Аукцион завершен, отображаем уведомление о победителе и продукте
        alert("Auction ended. \n" + "Winner: " + winner + "\n Win product: " + productName);
    }

    function placeBid() {
        const bidAmount = document.getElementById('bidAmount').value;
        const auctionId = document.getElementById('auctionId').value;

        // Формируем данные для отправки на сервер
        const data = new FormData();
        data.append('auctionId', auctionId);
        data.append('bidAmount', bidAmount);

        // Отправляем AJAX-запрос на сервер
        fetch('placeBid', {
            method: 'POST',
            body: data
        })
            .then(response => {
                if (response.ok) {
                    // Если запрос успешен, обновляем список ставок
                    fetchAuctionDetails(auctionId);
                } else {
                    // Если произошла ошибка, выводим сообщение
                    console.error('Error placing bet');
                }
            })
            .catch(error => {
                console.error('Error sending request:', error);
            });
    }

    // Функция для получения деталей аукциона (включая список ставок) с сервера
    function fetchAuctionDetails(auctionId) {
        fetch('auction?id=' + auctionId)
            .then(response => response.json())
            .then(data => {
                // Обновляем информацию о ставках на странице
                const bidsElement = document.getElementById('bids');
                bidsElement.innerHTML = ''; // Очищаем предыдущий список ставок

                data.bids.forEach(bid => {
                    const bidElement = document.createElement('p');
                    bidElement.textContent = `(user: ${bid.user.userName} ${bid.bidAmount}$)`;
                    bidsElement.appendChild(bidElement);
                });
            })
            .catch(error => {
                console.error('Error when retrieving bet information:', error);
            });
    }

    function validateBid() {
        const bidAmountInput = document.getElementById('bidAmount');
        const bidAmount = parseFloat(bidAmountInput.value);
        const maxBid = parseFloat(document.getElementById('maxBid').value); // Get the maximum current bid from hidden field
        if (bidAmount <= maxBid) {
            alert('Your bid must be higher than the current highest bid.');
            bidAmountInput.focus(); // Focus on the input field to allow the user to correct the bid
            return false; // Prevent form submission
        }
        return true; // Continue form submission
    }

    function increaseBid(amount) {
        const bidAmountInput = document.getElementById('bidAmount');
        let currentBid = parseFloat(bidAmountInput.value);
        if (isNaN(currentBid)) {
            currentBid = parseFloat(document.getElementById('maxBid').value);
        }
        bidAmountInput.value = currentBid + amount;
    }

    // Функция для прокрутки списка ставок вниз при загрузке страницы
    function scrollToBottom() {
        const bidsContainer = document.getElementById('bidsContainer');
        bidsContainer.scrollTop = bidsContainer.scrollHeight;
    }

    // Вызываем функцию прокрутки вниз при загрузке страницы
    window.onload = function () {
        scrollToBottom();
    };
</script>

</body>
</html>
