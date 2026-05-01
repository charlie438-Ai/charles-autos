class AppUser {
  final String uid;
  final String email;
  final String role;
  final bool isLicenseVerified;
  final DateTime createdAt;

  AppUser({
    required this.uid,
    required this.email,
    required this.role,
    this.isLicenseVerified = false,
    required this.createdAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'BUYER',
      isLicenseVerified: json['isLicenseVerified'] ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'isLicenseVerified': isLicenseVerified,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
