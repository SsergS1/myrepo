package knit.semit.psr.marketplace.servlet.profile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import knit.semit.psr.marketplace.daohbn.OrderDAO;
import knit.semit.psr.marketplace.entity.Order;
import knit.semit.psr.marketplace.entity.User;

import java.io.IOException;

@WebServlet("/payOrder")
public class PayOrderServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Получаем ID заказа из параметра запроса
        Long orderId = Long.parseLong(request.getParameter("orderId"));

        System.out.println("orderId: " + orderId);

        // Получаем заказ по его ID
        Order order = OrderDAO.getOrderById(orderId);

        System.out.println("order: " + order);


        order.setOrderStatus(true);

        System.out.println("orderStatus updated: " + order.isOrderStatus()); // Добавляем отладочное сообщение

        // Обновляем информацию о заказе в базе данных
        OrderDAO.updateOrder(order);

        // Перенаправляем пользователя на страницу с заказами
        response.sendRedirect("orderList");
    }
}