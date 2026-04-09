package BudgetTracker;

import lombok.*;

import java.time.LocalDate;

@ToString
@AllArgsConstructor
@Getter
@Setter
public class Expense {
    private String category;
    private double amount;
    private LocalDate date;
}