import 'package:fitness/features/food/data/models/response/meal_dto.dart';
import 'package:flutter/material.dart';

import '../phone_helper/phone_length_helper.dart';

extension WidgetSliverExtension on Widget {
  Widget toSliver({double? padding}) => padding != null
      ? SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          sliver: SliverToBoxAdapter(child: this),
        )
      : SliverToBoxAdapter(child: this);
}

extension WidgetSliverPaddingExtension on Widget {
  SliverPadding withSliverPadding(EdgeInsetsGeometry padding) =>
      SliverPadding(padding: padding, sliver: this);
}

extension SliverListSpacingExtension on List<Widget> {
  List<Widget> withSliverSpacing(double spacing) {
    if (length <= 1 || spacing == 0) return this;
    final spaced = <Widget>[];
    for (var i = 0; i < length; i++) {
      spaced.add(this[i]);
      if (i != length - 1) {
        spaced.add(SliverToBoxAdapter(child: SizedBox(height: spacing)));
      }
    }
    return spaced;
  }
}

extension PhoneTextEditingControllerExtension on TextEditingController {
  static final Map<TextEditingController, String> _countryCodes = {};
  String get selectedCountryCode => _countryCodes[this] ?? '964';
  void updateSelectedCountryCode(String countryCode) {
    _countryCodes[this] = countryCode;
  }

  String get fullPhoneNumber => '+$selectedCountryCode$text';
  String get phoneNumberOnly => text;
  void setPhoneWithCountryCode(String phoneWithCode) {
    if (phoneWithCode.startsWith('+')) {
      final RegExp regExp = RegExp(r'^\+(\d{1,4})(.*)$');
      final match = regExp.firstMatch(phoneWithCode);
      if (match != null) {
        updateSelectedCountryCode(match.group(1)!);
        text = match.group(2)!;
      }
    } else {
      text = phoneWithCode;
    }
  }

  void clearCountryCode() {
    _countryCodes.remove(this);
  }

  void initValue(String phoneWithCode) {
    setPhoneWithCountryCode(PhoneHelper.getCountryCode(phoneWithCode) ?? "");
    text = phoneWithCode.replaceRange(
      0,
      PhoneHelper.getCountryCode(phoneWithCode)?.length ?? 0,
      '',
    );
  }

  bool get hasCountryCode => _countryCodes.containsKey(this);
  void initializeCountryCode(String countryCode) {
    if (!hasCountryCode) {
      updateSelectedCountryCode(countryCode);
    }
  }
}

extension MealNutritionExtension on MealDto {
  int get calculatedCalories {
    final base = (idMeal != null) ? (int.tryParse(idMeal!) ?? 0) % 300 : 200;
    return 250 + base;
  }

  int get calculatedProtein {
    final base = (strMeal?.length ?? 5) * 2;
    return (15 + base) % 45 + 10;
  }

  int get calculatedCarbs {
    final base = (idMeal != null) ? (int.tryParse(idMeal!) ?? 0) % 40 : 20;
    return 30 + base;
  }

  int get calculatedFat {
    final base = (strMeal?.length ?? 3) * 3;
    return (8 + base) % 25 + 5;
  }
}
