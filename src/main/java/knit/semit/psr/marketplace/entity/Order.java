package knit.semit.psr.marketplace.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.util.Locale;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@Entity
@Table(name = "`order`")  // Escaping the table name
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long orderId;

    @ManyToOne
    @JoinColumn(name = "userID")
    private User user;

    @ManyToMany
    @JoinTable(
            name = "Order_BucketItem",
            joinColumns = @JoinColumn(name = "orderID"),
            inverseJoinColumns = @JoinColumn(name = "bucketItemID")
    )
    private List<BucketItem> bucketItems;

    private String orderAddress;
    private Date orderDate;
    private boolean orderStatus;

    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("hh:mm a, d MMMM, yyyy", Locale.ENGLISH);

    public String getFormattedOrderDate() {
        return LocalDateTime.ofInstant(orderDate.toInstant(), ZoneId.systemDefault()).format(formatter);
    }

    public BigDecimal getTotalPrice() {
        BigDecimal total = BigDecimal.ZERO;
        for (BucketItem item : bucketItems) {
            total = total.add(item.getProduct().getProductPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
        }
        return total;
    }

    public BigDecimal getTotalPriceWithDelivery() {
        BigDecimal deliveryFee = new BigDecimal("20.00");
        return getTotalPrice().add(deliveryFee);
    }
}
