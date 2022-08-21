import 'package:expense_tracker/constants/enum/enum_category.dart';

class ModalBudget {
  double budgetMoney;
  double nowMoney;
  bool isLimited;
  ECategory category;
  String currency;

  double get remainMoney {
    double _sub = budgetMoney - nowMoney;
    return _sub < 0 ? 0 : _sub;
  }

  double get percent {
    if (budgetMoney == 0) return 1;
    double _percent = nowMoney / budgetMoney;
    return _percent > 1 ? 1 : _percent;
  }

  bool get isExceedLimit => isLimited && (nowMoney - budgetMoney) > 0;

  ModalBudget(
      {required this.budgetMoney,
      required this.nowMoney,
      this.isLimited = false,
      required this.category,
      required this.currency});
}
