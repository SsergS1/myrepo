package knit.semit.psr.marketplace.servlet.market;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import knit.semit.psr.marketplace.daohbn.BucketDAO;
import knit.semit.psr.marketplace.daohbn.ProductDAO;
import knit.semit.psr.marketplace.entity.Bucket;
import knit.semit.psr.marketplace.daohbn.BucketItemDAO;
import knit.semit.psr.marketplace.entity.BucketItem;
import knit.semit.psr.marketplace.entity.Product;
import knit.semit.psr.marketplace.entity.User;

import java.io.IOException;

@WebServlet("/addToCart")
public class AddToCartServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String productIdParam = request.getParameter("productId");
        int productId;

        try {
            if (productIdParam == null || productIdParam.isEmpty()) {
                throw new NumberFormatException("Product ID parameter is null or empty");
            }

            productId = Integer.parseInt(productIdParam.trim());

            User user = (User) request.getSession().getAttribute("user");
            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            Product product = ProductDAO.getProductById(productId);
            if (product == null) {
                response.getWriter().write("Product not found.");
                return;
            }

            Bucket bucket = BucketDAO.getBucketByUserId(user.getUserId());
            if (bucket == null) {
                bucket = new Bucket();
                bucket.setUser(user);
                BucketDAO.createBucket(bucket);
            }

            BucketItem bucketItem = new BucketItem();
            bucketItem.setBucket(bucket);
            bucketItem.setProduct(product);
            bucketItem.setQuantity(1);

            BucketItemDAO.addToCart(bucketItem);
            response.sendRedirect("marketplace");
        } catch (NumberFormatException e) {
            response.getWriter().write("Invalid product ID format.");
        } catch (Exception e) {
            response.getWriter().write("An error occurred while adding the product to the cart.");
        }
    }
}
