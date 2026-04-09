package BudgetTracker;

import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.println("Welcome to Budget Tracker!");
        System.out.println("Please choose the option:");

        boolean isRunning = true;
        ExpenseManager expenseManager = new ExpenseManager();

        while (isRunning) {
            System.out.println("1. Add Expense");
            System.out.println("2. Show all expenses");
            System.out.println("3. Show total amount");
            System.out.println("4. Show category statistics");
            System.out.println("5. Sort Expenses");
            System.out.println("6. Save all expenses to file");
            System.out.println("0. Exit");
            System.out.print("> ");

            int choice = expenseManager.tryCathException(sc);

            if (choice == 1) {
                expenseManager.addExpense();
                boolean addMore = true;
                while (addMore) {
                    System.out.print("Do you want to add another expense? (1-yes, 2-no): ");
                    int addMoreChoice = sc.nextInt();
                    if (addMoreChoice == 1) {
                        expenseManager.addExpense();
                    } else if (addMoreChoice == 2) {
                        addMore = false;
                    }
                }
            } else if (choice == 2) {
                expenseManager.printAllExpenses();

            } else if (choice == 3) {
                expenseManager.getTotalAmount();
            } else if (choice == 4) {
                expenseManager.printCategoryExpenses();
            } else if (choice == 5) {
                boolean sortBy = true;
                while (sortBy) {
                    System.out.println("1. Sort by date");
                    System.out.println("2. Sort by amount");
                    System.out.println("3. Sort by category name");
                    System.out.println("0. Back to main menu");
                    System.out.print("> ");

                    int sortByChoice = expenseManager.tryCathException(sc);

                    if (sortByChoice == 1) {
                        expenseManager.sortByDate();
                    } else if (sortByChoice == 2) {
                        expenseManager.sortByAmount();
                    } else if (sortByChoice == 3) {
                        expenseManager.sortCategoryByName();
                    } else if (sortByChoice == 0) {
                        sortBy = false;
                    } else {
                        System.out.println("Invalid choice, please try again!");
                    }
                }

            } else if (choice == 6) {
                expenseManager.saveAllExpenses();
            } else if (choice == 0) {
                isRunning = false;
                System.out.println("Exiting...");
            } else {
                System.out.println("Invalid choice, please try again!");
            }
            System.out.println("=====".repeat(20));
        }
    }
}
