import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/expense_model.dart';
import '../providers/expense_provider.dart';
import 'add_expense_screen.dart';
import 'expense_detail_screen.dart';

class ExpenseListScreen extends StatefulWidget {
  @override
  _ExpenseListScreenState createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the expenses from the database when the widget is first inserted
    Provider.of<ExpensesProvider>(context, listen: false).fetchExpenses();
  }

  @override
  Widget build(BuildContext context) {
    final expensesProvider = Provider.of<ExpensesProvider>(context);
    final List<Expense> expenses = expensesProvider.expenses;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to the AddExpenseScreen to add a new expense
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AddExpenseScreen()));
            },
          ),
        ],
      ),
      body: expenses.isEmpty
          ? const Center(
              child: Text('No expenses found.'),
            )
          : ExpenseListView(
              expenses: expenses,
            ),
    );
  }
}

class ExpenseListView extends StatelessWidget {
  final List<Expense> expenses;

  ExpenseListView({required this.expenses});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return Dismissible(
          key: Key(expense.id.toString()),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            final expensesProvider =
                Provider.of<ExpensesProvider>(context, listen: false);
            expensesProvider.deleteExpense(expense.id!);
          },
          child: ListTile(
            title: Text(expense.title),
            subtitle: Text(
              'Amount: \₹${expense.amount.toStringAsFixed(2)}\nDate: ${DateFormat('dd-MM-yyyy').format(expense.date)}',
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Implement navigation to the expense detail screen here
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExpenseDetailScreen(expense: expense),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
