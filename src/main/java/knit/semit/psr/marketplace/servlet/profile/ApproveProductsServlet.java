package knit.semit.psr.marketplace.servlet.profile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import knit.semit.psr.marketplace.daohbn.ProductDAO;
import knit.semit.psr.marketplace.entity.Product;
import knit.semit.psr.marketplace.entity.User;

import java.io.IOException;
import java.util.List;


@WebServlet("/approveproducts")
public class ApproveProductsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        List<Product> productsToApprove = ProductDAO.getProductsToApprove();

        request.setAttribute("products", productsToApprove);
        request.getRequestDispatcher("approveproducts.jsp").forward(request, response);
    }
}
