class BudgetModel {
  final double totalBudget;
  final double spentAmount;

  const BudgetModel({
    required this.totalBudget,
    required this.spentAmount,
  });

  double get remainingAmount => totalBudget - spentAmount;
  double get spentPercentage => (spentAmount / totalBudget) * 100;
} 