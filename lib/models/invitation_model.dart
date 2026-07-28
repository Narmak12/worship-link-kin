import 'profile_model.dart';

class InvitationModel {
  final String id;
  final String recruiterId;
  final String talentId;
  final String? jobId;
  final String? message;
  final int? proposedPrice;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProfileModel? recruiterProfile;
  final String? jobTitle;

  InvitationModel({
    required this.id, required this.recruiterId, required this.talentId,
    this.jobId, this.message, this.proposedPrice, required this.status,
    required this.createdAt, required this.updatedAt,
    this.recruiterProfile, this.jobTitle,
  });

  factory InvitationModel.fromJson(Map<String, dynamic> json) {
    final recruiterJson = json['recruiter'] as Map<String, dynamic>?;
    final jobJson = json['job'] as Map<String, dynamic>?;
    return InvitationModel(
      id: json['id'] as String,
      recruiterId: json['recruiter_id'] as String,
      talentId: json['talent_id'] as String,
      jobId: json['job_id'] as String?,
      message: json['message'] as String?,
      proposedPrice: json['proposed_price'] as int?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      recruiterProfile: recruiterJson != null ? ProfileModel.fromJson(recruiterJson) : null,
      jobTitle: jobJson?['title'] as String?,
    );
  }

  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
}
