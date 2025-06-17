import 'package:dio/dio.dart';
import 'package:employeedirectoryapp/features/employee/data/model/employee_model.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../features/employee/controllers/add_employee_controller.dart';
import '../../features/employee/controllers/all_employee_controller.dart';
import '../../features/employee/data/datasources/employee_uploader_data_source.dart';
import '../../features/splash/controller/splash_controller.dart';
import '../helper/extensions/getx_controller_extensions.dart';
import '../network/api_constants.dart';

import '../services/dio/implementations/repos/uploader_storage_repo.dart';
import '../services/dio/implementations/services/cloudinary_storage_service.dart';
import '../services/dio/implementations/services/dio_service.dart';
import '../services/dio/interfaces/i_remote_database_service.dart';
import '../services/local_database/implementations/services/hive_database_service.dart';
import '../services/local_database/interfaces/i_local_database_service.dart';

class AppBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    // Initialize services
    final dio = _initializeDioClient();
    final employeesHiveService = await _initializeHiveService<EmployeeModel>(boxName: ApiConstants.employeesBoxName);

    // Initialize repositories
    final repositories = _initializeRepositories(
      remoteDatabaseService: DioDatabaseService(dio),
      employeesHiveService: employeesHiveService,
      cloudinaryStorageService: CloudinaryStorageService(dio),
    );

    // Lazy Controllers
    _initializeLazyControllers(repositories);

    // Permanent Controllers
    _initializePermanentControllers(repositories);
  }

  // Initialize external services
  Dio _initializeDioClient() => Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Future<ILocalDatabaseService<T>> _initializeHiveService<T>({required String boxName}) async {
    Box<T> box = await Hive.openBox<T>(boxName);
    return HiveDatabaseService(box);
  }

  // Repositories Initialization
  _Repositories _initializeRepositories({
    required IRemoteDatabaseService<Map<String, dynamic>> remoteDatabaseService,
    required ILocalDatabaseService<EmployeeModel> employeesHiveService,
    required CloudinaryStorageService cloudinaryStorageService,
  }) {
    final uploaderDatasource = EmployeeUploaderDataSource(
      databaseService: remoteDatabaseService,
      databaseStorageService: cloudinaryStorageService,
      localDatabaseService:employeesHiveService,
      // remoteDatabaseService: h
    );

    return _Repositories(uploaderRemoteDataService: RemoteDataServiceWithUploaderRepo<EmployeeModel>(uploaderDatasource));
  }

  // Permanent Controllers Initialization
  void _initializePermanentControllers(_Repositories repositories) {}

  // Lazy Controllers Initialization
  void _initializeLazyControllers(_Repositories repositories) {

    lazyPut(AllEmployeeController(repositories.uploaderRemoteDataService));
    lazyPut(AddEmployeeController(repositories.uploaderRemoteDataService));
  }
}

// Helper class to group repositories
class _Repositories {
  final RemoteDataServiceWithUploaderRepo<EmployeeModel> uploaderRemoteDataService;

  _Repositories({required this.uploaderRemoteDataService});
}