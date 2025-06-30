import 'package:budgetdotai/json/day_month.dart';
import 'package:budgetdotai/providers/transaction_provider.dart';
import 'package:budgetdotai/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:provider/provider.dart';

class DailyPage extends StatefulWidget {
  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
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
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.01),
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
                        "Daily Transaction",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Icon(AntDesign.search1),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(days.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            activeDay = index;
                          });
                        },
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 40) / 7,
                          child: Column(
                            children: [
                              Text(
                                days[index]['label'],
                                style: TextStyle(fontSize: 10),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: activeDay == index
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: activeDay == index
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.1),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    days[index]['day'],
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
          SizedBox(height: 30),
          Consumer<TransactionProvider>(
            builder: (context, transactionProvider, child) {
              final transactions = transactionProvider.transactions;
              if (transactions.isEmpty) {
                return Center(
                  child: Text(
                    "No transactions yet.",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: List.generate(transactions.length, (index) {
                    final transaction = transactions[index];
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: (size.width - 40) * 0.7,
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.1),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.attach_money,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Container(
                                    width: (size.width - 90) * 0.5,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          transaction.name,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          transaction.budgetCategory,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.5),
                                            fontWeight: FontWeight.w400,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: (size.width - 40) * 0.3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "-\$${transaction.amount.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 65, top: 8),
                          child: Divider(
                            thickness: 0.8,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.1),
                          ),
                        )
                      ],
                    );
                  }),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
