package knit.semit.psr.marketplace.servlet.market;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import knit.semit.psr.marketplace.daohbn.BucketDAO;
import knit.semit.psr.marketplace.daohbn.BucketItemDAO;
import knit.semit.psr.marketplace.entity.Bucket;
import knit.semit.psr.marketplace.entity.BucketItem;
import knit.semit.psr.marketplace.entity.User;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/my-bucket")
public class BucketServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session != null) {
            User user = (User) session.getAttribute("user");

            if (user != null) {
                int userId = user.getUserId();

                Bucket userBucket = BucketDAO.getBucketByUserId(userId);

                if (userBucket != null) {
                    List<BucketItem> bucketItems = BucketItemDAO.getBucketItemsByUserId(userId);

                    BigDecimal totalPrice = calculateTotalPrice(bucketItems);

                    request.setAttribute("bucketItems", bucketItems);
                    request.setAttribute("totalPrice", totalPrice);

                    request.getRequestDispatcher("/bucket.jsp").forward(request, response);
                    return;
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    private BigDecimal calculateTotalPrice(List<BucketItem> bucketItems) {
        BigDecimal totalPrice = BigDecimal.ZERO;
        for (BucketItem item : bucketItems) {
            BigDecimal itemPrice = item.getProduct().getProductPrice();
            int quantity = item.getQuantity();
            totalPrice = totalPrice.add(itemPrice.multiply(BigDecimal.valueOf(quantity)));
        }
        return totalPrice;
    }
}