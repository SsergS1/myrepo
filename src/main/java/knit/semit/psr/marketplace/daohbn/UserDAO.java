package knit.semit.psr.marketplace.daohbn;

import jakarta.persistence.TypedQuery;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;

import knit.semit.psr.marketplace.entity.User;
import knit.semit.psr.marketplace.enums.MsgForUser;
import knit.semit.psr.marketplace.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class UserDAO {

    public static List<User> getAllUsers() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery cq = cb.createQuery(User.class);
        Root rootEntry = cq.from(User.class);
        CriteriaQuery all = cq.select(rootEntry);
        TypedQuery allQuery = session.createQuery(all);
        return allQuery.getResultList();
    }
    public static User getUserById(Long idToFind) {
        User stuInDB = null;
        List<User> results;
        Session session = HibernateUtil.getSessionFactory().openSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery cq = cb.createQuery(User.class);
        Root rootEntry = cq.from(User.class);
        cq.select(rootEntry).where(cb.equal(rootEntry.get("id"), idToFind));
        Query<User> query = session.createQuery(cq);
        results = query.getResultList();
        if (!results.isEmpty()) {
            stuInDB = results.get(0);
        }
        return stuInDB;
    }

    public static Long getIdByKeyset(User userKey) {
        Long findID = null;
        List<User> results;
        Session session = HibernateUtil.getSessionFactory().openSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery cq = cb.createQuery(User.class);
        Root rootEntry = cq.from(User.class);
        cq.select(rootEntry).where(cb.equal(rootEntry.get("userEmail"), userKey.getUserEmail()));
        Query<User> query = session.createQuery(cq);
        results = query.getResultList();
        if (!results.isEmpty()) {
            findID = (long) results.get(0).getUserId();
        }
        return findID;
    }


    public static String update(User studForUpdate, Long idStudToUpdate) {
        String msgUp = MsgForUser.OK_UPD_MSG.getText();
        // Проверяем, что idStudToUpdate не равен null
        if (idStudToUpdate != null) {
            // Для обновления требуется объект из базы данных
            User userForEdit = getUserById(idStudToUpdate);
            if (userForEdit == null) {
                // Нечего обновлять
                msgUp = MsgForUser.ERR_NOT_IN_MSG.getText();
            } else {
                // Проверяем наличие других записей с теми же данными
                Long studInDB = getIdByKeyset(studForUpdate);
                if (studInDB == null || (studInDB.equals(idStudToUpdate))) {
                    Transaction transaction = null;
                    try (Session session = HibernateUtil.getSessionFactory().openSession()) {
                        // Начинаем транзакцию
                        transaction = session.beginTransaction();
                        // Обновляем объект
                        session.update(studForUpdate);
                        // Фиксируем транзакцию
                        transaction.commit();
                    } catch (Exception e) {
                        if (transaction != null) {
                            transaction.rollback();
                        }
                        msgUp = MsgForUser.ERR_UPD_MSG.getText();
                    }
                } else {
                    msgUp = MsgForUser.ERR_DOUBLE_MSG.getText();
                }
            }
        } else {
            // Если idStudToUpdate равен null, возвращаем сообщение об ошибке
            msgUp = MsgForUser.ERR_ID_NULL_MSG.getText();
        }
        return msgUp;
    }

    public static void banUser(int userId) {
        System.out.println("UserDAO: Attempting to ban user with ID: " + userId);
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction transaction = session.beginTransaction();
            User user = session.get(User.class, userId);
            if (user != null) {
                System.out.println("UserDAO: Found user: " + user.getUserName() + " (ID: " + user.getUserId() + ")");
                user.setIsbanned(1);
                session.update(user);
                transaction.commit();
                System.out.println("UserDAO: Successfully banned user with ID: " + userId);
            } else {
                System.out.println("UserDAO: User not found with ID: " + userId);
            }
        } catch (Exception e) {
            System.out.println("UserDAO: Error banning user with ID: " + userId);
            e.printStackTrace();
        }
    }

    public static void unbanUser(int userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction transaction = session.beginTransaction();
            User user = session.get(User.class, userId);
            if (user != null) {
                user.setIsbanned(0);
                session.update(user);
                transaction.commit();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


}
