import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:budgetdotai/models/budget.dart';

class BudgetProvider with ChangeNotifier {
  late Box<Budget> _budgetBox;

  List<Budget> get budgets => _budgetBox.values.toList();

  Future<void> init() async {
    _budgetBox = await Hive.openBox<Budget>('budgets');
    notifyListeners();
  }

  Future<void> addBudget(Budget budget) async {
    await _budgetBox.add(budget);
    notifyListeners();
  }

  Future<void> deleteBudget(int index) async {
    await _budgetBox.deleteAt(index);
    notifyListeners();
  }

  Future<void> updateBudget(int index, Budget budget) async {
    await _budgetBox.putAt(index, budget);
    notifyListeners();
  }

  Future<void> subtractFromBudget(String category, double amount) async {
    final budgetIndex = budgets.indexWhere((b) => b.category == category);
    if (budgetIndex != -1) {
      final budget = budgets[budgetIndex];
      budget.remainingAmount = (budget.remainingAmount ?? 0.0) - amount;
      await _budgetBox.putAt(budgetIndex, budget);
      notifyListeners();
    }
  }
}