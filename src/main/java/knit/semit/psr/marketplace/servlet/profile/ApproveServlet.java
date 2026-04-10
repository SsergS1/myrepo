package knit.semit.psr.marketplace.servlet.profile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import knit.semit.psr.marketplace.daohbn.ProductDAO;
import knit.semit.psr.marketplace.entity.Product;

import java.io.IOException;

@WebServlet("/approve")
public class ApproveServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Получаем ID продукта из запроса
        int productId = Integer.parseInt(request.getParameter("productId"));

        // Получаем продукт по его ID
        Product product = ProductDAO.getProductById(productId);


        product.setApproved(true);

        // Обновляем информацию о продукте в базе данных
        ProductDAO.updateProduct(product);

        // Перенаправляем пользователя обратно на страницу со списком продуктов для одобрения
        response.sendRedirect("approveproducts");
    }
}