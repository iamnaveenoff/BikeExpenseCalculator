import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/expense_model.dart';

class ExpensesProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  DateTime _selectedDate = DateTime.now(); // Add selectedDate property

  List<Expense> get expenses => _expenses;
  DateTime get selectedDate => _selectedDate; // Getter for selectedDate

  Future<void> fetchExpenses() async {
    try {
      _expenses = await DatabaseHelper.instance.getExpenses();
      notifyListeners(); // Notify listeners after updating the list
    } catch (e) {
      // Handle the error appropriately (e.g., log it or show an error message)
      rethrow;
    }
  }

  Future<void> addExpense(Expense expense) async {
    await DatabaseHelper.instance.insertExpense(expense);
    await fetchExpenses(); // Update the list after adding a new expense
  }

  Future<void> updateExpense(Expense updatedExpense) async {
    await DatabaseHelper.instance.updateExpense(updatedExpense);
    // Update the _expenses list with the updated expense
    final index =
        _expenses.indexWhere((expense) => expense.id == updatedExpense.id);
    if (index != -1) {
      _expenses[index] = updatedExpense;
      notifyListeners();
    }
  }

  Future<void> deleteExpense(int id) async {
    await DatabaseHelper.instance.deleteExpense(id);
    await fetchExpenses(); // Update the list after deleting an expense
  }

  // Method to set the selected date
  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      notifyListeners();
    }
  }

  void updateExpenseDetails(Expense updatedExpense) {
    final index =
        _expenses.indexWhere((expense) => expense.id == updatedExpense.id);
    if (index != -1) {
      _expenses[index] = updatedExpense;
      notifyListeners();
    }
  }
}
