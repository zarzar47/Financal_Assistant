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
}

class Database extends ChangeNotifier {
  static final List<TransactionInfo> _transactions = [];
  DocumentSnapshot? _lastDocument; // Tracks the last document retrieved
  bool _hasMoreData = true; // Tracks if more data is available
  static const int _pageSize = 6; // Number of items to fetch per page

  static final Database _instance = Database._internal();

  factory Database() {
    return _instance;
  }

  Database._internal();

  bool get hasMoreData => _hasMoreData;
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

  Future<void> fetchTransactionsFromFirestore({bool loadMore = false}) async {
    try {
      // If no more data to load, exit early
      if (!_hasMoreData && loadMore) return;

      Query query = FirebaseFirestore.instance
          .collection('Transactions')
          .orderBy("Date", descending: true)
          .limit(_pageSize);

      // If loading more data, start after the last document
      if (loadMore && _lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final QuerySnapshot snapshot = await query.get();

      // Update the last document and check if there's more data
      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
      }
      if (snapshot.docs.length < _pageSize) {
        _hasMoreData = false; // No more data to fetch
      }

      // Parse and add transactions
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        _transactions.add(TransactionInfo(
          transactionID: doc.id,
          price: data['Price'],
          category: data['Category'],
          subCategory: data['Subcategory'] ?? 'Not selected',
          date: data['Date'],
          description: data['Description'],
          location: data['Location'],
          picture: data['Picture'],
        ));
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

  void resetPagination() {
    // Resets pagination state for refreshing data
    _lastDocument = null;
    _hasMoreData = true;
    _transactions.clear();
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
