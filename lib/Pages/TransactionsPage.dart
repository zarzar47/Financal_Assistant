import 'package:flutter/material.dart';
import 'package:finance_app/Widgets/TransactionsList.dart';
import 'package:finance_app/Widgets/TransactionForm.dart';

class Transactionspage extends StatelessWidget {
  const Transactionspage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Transactions list')),
      ),
      body: const Stack(
        children: [
          // Transactions list
          Center(child: Transactionslist()),
          // Bottom-right button
          Align(alignment: Alignment(0.9, 0.9), child: AddTransactionButton()),
        ],
      ),
    );
  }
}
