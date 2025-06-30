import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 1) // Use a different typeId than Budget (which is 0)
class Transaction extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late double amount;

  @HiveField(2)
  late String budgetCategory; // To link with a budget

  @HiveField(3)
  late DateTime createdAt;

  Transaction({
    required this.name,
    required this.amount,
    required this.budgetCategory,
    required this.createdAt,
  });
}