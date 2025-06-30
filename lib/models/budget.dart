import 'package:hive/hive.dart';

part 'budget.g.dart';

@HiveType(typeId: 0)
class Budget extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late double amount;

  @HiveField(2)
  late String category;

  @HiveField(3)
  late DateTime createdAt;
  
  @HiveField(4)
  double? remainingAmount;

  Budget({
    required this.name,
    required this.amount,
    required this.category,
    required this.createdAt,
  }) : remainingAmount = amount;
}