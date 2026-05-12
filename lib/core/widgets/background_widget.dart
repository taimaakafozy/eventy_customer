import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final String image;
  final Widget child;

  const BackgroundWidget({
    super.key,
    required this.image,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          image,
          fit: BoxFit.cover,
          cacheWidth: width.toInt(), //  تحسين ضخم
          filterQuality: FilterQuality.low,
        ),
        SafeArea(child: child),
      ],
    );
  }
}