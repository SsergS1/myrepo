package knit.semit.psr.marketplace.servlet.market;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import knit.semit.psr.marketplace.daohbn.CategoryDAO;
import knit.semit.psr.marketplace.daohbn.ProductDAO;
import knit.semit.psr.marketplace.entity.Category;
import knit.semit.psr.marketplace.entity.Product;

import java.io.IOException;
import java.util.List;

@WebServlet("/marketplace")
public class ProductListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Получаем параметры фильтров
        String categoryId = request.getParameter("category");
        String priceOrder = request.getParameter("priceOrder");
        String searchQuery = request.getParameter("searchQuery");

        // Получаем список доступных продуктов для маркетплейса с учетом фильтров
        List<Product> productList = ProductDAO.getFilteredProductsForMarketplace(categoryId, priceOrder, searchQuery);

        // Получаем список всех категорий
        List<Category> categories = CategoryDAO.getAllCategories();

        // Передаем списки на JSP через атрибуты request
        request.setAttribute("products", productList);
        request.setAttribute("categories", categories);
        // Перенаправляем на JSP страницу для отображения продуктов
        request.getRequestDispatcher("/market.jsp").forward(request, response);
    }
}