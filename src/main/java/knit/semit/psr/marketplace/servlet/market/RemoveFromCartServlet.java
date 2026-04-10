package knit.semit.psr.marketplace.servlet.market;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import knit.semit.psr.marketplace.daohbn.BucketDAO;

import java.io.IOException;

@WebServlet("/removeFromCart")
public class RemoveFromCartServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int bucketItemId = Integer.parseInt(request.getParameter("bucketItemId"));
        BucketDAO.removeFromCart(bucketItemId);
        response.sendRedirect("my-bucket");
    }
}
