package knit.semit.psr.marketplace.entity;


import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@Entity
@Table(name = "liveauction")
public class LiveAuction {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "liveAuctionID")
    private int liveAuctionId;

    @ManyToOne
    @JoinColumn(name = "auctionID", referencedColumnName = "auctionID")
    private Auction auction;

    @Column(name = "currentBid")
    private BigDecimal currentBid;

    @ManyToOne
    @JoinColumn(name = "currentBidder", referencedColumnName = "userID")
    private User currentBidder;

    @Column(name = "auctionStartTime")
    private LocalDateTime auctionStartTime;

    @Column(name = "auctionEndTime")
    private LocalDateTime auctionEndTime;


}
