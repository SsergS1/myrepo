package knit.semit.psr.marketplace.servlet.sendToAuction;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import knit.semit.psr.marketplace.daohbn.AuctionRequestDAO;
import knit.semit.psr.marketplace.entity.AuctionRequest;

import java.io.IOException;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/rejectAuctionRequest")
public class RejectAuctionRequestServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Получаем ID заявки из запроса
        int requestId = Integer.parseInt(request.getParameter("requestId"));

        // Получаем заявку из базы данных
        AuctionRequestDAO auctionRequestDAO = new AuctionRequestDAO();
        AuctionRequest auctionRequest = auctionRequestDAO.findById((long) requestId);

        if (auctionRequest != null) {
            // Меняем статус заявки на REJECT
            auctionRequest.setRequestStatus(AuctionRequest.RequestStatus.REJECT);
            auctionRequestDAO.update(auctionRequest);
        }

        // Перенаправляем пользователя обратно на страницу со списком заявок на аукцион
        response.sendRedirect("auctionRequests");
    }
}
