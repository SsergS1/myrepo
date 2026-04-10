package knit.semit.psr.marketplace.servlet.market;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import knit.semit.psr.marketplace.daohbn.BucketDAO;
import knit.semit.psr.marketplace.daohbn.OrderDAO;
import knit.semit.psr.marketplace.daohbn.ProductDAO;
import knit.semit.psr.marketplace.entity.*;

import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet("/SubmitOrderServlet")
public class SubmitOrderServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String orderAddress = request.getParameter("orderAddress");

        if (user != null && orderAddress != null && !orderAddress.isEmpty()) {
            List<BucketItem> bucketItems = BucketDAO.getBucketItemsByUserId(user.getUserId());
            if (bucketItems.isEmpty()) {
                response.sendRedirect("orderError.jsp");
                return;
            }

            Order order = new Order();
            order.setUser(user);
            order.setBucketItems(bucketItems);
            order.setOrderAddress(orderAddress);
            order.setOrderDate(new Date());
            order.setOrderStatus(false);

            OrderDAO.createOrder(order);

            for (BucketItem bucketItem : bucketItems) {
                Product product = bucketItem.getProduct();
                product.setOrdered(true);
                ProductDAO.updateProduct(product);
            }

            response.sendRedirect("orderList");
        } else {
            response.sendRedirect("orderError.jsp");
        }
    }
}
