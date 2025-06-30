import 'package:budgetdotai/pages/budget_page.dart';
import 'package:budgetdotai/pages/create_budge_page.dart';
import 'package:budgetdotai/pages/daily_page.dart';
import 'package:budgetdotai/pages/chatbot_ai_page.dart';
import 'package:budgetdotai/pages/stats_page.dart';
import 'package:budgetdotai/pages/create_transaction_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int pageIndex = 0;
  List<Widget> pages = [
    DailyPage(),
    StatsPage(),
    BudgetPage(),
    ChatBotAiPage(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      bottomNavigationBar: getFooter(),
      floatingActionButton: pageIndex == 3
          ? null
          : FloatingActionButton(
              onPressed: () {
                if (pageIndex == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateTransactionPage(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateBudgetPage()),
                  );
                }
              },
              child: Icon(Icons.add, size: 25),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget getBody() {
    return IndexedStack(index: pageIndex, children: pages);
  }

  Widget getFooter() {
    List<IconData> iconItems = [
      Ionicons.md_calendar,
      Ionicons.md_stats,
      Ionicons.md_wallet,
      Ionicons.ios_chatbubbles,
    ];

    return AnimatedBottomNavigationBar(
      activeColor: Theme.of(context).colorScheme.secondary,
      splashColor: Theme.of(context).colorScheme.secondary,
      inactiveColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
      icons: iconItems,
      activeIndex: pageIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 10,
      iconSize: 25,
      rightCornerRadius: 10,
      onTap: (index) {
        selectedTab(index);
      },
      backgroundColor: Theme.of(context).colorScheme.surface,
      //other params
    );
  }

  selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
