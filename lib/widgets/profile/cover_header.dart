import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';

class CoverHeader extends StatelessWidget {
  final String? coverUrl;
  final String? avatarUrl;
  final String name;
  final String subtitle;
  final bool isVerified;
  final bool isAvailable;

  const CoverHeader({
    super.key,
    this.coverUrl,
    this.avatarUrl,
    required this.name,
    required this.subtitle,
    this.isVerified = false,
    this.isAvailable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.deepBlue,
                image: coverUrl != null ? DecorationImage(image: NetworkImage(coverUrl!), fit: BoxFit.cover) : null,
              ),
            ),
            Positioned(
              bottom: -40,
              left: 0,
              right: 0,
              child: Center(
                child: CircleAvatar(
                  radius: 44,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.offWhite,
                    backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                    child: avatarUrl == null ? const Icon(Icons.person, size: 36, color: AppColors.slateMuted) : null,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 48),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(name, style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.deepBlue)),
            if (isVerified) ...[
              const SizedBox(width: 6),
              const Icon(Icons.verified, size: 18, color: AppColors.gold),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: GoogleFonts.inter(fontSize: 14, color: AppColors.slateMuted)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isAvailable ? AppColors.success.withOpacity(0.12) : AppColors.slateMuted.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isAvailable ? 'Disponible' : 'Indisponible',
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: isAvailable ? AppColors.success : AppColors.slateMuted),
          ),
        ),
      ],
    );
  }
}
