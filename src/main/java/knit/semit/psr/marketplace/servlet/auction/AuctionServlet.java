package knit.semit.psr.marketplace.servlet.auction;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import knit.semit.psr.marketplace.daohbn.AuctionDAO;
import knit.semit.psr.marketplace.daohbn.BidLogDAO;
import knit.semit.psr.marketplace.entity.Auction;
import knit.semit.psr.marketplace.entity.BidLog;
import knit.semit.psr.marketplace.entity.User;

import java.io.IOException;
import java.util.List;

@WebServlet("/auction")
public class AuctionServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Проверяем, авторизован ли пользователь
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            // Если пользователь не авторизован, перенаправляем на страницу входа
            response.sendRedirect("login.jsp");
            return;
        }
        int auctionId = Integer.parseInt(request.getParameter("id"));

        Auction auction = AuctionDAO.getAuctionById((long) auctionId);
        List<BidLog> bids = BidLogDAO.getBidsForAuction(auctionId);

        request.setAttribute("auction", auction);
        request.setAttribute("bids", bids);
        request.getRequestDispatcher("/auction.jsp").forward(request, response);


    }
}
