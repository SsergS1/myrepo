package knit.semit.psr.marketplace.entity;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@Entity
public class BucketItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "bucketItemID")
    private int bucketItemId;

    @ManyToOne
    @JoinColumn(name = "bucketID", referencedColumnName = "bucketID")
    private Bucket bucket;

    @ManyToOne
    @JoinColumn(name = "productID", referencedColumnName = "productID")
    private Product product;

    @Column(name = "quantity")
    private int quantity;

    @ManyToOne
    @JoinColumn(name = "orderID", referencedColumnName = "orderID", nullable = true)
    private Order order;


}