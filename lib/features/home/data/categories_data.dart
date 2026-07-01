import 'package:flutter/material.dart';

class CategoryModel {
  final String title;
  final IconData icon;

  const CategoryModel({
    required this.title,
    required this.icon,
  });
}

const List<CategoryModel> homeCategories = [

  CategoryModel(
    title: "Venues",
    icon: Icons.location_city_rounded,
  ),

  CategoryModel(
    title: "Decoration",
    icon: Icons.auto_awesome_rounded,
  ),

  CategoryModel(
    title: "Catering",
    icon: Icons.restaurant_rounded,
  ),

  CategoryModel(
    title: "Photography",
    icon: Icons.camera_alt_rounded,
  ),

  CategoryModel(
    title: "Music",
    icon: Icons.music_note_rounded,
  ),

  CategoryModel(
    title: "Cakes",
    icon: Icons.cake_rounded,
  ),
];