import 'dart:developer';

import 'package:dartz/dartz.dart';
import '../../../../network/error/error_handler.dart';
import '../../../../network/error/failure.dart';
import '../../interfaces/remote_local_datasource_base.dart';

class RemoteLocalDataSourceRepository<T> {
  final RemoteLocalDatasourceBase<T> _dataSource;

  RemoteLocalDataSourceRepository(this._dataSource);

  Future<Either<Failure, List<T>>> getAll(String path) async {
    try {
      final items = await _dataSource.fetchAll(path: path);
      return Right(items);
    } catch (e, stackTrace) {
      log('❌ Error in getAll: $e',
          stackTrace: stackTrace,
          name: 'RemoteLocalDataSourceRepository.getAll');
      return Left(ErrorHandler(e).failure);
    }
  }

  Future<Either<Failure, T>> getById(String path) async {
    try {
      final item = await _dataSource.fetchById(path: path);
      return Right(item);
    } catch (e, stackTrace) {
      log('❌ Error in getById: $e',
          stackTrace: stackTrace,
          name: 'RemoteLocalDataSourceRepository.getById');
      return Left(ErrorHandler(e).failure);
    }
  }

  Future<Either<Failure, T>> save(T item, String path) async {
    try {
      final saved = await _dataSource.save(item, path: path);
      return Right(saved);
    } catch (e, stackTrace) {
      log('❌ Error in save: $e',
          stackTrace: stackTrace,
          name: 'RemoteLocalDataSourceRepository.save');
      return Left(ErrorHandler(e).failure);
    }
  }

  Future<Either<Failure, T>> update(T item, String path) async {
    try {
      final updated = await _dataSource.update(item, path: path);
      return Right(updated);
    } catch (e, stackTrace) {
      log('❌ Error in update: $e',
          stackTrace: stackTrace,
          name: 'RemoteLocalDataSourceRepository.update');
      return Left(ErrorHandler(e).failure);
    }
  }

  Future<Either<Failure, Unit>> delete(String path) async {
    try {
      await _dataSource.delete(path: path);
      return const Right(unit);
    } catch (e, stackTrace) {
      log('❌ Error in delete: $e',
          stackTrace: stackTrace,
          name: 'RemoteLocalDataSourceRepository.delete');
      return Left(ErrorHandler(e).failure);
    }
  }
}