import 'dart:ui';

import 'package:expense_tracker/constants/asset/category.dart';
import 'package:expense_tracker/constants/enum/enum_category.dart';
import 'package:expense_tracker/widgets/component/hint_category_component.dart';

class CategoryInstance {
  static const Map<ECategory, HintCategoryComponent Function()> instances =
      <ECategory, HintCategoryComponent Function()>{
    ECategory.shopping: _ShoppingCategory.instance,
    ECategory.bill: _BillCategory.instance,
    ECategory.food: _FoodCategory.instance,
    ECategory.money: _MoneyCategory.instance,
    ECategory.transportation: _TransportationCategory.instance
  };
}

class _ShoppingCategory extends HintCategoryComponent {
  static HintCategoryComponent? _instance;
  static const Color _backgroundColor = Color(0xFFFCEED4);
  static const String _name = "Shopping";
  static const String _assetName = CategoryAsset.shoppingBag;
  static const Color _assetColor = Color(0xFFFCAC12);

  _ShoppingCategory()
      : super(
            name: _name,
            backgroundColor: _backgroundColor,
            assetName: _assetName,
            assetColor: _assetColor);

  static HintCategoryComponent instance() {
    _instance ??= HintCategoryComponent(
        backgroundColor: _backgroundColor,
        name: _name,
        assetName: _assetName,
        assetColor: _assetColor);
    return _instance!;
  }
}

class _BillCategory extends HintCategoryComponent {
  static HintCategoryComponent? _instance;
  static const Color _backgroundColor = Color(0xFFEEE5FF);
  static const String _name = "Bill";
  static const String _assetName = CategoryAsset.bill;
  static const Color _assetColor = Color(0xFF7F3DFF);

  _BillCategory()
      : super(
            name: _name,
            backgroundColor: _backgroundColor,
            assetName: _assetName,
            assetColor: _assetColor);

  static HintCategoryComponent instance() {
    _instance ??= HintCategoryComponent(
        backgroundColor: _backgroundColor,
        name: _name,
        assetName: _assetName,
        assetColor: _assetColor);
    return _instance!;
  }
}

class _FoodCategory extends HintCategoryComponent {
  static HintCategoryComponent? _instance;
  static const Color _backgroundColor = Color(0xFFFDD5D7);
  static const String _name = "Food";
  static const String _assetName = CategoryAsset.food;
  static const Color _assetColor = Color(0xFFFD3C4A);

  _FoodCategory()
      : super(
            name: _name,
            backgroundColor: _backgroundColor,
            assetName: _assetName,
            assetColor: _assetColor);

  static HintCategoryComponent instance() {
    _instance ??= HintCategoryComponent(
        backgroundColor: _backgroundColor,
        name: _name,
        assetName: _assetName,
        assetColor: _assetColor);
    return _instance!;
  }
}

class _TransportationCategory extends HintCategoryComponent {
  static HintCategoryComponent? _instance;
  static const Color _backgroundColor = Color(0xFFBDDCFF);
  static const String _name = "Transportation";
  static const String _assetName = CategoryAsset.transportation;
  static const Color _assetColor = Color(0xFF0077FF);

  _TransportationCategory()
      : super(
            name: _name,
            backgroundColor: _backgroundColor,
            assetName: _assetName,
            assetColor: _assetColor);

  static HintCategoryComponent instance() {
    _instance ??= HintCategoryComponent(
        backgroundColor: _backgroundColor,
        name: _name,
        assetName: _assetName,
        assetColor: _assetColor);
    return _instance!;
  }
}

class _MoneyCategory extends HintCategoryComponent {
  static HintCategoryComponent? _instance;
  static const Color _backgroundColor = Color(0xFFCFFAEA);
  static const String _name = "Money";
  static const String _assetName = CategoryAsset.moneyBag;
  static const Color _assetColor = Color(0xFF00A86B);

  _MoneyCategory()
      : super(
            name: _name,
            backgroundColor: _backgroundColor,
            assetName: _assetName,
            assetColor: _assetColor);

  static HintCategoryComponent instance() {
    _instance ??= HintCategoryComponent(
        backgroundColor: _backgroundColor,
        name: _name,
        assetName: _assetName,
        assetColor: _assetColor);
    return _instance!;
  }
}
