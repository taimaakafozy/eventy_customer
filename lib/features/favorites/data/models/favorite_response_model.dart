class FavoriteResponse {
  final bool success;
  final int statusCode;
  final String message;
  final FavoriteData data;
  final DateTime timestamp;

  FavoriteResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory FavoriteResponse.fromJson(Map<String, dynamic> json) {
    return FavoriteResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: FavoriteData.fromJson(json['data']),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class FavoriteData {
  final String id;
  final String userId;
  final String targetType;
  final String targetId;
  final DateTime createdAt;

  FavoriteData({
    required this.id,
    required this.userId,
    required this.targetType,
    required this.targetId,
    required this.createdAt,
  });

  factory FavoriteData.fromJson(Map<String, dynamic> json) {
    return FavoriteData(
      id: json['id'],
      userId: json['userId'],
      targetType: json['targetType'],
      targetId: json['targetId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}