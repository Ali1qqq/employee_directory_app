import 'package:employeedirectoryapp/core/services/dio/interfaces/remote_local_datasource_base.dart';

import 'i_remote_storage_service.dart';

abstract class UploaderCapability<T> {
  Future<String> uploadImage(String imagePath);
}

abstract class UploaderStorageDataSource<T> extends RemoteLocalDatasourceBase<T>
    implements UploaderCapability<T> {
  final IRemoteStorageService<String> databaseStorageService;

  UploaderStorageDataSource(

      {required super.databaseService, required this.databaseStorageService,required super.localDatabaseService});
}

abstract class ImageLoaderUploaderCapability<T> {
  Future<String> uploadImage({required String imagePath});

}