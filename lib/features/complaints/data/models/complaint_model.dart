class ComplaintModel {
  final String id;
  final String complainantId;
  final String targetType;
  final String? targetId;
  final String? bookingId;
  final String? packageBookingId;
  final String subject;
  final String description;
  final String status;
  final String? adminReply;
  final String? handledByUserId;
  final DateTime? resolvedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  ComplaintModel({
    required this.id,
    required this.complainantId,
    required this.targetType,
    this.targetId,
    this.bookingId,
    this.packageBookingId,
    required this.subject,
    required this.description,
    required this.status,
    this.adminReply,
    this.handledByUserId,
    this.resolvedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'] ?? '',
      complainantId: json['complainantId'] ?? '',
      targetType: json['targetType'] ?? 'GENERAL',
      targetId: json['targetId'],
      bookingId: json['bookingId'],
      packageBookingId: json['packageBookingId'],
      subject: json['subject'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'PENDING',
      adminReply: json['adminReply'],
      handledByUserId: json['handledByUserId'],
      resolvedAt: json['resolvedAt'] != null ? DateTime.tryParse(json['resolvedAt']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class ComplaintsListResponseModel {
  final List<ComplaintModel> items;
  final ComplaintsMetaModel meta;

  ComplaintsListResponseModel({required this.items, required this.meta});

  factory ComplaintsListResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return ComplaintsListResponseModel(
      items: (data['items'] as List<dynamic>? ?? []).map((e) => ComplaintModel.fromJson(e)).toList(),
      meta: ComplaintsMetaModel.fromJson(data['meta'] ?? {}),
    );
  }
}

class ComplaintsMetaModel {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  ComplaintsMetaModel({required this.total, required this.page, required this.limit, required this.totalPages});

  factory ComplaintsMetaModel.fromJson(Map<String, dynamic> json) {
    return ComplaintsMetaModel(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}