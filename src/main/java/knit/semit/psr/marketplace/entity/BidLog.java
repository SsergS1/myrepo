package knit.semit.psr.marketplace.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@Entity
@Table(name = "bidlog")
public class BidLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "bidLogID")
    private int bidLogId;

    @ManyToOne
    @JoinColumn(name = "liveAuctionID", referencedColumnName = "liveAuctionID")
    private LiveAuction liveAuction;

    @ManyToOne
    @JoinColumn(name = "userID", referencedColumnName = "userID")
    private User user;

    @Column(name = "bidAmount")
    private BigDecimal bidAmount;

    @Column(name = "bidTime")
    private LocalDateTime bidTime;

    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("hh:mm:ss a, d MMMM, yyyy", Locale.ENGLISH);

    public String getFormattedBidTime() {
        return bidTime.format(formatter);
    }
}
