package knit.semit.psr.marketplace.servlet.profile;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.*;
import knit.semit.psr.marketplace.daohbn.CategoryDAO;
import knit.semit.psr.marketplace.daohbn.ProductDAO;
import knit.semit.psr.marketplace.entity.Category;
import knit.semit.psr.marketplace.entity.Product;
import knit.semit.psr.marketplace.entity.User;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/addproduct")
public class AddProductServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        List<Category> categories = CategoryDAO.getAllCategories();

        // Передача списка категорий на JSP страницу
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("addproduct.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Получаем данные о продукте из параметров запроса
        String productName = request.getParameter("productName");
        String productImage = request.getParameter("productImage");
        String productPriceStr = request.getParameter("productPrice");
        String productInfo = request.getParameter("productInfo");
        int categoryId = Integer.parseInt(request.getParameter("productCategory"));

        User seller = (User) request.getSession().getAttribute("user");

        // Проверяем, не является ли productPriceStr null или пустым, прежде чем создать BigDecimal
        BigDecimal productPrice = null;
        if (productPriceStr != null && !productPriceStr.isEmpty()) {
            productPrice = new BigDecimal(productPriceStr);
        } else {
            // Если значение productPrice не передано в запросе или пустое, можем установить значение по умолчанию
            productPrice = BigDecimal.ZERO;
        }

        // Создаем новый продукт
        Product product = new Product();
        product.setProductName(productName);
        product.setProductPic(productImage);
        product.setProductPrice(productPrice);
        product.setProductInfo(productInfo);
        product.setCategory(new Category(categoryId));
        product.setSeller(seller);
        product.setApproved(false); // По умолчанию продукт не одобрен

        // Сохраняем продукт в базе данных
        ProductDAO.saveProduct(product);

        // Перенаправляем пользователя обратно на страницу добавления продукта
        response.sendRedirect("listproduct");
    }
}
