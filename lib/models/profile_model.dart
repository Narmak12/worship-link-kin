import 'enums.dart';

class ProfileModel {
  final String id;
  final UserRole role;
  final String fullName;
  final String phone;
  final String? whatsapp;
  final String? email;
  final String city;
  final String? commune;
  final String? churchName;
  final String? avatarUrl;
  final String? coverUrl;
  final String? bio;
  final int? hourlyRateMin;
  final int? hourlyRateMax;
  final bool isAvailable;
  final bool isVerified;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfileModel({
    required this.id, required this.role, required this.fullName, required this.phone,
    this.whatsapp, this.email, this.city = 'Kinshasa', this.commune, this.churchName,
    this.avatarUrl, this.coverUrl, this.bio, this.hourlyRateMin, this.hourlyRateMax,
    this.isAvailable = true, this.isVerified = false, this.isActive = true,
    required this.createdAt, required this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      role: UserRole.values.firstWhere((e) => e.value == json['role'], orElse: () => UserRole.talent),
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      whatsapp: json['whatsapp'],
      email: json['email'],
      city: json['city'] ?? 'Kinshasa',
      commune: json['commune'],
      churchName: json['church_name'],
      avatarUrl: json['avatar_url'],
      coverUrl: json['cover_url'],
      bio: json['bio'],
      hourlyRateMin: json['hourly_rate_min'],
      hourlyRateMax: json['hourly_rate_max'],
      isAvailable: json['is_available'] ?? true,
      isVerified: json['is_verified'] ?? false,
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
