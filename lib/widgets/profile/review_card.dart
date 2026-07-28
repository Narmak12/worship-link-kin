import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';

class ReviewCard extends StatelessWidget {
  final String reviewerName;
  final String? avatarUrl;
  final int rating;
  final String comment;
  final DateTime date;

  const ReviewCard({
    super.key,
    required this.reviewerName,
    this.avatarUrl,
    required this.rating,
    required this.comment,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [AppShadows.level1]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                child: avatarUrl == null ? const Icon(Icons.person, size: 16) : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(reviewerName, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.slateText)),
              ),
              Row(
                children: List.generate(5, (i) => Icon(i < rating ? Icons.star : Icons.star_border, size: 14, color: AppColors.gold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(comment, style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateText, height: 1.4)),
          const SizedBox(height: 6),
          Text(DateFormat('d MMM yyyy', 'fr_FR').format(date), style: GoogleFonts.inter(fontSize: 11, color: AppColors.slateMuted)),
        ],
      ),
    );
  }
}
