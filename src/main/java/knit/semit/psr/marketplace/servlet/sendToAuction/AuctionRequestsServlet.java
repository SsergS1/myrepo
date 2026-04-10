package knit.semit.psr.marketplace.servlet.sendToAuction;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import knit.semit.psr.marketplace.daohbn.AuctionRequestDAO;
import knit.semit.psr.marketplace.entity.AuctionRequest;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/auctionRequests")
public class AuctionRequestsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        AuctionRequestDAO auctionRequestDAO = new AuctionRequestDAO();
        List<AuctionRequest> auctionRequests = auctionRequestDAO.findAllWithProductsAndUsers();

        // Filter out requests with statuses ON_THE_AUCTION and REJECT
        auctionRequests = auctionRequests.stream()
                .filter(r -> r.getRequestStatus() == AuctionRequest.RequestStatus.PENDING)
                .collect(Collectors.toList());

        request.setAttribute("auctionRequests", auctionRequests);
        request.getRequestDispatcher("auctionrequest.jsp").forward(request, response);
    }
}
