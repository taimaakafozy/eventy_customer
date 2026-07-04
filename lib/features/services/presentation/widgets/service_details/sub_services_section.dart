// import 'package:eventy_customer/features/services/data/models/service_details_model.dart';
// import 'package:eventy_customer/features/services/presentation/widgets/service_details/sub_service_card.dart';
// import 'package:flutter/material.dart';

// class SubServicesSection extends StatefulWidget {
//   final List<SubServiceModel> subServices;
//   final void Function(Map<String, int> selections) onSelectionChanged;

//   const SubServicesSection({
//     super.key,
//     required this.subServices,
//     required this.onSelectionChanged,
//   });

//   @override
//   State<SubServicesSection> createState() => _SubServicesSectionState();
// }

// class _SubServicesSectionState extends State<SubServicesSection> {
//   final Map<String, int> _selections = {};

//   void _toggle(String id) {
//     setState(() {
//       if (_selections.containsKey(id)) {
//         _selections.remove(id);
//       } else {
//         _selections[id] = 1;
//       }
//     });
//     widget.onSelectionChanged(Map.from(_selections));
//   }

//   void _changeQty(String id, int qty) {
//     setState(() => _selections[id] = qty);
//     widget.onSelectionChanged(Map.from(_selections));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: widget.subServices.map((sub) {
//         final isSelected = _selections.containsKey(sub.id);

//         return SubServiceCard(
//           subService: sub,
//           isSelected: isSelected,
//           quantity: _selections[sub.id] ?? 1,
//           onToggle: () => _toggle(sub.id),
//           onQuantityChanged: (qty) => _changeQty(sub.id, qty),
//         );
//       }).toList(),
//     );
//   }
// }