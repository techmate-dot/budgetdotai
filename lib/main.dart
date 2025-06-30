import 'package:flutter/material.dart';
import 'package:budgetdotai/pages/root_app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:budgetdotai/models/budget.dart';
import 'package:budgetdotai/models/transaction.dart';
import 'package:budgetdotai/providers/budget_provider.dart';
import 'package:budgetdotai/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(BudgetAdapter());
  Hive.registerAdapter(TransactionAdapter());

  final budgetProvider = BudgetProvider();
  await budgetProvider.init();

  final transactionProvider = TransactionProvider();
  await transactionProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<BudgetProvider>(
          create: (context) => budgetProvider,
        ),
        ChangeNotifierProvider<TransactionProvider>(
          create: (context) => transactionProvider,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BudgetDotAI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
            .copyWith(
              primary: const Color(
                0xFF007BFF,
              ), // A vibrant blue for primary actions
              secondary: const Color(
                0xFF6C757D,
              ), // A muted grey for secondary elements
              surface: Colors
                  .white, // White for card backgrounds and elevated surfaces
              background: const Color(
                0xFFF8F9FA,
              ), // Light grey for general backgrounds
              error: const Color(0xFFDC3545), // Red for error states
              onPrimary: Colors.white, // White text on primary background
              onSecondary: Colors.white, // White text on secondary background
              onSurface: Colors.black, // Black text on surface backgrounds
              onBackground: Colors.black, // Black text on general backgrounds
              onError: Colors.white, // White text on error backgrounds
            ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
            .copyWith(
              primary: const Color(
                0xFF007BFF,
              ), // A vibrant blue for primary actions
              secondary: const Color(
                0xFF6C757D,
              ), // A muted grey for secondary elements
              surface: const Color(
                0xFF343A40,
              ), // Dark grey for card backgrounds and elevated surfaces
              background: const Color(
                0xFF212529,
              ), // Darker grey for general backgrounds
              error: const Color(0xFFDC3545), // Red for error states
              onPrimary: Colors.white, // White text on primary background
              onSecondary: Colors.white, // White text on secondary background
              onSurface: Colors.white, // White text on surface backgrounds
              onBackground: Colors.white, // White text on general backgrounds
              onError: Colors.white, // White text on error backgrounds
            ),
        useMaterial3: true,
      ),
      home: RootApp(),
    );
  }
}
