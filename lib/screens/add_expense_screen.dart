import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/expense_model.dart';
import '../providers/expense_provider.dart';

class AddExpenseScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an amount.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid amount.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text(
                  'Expense Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                ),
                onTap: () {
                  final expensesProvider =
                      Provider.of<ExpensesProvider>(context, listen: false);
                  expensesProvider.selectDate(context);
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final title = _titleController.text.trim();
                    final amount = double.parse(_amountController.text.trim());
                    final newExpense = Expense(
                      title: title,
                      amount: amount,
                      date:
                          Provider.of<ExpensesProvider>(context, listen: false)
                              .selectedDate,
                    );

                    final expensesProvider =
                        Provider.of<ExpensesProvider>(context, listen: false);
                    expensesProvider.addExpense(newExpense);

                    // Navigate back to the ExpenseListScreen after adding the expense
                    Navigator.pop(context);
                  }
                },
                child: Text('Save Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
