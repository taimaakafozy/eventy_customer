class FavoritesListResponseModel {
  final List<FavoriteItemModel> items;
  final FavoritesMetaModel meta;

  FavoritesListResponseModel({required this.items, required this.meta});

  factory FavoritesListResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return FavoritesListResponseModel(
      items: (data['items'] as List<dynamic>? ?? [])
          .map((e) => FavoriteItemModel.fromJson(e))
          .toList(),
      meta: FavoritesMetaModel.fromJson(data['meta'] ?? {}),
    );
  }
}

class FavoriteItemModel {
  final String id;
  final String userId;
  final String targetType;
  final String targetId;
  final DateTime createdAt;
  final FavoriteTargetModel? target;

  FavoriteItemModel({
    required this.id,
    required this.userId,
    required this.targetType,
    required this.targetId,
    required this.createdAt,
    this.target,
  });

  factory FavoriteItemModel.fromJson(Map<String, dynamic> json) {
    return FavoriteItemModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      targetType: json['targetType'] ?? '',
      targetId: json['targetId'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      target: json['target'] != null ? FavoriteTargetModel.fromJson(json['target']) : null,
    );
  }
}

class FavoriteTargetModel {
  final String id;
  final String description;
  final double? price;
  final double rating;
  final String? serviceLogo;
  final String approvalStatus;

  FavoriteTargetModel({
    required this.id,
    required this.description,
    this.price,
    required this.rating,
    this.serviceLogo,
    required this.approvalStatus,
  });

  factory FavoriteTargetModel.fromJson(Map<String, dynamic> json) {
    return FavoriteTargetModel(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      price: json['price']?.toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      serviceLogo: json['serviceLogo'],
      approvalStatus: json['approvalStatus'] ?? '',
    );
  }
}

class FavoritesMetaModel {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  FavoritesMetaModel({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory FavoritesMetaModel.fromJson(Map<String, dynamic> json) {
    return FavoritesMetaModel(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}