import 'package:flutter/material.dart';
import 'package:talacare/helpers/color_palette.dart';

class AppTextStyles {
  static const TextStyle h1 = TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: AppColors.textColor,
      fontFamily: "Fredoka One");

  static const TextStyle h2 = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.textColor,
      fontFamily: "Fredoka One");

  static const TextStyle normal = TextStyle(
    color: AppColors.textColor,
    fontSize: 16,
    fontFamily: 'Fredoka',
    fontWeight: FontWeight.w500,
  );

  static const TextStyle normalBold = TextStyle(
    color: AppColors.textColor,
    fontSize: 16,
    fontFamily: 'Fredoka',
    fontWeight: FontWeight.w600,
  );

  static const TextStyle medium = TextStyle(
    color: AppColors.textColor,
    fontSize: 18,
    fontFamily: 'Fredoka',
    fontWeight: FontWeight.w500,
  );

  static const TextStyle mediumBold = TextStyle(
    color: AppColors.textColor,
    fontSize: 18,
    fontFamily: 'Fredoka',
    fontWeight: FontWeight.w600,
  );

  static const TextStyle large = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      fontFamily: 'Fredoka',
      color: AppColors.textColor);

  static const TextStyle largeBold = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      fontFamily: 'Fredoka',
      color: AppColors.textColor);
}