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
@Table(name = "user")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "userID")
    private int userId;

    @Column(name = "userName")
    private String userName;

    @Column(name = "userLN")
    private String userLn;

    @Column(name = "userEmail", unique = true)
    private String userEmail;

    @Column(name = "userPsw")
    private String userPsw;

    @ManyToOne
    @JoinColumn(name = "roleID", referencedColumnName = "roleID")
    private Role role;

    @Column(name = "userInfo")
    private String userInfo;

    @Column(name = "isbanned")
    private int isbanned;

    public User(String userName, String userLn, String userEmail, String userPsw, Role role, String userInfo) {
        this.userId = 0;
        this.userName = userName;
        this.userLn = userLn;
        this.userEmail = userEmail;
        this.userPsw = userPsw;
        this.role = role;
        this.userInfo = userInfo;
        this.isbanned = 0;
    }

    public User(String newUser) {

        this.userId = 0;
        this.userName = newUser;
        this.userLn = "";
        this.userEmail = "";
        this.userPsw = "";
        this.role = null;
        this.userInfo = "";
        this.isbanned = 0;
    }

    public User(String userName, String userLn, String userEmail, String userInfo) {
        this.userName = userName;
        this.userLn = userLn;
        this.userEmail = userEmail;
        this.userInfo = userInfo;
        this.isbanned = 0;
    }
}