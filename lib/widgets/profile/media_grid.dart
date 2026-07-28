import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';

class MediaGrid extends StatelessWidget {
  final List<Map<String, dynamic>> media;
  final void Function(Map<String, dynamic>)? onDelete;

  const MediaGrid({super.key, required this.media, this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (media.isEmpty) {
      return Text('Aucun contenu de portfolio pour le moment', style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateMuted));
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: media.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
      itemBuilder: (context, index) {
        final item = media[index];
        final type = item['type'] as String? ?? 'image';
        final url = item['public_url'] as String?;
        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: type == 'image' && url != null
                  ? Image.network(url, fit: BoxFit.cover)
                  : Container(
                      color: AppColors.deepBlue.withOpacity(0.08),
                      child: Icon(type == 'audio' ? Icons.audiotrack : Icons.videocam, color: AppColors.deepBlue),
                    ),
            ),
            if (onDelete != null)
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => onDelete!(item),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                    child: const Icon(Icons.close, size: 14, color: Colors.white),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
