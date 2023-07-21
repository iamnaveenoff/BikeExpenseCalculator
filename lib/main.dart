import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/expense_model.dart';
import 'providers/expense_provider.dart';
import 'screens/expense_list_screen.dart';
import 'screens/expense_detail_screen.dart';
import 'screens/add_expense_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpensesProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Tracker',
        initialRoute: '/',
        routes: {
          '/': (_) => ExpenseListScreen(),
          '/addExpense': (_) => AddExpenseScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/expenseDetail') {
            final expense = settings.arguments as Expense;
            return MaterialPageRoute(
              builder: (_) => ExpenseDetailScreen(expense: expense),
            );
          }
          return null;
        },
      ),
    );
  }
}
