import 'package:fitness/core/theme/app_colors.dart';
import 'package:fitness/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();
  static ThemeData lightTheme = ThemeData(
    dialogTheme: const DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all<Color>(AppColors.whiteF9),
      ),
    ),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    datePickerTheme: DatePickerThemeData(
      dayStyle: 16.medium,
      weekdayStyle: 16.medium,
      backgroundColor: AppColors.whiteF9,
      yearStyle: 16.medium.copyWith(color: AppColors.whiteF9),
      dayForegroundColor: WidgetStateProperty.all<Color>(AppColors.whiteF9),
      todayForegroundColor: WidgetStateProperty.all<Color>(
        AppColors.primaryLight,
      ),
      todayBackgroundColor: WidgetStateProperty.all<Color>(AppColors.grayA6),
      rangePickerBackgroundColor: AppColors.whiteF9,
      rangePickerHeaderForegroundColor: AppColors.whiteF9,
      rangePickerHeaderBackgroundColor: AppColors.primaryLight,
      rangePickerHeaderHeadlineStyle: 16.bold.copyWith(
        color: AppColors.whiteF9,
      ),
      rangePickerHeaderHelpStyle: 14.medium.copyWith(color: AppColors.whiteF9),
      rangePickerShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      dayShape: WidgetStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      yearShape: WidgetStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      headerForegroundColor: AppColors.black0C,
      headerBackgroundColor: AppColors.grayCF,
      dayOverlayColor: WidgetStateProperty.all<Color>(
        AppColors.primaryLight.withValues(alpha: 0.1),
      ),
      yearOverlayColor: WidgetStateProperty.all<Color>(
        AppColors.primaryLight.withValues(alpha: 0.1),
      ),
      todayBorder: const BorderSide(color: AppColors.primaryLight, width: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.whiteF9,
    primaryColor: AppColors.primaryLight,

    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: AppColors.primaryLight),
      shadowColor: AppColors.whiteF9,
      backgroundColor: AppColors.whiteF9,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    ),
    useMaterial3: true,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: AppColors.black0C,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: AppColors.black0C,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        color: AppColors.black0C,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: TextStyle(
        color: AppColors.black0C,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.black0C,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryLight,
      brightness: Brightness.light,
      primary: AppColors.primaryLight,
      onPrimary: AppColors.black0C,
      secondary: AppColors.primaryLight,
      onSecondary: AppColors.black0C,
      surface: AppColors.black0C,
      onSurface: AppColors.black0C,
      error: AppColors.redCC,
      onError: AppColors.redCC,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primaryLight,
      selectionColor: AppColors.primaryLight,
      selectionHandleColor: AppColors.primaryLight,
    ),
    fontFamily: AppTextStyles.fontFamily,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.center,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      focusColor: AppColors.primaryLight,
      floatingLabelStyle: 18.regular.copyWith(color: AppColors.primaryLight),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.grayCF, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: AppColors.primaryLight),
        borderRadius: BorderRadius.circular(4),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: AppColors.primaryLight),
        borderRadius: BorderRadius.circular(4),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.redCC, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      fillColor: AppColors.whiteF9,
      filled: true,
      hintStyle: 14.regular.copyWith(color: AppColors.black0C),
      labelStyle: 14.regular.copyWith(color: AppColors.black0C),
      errorStyle: 12.regular.copyWith(color: AppColors.redCC),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      iconColor: AppColors.black0C,
      suffixIconColor: AppColors.black0C,
      prefixIconColor: AppColors.black0C,
      alignLabelWithHint: true,
    ),
    switchTheme: SwitchThemeData(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
      splashRadius: 16,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      trackColor: WidgetStateProperty.all<Color>(AppColors.primaryLight),
      thumbColor: WidgetStateProperty.all<Color>(AppColors.whiteF9),
      trackOutlineColor: WidgetStateProperty.all<Color>(AppColors.primaryLight),
      overlayColor: WidgetStateProperty.all<Color>(AppColors.black0C),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        backgroundColor: WidgetStateProperty.all<Color>(AppColors.primaryLight),
        foregroundColor: WidgetStateProperty.all<Color>(AppColors.whiteF9),
        overlayColor: WidgetStateProperty.all<Color>(AppColors.black0C),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryLight,
      foregroundColor: AppColors.whiteF9,
      shape: CircleBorder(),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.whiteF9,
      showDragHandle: true,
      dragHandleColor: AppColors.grayA6,
      dragHandleSize: Size(48, 6),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      enableFeedback: true,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      backgroundColor: AppColors.whiteF9,
      selectedItemColor: AppColors.primaryLight,
      unselectedItemColor: AppColors.black0C,
      elevation: 0,
      selectedLabelStyle: 12.regular.copyWith(color: AppColors.primaryLight),
      unselectedLabelStyle: 12.regular.copyWith(color: AppColors.gray7D),
    ),
    tabBarTheme: const TabBarThemeData(indicatorColor: AppColors.primaryLight),
  );
  static ThemeData darkTheme = ThemeData();
}
