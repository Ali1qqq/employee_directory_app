import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:employeedirectoryapp/core/services/dio/implementations/repos/remote_local_datasource_repo.dart';

import '../../../../network/error/error_handler.dart';
import '../../../../network/error/failure.dart';
import '../../interfaces/uploader_storage_datasource.dart';


class RemoteDataServiceWithUploaderRepo<T> extends RemoteLocalDataSourceRepository<T> {
  final UploaderStorageDataSource<T> _uploaderAbleDatasource;

  RemoteDataServiceWithUploaderRepo(this._uploaderAbleDatasource)
      : super(_uploaderAbleDatasource);

  Future<Either<Failure, String>> uploadImage(String imagePath) async {
    try {
      final savedItems = await _uploaderAbleDatasource.uploadImage(imagePath);
      return Right(savedItems); // Return the list of saved items
    } catch (e, stackTrace) {
      log('Error in uploadImage: $e',
          stackTrace: stackTrace,
          name: 'UploaderAbleDatasourceRepo uploadImage');
      return Left(ErrorHandler(e).failure); // Return error
    }
  }
}