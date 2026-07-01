class PaginationMetaModel {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const PaginationMetaModel({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginationMetaModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PaginationMetaModel(
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
    );
  }
}