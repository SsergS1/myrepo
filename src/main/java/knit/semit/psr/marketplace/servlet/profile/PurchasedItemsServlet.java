package knit.semit.psr.marketplace.servlet.profile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import knit.semit.psr.marketplace.daohbn.AuctionDAO;
import knit.semit.psr.marketplace.daohbn.BidLogDAO;
import knit.semit.psr.marketplace.entity.Auction;
import knit.semit.psr.marketplace.entity.BidLog;
import knit.semit.psr.marketplace.entity.User;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/purchasedItems")
public class PurchasedItemsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        List<Auction> allAuctions = AuctionDAO.getAuctionsByBuyerId(user.getUserId());

        List<Auction> completedAuctions = allAuctions.stream()
                .filter(auction -> auction.getAuctionEndTime().isBefore(LocalDateTime.now()))
                .collect(Collectors.toList());

        Map<Integer, String> auctionLastBidTimes = new HashMap<>();
        Map<Integer, String> winningBids = new HashMap<>();

        for (Auction auction : completedAuctions) {
            BidLog lastBid = BidLogDAO.getLastBidForAuction(auction.getAuctionId());
            if (lastBid != null) {
                auctionLastBidTimes.put(auction.getAuctionId(), lastBid.getFormattedBidTime());
                winningBids.put(auction.getAuctionId(), lastBid.getBidAmount().toString());
            } else {
                auctionLastBidTimes.put(auction.getAuctionId(), "-");
                winningBids.put(auction.getAuctionId(), "-");
            }
        }

        request.setAttribute("auctions", completedAuctions);
        request.setAttribute("auctionLastBidTimes", auctionLastBidTimes);
        request.setAttribute("winningBids", winningBids);

        request.getRequestDispatcher("purchasedItems.jsp").forward(request, response);
    }
}
