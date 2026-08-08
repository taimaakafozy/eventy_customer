class ReviewModel {
  final String id;
  final String bookingId;
  final String customerId;
  final String serviceId;
  final int rating;
  final String comment;
  final String? providerReply;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// ⚠️ يظهر فقط ضمن قائمة تقييمات الخدمة (findForService) — غائب بردّي
  /// الإنشاء (create) والتقييم الشخصي (findMine)
  final ReviewCustomerModel? customer;

  ReviewModel({
    required this.id,
    required this.bookingId,
    required this.customerId,
    required this.serviceId,
    required this.rating,
    required this.comment,
    this.providerReply,
    required this.createdAt,
    required this.updatedAt,
    this.customer,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? '',
      bookingId: json['bookingId'] ?? '',
      customerId: json['customerId'] ?? '',
      serviceId: json['serviceId'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      providerReply: json['providerReply'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      customer: json['customer'] != null ? ReviewCustomerModel.fromJson(json['customer']) : null,
    );
  }
}

class ReviewCustomerModel {
  final String fullName;
  final String? profileImage;

  ReviewCustomerModel({required this.fullName, this.profileImage});

  factory ReviewCustomerModel.fromJson(Map<String, dynamic> json) {
    return ReviewCustomerModel(
      fullName: json['fullName'] ?? '',
      profileImage: json['profileImage'],
    );
  }
}

class ReviewsListResponseModel {
  final List<ReviewModel> items;
  final ReviewsMetaModel meta;

  ReviewsListResponseModel({required this.items, required this.meta});

  factory ReviewsListResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return ReviewsListResponseModel(
      items: (data['items'] as List<dynamic>? ?? []).map((e) => ReviewModel.fromJson(e)).toList(),
      meta: ReviewsMetaModel.fromJson(data['meta'] ?? {}),
    );
  }
}

class ReviewsMetaModel {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  ReviewsMetaModel({required this.total, required this.page, required this.limit, required this.totalPages});

  factory ReviewsMetaModel.fromJson(Map<String, dynamic> json) {
    return ReviewsMetaModel(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}