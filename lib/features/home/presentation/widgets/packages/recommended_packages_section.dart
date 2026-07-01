import 'package:eventy_customer/core/widgets/section_header.dart';
import 'package:eventy_customer/features/home/data/package_data.dart';
import 'package:flutter/material.dart';

import 'package_card.dart';

class RecommendedPackagesSection extends StatelessWidget {
  const RecommendedPackagesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: "Recommended Packages",
          onSeeAll: () {
            // لاحقاً ننتقل إلى صفحة جميع البكجات
          },
        ),

        const SizedBox(height: 4),

        SizedBox(
          height: 390,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: recommendedPackages.length,
            itemBuilder: (_, index) {
              return PackageCard(
                package: recommendedPackages[index],
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}
