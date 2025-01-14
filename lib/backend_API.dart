import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Categories {
  static List<String> primaryCategoryLists = [
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

  static Map<String, List<String>> subCategoryLists = {
    "Food": ["Groceries", "Restaurants", "Snacks", "Takeout", "Coffee"],
    "Transportation": [
      "Public Transport",
      "Fuel",
      "Ride-hailing",
      "Parking",
      "Maintenance",
      "Tickets"
    ],
    "Utilities": ["Electricity", "Gas", "Water", "Internet", "Phone"],
    "Housing": ["Rent", "Mortgage", "Tax"],
    "Entertainment": ["Movies", "Events", "Gaming", "Subscriptions"],
    "Education": ["Tuition", "Books", "Courses"],
    "Shopping": ["Clothing", "Electronics", "Household", "Gifts"],
    "Personal Care": [
      "Gym",
      "Doctor",
      "Medication",
      "Therapy",
      "Salons",
      "Skincare"
    ],
    "Savings": ["Emergency Fund", "Investments"],
    "Debt Repayments": ["Credit Cards", "Loans"],
    "Insurance": ["Health", "Auto"]
  };
}

class Database extends ChangeNotifier {
  static final List<TransactionInfo> _transactions = [
    const TransactionInfo(
        transactionID: "0",
        price: 100,
        category: "Food",
        subCategory: "Takeout",
        date: "24-11-2024",
        description: "KFC",
        location: "Home",
        picture: "None"),
    const TransactionInfo(
        transactionID: "1",
        price: 101,
        category: "Food",
        subCategory: "Takeout",
        date: "24-11-2024",
        description: "KFC",
        location: "Home",
        picture: "None"),
    const TransactionInfo(
        transactionID: "2",
        price: 102,
        category: "Food",
        subCategory: "Takeout",
        date: "24-11-2024",
        description: "KFC",
        location: "Home",
        picture: "None"),
    const TransactionInfo(
        transactionID: "3",
        price: 103,
        category: "Food",
        subCategory: "Takeout",
        date: "24-11-2024",
        description: "KFC",
        location: "Home",
        picture: "None")
  ];

  static final Database _instance = Database._internal();

  factory Database() {
    return _instance;
  }

  Database._internal();

  List<TransactionInfo> get transactions => _transactions;

  void addTransaction(Map<String, dynamic> data) {
    TransactionInfo trans = TransactionInfo(
        transactionID: "${_transactions.length}",
        price: data['Price'],
        category: data['Category'],
        subCategory: data['Subcategory'],
        date: data['Date'],
        description: data['Description'],
        location: data['Location'],
        picture: data['Picture']);
    _transactions.add(trans);
    addTransToFirebase(trans);
    notifyListeners();
  }

  Future<DocumentReference> addTransToFirebase(TransactionInfo T) {
    // print("Data being saved$message");
    return FirebaseFirestore.instance
        .collection('Transactions')
        .add(<String, dynamic>{
      'Category': T.category,
      'Date': T.date,
      'Description': T.description,
      'Location': T.location,
      'Picture': T.picture,
      'Price': T.price,
      'Subcategory': T.subCategory,
    });
  }

  Future<void> removeTransFromFirebase(String id) async {
    print("ID being used $id");
    FirebaseFirestore.instance.collection('Transactions').doc(id).delete().then(
        (doc) => print("Document deleted"),
        onError: (e) => print("Error updating document $e"));
  }

  // Fetch transactions from Firestore
  Future<void> fetchTransactionsFromFirestore() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Transactions')
          .orderBy("Date")
          .get();

      // Clear the local list and repopulate
      if (snapshot.docs.isNotEmpty) {
        _transactions.clear();
      }

      for (var doc in snapshot.docs) {
        // print(doc.toString());
        final data = doc.data() as Map<String, dynamic>;
        // Convert the Firestore data into info for display
        _transactions.add(TransactionInfo(
            transactionID: doc.id,
            price: data['Price'],
            category: data['Category'],
            subCategory: data['Subcategory'] ?? 'Not selected',
            date: data['Date'],
            description: data['Description'],
            location: data['Location'],
            picture: data['Picture']));
      }

      notifyListeners();
    } catch (e) {
      print('Error fetching transactions: $e');
    }
  }

  Map<String, double> calculateCategoryTotals() {
    Map<String, double> totals = {};

    for (var transaction in transactions) {
      String category = transaction.category;
      double amount = (transaction.price / 1);

      if (totals.containsKey(category)) {
        totals[category] = totals[category]! + amount;
      } else {
        totals[category] = amount;
      }
    }
    return totals;
  }

  Future<bool> deleteTransaction(String transactionID) async {
    // print("Transaction to delete " + transactionID);
    for (var trans in _transactions) {
      if (trans.transactionID == transactionID) {
        bool result = _transactions.remove(trans);
        removeTransFromFirebase(transactionID);
        notifyListeners();
        return result;
      }
    }
    notifyListeners();
    return false;
  }
}

class TransactionInfo {
  final String
      transactionID; // this is needed for firebase, should NOT be displayed
  final int price;
  final String category;
  final String subCategory;
  final String date;
  final String description;
  final String location;
  final String picture;

  const TransactionInfo({
    required this.transactionID,
    required this.price,
    required this.category,
    required this.subCategory,
    required this.date,
    required this.description,
    required this.location,
    required this.picture,
  });
}
