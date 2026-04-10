package knit.semit.psr.marketplace.servlet.profile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import knit.semit.psr.marketplace.daohbn.ProductDAO;
import knit.semit.psr.marketplace.entity.Product;
import knit.semit.psr.marketplace.entity.User;
import knit.semit.psr.marketplace.utils.HibernateUtil;
import org.hibernate.Hibernate;
import org.hibernate.Session;

import java.io.IOException;
import java.util.List;

@WebServlet("/listproduct")
public class SellerProductsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        if (session.getAttribute("user") != null) {
            User currentUser = (User) session.getAttribute("user");
            int userId = currentUser.getUserId();
            List<Product> products = ProductDAO.getProductsBySellerId(userId);

            try (Session hibernateSession = HibernateUtil.getSessionFactory().openSession()) {
                for (Product product : products) {
                    Hibernate.initialize(product.getAuctionRequests());
                    product.setAuctionRequestStatus(product.getAuctionRequestStatus());
                }
            }

            request.setAttribute("products", products);
            request.getRequestDispatcher("/sellerproducts.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
}