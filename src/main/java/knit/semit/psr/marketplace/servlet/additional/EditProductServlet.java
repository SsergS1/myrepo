package knit.semit.psr.marketplace.servlet.additional;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import knit.semit.psr.marketplace.daohbn.ProductDAO;
import knit.semit.psr.marketplace.entity.Product;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/editProduct")
public class EditProductServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        if (session.getAttribute("user") != null) {
            String productIdStr = request.getParameter("productId");
            if (productIdStr != null && !productIdStr.isEmpty()) {
                int productId = Integer.parseInt(productIdStr);
                Product product = ProductDAO.getProductById(productId);
                request.setAttribute("product", product);
                request.getRequestDispatcher("/editProduct.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/listproduct");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        if (session.getAttribute("user") != null) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            String productName = request.getParameter("productName");
            BigDecimal productPrice = new BigDecimal(request.getParameter("productPrice"));
            String productInfo = request.getParameter("productInfo");
            String productPic = request.getParameter("productPic");

            Product product = ProductDAO.getProductById(productId);

            // Проверяем, были ли внесены изменения
            boolean changesWereMade = !product.getProductName().equals(productName) ||
                    !product.getProductPrice().equals(productPrice)  ||
                    !product.getProductInfo().equals(productInfo) ||
                    !product.getProductPic().equals(productPic);

            product.setProductName(productName);
            product.setProductPrice(productPrice);
            product.setProductInfo(productInfo);
            product.setProductPic(productPic);

            // Если были внесены изменения и продукт был ранее одобрен,
            // устанавливаем isApproved в false
            if (changesWereMade && product.isApproved()) {
                product.setApproved(false);
            }

            ProductDAO.updateProduct(product);

            response.sendRedirect(request.getContextPath() + "/listproduct");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
}