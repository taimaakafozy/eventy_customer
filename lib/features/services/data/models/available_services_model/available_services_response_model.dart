import 'pagination_meta_model.dart';
import 'service_model.dart';

class AvailableServicesResponseModel {
  final List<ServiceModel> items;
  final PaginationMetaModel meta;

  const AvailableServicesResponseModel({
    required this.items,
    required this.meta,
  });

  factory AvailableServicesResponseModel.fromJson(
      Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return AvailableServicesResponseModel(
      items: (data['items'] as List<dynamic>? ?? [])
          .map((e) => ServiceModel.fromJson(e))
          .toList(),

      meta: PaginationMetaModel.fromJson(
        data['meta'] ?? {},
      ),
    );
  }
}