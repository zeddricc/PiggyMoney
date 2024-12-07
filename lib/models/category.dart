import 'package:flutter/material.dart';

class Subcategory {
  final String name; 
  final IconData icon; 
  final Color color;

  Subcategory({
    required this.name,
    required this.icon,
    required this.color,
  });
}

class Category {
  final String name; 
  final IconData icon;
  final List<Subcategory> subcategories; 
  final Color color;
  final String type;

  Category({
    required this.name,
    required this.icon,
    required this.subcategories,
    required this.color,
    required this.type,
  });
} 