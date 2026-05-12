import 'package:get_it/get_it.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_use_case.dart';
import '../../features/auth/presentation/blocs/app_cubit.dart';
import '../../features/auth/presentation/blocs/login_cubit.dart';
import '../network/dio_client.dart';
import '../services/secure_storage_service.dart';

final sl = GetIt.instance;

Future<void> setup() async {
  sl.registerLazySingleton(() => SecureStorageService());

  sl.registerLazySingleton(() => DioClient(sl()));



  // ///Auth
  // sl.registerLazySingleton<AuthRemoteDataSource>(
  //   () => AuthRemoteDataSourceImpl(sl()),
  // );
  // sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  // sl.registerLazySingleton(() => LoginUseCase(sl()));
  // sl.registerFactory(() => LoginCubit(sl(), sl()));
  // sl.registerLazySingleton(() => LogoutUseCase(sl()));
  // sl.registerFactory(() => AppCubit(sl(),sl()));


}

