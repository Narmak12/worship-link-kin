import 'package:intl/intl.dart';

class JobModel {
  final String id;
  final String recruiterId;
  final String title;
  final String description;
  final String? location;
  final String? commune;
  final DateTime? eventDate;
  final String? specialite;
  final int? budgetMin;
  final int? budgetMax;
  final String status;
  final DateTime createdAt;
  final String? churchName;
  final String? pastorName;
  final String? recruiterWhatsapp;
  final String? recruiterPhone;
  final String? recruiterAvatarUrl;

  JobModel({
    required this.id, required this.recruiterId, required this.title, required this.description,
    this.location, this.commune, this.eventDate, this.specialite, this.budgetMin, this.budgetMax,
    required this.status, required this.createdAt,
    this.churchName, this.pastorName, this.recruiterWhatsapp, this.recruiterPhone, this.recruiterAvatarUrl,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    final profile = json['profiles'] as Map<String, dynamic>?;
    return JobModel(
      id: json['id'] as String,
      recruiterId: json['recruiter_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String?,
      commune: json['commune'] as String?,
      eventDate: json['event_date'] != null ? DateTime.parse(json['event_date']) : null,
      specialite: json['specialite'] as String?,
      budgetMin: json['budget_min'] as int?,
      budgetMax: json['budget_max'] as int?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at']),
      churchName: profile?['church_name'] as String?,
      pastorName: profile?['full_name'] as String?,
      recruiterWhatsapp: profile?['whatsapp'] as String?,
      recruiterPhone: profile?['phone'] as String?,
      recruiterAvatarUrl: profile?['avatar_url'] as String?,
    );
  }

  String get displayChurchName => churchName ?? 'Église';
  String get displayPastorName => pastorName ?? 'Responsable';
  String get bestContactNumber => recruiterWhatsapp ?? recruiterPhone ?? '';
  String get formattedEventDate {
    if (eventDate == null) return 'Date non précisée';
    return DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(eventDate!);
  }
  String get budgetDisplay {
    if (budgetMin == null && budgetMax == null) return 'Budget à négocier';
    if (budgetMin != null && budgetMax != null) {
      return '${NumberFormat('#,###').format(budgetMin)} - ${NumberFormat('#,###').format(budgetMax)} CDF';
    }
    return '${NumberFormat('#,###').format(budgetMin ?? budgetMax)} CDF';
  }
}
