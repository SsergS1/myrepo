package knit.semit.psr.marketplace.entity;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@Entity
@Table(name = "auction")
public class Auction {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "auctionID")
    private int auctionId;

    @Column(name = "auctionName")
    private String auctionName;

    @Column(name = "auctionStartTime")
    private LocalDateTime auctionStartTime;

    @Column(name = "auctionEndTime")
    private LocalDateTime auctionEndTime;

    @ManyToOne
    @JoinColumn(name = "productID", referencedColumnName = "productID")
    private Product product;

    @ManyToOne
    @JoinColumn(name = "buyerID", referencedColumnName = "userID")
    private User buyer;

    @ManyToOne
    @JoinColumn(name = "adminID", referencedColumnName = "userID")
    private User admin;
    @Transient
    private boolean ended;

    @Transient
    private boolean notStarted;

    @Transient
    private boolean inProgress;

    private static final DateTimeFormatter Startformatter = DateTimeFormatter.ofPattern("hh:mm a, d MMMM, yyyy", Locale.ENGLISH);
    private static final DateTimeFormatter Endformatter = DateTimeFormatter.ofPattern("hh:mm a, d MMMM, yyyy", Locale.ENGLISH);

    public String getFormattedStartTime() {
        return auctionStartTime.format(Startformatter);
    }

    public String getFormattedEndTime() {
        return auctionEndTime.format(Endformatter);
    }
    public boolean isEnded() {
        return LocalDateTime.now().isAfter(auctionEndTime);
    }
    public boolean isNotStarted() {
        return LocalDateTime.now().isBefore(auctionStartTime);
    }

    public void setNotStarted(boolean notStarted) {
        this.notStarted = notStarted;
    }

    public boolean isInProgress() {
        LocalDateTime now = LocalDateTime.now();
        return now.isAfter(auctionStartTime) && now.isBefore(auctionEndTime);
    }

    public void setInProgress(boolean inProgress) {
        this.inProgress = inProgress;
    }
}
