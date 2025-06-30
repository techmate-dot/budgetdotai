import 'package:budgetdotai/models/budget.dart';
import 'package:budgetdotai/models/transaction.dart';
import 'package:budgetdotai/providers/budget_provider.dart';
import 'package:budgetdotai/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class CreateTransactionPage extends StatefulWidget {
  @override
  _CreateTransactionPageState createState() => _CreateTransactionPageState();
}

class _CreateTransactionPageState extends State<CreateTransactionPage> {
  int activeBudgetIndex = 0;
  TextEditingController _transactionName = TextEditingController();
  TextEditingController _transactionAmount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: getBody(),
    );
  }

  void _submitTransaction(BuildContext context) {
    final transactionProvider = context.read<TransactionProvider>();
    final budgetProvider = context.read<BudgetProvider>();
    final budgets = budgetProvider.budgets;

    if (_transactionName.text.isEmpty || _transactionAmount.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter transaction name and amount')),
      );
      return;
    }

    final double amount = double.tryParse(_transactionAmount.text) ?? 0.0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    if (budgets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No budgets available to assign transaction')),
      );
      return;
    }

    final selectedBudget = budgets[activeBudgetIndex];

    final transaction = Transaction(
      name: _transactionName.text,
      amount: amount,
      budgetCategory: selectedBudget.category,
      createdAt: DateTime.now(),
    );

    transactionProvider.addTransaction(transaction);
    budgetProvider.subtractFromBudget(selectedBudget.category, amount);

    Navigator.pop(context);
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    final budgetProvider = context.watch<BudgetProvider>();
    final List<Budget> budgets = budgetProvider.budgets;

    if (budgets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No budgets created yet.",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to budget page or root
              },
              child: Text("Go Back"),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                  spreadRadius: 10,
                  blurRadius: 3,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 60,
                right: 20,
                left: 20,
                bottom: 25,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Add Transaction",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Text(
              "Choose Budget",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ),
          SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(budgets.length, (index) {
                final budget = budgets[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      activeBudgetIndex = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      width: 150,
                      height: 170,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        border: Border.all(
                          width: 2,
                          color: activeBudgetIndex == index
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                            spreadRadius: 10,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 25,
                          right: 25,
                          top: 20,
                          bottom: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
                              ),
                              child: Center(
                                child: Text(
                                  budget.category.substring(0, 1).toUpperCase(), // Display first letter of category
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              budget.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              '₦${budget.amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Transaction Name",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                TextField(
                  controller: _transactionName,
                  cursorColor: Theme.of(context).colorScheme.onSurface,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: "Enter Transaction Name",
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: (size.width - 140),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Enter Amount",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          TextField(
                            controller: _transactionAmount,
                            cursorColor: Theme.of(context).colorScheme.onSurface,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter Amount",
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        _submitTransaction(context);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(Icons.check, color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}