import 'package:flutter/material.dart';

import '../constants/app_assets.dart';

class AppLogo extends StatelessWidget {
  final double width;

  const AppLogo({super.key, this.width = 200});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Image.asset(AppAssets.BasicLogo, width: width),
    );
  }
}


class SecondaryLogo extends StatelessWidget {
  final double width;

  const SecondaryLogo({super.key, this.width = 200});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Image.asset(AppAssets.secondaryLogo, width: width),
    );
  }
}
