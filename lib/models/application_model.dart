import 'profile_model.dart';

class ApplicationModel {
  final String id;
  final String jobId;
  final String talentId;
  final String recruiterId;
  final String? message;
  final int? proposedPrice;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProfileModel? talentProfile;
  final String? jobTitle;
  final String? jobSpecialite;
  final DateTime? jobEventDate;

  ApplicationModel({
    required this.id, required this.jobId, required this.talentId, required this.recruiterId,
    this.message, this.proposedPrice, required this.status, required this.createdAt, required this.updatedAt,
    this.talentProfile, this.jobTitle, this.jobSpecialite, this.jobEventDate,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    final talentJson = json['talent'] as Map<String, dynamic>?;
    final jobJson = json['job'] as Map<String, dynamic>?;
    return ApplicationModel(
      id: json['id'] as String,
      jobId: json['job_id'] as String,
      talentId: json['talent_id'] as String,
      recruiterId: json['recruiter_id'] as String,
      message: json['message'] as String?,
      proposedPrice: json['proposed_price'] as int?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      talentProfile: talentJson != null ? ProfileModel.fromJson(talentJson) : null,
      jobTitle: jobJson?['title'] as String?,
      jobSpecialite: jobJson?['specialite'] as String?,
      jobEventDate: jobJson?['event_date'] != null ? DateTime.parse(jobJson!['event_date']) : null,
    );
  }

  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isRejected => status == 'rejected';
}
