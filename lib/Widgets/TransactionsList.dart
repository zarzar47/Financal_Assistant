import 'package:flutter/material.dart';
import '../backend_API.dart';
import 'package:provider/provider.dart';


// This is the actual list that DISPLAYS all of the transactions on the initial page
class Transactionslist extends StatefulWidget {
  const Transactionslist({super.key});

  @override
  State<StatefulWidget> createState() => TransactionsListState();
}

class TransactionsListState extends State<Transactionslist> {
  @override
  Widget build(BuildContext context) {
    final transactions =
        Provider.of<Database>(context).transactions.reversed.toList();

    return SizedBox(
      width: 300,
      child: ListView(
        reverse: false,
        children: transactions.map((value) {
          return TransactionItem(value: value);
        }).toList(),
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final TransactionInfo value;

  const TransactionItem({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Transaction Info"),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Price: Rs ${value.price}"),
                  Text("Category: ${value.category}"),
                  Text("Subcategory: ${value.subCategory}"),
                  Text("Date: ${value.date}"),
                  Text("Description: ${value.description}"),
                  Text("Location: ${value.location}"),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Warning"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                      "Are you sure you want to delete?"),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Database().deleteTransaction(
                                                value.transactionID);
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Yes")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("No")),
                                    ],
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    child: const Text("Delete")),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Close"),
                ),
              ],
            );
          },
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Price: Rs ${value.price}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Category: ${value.category}",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                "Date: ${value.date}",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
