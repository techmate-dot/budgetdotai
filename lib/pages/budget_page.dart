import 'package:budgetdotai/json/day_month.dart';
import 'package:budgetdotai/pages/create_budge_page.dart';
import 'package:budgetdotai/providers/budget_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';

class BudgetPage extends StatefulWidget {
  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  int activeDay = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                  spreadRadius: 10,
                  blurRadius: 3,
                  // changes position of shadow
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
                        "Budget",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => CreateBudgetPage(),
                              ));
                            },
                            child: Icon(Icons.add, size: 25),
                          ),
                          SizedBox(width: 20),
                          Icon(AntDesign.search1),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(months.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            activeDay = index;
                          });
                        },
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 40) / 6,
                          child: Column(
                            children: [
                              Text(
                                months[index]['label'],
                                style: TextStyle(fontSize: 10),
                              ),
                              SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: activeDay == index
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: activeDay == index
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.1),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    right: 12,
                                    top: 7,
                                    bottom: 7,
                                  ),
                                  child: Text(
                                    months[index]['day'],
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: activeDay == index
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.onPrimary
                                          : Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Consumer<BudgetProvider>(
              builder: (context, budgetProvider, child) {
                if (budgetProvider.budgets.isEmpty) {
                  return Center(
                    child: Text(
                      "No budgets created yet.",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                      ),
                    ),
                  );
                }
                return Column(
                  children: List.generate(budgetProvider.budgets.length, (index) {
                    final budget = budgetProvider.budgets[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                          spreadRadius: 10,
                          blurRadius: 3,
                          // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 25,
                        right: 25,
                        bottom: 25,
                        top: 25,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            budget.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                            '\$${(budget.remainingAmount ?? 0.0).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                                  SizedBox(width: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Text(
                                      budget.category,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Text(
                                  "\$5000.00",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Stack(
                            children: [
                              Container(
                                width: (size.width - 40),
                                height: 4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                                ),
                              ),
                              Container(
                                width:
                                    (size.width - 40) * (budget.amount / 10000), // Assuming a max budget of 10000 for percentage calculation
                                height: 4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
