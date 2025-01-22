import 'dart:math';
import 'package:flutter/material.dart';
import 'package:finance_app/backend_API.dart';
import 'package:provider/provider.dart';

class Statisticspage extends StatelessWidget {
  const Statisticspage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Statistics Page')),
      ),
      body: const Column(children: [
        Text("What to do"),
      ],)
    );
  }

  Future<void> addRandomTransactions(BuildContext context, count) async {
    final random = Random();

    // Define sample data for randomization
    final List<String> categories = [
      "Food",
      "Transportation",
      "Utilities",
      "Housing",
      "Entertainment",
      "Education",
      "Shopping",
      "Personal Care",
      "Savings",
      "Debt Repayments",
      "Insurance",
    ];
    final List<String> subcategories = [
      'Takeout',
      'Groceries',
      'Snacks',
      'Coffee',
      'Restaurants'
    ];
    final List<String> locations = [
      'Mall',
      'Home',
      'Office',
      'Restaurant',
      'N/A'
    ];
    final List<String> descriptions = [
      'Lucky One Mall adventure',
      'Groceries at Carrefour',
      'Dinner at XYZ Restaurant',
      'Gas station refill',
      'Netflix subscription renewal',
      'Eating at no lies fries',
      'Indus biryani',
      'KFC Food',
    ];

    final DateTime today = DateTime.now();

    for (int i = 0; i < count; i++) {
      // Generate random data
      String category = categories[random.nextInt(categories.length)];
      String subcategory = subcategories[random.nextInt(subcategories.length)];
      String location = locations[random.nextInt(locations.length)];
      String description = descriptions[random.nextInt(descriptions.length)];
      String picture = 'None'; // Placeholder for picture field
      int price =
          (100 + random.nextInt(5000)); // Random price between 100 and 5100

      // Generate a random date within the last 30 days
      DateTime randomDate = today.subtract(Duration(days: random.nextInt(30)));
      String date = '${randomDate.day}-${randomDate.month}-${randomDate.year}';

      // Create a transaction map
      Map<String, dynamic> transactionData = {
        'Category': category,
        'Date': date,
        'Description': description,
        'Location': location,
        'Picture': picture,
        'Price': price,
        'Subcategory': subcategory,
      };

      // Add the transaction to Firestore
      try {
        Provider.of<Database>(context, listen: false)
            .addTransaction(transactionData);
        print('Transaction added: $transactionData');
      } catch (e) {
        print('Error adding transaction: $e');
      }
    }
  }
}
