package knit.semit.psr.marketplace.daohbn;

import jakarta.persistence.TypedQuery;
import jakarta.persistence.criteria.*;
import knit.semit.psr.marketplace.entity.AuctionRequest;
import knit.semit.psr.marketplace.entity.Product;
import knit.semit.psr.marketplace.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.ArrayList;
import java.util.List;

import static knit.semit.psr.marketplace.utils.HibernateUtil.getSessionFactory;



public class ProductDAO {

    public static List<Product> getAllProduct() {
        Session session = getSessionFactory().openSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery cq = cb.createQuery(Product.class);
        Root rootEntry = cq.from(Product.class);
        CriteriaQuery all = cq.select(rootEntry);
        TypedQuery allQuery = session.createQuery(all);
        return allQuery.getResultList();
    }
    public static List<Product> getAllApprovedProducts() {
        Session session = getSessionFactory().openSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Product> cq = cb.createQuery(Product.class);
        Root<Product> root = cq.from(Product.class);
        // чтобы выбрать только одобренные и не заказанные продукты
        cq.select(root).where(cb.equal(root.get("isApproved"), true), cb.equal(root.get("isOrdered"), false));
        TypedQuery<Product> query = session.createQuery(cq);
        return query.getResultList();
    }
    public static Product getProductById(int productId) {
        Session session = getSessionFactory().openSession();
        return session.get(Product.class, productId); // Возвращаем продукт по его ID
    }

    public static List<Product> getProductsToApprove() {
        Session session = getSessionFactory().openSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Product> cq = cb.createQuery(Product.class);
        Root<Product> root = cq.from(Product.class);

        // Добавляем условие, чтобы выбрать только продукты, которые еще не одобрены
        cq.select(root).where(cb.equal(root.get("isApproved"), false));

        TypedQuery<Product> query = session.createQuery(cq);
        return query.getResultList();
    }

//    public static List<Product> getProductsBySellerId(int sellerId) {
//        List<Product> products = null;
//        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
//            Query<Product> query = session.createQuery("FROM Product WHERE seller.userId = :sellerId", Product.class);
//            query.setParameter("sellerId", sellerId);
//            products = query.getResultList();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return products;
//    }

    public static List<Product> getProductsBySellerId(int sellerId) {
        Session session = null;
        List<Product> products = null;
        try {
            session = getSessionFactory().openSession();
            String hql = "FROM Product p LEFT JOIN FETCH p.auctionRequests WHERE p.seller.userId = :sellerId";
            Query<Product> query = session.createQuery(hql, Product.class);
            query.setParameter("sellerId", sellerId);
            products = query.getResultList();
        } finally {
            if (session != null) {
                session.close();
            }
        }
        return products;
    }

//    Для чего-то другого
//    public static void updateProduct(Product product) {
//        Transaction transaction = null;
//        try (Session session = getSessionFactory().openSession()) {
//            // Начинаем транзакцию
//            transaction = session.beginTransaction();
//            // Обновляем продукт в базе данных
//            session.update(product);
//            // Фиксируем изменения, выполняем коммит транзакции
//            transaction.commit();
//        } catch (Exception e) {
//            // Если произошла ошибка, откатываем транзакцию
//            if (transaction != null) {
//                transaction.rollback();
//            }
//            e.printStackTrace();
//        }
//    }

    public static void updateProduct(Product product) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = getSessionFactory().openSession();
            transaction = session.beginTransaction();

