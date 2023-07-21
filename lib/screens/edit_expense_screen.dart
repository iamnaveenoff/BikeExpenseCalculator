import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/expense_model.dart';
import '../providers/expense_provider.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;

  const EditExpenseScreen({super.key, required this.expense});

  @override
  // ignore: library_private_types_in_public_api
  _EditExpenseScreenState createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.expense.title;
    _amountController.text = widget.expense.amount.toString();
    _selectedDate = widget.expense.date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value?.trim().isEmpty ?? true) {
                  return 'Please enter a title.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value?.trim().isEmpty ?? true) {
                  return 'Please enter an amount.';
                }
                if (double.tryParse(value!) == null) {
                  return 'Please enter a valid amount.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                'Expense Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
              ),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _saveUpdatedExpense(context),
              child: const Text('Save Expense'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveUpdatedExpense(BuildContext context) async {
    final updatedExpense = Expense(
      id: widget.expense.id,
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      date: _selectedDate,
    );

    // Update the expense using the ExpensesProvider
    final expensesProvider =
        Provider.of<ExpensesProvider>(context, listen: false);
    await expensesProvider.updateExpense(updatedExpense);

    // Navigate back to the ExpenseDetailScreen after updating the expense
    Navigator.pop(context, updatedExpense);
  }
}
