package knit.semit.psr.marketplace.servlet.auction;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import knit.semit.psr.marketplace.daohbn.AuctionDAO;
import knit.semit.psr.marketplace.daohbn.BidLogDAO;
import knit.semit.psr.marketplace.entity.Auction;
import knit.semit.psr.marketplace.entity.BidLog;
import knit.semit.psr.marketplace.entity.LiveAuction;
import knit.semit.psr.marketplace.entity.User;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@WebServlet("/placeBid")
public class PlaceBidServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {


        // Получаем параметры из запроса
        long liveAuctionId = Long.parseLong(request.getParameter("liveAuctionId"));
        BigDecimal bidAmount = new BigDecimal(request.getParameter("bidAmount"));

        // Получаем информацию о пользователе из сессии
        User user = (User) request.getSession().getAttribute("user");

        // Проверяем, что пользователь вошел в систему
        if (user != null) {
            // Получаем информацию о текущем аукционе
            Auction auction = AuctionDAO.getAuctionById(liveAuctionId);

            // Получаем стартовую цену продукта
            BigDecimal startingPrice = auction.getProduct().getProductPrice();

            // Проверяем, находится ли текущее время в периоде проведения аукциона
            LocalDateTime currentTime = LocalDateTime.now();
            if (currentTime.isAfter(auction.getAuctionStartTime()) && currentTime.isBefore(auction.getAuctionEndTime())) {
                // Время нахождения в периоде аукциона, разрешаем ставку

                // Проверяем, что ставка выше стартовой цены
                if (bidAmount.compareTo(startingPrice) >= 0) {
                    // Ставка выше или равна стартовой цене
                    // Получаем предыдущую максимальную ставку для данного аукциона
                    BigDecimal previousBidAmount = BidLogDAO.getHighestBidAmountForAuction(liveAuctionId);

                    if (previousBidAmount == null || bidAmount.compareTo(previousBidAmount) > 0) {
                        // Предыдущая ставка отсутствует или текущая ставка больше предыдущей
                        // Создаем объект BidLog для новой ставки
                        BidLog bidLog = new BidLog();
                        LiveAuction liveAuction = new LiveAuction();
                        liveAuction.setLiveAuctionId((int) liveAuctionId);
                        bidLog.setLiveAuction(liveAuction);
                        bidLog.setUser(user);
                        bidLog.setBidAmount(bidAmount);
                        bidLog.setBidTime(LocalDateTime.now());

                        // Сохраняем ставку в базе данных
                        BidLogDAO.saveBidLog(bidLog);
                        // Получаем аукцион, к которому относится эта ставка

                        // Устанавливаем новую максимальную ставку и победителя аукциона
                        auction.setBuyer(user); // Устанавливаем пользователя, сделавшего ставку, как победителя

                        // Сохраняем обновленные данные об аукционе в базе данных
                        AuctionDAO.updateAuction(auction);
                        // Перенаправляем на ту же страницу
                        response.sendRedirect("auction?id=" + liveAuctionId);
                    } else {
                        // Текущая ставка меньше или равна предыдущей
                        // Возвращаем ошибку  needhigherbid.jsp
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        response.sendRedirect("needhigherbid.jsp?id=" + liveAuctionId);
                    }
                } else {
                    // Ставка ниже стартовой цены
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.sendRedirect("lowerbidthanstarting.jsp?id=" + liveAuctionId);
                }
            } else {
                // Вне периода аукциона, возвращаем ошибку
                request.getRequestDispatcher("/auctionnotstart.jsp").forward(request, response);
            }
        } else {
            // Пользователь не вошел в систему, возвращаем ошибку
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        }
    }
}