package BudgetTracker;

import lombok.ToString;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@ToString
public class ExpenseManager {
    private final List<Expense> expenses = new ArrayList<>();

    Scanner scanner = new Scanner(System.in);
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy");

    public void addExpense(){
        String category;
        while (true) {
            System.out.print("Enter category: ");
            category = scanner.next();
            if (category.matches("^[A-Za-z]+")) {
                category = category.substring(0, 1).toUpperCase() + category.substring(1).toLowerCase();
                break;
            } else {
                System.out.println("Invalid category! Only letters allowed.");
            }
        }

        double amount;
        while (true) {
            System.out.print("Enter amount: ");
            try{
                amount = Double.parseDouble(scanner.next().replace(",", "."));
            }catch(NumberFormatException e){
                System.out.println("Invalid amount!");
                continue;
            }
            if (amount <= 0) {
                System.out.println("Amount must be a positive number.");
            } else {
                break;
            }
        }

      //  LocalDate date = LocalDate.now(); // for tests
                LocalDate date = null;
                while (date == null) {
                    System.out.print("Enter date (day.month.year): ");
                    String inputDate = scanner.next();
                    try{
                        date = LocalDate.parse(inputDate, formatter);
                    } catch (Exception e){
                        System.out.println("Invalid date format! Please try again.");
                    }
                }

        Expense expense = new Expense(category, amount, date);
        expenses.add(expense);
        System.out.println("Expense added successfully!");


    }

    public double totalExpenses() {
        return expenses.stream()
                .mapToDouble(Expense::getAmount)
                .sum();
    }

    public void getTotalAmount() {
        if (totalExpenses() == 0) {
            System.out.println("No expenses recorded");
        } else {
            System.out.printf("Total amount of expenses: %.2f\n", totalExpenses());
        }

    }

    public Map<String, Double> getCategoryExpenses() {
        if (expenses.isEmpty()) {
            System.out.println("No expenses recorded");
        }
        Map<String, Double> expenseMap = new HashMap<>();
        for (Expense expense : expenses) {
            String category = expense.getCategory();
            double amount = expense.getAmount();
            if (expenseMap.containsKey(category)) {
                double currentAmount = expenseMap.get(category);
                expenseMap.put(category, currentAmount + amount);
            } else {
                expenseMap.put(category, amount);
            }
        }
        return expenseMap;
    }


    public void printCategoryExpenses(){
        if (expenses.isEmpty()) {
            System.out.println("No expenses recorded");
        } else{
            Map<String, Double> expenseMap = getCategoryExpenses();
            System.out.println("Expenses by Category:");
            for (Map.Entry<String, Double> entry : expenseMap.entrySet()) {
                double percent = (entry.getValue() / totalExpenses()) * 100;
                System.out.printf("%s: %.2f (%.2f%%) \n",entry.getKey(), entry.getValue(), percent);
            }
            getTotalAmount();
        }
    }


    public void sortByDate() {
        if (expenses.isEmpty()) {
            System.out.println("No expenses recorded");
        } else {
            System.out.print("Please enter the date sort from(day.month.year): ");
            String dateFrom = scanner.next();
            System.out.print("Please enter the date sort to(day.month.year): ");
            String dateTo = scanner.next();
            LocalDate from = null;
            LocalDate to = null;
            try {
                from = LocalDate.parse(dateFrom, formatter);
                to = LocalDate.parse(dateTo, formatter);
            } catch (Exception e) {
                System.out.println("Error. Please enter a valid date, like 12.08.2025 ");
            }

            assert to != null;
            if (to.isBefore(from)) {
                System.out.println("Error: End date cannot be before start date.");
                return;
            }

            boolean found = false;
            System.out.printf("Sorted by date from %s to %s.\n", formatter.format(from), formatter.format(to));
            for (Expense expense : expenses) {
                if (!expense.getDate().isBefore(from) && !expense.getDate().isAfter(to)) {
                    System.out.printf("%s: %.2f \n",expense.getCategory(), expense.getAmount());
                    found = true;
                }
            }
            if (!found) {
                System.out.println("No expenses found in this period");
            }
        }
    }

    public void sortCategoryByName() {
        if (expenses.isEmpty()) {
            System.out.println("No expenses recorded");
        }
        expenses.sort(Comparator.comparing(Expense::getCategory));
        expenses.stream()
                .sorted(Comparator.comparing(Expense::getCategory))
                .forEach(expense -> System.out.printf("%s: %.2f (%s) \n",expense.getCategory(), expense.getAmount(),
                        formatter.format(expense.getDate())));

    }

    public void sortByAmount() {
        if (expenses.isEmpty()) {
            System.out.println("No expenses recorded");
        } else {
            System.out.println("Please choose (1 - by increasing price, 2 - by decreasing price): ");
            int type = scanner.nextInt();
            if (type == 1) {
                expenses.stream()
                        .sorted(Comparator.comparing(Expense::getAmount))
                        .forEach(expense -> System.out.printf("%s: %.2f \n",expense.getCategory(),expense.getAmount()));
            } else if (type == 2){
                expenses.stream()
                        .sorted(Comparator.comparing(Expense::getAmount).reversed())
                        .forEach(expense -> System.out.printf("%s: %.2f \n",expense.getCategory(),expense.getAmount()));
            }
        }


    }

    public int tryCathException(Scanner sc){
        int choice = -1;
        try{
            choice = sc.nextInt();
        }catch(InputMismatchException e){
            System.out.println("Invalid input! Please enter a number from the menu.");
            sc.nextLine();

        }
        return choice;
    }


    public void printAllExpenses() {
        if (expenses.isEmpty()) {
            System.out.println("No expenses recorded");
        } else {
            System.out.println("Your expenses:");
            for (Expense expense : expenses) {
                System.out.printf("%s: %.2f - %s\n",expense.getCategory(), expense.getAmount(), formatter.format(expense.getDate()));
            }
        }
    }

    // test new topic
    public void saveAllExpenses() {
        if (expenses.isEmpty()) {
            System.out.println("No expenses recorded");
        } else {
            String fileName = "All expense.txt";
            try(BufferedWriter bw = new BufferedWriter(new FileWriter(fileName))) {
                bw.write("Your expenses: \n");
                for (Expense expense : expenses) {
                    bw.write(expense.getCategory() + ": " + expense.getAmount() + " ("+ formatter.format(expense.getDate()) + ")" +"\n");
                }
                System.out.println("File saved to: " + fileName);
            } catch (IOException e) {
                System.out.println("Error with file: " + fileName);
            }
        }
    }
}