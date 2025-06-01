import 'package:flutter/material.dart';
import 'package:hackathon/core/colors.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primaryColor,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: AppColors.primaryColor,
    unselectedItemColor: Colors.grey,
    backgroundColor: Colors.white,
    selectedIconTheme: IconThemeData(color: AppColors.primaryColor),
    unselectedIconTheme: IconThemeData(color: Colors.grey),
    showSelectedLabels: true,
    showUnselectedLabels: true,
    selectedLabelStyle: TextStyle(
      fontWeight: FontWeight.bold,
    ),
  ),
);
