package knit.semit.psr.marketplace.servlet.profile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import knit.semit.psr.marketplace.daohbn.AuctionDAO;
import knit.semit.psr.marketplace.daohbn.AuctionRequestDAO;
import knit.semit.psr.marketplace.daohbn.LiveAuctionDAO;
import knit.semit.psr.marketplace.daohbn.ProductDAO;
import knit.semit.psr.marketplace.entity.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/submitAuction")
public class CreateAuctionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Получаем данные из запроса
        String auctionName = request.getParameter("auctionName");
        LocalDateTime auctionStart = LocalDateTime.parse(request.getParameter("auctionStart"));
        LocalDateTime auctionEnd = LocalDateTime.parse(request.getParameter("auctionEnd"));
        int productID = Integer.parseInt(request.getParameter("productID"));
        User admin = (User) request.getSession().getAttribute("user");

        // Получаем продукт по ID
        Product product = ProductDAO.getProductById(productID);

        if (product != null) {
            // Создаем новый объект аукциона
            Auction newAuction = new Auction();
            newAuction.setAuctionName(auctionName);
            newAuction.setAuctionStartTime(auctionStart);
            newAuction.setAuctionEndTime(auctionEnd);
            newAuction.setProduct(product);
            newAuction.setAdmin(admin);
            // Сохраняем новый аукцион в базе данных
            AuctionDAO.saveAuction(newAuction);

            // Создаем запись LiveAuction
            LiveAuction liveAuction = new LiveAuction();
            liveAuction.setLiveAuctionId(newAuction.getAuctionId());
            liveAuction.setAuction(newAuction);
            liveAuction.setAuctionStartTime(auctionStart);
            liveAuction.setAuctionEndTime(auctionEnd);
            // Сохраняем запись LiveAuction в базе данных
            LiveAuctionDAO.saveLiveAuction(liveAuction);

            // Обновляем статус заявки на аукцион
            AuctionRequest auctionRequest = AuctionRequestDAO.findByProductId(productID);
            if (auctionRequest != null) {
                auctionRequest.setRequestStatus(AuctionRequest.RequestStatus.ON_THE_AUCTION);
                AuctionRequestDAO.update(auctionRequest);
            }

            response.sendRedirect("auctions");
        } else {
            response.sendRedirect("error.jsp");
        }
    }
}
