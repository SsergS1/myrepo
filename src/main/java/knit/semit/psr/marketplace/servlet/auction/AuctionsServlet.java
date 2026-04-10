package knit.semit.psr.marketplace.servlet.auction;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import knit.semit.psr.marketplace.daohbn.AuctionDAO;
import knit.semit.psr.marketplace.daohbn.CategoryDAO;
import knit.semit.psr.marketplace.entity.Auction;
import knit.semit.psr.marketplace.entity.Category;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/auctions")
public class AuctionsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String categoryParam = request.getParameter("category");
        String priceOrderParam = request.getParameter("priceOrder");
        String statusParam = request.getParameter("status");

        List<Auction> auctions;
        if (categoryParam != null && !categoryParam.isEmpty()) {
            int categoryId = Integer.parseInt(categoryParam);
            auctions = AuctionDAO.getAuctionsByCategory(categoryId, priceOrderParam);
        } else {
            auctions = AuctionDAO.getAllAuctions(priceOrderParam);
        }

        // Filter auctions based on status
        if (statusParam != null && !statusParam.isEmpty()) {
            auctions = auctions.stream()
                    .filter(auction -> {
                        switch (statusParam) {
                            case "Upcoming":
                                return auction.isNotStarted();
                            case "Active":
                                return auction.isInProgress();
                            case "Ended":
                                return auction.isEnded();
                            default:
                                return true;
                        }
                    })
                    .collect(Collectors.toList());
        }

        // Update status for each auction
        for (Auction auction : auctions) {
            auction.setEnded(auction.isEnded());
            auction.setNotStarted(auction.isNotStarted());
            auction.setInProgress(auction.isInProgress());
        }

        List<Category> categories = CategoryDAO.getAllCategories();

        request.setAttribute("auctions", auctions);
        request.setAttribute("categories", categories);
        request.setAttribute("selectedCategory", categoryParam);
        request.setAttribute("selectedPriceOrder", priceOrderParam);
        request.setAttribute("selectedStatus", statusParam);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/auctions.jsp");
        dispatcher.forward(request, response);
    }
}