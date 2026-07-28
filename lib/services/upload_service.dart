import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadProgress {
  final double percent;
  final String status;
  final String? error;
  const UploadProgress({required this.percent, required this.status, this.error});
}

class UploadService {
  final _storage = Supabase.instance.client.storage;

  Future<String?> uploadImage({
    required File file, required String userId, required String bucket,
    required Function(UploadProgress) onProgress, int maxWidth = 1200, int quality = 85,
  }) async {
    try {
      onProgress(const UploadProgress(percent: 0, status: 'compressing'));
      final tempDir = await getTemporaryDirectory();
      final targetPath = path.join(tempDir.path, '${DateTime.now().millisecondsSinceEpoch}.jpg');
      final compressed = await FlutterImageCompress.compressWithFile(
        file.absolute.path, minWidth: maxWidth, quality: quality, format: CompressFormat.jpeg,
      );
      if (compressed == null) throw Exception('Compression échouée');
      final compressedFile = File(targetPath)..writeAsBytesSync(compressed);
      onProgress(const UploadProgress(percent: 0.3, status: 'uploading'));
      final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storagePath = '$userId/$fileName';
      await _storage.from(bucket).upload(storagePath, compressedFile, fileOptions: const FileOptions(upsert: true));
      final publicUrl = _storage.from(bucket).getPublicUrl(storagePath);
      onProgress(const UploadProgress(percent: 1.0, status: 'done'));
      await compressedFile.delete();
      return publicUrl;
    } catch (e) {
      onProgress(UploadProgress(percent: 0, status: 'error', error: e.toString()));
      return null;
    }
  }

  Future<String?> uploadFile({
    required File file, required String userId, required String bucket,
    required Function(UploadProgress) onProgress,
  }) async {
    try {
      onProgress(const UploadProgress(percent: 0, status: 'uploading'));
      final ext = path.extension(file.path);
      final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}$ext';
      final storagePath = '$userId/$fileName';
      await _storage.from(bucket).upload(storagePath, file, fileOptions: FileOptions(upsert: true, contentType: _getMimeType(ext)));
      final publicUrl = _storage.from(bucket).getPublicUrl(storagePath);
      onProgress(const UploadProgress(percent: 1.0, status: 'done'));
      return publicUrl;
    } catch (e) {
      onProgress(UploadProgress(percent: 0, status: 'error', error: e.toString()));
      return null;
    }
  }

  Future<void> deleteFile({required String bucket, required String storagePath, required String mediaId}) async {
    try {
      await _storage.from(bucket).remove([storagePath]);
      await Supabase.instance.client.from('media').delete().eq('id', mediaId);
    } catch (e) { rethrow; }
  }

  String? _getMimeType(String ext) {
    switch (ext.toLowerCase()) {
      case '.mp4': return 'video/mp4';
      case '.mp3': return 'audio/mpeg';
      case '.m4a': return 'audio/mp4';
      case '.wav': return 'audio/wav';
      case '.jpg': case '.jpeg': return 'image/jpeg';
      case '.png': return 'image/png';
      default: return null;
    }
  }
}
