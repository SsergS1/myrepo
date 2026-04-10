package knit.semit.psr.marketplace.daohbn;

import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Expression;
import jakarta.persistence.criteria.Root;
import knit.semit.psr.marketplace.entity.Auction;

import knit.semit.psr.marketplace.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.time.LocalDateTime;
import java.util.List;

public class AuctionDAO {

    public static List<Auction> getAlllist() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery cq = cb.createQuery(Auction.class);
        Root rootEntry = cq.from(Auction.class);
        CriteriaQuery all = cq.select(rootEntry);
        TypedQuery allQuery = session.createQuery(all);
        return allQuery.getResultList();
    }
    public static List<Auction> getAllAuctions(String priceOrder) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Auction> cq = cb.createQuery(Auction.class);
        Root<Auction> root = cq.from(Auction.class);

        cq.select(root);

        // Сначала сортируем по статусу (не начавшиеся и идущие первыми)
        Expression<Boolean> isEnded = cb.greaterThan(cb.currentTimestamp(), root.get("auctionEndTime"));
        cq.orderBy(cb.asc(isEnded));

        // Затем применяем сортировку по цене
        if ("desc".equalsIgnoreCase(priceOrder)) {
            cq.orderBy(cb.asc(isEnded), cb.desc(root.get("product").get("productPrice")));
        } else {
            cq.orderBy(cb.asc(isEnded), cb.asc(root.get("product").get("productPrice")));
        }

        TypedQuery<Auction> query = session.createQuery(cq);
        List<Auction> auctions = query.getResultList();

        session.close();
        return auctions;
    }

    public static List<Auction> getAuctionsByCategory(int categoryId, String priceOrder) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Auction> cq = cb.createQuery(Auction.class);
        Root<Auction> root = cq.from(Auction.class);

        cq.select(root);
        cq.where(cb.equal(root.get("product").get("category").get("categoryId"), categoryId));

        Expression<Boolean> isEnded = cb.greaterThan(cb.currentTimestamp(), root.get("auctionEndTime"));
        cq.orderBy(cb.asc(isEnded));

        if ("desc".equalsIgnoreCase(priceOrder)) {
            cq.orderBy(cb.asc(isEnded), cb.desc(root.get("product").get("productPrice")));
        } else {
            cq.orderBy(cb.asc(isEnded), cb.asc(root.get("product").get("productPrice")));
        }

        TypedQuery<Auction> query = session.createQuery(cq);
        List<Auction> auctions = query.getResultList();

        session.close();
        return auctions;
    }

    public static Auction getAuctionById(Long idToFindG) {
        Auction aucInDB = null;
        List<Auction> results;
        Session session = HibernateUtil.getSessionFactory().openSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery cq = cb.createQuery(Auction.class);
        Root rootEntry = cq.from(Auction.class);
        cq.select(rootEntry).where(cb.equal(rootEntry.get("id"), idToFindG));
        Query<Auction> query = session.createQuery(cq);
        results = query.getResultList();
        if (!results.isEmpty()) {
            aucInDB = results.get(0);
        }
        return aucInDB;
    }

    public static List<Auction> getAuctionsByBuyerId(int buyerId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Auction> cq = cb.createQuery(Auction.class);
        Root<Auction> root = cq.from(Auction.class);
        cq.select(root).where(cb.equal(root.get("buyer").get("userId"), buyerId));
        TypedQuery<Auction> query = session.createQuery(cq);
        return query.getResultList();
    }
    public static String getAuctionNameById(int auctionId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "SELECT auctionName FROM Auction WHERE auctionId = :auctionId";
            Query<String> query = session.createQuery(hql, String.class);
            query.setParameter("auctionId", auctionId);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            session.close();
        }
    }

    public static void updateAuction(Auction auction) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Начать транзакцию
            transaction = session.beginTransaction();
            // Обновить объект аукциона в базе данных
            session.update(auction);
            // Закоммитить транзакцию
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public static void saveAuction(Auction auction) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.save(auction); // Сохраняем новый объект аукциона
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback(); // Откатываем транзакцию в случае ошибки
            }
            e.printStackTrace(); // Логгируем ошибку
        }
    }
    public static boolean isProductInAuction(int productId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Long> cq = cb.createQuery(Long.class);
        Root<Auction> root = cq.from(Auction.class);
        cq.select(cb.count(root)).where(cb.equal(root.get("product").get("productId"), productId));
        TypedQuery<Long> query = session.createQuery(cq);
        return query.getSingleResult() > 0;
    }

    public static List<Auction> getActiveAuctions() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Auction> cq = cb.createQuery(Auction.class);
        Root<Auction> root = cq.from(Auction.class);
        cq.select(root).where(cb.greaterThan(root.get("auctionEndTime"), LocalDateTime.now()));
        TypedQuery<Auction> query = session.createQuery(cq);
        return query.getResultList();
    }

}

