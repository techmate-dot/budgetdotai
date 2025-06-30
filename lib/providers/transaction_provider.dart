import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:budgetdotai/models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  late Box<Transaction> _transactionBox;

  List<Transaction> get transactions => _transactionBox.values.toList();

  Future<void> init() async {
    _transactionBox = await Hive.openBox<Transaction>('transactions');
  }

  void addTransaction(Transaction transaction) {
    _transactionBox.add(transaction);
    notifyListeners();
  }

  void deleteTransaction(Transaction transaction) {
    transaction.delete();
    notifyListeners();
  }

  // You might want to add methods to update transactions or filter them by budget category
}