import 'package:dio/dio.dart';
import '../../interfaces/i_remote_database_service.dart';

class DioDatabaseService implements IRemoteDatabaseService<Map<String, dynamic>> {
  final Dio _dio;

  DioDatabaseService(this._dio);

  @override
  Future<List<Map<String, dynamic>>> getAll(String path) async {
    final response = await _dio.get(path);
    final extracted = response.data;

    if (extracted is Map && extracted['data'] is List) {
      return List<Map<String, dynamic>>.from(extracted['data']);
    } else {
      throw Exception('Response format is invalid');
    }
  }


  @override
  Future<Map<String, dynamic>> getById(String path) async {
    final response = await _dio.get(path);
    final extracted = response.data;

    if (extracted is Map && extracted['data'] is Map) {
      return Map<String, dynamic>.from(extracted['data']);
    } else {
      throw Exception('Response format is invalid');
    }
  }

  @override
  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> data) async {
    final response = await _dio.post(path, data: data);
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> data) async {
    final response = await _dio.put(path, data: data);
    return response.data;
  }

  @override
  Future<void> delete(String path) async {
    await _dio.delete(path);
  }


}