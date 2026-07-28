import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';

class SkillChips extends StatelessWidget {
  final List<String> skills;
  final void Function(String)? onDelete;

  const SkillChips({super.key, required this.skills, this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) {
      return Text('Aucune compétence renseignée', style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateMuted));
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills.map((s) {
        return Container(
          padding: EdgeInsets.only(left: 14, right: onDelete != null ? 6 : 14, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: AppColors.goldMuted,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(s, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.deepBlue)),
              if (onDelete != null) ...[
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => onDelete!(s),
                  child: const Icon(Icons.close, size: 14, color: AppColors.deepBlue),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}
