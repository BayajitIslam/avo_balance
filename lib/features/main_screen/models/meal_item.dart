// models/meal_item.dart
import 'package:flutter/material.dart';

class MealItem {
  final String name;
  final int calories;
  final int? weight;
  final Color color;
  final bool isPlanned;

  MealItem({
    required this.name,
    required this.calories,
    this.weight,
    required this.color,
    this.isPlanned = false,
  });
}

// Predefined Food Colors
class FoodColors {
  static const Color planned = Color(0xFF00BFA5);
  static const Color oatmeal = Color(0xFFE91E63);
  static const Color rice = Color(0xFF9C27B0);
  static const Color butter = Color(0xFF00BCD4);
  static const Color meat = Color(0xFF9C27B0);
  static const Color chicken = Color(0xFF2196F3);
  static const Color vegetables = Color(0xFF4CAF50);
  static const Color cheatMeal = Color(0xFFE91E63);
  static const Color restaurant = Color(0xFFFF9800);
}