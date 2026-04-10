package knit.semit.psr.marketplace.daohbn;

import knit.semit.psr.marketplace.entity.LiveAuction;
import knit.semit.psr.marketplace.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class LiveAuctionDAO {

    public static void saveLiveAuction(LiveAuction liveAuction) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.save(liveAuction);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }
}
