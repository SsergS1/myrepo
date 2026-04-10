package knit.semit.psr.marketplace.servlet.sendToAuction;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import knit.semit.psr.marketplace.daohbn.ProductDAO;
import knit.semit.psr.marketplace.entity.Product;

import java.io.IOException;

@WebServlet("/createAuction")
public class FormCreateAuctionServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productId = request.getParameter("productId");
        if (productId != null && !productId.isEmpty()) {
            try {
                int id = Integer.parseInt(productId);
                ProductDAO productDAO = new ProductDAO();
                Product product = productDAO.getProductById(id);
                if (product != null) {
                    request.setAttribute("product", product);
                    request.getRequestDispatcher("/creacteauction.jsp").forward(request, response);
                } else {
                    response.sendRedirect("auctionRequests"); // Перенаправление, если продукт не найден
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("auctionRequests"); // Перенаправление при некорректном ID
            }
        } else {
            response.sendRedirect("auctionRequests"); // Перенаправление, если ID не указан
        }
    }
}