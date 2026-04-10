package knit.semit.psr.marketplace.daohbn;

import knit.semit.psr.marketplace.entity.BucketItem;
import knit.semit.psr.marketplace.entity.Order;
import knit.semit.psr.marketplace.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class OrderDAO {

    public static Order getOrderById(Long orderId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Order.class, orderId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    public static List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Order> query = session.createQuery("SELECT o FROM Order o LEFT JOIN FETCH o.bucketItems WHERE o.user.userId = :userId", Order.class);
            query.setParameter("userId", userId);
            orders = query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public static void updateOrder(Order order) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.update(order);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }
    public static void createOrder(Order order) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.save(order);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }
    public static List<BucketItem> getBucketItemsByUserId(int userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<BucketItem> query = session.createQuery("FROM BucketItem bi WHERE bi.bucket.user.userId = :userId AND bi.order IS NULL", BucketItem.class);
            query.setParameter("userId", userId);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
