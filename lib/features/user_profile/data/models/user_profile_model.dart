class UserProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? profileImage;
  final String? locationName;
  final double? latitude;
  final double? longitude;
  final String role;
  final String status;
  final bool emailVerified;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  final int loyaltyPoints;

  const UserProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.profileImage,
    this.locationName,
    this.latitude,
    this.longitude,
    required this.role,
    required this.status,
    required this.emailVerified,
    this.lastLoginAt,
    required this.createdAt,
    required this.loyaltyPoints,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profileImage: json['profileImage'],
      locationName: json['locationName'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      role: json['role'] ?? 'CUSTOMER',
      status: json['status'] ?? '',
      emailVerified: json['emailVerified'] ?? false,
      lastLoginAt: json['lastLoginAt'] != null ? DateTime.tryParse(json['lastLoginAt']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      loyaltyPoints: json['customer']?['loyaltyPoints'] ?? 0,
    );
  }

  /// الأحرف الأولى من الاسم — تُستخدم كـ Avatar احتياطي عند عدم وجود صورة
  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return "?";
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return "${parts.first[0]}${parts.last[0]}".toUpperCase();
  }
}