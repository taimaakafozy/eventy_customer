import 'package:eventy_customer/core/constants/app_assets.dart';

class PackageModel {
  final String image;
  final String title;
  final String hallName;
  final List<String> services;
  final double price;
  final String badge;

  const PackageModel({
    required this.image,
    required this.title,
    required this.hallName,
    required this.services,
    required this.price,
    required this.badge,
  });
}


const recommendedPackages = [

  PackageModel(
    image: AppAssets.hero1,
    title: "Luxury Wedding",
    hallName: "Royal Palace Hall",
    services: [
      "DJ",
      "Photo",
      "Food",
      "Decor",
    ],
    price: 1200,
    badge: "POPULAR",
  ),

  PackageModel(
    image: AppAssets.hero2,
    title: "Birthday Package",
    hallName: "Golden Hall",
    services: [
      "Music",
      "Cake",
      "Photo",
    ],
    price: 750,
    badge: "BEST VALUE",
  ),

  PackageModel(
    image: AppAssets.hero3,
    title: "Graduation Party",
    hallName: "Diamond Venue",
    services: [
      "DJ",
      "Decor",
      "Food",
    ],
    price: 980,
    badge: "NEW",
  ),

];