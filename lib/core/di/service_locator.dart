import 'package:eventy_customer/features/auth/domain/usecases/logout_use_case.dart';
import 'package:eventy_customer/features/auth/domain/usecases/register_usecase.dart';
import 'package:eventy_customer/features/auth/domain/usecases/request_reset_password_usecase.dart';
import 'package:eventy_customer/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:eventy_customer/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:eventy_customer/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/register_cubit.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/request_reset_password_cubit.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/resend_otp_cubit.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/reset_password_cubit.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/verify_otp_cubit.dart';
import 'package:eventy_customer/features/events/data/datasource/event_remote_datasource.dart';
import 'package:eventy_customer/features/events/data/repository/event_repository_impl.dart';
import 'package:eventy_customer/features/events/domain/repository/event_repository.dart';
import 'package:eventy_customer/features/events/domain/usecases/create_event_usecase.dart';
import 'package:eventy_customer/features/events/presentation/blocs/create_event/create_event_cubit.dart';
import 'package:eventy_customer/features/services/data/datasources/service_remote_data_source.dart';
import 'package:eventy_customer/features/services/data/repositories/service_repository_impl.dart';
import 'package:eventy_customer/features/services/domain/repositories/service_repository.dart';
import 'package:eventy_customer/features/services/domain/usecases/get_available_services_usecase.dart';
import 'package:eventy_customer/features/services/domain/usecases/get_service_details_usecase.dart';
import 'package:eventy_customer/features/services/domain/usecases/get_service_types_usecase.dart';
import 'package:eventy_customer/features/services/presentation/blocs/available_services/available_services_cubit.dart';
import 'package:eventy_customer/features/services/presentation/blocs/service_details/service_details_cubit.dart';
import 'package:eventy_customer/features/services/presentation/blocs/service_types/service_types_cubit.dart';
import 'package:get_it/get_it.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/blocs/app_cubit.dart';
import '../../features/auth/presentation/blocs/login_cubit.dart';
import '../network/dio_client.dart';
import '../services/secure_storage_service.dart';

final sl = GetIt.instance;

Future<void> setup() async {
  sl.registerLazySingleton(() => SecureStorageService());

sl.registerLazySingleton(() => DioClient(sl()));



  ///Auth
   sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
 
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );
 
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl()),
  );

  sl.registerLazySingleton<RegisterUsecase>(
    () => RegisterUsecase(sl()),
  );
 sl.registerLazySingleton<VerifyOtpUsecase>(
    () => VerifyOtpUsecase(sl()),
  );

  sl.registerLazySingleton<ResendOtpUsecase>(
    () => ResendOtpUsecase(sl()),
  );

  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(sl()),
  );
  sl.registerLazySingleton<RequestResetPasswordUseCase>(
  () => RequestResetPasswordUseCase(sl()),
);

sl.registerLazySingleton<ResetPasswordUseCase>(
  () => ResetPasswordUseCase(sl()),
);
 
  sl.registerLazySingleton<AppCubit>(
    () => AppCubit(sl(), sl()),
  );
 
  sl.registerFactory<LoginCubit>(
    () => LoginCubit(
      sl(),
      sl(),
    ),
  );

  sl.registerFactory<RegisterCubit>(
    () => RegisterCubit(
      sl(),
    ),
  );
  sl.registerFactory<VerifyOtpCubit>(
    () => VerifyOtpCubit(
      sl(),
      sl(),
    ),
  );
  sl.registerFactory<ResendOtpCubit>(
    () => ResendOtpCubit(
      sl(),
    ),
  );

  sl.registerFactory<RequestResetPasswordCubit>(
  () => RequestResetPasswordCubit(
    sl(),
  ),
);
sl.registerFactory<ResetPasswordCubit>(
  () => ResetPasswordCubit(
    sl(),
    sl(),
  ),
);

  /// Services

  sl.registerLazySingleton<ServiceRemoteDataSource>(
    () => ServiceRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<ServiceRepository>(
    () => ServiceRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<GetServiceTypesUseCase>(
    () => GetServiceTypesUseCase(sl()),
  );

  sl.registerFactory<ServiceTypesCubit>(
    () => ServiceTypesCubit(
      sl(),
    ),
  );

  sl.registerLazySingleton<GetAvailableServicesUseCase>(
  () => GetAvailableServicesUseCase(sl()),
);
sl.registerFactory<AvailableServicesCubit>(
  () => AvailableServicesCubit(sl()),
);

sl.registerLazySingleton(
  () => GetServiceDetailsUseCase(
    sl<ServiceRepository>(),
  ),
);

sl.registerFactory(
  () => ServiceDetailsCubit(
    sl<GetServiceDetailsUseCase>(),
  ),
);

/// Events
sl.registerLazySingleton<EventRemoteDataSource>(
  () => EventRemoteDataSourceImpl(
    sl(),
  ),
);

sl.registerLazySingleton<EventRepository>(
  () => EventRepositoryImpl(
    sl(),
  ),
);

sl.registerLazySingleton(
  () => CreateEventUseCase(
    sl(),
  ),
);
sl.registerFactory(
  () => EventCubit(
    sl(),
  ),
);
}

