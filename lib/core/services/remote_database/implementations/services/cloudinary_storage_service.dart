import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../interfaces/i_remote_storage_service.dart';

class CloudinaryStorageService implements IRemoteStorageService<String> {
  final Dio _dio ;

  /// Replace these with your actual Cloudinary credentials
  final String cloudName = 'zeusali';
  final String uploadPreset = 'aliTest';

  CloudinaryStorageService(this._dio);

  @override
  Future<String> uploadImage({required String imagePath}) async {
    final url = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

    final file = File(imagePath);

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
      'upload_preset': uploadPreset,
    });

    try {
      final response = await _dio.post(url, data: formData);
      return response.data['secure_url']; // Direct URL of uploaded image
    } catch (e) {
      debugPrint('Cloudinary upload error: $e');
      rethrow;
    }
  }




}