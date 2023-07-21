class Expense {
  int? id; // Marking 'id' as non-nullable and required.
  String title;
  double amount;
  DateTime date;

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
  });

  // Convert Expense object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
    );
  }
}
