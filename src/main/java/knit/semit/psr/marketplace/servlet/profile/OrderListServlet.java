package knit.semit.psr.marketplace.servlet.profile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import knit.semit.psr.marketplace.daohbn.OrderDAO;
import knit.semit.psr.marketplace.entity.Order;
import knit.semit.psr.marketplace.entity.User;

import java.io.IOException;
import java.util.List;

@WebServlet("/orderList")
public class OrderListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userId = getCurrentUserId(request);
        List<Order> orders = OrderDAO.getOrdersByUserId(userId);
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/OrderList.jsp").forward(request, response);
    }

    private int getCurrentUserId(HttpServletRequest request) {
        HttpSession session = request.getSession();
        return (int) session.getAttribute("userId");
    }
}

