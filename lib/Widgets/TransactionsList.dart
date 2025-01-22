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
  final ScrollController _scrollController = ScrollController();
  final Database _database = Database();

  @override
  void initState() {
    super.initState();
    _database.fetchTransactionsFromFirestore(); // Initial data fetch

    // Listen for scroll events
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Load more data when scrolled to the bottom
        _database.fetchTransactionsFromFirestore(loadMore: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Consumer<Database>(
          builder: (context, db, child) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: db.transactions.length + 1, // Extra item for loading indicator
              itemBuilder: (context, index) {
                if (index < db.transactions.length) {
                  final transaction = db.transactions[index];
                  return TransactionItem(
                    value: transaction
                  );
                } else {
                  // Show a loading indicator at the bottom
                  return db.transactions.isNotEmpty && _database.hasMoreData
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox();
                }
              },
            );
          },
        ),
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
