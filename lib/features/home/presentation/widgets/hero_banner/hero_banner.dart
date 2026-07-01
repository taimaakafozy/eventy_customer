import 'dart:async';

import 'package:eventy_customer/features/home/data/hero_banner_items.dart';
import 'package:flutter/material.dart';

import 'hero_banner_card.dart';
import 'hero_banner_indicator.dart';

class HeroBanner extends StatefulWidget {
  const HeroBanner({super.key});

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> {
  final PageController _pageController = PageController(viewportFraction: .93);
  int currentIndex = 0;

  Timer? _timer;

  bool isDragging = false;

  @override
  void initState() {
    super.initState();

    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_pageController.hasClients || isDragging) {
        return;
      }
      currentIndex++;

      if (currentIndex >= heroBannerItems.length) {
        currentIndex = 0;
      }

      _pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();

    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 210,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollStartNotification) {
                isDragging = true;
              }

              if (notification is ScrollEndNotification) {
                isDragging = false;
              }

              return false;
            },
            child: PageView.builder(
              controller: _pageController,

              itemCount: heroBannerItems.length,

              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },

              itemBuilder: (_, index) {
                final item = heroBannerItems[index];

                return HeroBannerCard(
                  image: item.image,
                  title: item.title,
                  subtitle: item.subtitle,
                  buttonText: item.button,
                  onPressed: () {},
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 14),

        HeroBannerIndicator(
          currentIndex: currentIndex,
          count: heroBannerItems.length,
        ),
      ],
    );
  }
}