            session.merge(product);  // Use merge instead of update

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    public static void saveProduct(Product product) {
        Transaction transaction = null;
        try (Session session = getSessionFactory().openSession()) {
            // Начинаем транзакцию
            transaction = session.beginTransaction();
            // Сохраняем продукт в базе данных
            session.save(product);
            // Фиксируем изменения, выполняем коммит транзакции
            transaction.commit();
        } catch (Exception e) {
            // Если произошла ошибка, откатываем транзакцию
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }
    public static void deleteProduct(int productId) {
        Transaction transaction = null;
        try  (Session session = getSessionFactory().openSession()) {
            // Начинаем транзакцию
            transaction = session.beginTransaction();
            // Получаем продукт по его ID
            Product product = session.get(Product.class, productId);
            // Удаляем продукт из базы данных
            session.delete(product);
            // Фиксируем изменения, выполняем коммит транзакции
            transaction.commit();
        } catch (Exception e) {
            // Если произошла ошибка, откатываем транзакцию
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }

    public static List<Product> getAvailableProductsForMarketplace() {
        Session session = getSessionFactory().openSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Product> cq = cb.createQuery(Product.class);
        Root<Product> root = cq.from(Product.class);
        cq.select(root).where(
                cb.and(
                        cb.equal(root.get("isApproved"), true),
                        cb.equal(root.get("isOrdered"), false)
                )
        );
        TypedQuery<Product> query = session.createQuery(cq);
        List<Product> products = query.getResultList();

        // Фильтруем продукты, которые не находятся на аукционе
        products.removeIf(product -> AuctionDAO.isProductInAuction(product.getProductId()));

        return products;
    }

    public static void markProductAsOrdered(int productId) {
        Transaction transaction = null;
        try (Session session = getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Product product = session.get(Product.class, productId);
            if (product != null) {
                product.setOrdered(true);
                session.update(product);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
    }
    public static Product findById(int productId) {
        try (Session session = getSessionFactory().openSession()) {
            return session.get(Product.class, productId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    public static List<Product> getAvailableProductsForAuction() {
        return getAvailableProductsForMarketplace(); // Используем тот же метод, так как требования идентичны
    }
    // Новый метод для получения фильтрованных продуктов
    public static List<Product> getFilteredProductsForMarketplace(String categoryId, String priceOrder, String searchQuery) {
        Session session = getSessionFactory().openSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Product> cq = cb.createQuery(Product.class);
        Root<Product> root = cq.from(Product.class);

        // Basic conditions: approved and not ordered products
        Predicate isApproved = cb.equal(root.get("isApproved"), true);
        Predicate isNotOrdered = cb.equal(root.get("isOrdered"), false);
        List<Predicate> predicates = new ArrayList<>();
        predicates.add(isApproved);
        predicates.add(isNotOrdered);

        // Filter by category
        if (categoryId != null && !categoryId.isEmpty()) {
            predicates.add(cb.equal(root.get("category").get("categoryId"), Integer.parseInt(categoryId)));
        }

        // Search by product name
        if (searchQuery != null && !searchQuery.isEmpty()) {
            predicates.add(cb.like(cb.lower(root.get("productName")), "%" + searchQuery.toLowerCase() + "%"));
        }

        // Exclude products with pending or on-auction requests
        Subquery<Integer> subquery = cq.subquery(Integer.class);
        Root<AuctionRequest> subRoot = subquery.from(AuctionRequest.class);
        subquery.select(subRoot.get("productID"))
                .where(cb.and(
                        cb.equal(subRoot.get("productID"), root.get("productId")),
                        cb.or(
                                cb.equal(subRoot.get("requestStatus"), AuctionRequest.RequestStatus.PENDING),
                                cb.equal(subRoot.get("requestStatus"), AuctionRequest.RequestStatus.ON_THE_AUCTION)
                        )
                ));
        predicates.add(cb.not(cb.exists(subquery)));

        // Apply all filters
        cq.where(predicates.toArray(new Predicate[0]));

        // Sort by price
        if (priceOrder != null && priceOrder.equals("asc")) {
            cq.orderBy(cb.asc(root.get("productPrice")));
        } else if (priceOrder != null && priceOrder.equals("desc")) {
            cq.orderBy(cb.desc(root.get("productPrice")));
        }

        TypedQuery<Product> query = session.createQuery(cq);
        List<Product> products = query.getResultList();
        session.close();

        return products;
    }
}

