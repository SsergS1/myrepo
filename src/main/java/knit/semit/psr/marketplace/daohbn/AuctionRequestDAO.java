package knit.semit.psr.marketplace.daohbn;


import knit.semit.psr.marketplace.entity.Auction;
import knit.semit.psr.marketplace.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import knit.semit.psr.marketplace.entity.AuctionRequest;
import org.hibernate.query.Query;

import java.util.List;

public class AuctionRequestDAO {
    private static SessionFactory sessionFactory;

    static {
        try {
            // Создаем SessionFactory при инициализации класса
            sessionFactory = new Configuration().configure().buildSessionFactory();
        } catch (Throwable ex) {
            System.err.println("Initial SessionFactory creation failed." + ex);
            throw new ExceptionInInitializerError(ex);
        }
    }

    public static void saveRequest(AuctionRequest auctionRequest) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.save(auctionRequest); // Сохраняем новый объект аукциона
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback(); // Откатываем транзакцию в случае ошибки
            }
            e.printStackTrace(); // Логгируем ошибку
        }
    }

    public List<AuctionRequest> findAll() {
        Session session = sessionFactory.openSession();
        try {
            return session.createQuery("from AuctionRequest", AuctionRequest.class).list();
        } finally {
            session.close();
        }
    }

    public AuctionRequest findById(Long requestId) {
        Session session = sessionFactory.openSession();
        try {
            return session.get(AuctionRequest.class, requestId);
        } finally {
            session.close();
        }
    }

    public static AuctionRequest findByProductId(int productId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<AuctionRequest> query = session.createQuery(
                    "FROM AuctionRequest WHERE productID = :productId", AuctionRequest.class);
            query.setParameter("productId", productId);
            return query.uniqueResult();
        }
    }

    //Старый//
//    public void update(AuctionRequest request) {
//        Session session = sessionFactory.openSession();
//        Transaction tx = null;
//        try {
//            tx = session.beginTransaction();
//            session.update(request);
//            tx.commit();
//        } catch (Exception e) {
//            if (tx != null) tx.rollback();
//            throw e;
//        } finally {
//            session.close();
//        }
//    }

    public static void update(AuctionRequest request) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Начать транзакцию
            transaction = session.beginTransaction();
            // Обновить объект аукциона в базе данных
            session.update(request);
            // Закоммитить транзакцию
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }
    public void saveOrUpdateRequest(AuctionRequest auctionRequest) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            // Проверка на существующую заявку
            AuctionRequest existingRequest = session.createQuery("FROM AuctionRequest WHERE productID = :productId", AuctionRequest.class)
                    .setParameter("productId", auctionRequest.getProductID())
                    .uniqueResult();

            if (existingRequest != null) {
                // Обновление статуса существующей заявки
                existingRequest.setRequestStatus(auctionRequest.getRequestStatus());
                session.update(existingRequest);
            } else {
                // Сохранение новой заявки
                session.save(auctionRequest);
            }

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }
    public List<AuctionRequest> findAllWithProductsAndUsers() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "select ar from AuctionRequest ar join fetch ar.product join fetch ar.user";
            Query<AuctionRequest> query = session.createQuery(hql, AuctionRequest.class);
            return query.list();
        }
    }

    // Метод для закрытия SessionFactory при завершении работы приложения
    public static void closeSessionFactory() {
        if (sessionFactory != null && !sessionFactory.isClosed()) {
            sessionFactory.close();
        }
    }
}