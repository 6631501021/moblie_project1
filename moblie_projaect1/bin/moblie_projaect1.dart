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
      case '1':
        List<Expense> expenses = await fetchExpenses(username);
        if (expenses.isEmpty) {
          print('No expenses recorded.');
        } else {
          double total = 0;
          for (var expense in expenses) {
            print(
              '${expense.id}. ${expense.item} : ${expense.amount} THB : ${expense.date}',
            );
            total += expense.amount;
          }
          print('Total expenses = ${total.toInt()} THB');
        }
        break;

      // Today's expense ****Gus****

      case '2':
        List<Expense> expenses = await fetchExpenses(username);
        DateTime today = DateTime.now();
        var todayExpenses = expenses
            .where(
              (e) =>
                  e.date.day == today.day &&
                  e.date.month == today.month &&
                  e.date.year == today.year,
            )
            .toList();
        if (todayExpenses.isEmpty) {
          print('No expenses for today.');
        } else {
          double total = 0;
          for (var expense in todayExpenses) {
            print('${expense.item} : ${expense.amount} THB : ${expense.date}');
            total += expense.amount;
          }
          print('Total expenses = ${total.toInt()} THB');
        }
        break;

      // Search expense ****Gus****

      case '3': // Search expense
        stdout.write('Item to search: ');
        String? searchTerm = stdin.readLineSync();
        if (searchTerm != null && searchTerm.isNotEmpty) {
          List<Expense> expenses = await fetchExpenses(username);
          var found = expenses
              .where(
                (e) => e.item.toLowerCase().contains(searchTerm.toLowerCase()),
              )
              .toList();
          if (found.isEmpty) {
            print('No item: $searchTerm');
          } else {
            for (var expense in found) {
              print(
                '${expense.id}. ${expense.item} : ${expense.amount} THB : ${expense.date}',
              );
            }
          }
        }
        break;
      // Add new expense ****Bua****
  case '4': // Add new expense
        stdout.write('Item: ');
        String? item = stdin.readLineSync();
        stdout.write('Paid: ');
        double? amount = double.tryParse(stdin.readLineSync() ?? '');
        if (item != null && item.isNotEmpty && amount != null) {
          final url = Uri.parse('http://localhost:3000/expense');
          final body = {
            'username': username,
            'item': item,
            'paid': amount.toString(),
          }; // Convert double to String
          final response = await http.post(url, body: body);
          if (response.statusCode == 200) {
            print('Inserted!');
          } else {
            print('Failed to add expense: ${response.body}');
          }
        } else {
          print('Invalid input!');
        }
        break;
      // Delete an expense ****Bua****

      // Exit ****Bua****

      default:
        print("Invalid choice!");
    }
  }
}
