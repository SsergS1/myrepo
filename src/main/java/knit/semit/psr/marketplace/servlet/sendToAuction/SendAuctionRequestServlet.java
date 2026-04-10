package knit.semit.psr.marketplace.servlet.sendToAuction;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import knit.semit.psr.marketplace.daohbn.AuctionRequestDAO;
import knit.semit.psr.marketplace.entity.AuctionRequest;

import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/sendAuctionRequest")
public class SendAuctionRequestServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(SendAuctionRequestServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int userId = (int) request.getSession().getAttribute("userId");

            logger.info("Attempting to create or update auction request for product " + productId + " and user " + userId);

            AuctionRequest auctionRequest = new AuctionRequest();
            auctionRequest.setProductID(productId);
            auctionRequest.setUserID(userId);
            auctionRequest.setRequestStatus(AuctionRequest.RequestStatus.PENDING);

            AuctionRequestDAO auctionRequestDAO = new AuctionRequestDAO();
            auctionRequestDAO.saveOrUpdateRequest(auctionRequest);

            logger.info("Auction request processed successfully");

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("Auction request processed successfully.");
        } catch (Exception e) {
            logger.severe("Error processing auction request: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing auction request: " + e.getMessage());
        }
    }
}