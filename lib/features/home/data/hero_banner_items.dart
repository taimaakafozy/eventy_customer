import 'package:eventy_customer/core/constants/app_assets.dart';

class HeroBannerItem {
  final String image;
  final String title;
  final String subtitle;
  final String button;

  const HeroBannerItem({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.button,
  });
}

const heroBannerItems = [

 
   HeroBannerItem(
    image:  AppAssets.hero1,
    title: "Discover Amazing Events",
    subtitle: "Book everything you need in one place",
    button: "Explore Services",
  ),

   HeroBannerItem(
    image:  AppAssets.hero2,
    title: "Professional Event Services",
    subtitle: "Photography, Catering, Music & More",
    button: "View Services",
  ),


 HeroBannerItem(
    image:  AppAssets.hero3,
    title: "Find Perfect Venues",
    subtitle: "Elegant halls for every celebration",
    button: "Browse Venues",
  ),


  HeroBannerItem(
    image:  AppAssets.hero4,
    title: "Create Unforgettable Moments",
    subtitle: "Everything for your perfect event",
    button: "Get Started",
  ),
];