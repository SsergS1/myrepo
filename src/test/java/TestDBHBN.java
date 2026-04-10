import jakarta.transaction.Transaction;
import knit.semit.psr.marketplace.daohbn.*;
import knit.semit.psr.marketplace.entity.*;
import knit.semit.psr.marketplace.utils.HibernateUtil;
import org.hibernate.Session;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.util.List;

import static org.hibernate.validator.internal.util.Contracts.assertNotNull;
import static org.junit.jupiter.api.Assertions.*;

public class TestDBHBN {
    private static Session session;
    private Transaction transaction;

    List<Auction> Alist;
    List<Product> Plist;
    List<Category> Clist;
    List<Bucket> Blist;
    List<User> Ulist;

    @BeforeAll
    static void beforeAll() {
        session = HibernateUtil.getSessionFactory().openSession();
        System.out.println("\n\nHIBERNATE підключивася до БД!!!");

    }
    //start=====================================================
    @Test
    void simpleStart(){

    }

    @Test
    public void testGetAllUsers() {
        Ulist = UserDAO.getAllUsers();
        Ulist.stream().forEach(user -> System.out.println(user.getUserName()));
    }

    @Test
    public void testGetAllAuctions() {
        Alist = AuctionDAO.getAlllist();
        Alist.stream().forEach(System.out::println);
        System.out.println(AuctionDAO.getAlllist().get(0).getAuctionName());
        System.out.println();
    }
    @Test
    void getByIdTest(){
        long idToFind = 2l;
        Auction auc = AuctionDAO.getAuctionById(idToFind);
        assertNotNull(auc); // Проверяем, что аукцион был найден
        System.out.println("Auction ID: " + auc.getAuctionId());
        System.out.println("Auction Name: " + auc.getAuctionName());
        System.out.println("Auction Start Time: " + auc.getAuctionStartTime());
        System.out.println("Auction End Time: " + auc.getAuctionEndTime());
        System.out.println("Product: " + auc.getProduct());
        System.out.println("Buyer: " + auc.getBuyer());
        System.out.println("Admin: " + auc.getAdmin());
    }

    @Test
    public void testGetWinnerAndProductForAuction() {
        long auctionId = 2; // Замените на реальный ID аукциона для вашего теста
        Auction auction = AuctionDAO.getAuctionById(auctionId);
        assertNotNull(auction, "Auction should not be null");

        User winner = BidLogDAO.getWinnerForAuction((int) auctionId);
        assertNotNull(winner, "Winner should not be null");

        Product product = auction.getProduct();
        assertNotNull(product, "Product should not be null");

        System.out.println("Auction Name: " + auction.getAuctionName());
        System.out.println("Winner: " + winner.getUserName());
        System.out.println("Product Name: " + product.getProductName());
    }


    @Test
    void testGetHighestBidAmountForAuction() {
        long liveAuctionId = 2;
        BigDecimal highestBidAmount = BidLogDAO.getHighestBidAmountForAuction(liveAuctionId);
        assertNotNull(highestBidAmount);
        System.out.println("ID аукциона: " + liveAuctionId);
        System.out.println("Максимальная ставка: " + highestBidAmount);
        assertTrue(highestBidAmount.compareTo(BigDecimal.ZERO) >= 0);
    }

    @Test
    void getUserTest(){
        long
                idToFind = 15l;
        User us = UserDAO.getUserById(idToFind);
        Assertions.assertEquals(us.getUserName(),"Tommy");
        System.out.println(us);
    }
    @Test
    void getIdByKeySetTest(){
        User userToFind = new User(null, null,"Andriyov@example.com",null,null,null);
        Long idInDB = UserDAO.getIdByKeyset(userToFind);
        Assertions.assertEquals(idInDB,23);
        System.out.println("idInDB =" + idInDB);
    }

    @Test
    void getAllProduct(){
        Plist = ProductDAO.getAllProduct();
//        Plist.stream().forEach(System.out::println);
        Plist.stream().forEach(product -> System.out.println(product.getProductName()));
    }
    @Test
    void getAllСategory(){
        Clist = CategoryDAO.getAllCategories();
        Clist.forEach(category -> System.out.println(category.getCategoryName()));
    }

    @Test
    public void testPrintProductsBySellerId() {
        int sellerId = 15; // Здесь укажите id продавца, для которого хотите вывести продукты
        List<Product> products = ProductDAO.getProductsBySellerId(sellerId);

        // Проверка, что список продуктов не пустой
        if (!products.isEmpty()) {
            System.out.println("Продукты продавца с ID " + sellerId + ":");
            for (Product product : products) {
                System.out.println("Название: " + product.getProductName());
                System.out.println("Информация: " + product.getProductInfo());
                System.out.println("-------------------------------");
            }
        } else {
            System.out.println("У продавца с ID " + sellerId + " нет продуктов.");
        }
    }

    @Test
    public void testGetMaxBidAmountAndAuctionName() {
        int auctionId = 30; // Replace with a valid auction ID from your database
        String auctionName = AuctionDAO.getAuctionNameById(auctionId);
        BigDecimal maxBidAmount = BidLogDAO.getHighestBidAmountForAuction(auctionId);

        assertNotNull(auctionName, "Auction name should not be null");
        assertNotNull(maxBidAmount, "Max bid amount should not be null");

        System.out.println("Auction Name: " + auctionName);
        System.out.println("Max Bid Amount: " + maxBidAmount);
    }

//    @Test
//    public void getAllbucket(){
//        Blist = BucketDAO.getAllBucket(); //AuctionDAO.getAlllist();
//        Blist.stream().forEach(bucket -> {
//            System.out.println("Bucket ID: " + bucket.getBucketId());
//            System.out.println("User Name: " + bucket.getUser().getUserName());
//            System.out.println("Product Name: " + bucket.getProduct().getProductName());
//        });
//
//    }
//    @Test
//    public void testGetOrdersByUserId() {
//       int userId = 23;
//
//        // Получаем список заказов пользователя
//        List<Order> orders = OrderDAO.getOrdersByUserId(userId);
//
//        // Проверяем, что список заказов не пустой
//        assertNotNull(orders);
//
//        // Проверяем, что список заказов содержит хотя бы один элемент
//        assertTrue(orders.size() > 0);
//
//        // Выводим информацию о каждом заказе (название продукта и адрес)
//        for (Order order : orders) {
//            System.out.println("Order ID: " + order.getOrderId());
//            System.out.println("Product Name: " + order.getBucket().getProduct().getProductName());
//            System.out.println("Order Address: " + order.getOrderAddress());
//            System.out.println("--------------------------");
//        }
//    }
//    @Test
//    public void testGetWinnerForAuction() {
//        int auctionId = 1; // Замените на реальный ID аукциона для вашего теста
//        User winner = BidLogDAO.getWinnerForAuction(auctionId);
//        assertNotNull(winner, "Winner should not be null");
//        System.out.println("Auction ID: " + auctionId);
//        System.out.println("Winner: " + winner.getUserName()); // Предполагается, что есть метод getUserName() в классе User
//    }


    //end=========================================================
    @AfterAll
    static void afterAll() {
        System.out.println("\n\nHIBERNATE завершив роботу!!!");
        HibernateUtil.shutdown();
    }
}
