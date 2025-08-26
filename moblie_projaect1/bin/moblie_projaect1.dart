// Install Package: dart pub add http

import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class Expense {
  int id;
  String item;
  double amount;
  DateTime date;

  Expense(this.id, this.item, this.amount, this.date);

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      json['id'],
      json['item'],
      json['paid'].toDouble(),
      DateTime.parse(json['date']),
    );
  }
}

Future<void> main() async {
  await login();
}

// Login ****Nook****
Future<void> login() async {
  print("===== Login =====");
  stdout.write("Username: ");
  String? username = stdin.readLineSync()?.trim();
  stdout.write("Password: ");
  String? password = stdin.readLineSync()?.trim();
  if (username == null || password == null) {
    print("Incomplete input");
    return;
  }

  final body = {"username": username, "password": password};
  final url = Uri.parse('http://localhost:3000/login');
  final response = await http.post(url, body: body);

  if (response.statusCode == 200) {
    // Assuming response.body contains "Login OK" or user details
    String loggedInUser = username; // Use username for now
    await runExpenseApp(loggedInUser);
  } else if (response.statusCode == 401 || response.statusCode == 500) {
    final result = response.body;
    print(result);
  } else {
    print("Unknown error");
  }
}

// ****Nook****
Future<List<Expense>> fetchExpenses(String username) async {
  final url = Uri.parse('http://localhost:3000/expenses/$username');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Expense.fromJson(json)).toList();
  } else {
    print("Failed to load expenses: ${response.body}");
    return [];
  }
}

Future<void> runExpenseApp(String username) async {
  while (true) {
    print('\n${'=' * 20} Expense Tracking App ${'=' * 20}');
    print('Welcome $username');
    print('1. All expenses');
    print('2. Today\'s expense');
    print('3. Search expense');
    print('4. Add new expense');
    print('5. Delete an expense');
    print('6. Exit');
    stdout.write('Choose: ');

    String? choice = stdin.readLineSync();
    print('');

    switch (choice) {
      // All expenses ****Gus****

      // Today's expense ****Gus****

      // Search expense ****Gus****

      // Add new expense ****Bua****

      // Delete an expense ****Gus****

      // Exit ****Bua****

      default:
        print("Invalid choice!");
    }
  }
}
