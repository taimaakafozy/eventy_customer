// import 'package:eventy_customer/core/theme/app_colors.dart';
// import 'package:eventy_customer/features/services/data/models/available_services_model/service_model.dart';
// import 'package:flutter/material.dart';

// import 'service_placeholder.dart';

// class ServiceImage extends StatelessWidget {
//   final ServiceModel service;

//   const ServiceImage({super.key, required this.service});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     final bool hasImage =
//         service.serviceLogo != null && service.serviceLogo!.isNotEmpty;

//     return Hero(
//       tag: service.id,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(18),
//         child: SizedBox(
//           height: 220,
//           width: double.infinity,
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               /// Image / Placeholder
//               if (hasImage)
//                 Image.network(
//                   service.serviceLogo!,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) {
//                     return ServicePlaceholder(type: service.serviceType.name);
//                   },
//                 )
//               else
//                 ServicePlaceholder(type: service.serviceType.name),

//               /// Dark Overlay
//               Positioned.fill(
//                 child: DecoratedBox(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.transparent,
//                         Colors.black.withOpacity(.08),
//                         Colors.black.withOpacity(.55),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               /// Bottom Info
//               Positioned(
//                 left: 18,
//                 right: 18,
//                 bottom: 18,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 5,
//                         vertical: 3,
//                       ),
//                       decoration: BoxDecoration(
//                         color: AppColors.gold,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Text(
//                         service.provider.businessName,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: theme.textTheme.titleMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 21,
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 6),

//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:eventy_customer/core/utils/service_type_helper.dart';
import 'package:eventy_customer/features/services/data/models/available_services_model/service_model.dart';
import 'package:flutter/material.dart';

import 'service_placeholder.dart';

class ServiceImage extends StatelessWidget {
  final ServiceModel service;

  const ServiceImage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bool hasImage =
        service.serviceLogo != null && service.serviceLogo!.isNotEmpty;

    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.primaryColor, AppColors.gold],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -35,
            right: -35,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: -45,
            left: -45,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(.25)),
                  ),
                  child: hasImage
                      ? ClipOval(
                          child: Image.network(
                            service.serviceLogo!,
                            fit: BoxFit.cover,
                            width: 120,
                            height: 120,
                            errorBuilder: (_, __, ___) {
                              return ServicePlaceholder(
                                type: service.serviceType.name,
                              );
                            },
                          ),
                        )
                      : Icon(
                          ServiceTypeHelper.icon(service.serviceType.name),
                          size: 42,
                          color: Colors.white,
                        ),
                ),

                Text(
                  ServiceTypeHelper.displayName(service.serviceType.name),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(.08),
                    Colors.black.withOpacity(.55),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: 18,
            right: 18,
            bottom: 12,
            child: Text(
              service.provider.businessName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 21,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
