package knit.semit.psr.marketplace.servlet.profile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import knit.semit.psr.marketplace.daohbn.ProductDAO;

import java.io.IOException;

@WebServlet("/reject")
public class RejectServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Получаем ID продукта из запроса
        int productId = Integer.parseInt(request.getParameter("productId"));

        // Удаление продукта из базы данных
        ProductDAO.deleteProduct(productId);

        // Перенаправляем пользователя обратно на страницу со списком продуктов для одобрения
        response.sendRedirect("approveproducts");
    }
}
