package knit.semit.psr.marketplace.daohbn;

import javax.persistence.EntityManager;
import knit.semit.psr.marketplace.entity.BidLog;
import knit.semit.psr.marketplace.entity.User;
import knit.semit.psr.marketplace.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.math.BigDecimal;
import java.util.List;

public class BidLogDAO {


    private EntityManager entityManager;
    public static List<BidLog> getBidsForAuction(int auctionId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "FROM BidLog WHERE liveAuction.auction.auctionId = :auctionId";
            Query<BidLog> query = session.createQuery(hql, BidLog.class);
            query.setParameter("auctionId", auctionId);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            session.close();
        }
    }
    public static User getWinnerForAuction(int auctionId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            // Запрос для получения последней ставки для определенного аукциона
            String hql = "SELECT bl.user FROM BidLog bl WHERE bl.liveAuction.auction.auctionId = :auctionId " +
                    "ORDER BY bl.bidTime DESC";
            Query<User> query = session.createQuery(hql, User.class);
            query.setParameter("auctionId", auctionId);
            query.setMaxResults(1); // Получаем только один результат - победителя
            return query.uniqueResult(); // Возвращает пользователя, сделавшего последнюю ставку, как победителя
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            session.close();
        }
    }

    public static BidLog getLastBidForAuction(int auctionId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            String hql = "FROM BidLog WHERE liveAuction.auction.auctionId = :auctionId ORDER BY bidTime DESC";
            Query<BidLog> query = session.createQuery(hql, BidLog.class);
            query.setParameter("auctionId", auctionId);
            query.setMaxResults(1);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            session.close();
        }
    }

    public static void saveBidLog(BidLog bidLog) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction transaction = null;

        try {
            transaction = session.beginTransaction();
            session.save(bidLog); // Сохраняем запись о ставке в базе данных
            transaction.commit(); // Фиксируем изменения в базе данных
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback(); // Откатываем транзакцию в случае ошибки
            }
            e.printStackTrace();
        } finally {
            session.close(); // Закрываем сессию Hibernate
        }
    }
    public static BigDecimal getHighestBidAmountForAuction(long liveAuctionId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Находим максимальную ставку для данного аукциона
            Query<BigDecimal> query = session.createQuery(
                    "SELECT MAX(bid.bidAmount) FROM BidLog bid WHERE bid.liveAuction.liveAuctionId = :liveAuctionId",
                    BigDecimal.class
            );
            query.setParameter("liveAuctionId", liveAuctionId);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
