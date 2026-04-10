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

@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null) {
            int userId = user.getUserId();

            // Получаем все элементы корзины пользователя
            List<BucketItem> bucketItems = BucketItemDAO.getBucketItemsByUserId(userId);

            // Вычисляем общую стоимость
            BigDecimal totalPrice = bucketItems.stream()
                    .map(item -> item.getProduct().getProductPrice().multiply(BigDecimal.valueOf(item.getQuantity())))
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            request.setAttribute("bucketItems", bucketItems);
            request.setAttribute("totalPrice", totalPrice);

            request.getRequestDispatcher("order.jsp").forward(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}