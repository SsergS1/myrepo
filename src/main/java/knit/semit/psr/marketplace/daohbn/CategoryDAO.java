package knit.semit.psr.marketplace.daohbn;

import jakarta.persistence.TypedQuery;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;
import knit.semit.psr.marketplace.entity.Category;
import knit.semit.psr.marketplace.utils.HibernateUtil;
import org.hibernate.Session;

import java.util.List;

public class CategoryDAO {

    public static List<Category> getAllCategories() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery cq = cb.createQuery(Category.class);
        Root rootEntry = cq.from(Category.class);
        CriteriaQuery all = cq.select(rootEntry);
        TypedQuery allQuery = session.createQuery(all);
        return allQuery.getResultList();
    }
}
