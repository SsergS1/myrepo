    package knit.semit.psr.marketplace.entity;

    import jakarta.persistence.*;
    import lombok.AllArgsConstructor;
    import lombok.Getter;
    import lombok.NoArgsConstructor;
    import lombok.Setter;

    import java.math.BigDecimal;
    import java.util.List;

    @AllArgsConstructor
    @NoArgsConstructor
    @Setter
    @Getter
    @Entity
    @Table(name = "product")
    public class Product {
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        @Column(name = "productID")
        private int productId;

        @Column(name = "productName")
        private String productName;

        @Column(name = "productPic")
        private String productPic;

        @Column(name = "productPrice")
        private BigDecimal productPrice;

        @Column(name = "productInfo")
        private String productInfo;

        @ManyToOne
        @JoinColumn(name = "sellerID", referencedColumnName = "userID")
        private User seller;

        @ManyToOne
        @JoinColumn(name = "categoryID", referencedColumnName = "categoryID")
        private Category category;

        @Column(name = "isApproved")
        private boolean isApproved;

        @Column(name = "isOrdered")
        private boolean isOrdered;

        @OneToMany(mappedBy = "product", fetch = FetchType.LAZY)
        private List<AuctionRequest> auctionRequests;

        @Transient
        private String auctionRequestStatus;

        public String getAuctionRequestStatus() {
            if (auctionRequests != null && !auctionRequests.isEmpty()) {
                return auctionRequests.get(0).getRequestStatus().name(); // Assuming the latest request is the first one
            }
            return "NO_REQUEST";
        }
    }