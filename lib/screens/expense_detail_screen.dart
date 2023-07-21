import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/expense_model.dart';
import '../providers/expense_provider.dart';
import 'edit_expense_screen.dart';

class ExpenseDetailScreen extends StatefulWidget {
  final Expense? expense;

  const ExpenseDetailScreen({Key? key, required this.expense})
      : super(key: key);

  @override
  _ExpenseDetailScreenState createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  Expense? _editedExpense;

  @override
  void initState() {
    super.initState();
    _editedExpense = widget.expense;
  }

  void _navigateToEditExpense(BuildContext context, Expense expense) async {
    final updatedExpense = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditExpenseScreen(expense: expense),
      ),
    ) as Expense?;

    if (updatedExpense != null) {
      setState(() {
        _editedExpense = updatedExpense;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_editedExpense != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _editedExpense!.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Amount: \₹${_editedExpense!.amount.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date: ${DateFormat('yyyy-MM-dd').format(_editedExpense!.date)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            _navigateToEditExpense(context, _editedExpense!),
                        child: const Text('Edit'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final expensesProvider =
                              Provider.of<ExpensesProvider>(context,
                                  listen: false);
                          await expensesProvider
                              .deleteExpense(_editedExpense!.id!);
                          Navigator.pop(context);
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ],
              )
            else
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
