import 'package:eventy_customer/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:eventy_customer/features/auth/domain/usecases/logout_use_case.dart';
import 'package:eventy_customer/features/auth/domain/usecases/register_usecase.dart';
import 'package:eventy_customer/features/auth/domain/usecases/request_reset_password_usecase.dart';
import 'package:eventy_customer/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:eventy_customer/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:eventy_customer/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/change_password_cubit.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/register_cubit.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/request_reset_password_cubit.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/resend_otp_cubit.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/reset_password_cubit.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/verify_otp_cubit.dart';
import 'package:eventy_customer/features/complaints/data/datasources/complaint_remote_data_source.dart';
import 'package:eventy_customer/features/complaints/data/repositories/complaint_repository_impl.dart';
import 'package:eventy_customer/features/complaints/domain/repositories/complaint_repository.dart';
import 'package:eventy_customer/features/complaints/domain/usecases/create_complaint_usecase.dart';
import 'package:eventy_customer/features/complaints/domain/usecases/get_complaint_details_usecase.dart';
import 'package:eventy_customer/features/complaints/domain/usecases/get_complaints_usecase.dart';
import 'package:eventy_customer/features/complaints/presentation/blocs/complaint_details/complaint_details_cubit.dart';
import 'package:eventy_customer/features/complaints/presentation/blocs/complaints_list/complaints_list_cubit.dart';
import 'package:eventy_customer/features/complaints/presentation/blocs/create_complaint/create_complaint_cubit.dart';
import 'package:eventy_customer/features/events/data/datasource/event_remote_datasource.dart';
import 'package:eventy_customer/features/events/data/repository/event_repository_impl.dart';
import 'package:eventy_customer/features/events/domain/repository/event_repository.dart';
import 'package:eventy_customer/features/events/domain/usecases/add_service_to_event_usecase.dart';
import 'package:eventy_customer/features/events/domain/usecases/cancel_event_usecase.dart';
import 'package:eventy_customer/features/events/domain/usecases/create_event_usecase.dart';
import 'package:eventy_customer/features/events/domain/usecases/get_all_events_usecase.dart';
import 'package:eventy_customer/features/events/domain/usecases/get_event_bookings_usecase.dart';
import 'package:eventy_customer/features/events/domain/usecases/submit_quote_decisions_usecase.dart';
import 'package:eventy_customer/features/events/presentation/blocs/add_service_to_event/add_service_to_event_cubit.dart';
import 'package:eventy_customer/features/events/presentation/blocs/cancel_event/cancel_event_cubit.dart';
import 'package:eventy_customer/features/events/presentation/blocs/create_event/create_event_cubit.dart';
import 'package:eventy_customer/features/events/presentation/blocs/event_bookings_details/event_bookings_details_cubit.dart';
import 'package:eventy_customer/features/events/presentation/blocs/event_builder/event_builder_cubit.dart';
import 'package:eventy_customer/features/events/presentation/blocs/get_All_Events/Get_All_Events_Cubit.dart';
import 'package:eventy_customer/features/events/presentation/blocs/quote_decision/quote_decision_cubit.dart';
import 'package:eventy_customer/features/favorites/data/datasource/favorite_remote_datasource.dart';
import 'package:eventy_customer/features/favorites/data/repository/favorite_repository_impl.dart';
import 'package:eventy_customer/features/favorites/domain/repository/favorite_repository.dart';
import 'package:eventy_customer/features/favorites/domain/usecases/add_to_favorite_usecase.dart';
import 'package:eventy_customer/features/favorites/domain/usecases/get_favorites_usecase.dart';
import 'package:eventy_customer/features/favorites/domain/usecases/remove_from_favorite_usecase.dart';
import 'package:eventy_customer/features/favorites/presentation/blocs/favorite_status/favorite_status_cubit.dart';
import 'package:eventy_customer/features/favorites/presentation/blocs/favorites_list/favorites_list_cubit.dart';
import 'package:eventy_customer/features/reviews/data/datasources/review_remote_data_source.dart';
import 'package:eventy_customer/features/reviews/data/repositories/review_repository_impl.dart';
import 'package:eventy_customer/features/reviews/domain/repositories/review_repository.dart';
import 'package:eventy_customer/features/reviews/domain/usecases/create_review_usecase.dart';
import 'package:eventy_customer/features/reviews/domain/usecases/get_my_review_usecase.dart';
import 'package:eventy_customer/features/reviews/domain/usecases/get_service_reviews_usecase.dart';
import 'package:eventy_customer/features/reviews/presentation/blocs/create_review/create_review_cubit.dart';
import 'package:eventy_customer/features/reviews/presentation/blocs/my_review/my_review_cubit.dart';
import 'package:eventy_customer/features/reviews/presentation/blocs/service_reviews/service_reviews_cubit.dart';
import 'package:eventy_customer/features/services/data/datasources/service_remote_data_source.dart';
import 'package:eventy_customer/features/services/data/repositories/service_repository_impl.dart';
import 'package:eventy_customer/features/services/domain/repositories/service_repository.dart';
import 'package:eventy_customer/features/services/domain/usecases/get_available_services_usecase.dart';
import 'package:eventy_customer/features/services/domain/usecases/get_service_details_usecase.dart';
import 'package:eventy_customer/features/services/domain/usecases/get_service_types_usecase.dart';
import 'package:eventy_customer/features/services/presentation/blocs/available_services/available_services_cubit.dart';
import 'package:eventy_customer/features/services/presentation/blocs/service_details/service_details_cubit.dart';
import 'package:eventy_customer/features/services/presentation/blocs/service_types/service_types_cubit.dart';
import 'package:eventy_customer/features/user_profile/data/datasources/user_profile_remote_data_source.dart';
import 'package:eventy_customer/features/user_profile/data/repositories/user_profile_repository_impl.dart';
import 'package:eventy_customer/features/user_profile/domain/repositories/user_profile_repository.dart';
import 'package:eventy_customer/features/user_profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:eventy_customer/features/user_profile/presentation/blocs/user_profile_cubit.dart';
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
    () => AppCubit(sl(), sl(),sl()),
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

sl.registerLazySingleton<ChangePasswordUseCase>(() => ChangePasswordUseCase(sl()));
sl.registerFactory<ChangePasswordCubit>(() => ChangePasswordCubit(sl()));

/// User Profile
sl.registerLazySingleton<UserProfileRemoteDataSource>(
  () => UserProfileRemoteDataSourceImpl(sl()),
);

sl.registerLazySingleton<UserProfileRepository>(
  () => UserProfileRepositoryImpl(sl()),
);

sl.registerLazySingleton<GetUserProfileUseCase>(
  () => GetUserProfileUseCase(sl()),
);

sl.registerFactory<UserProfileCubit>(
  () => UserProfileCubit(sl()),
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
  () => ServiceTypesCubit(sl()),
);

  sl.registerLazySingleton<GetAvailableServicesUseCase>(
  () => GetAvailableServicesUseCase(sl()),
);
sl.registerLazySingleton<AvailableServicesCubit>(
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

sl.registerFactory<EventBuilderCubit>(() => EventBuilderCubit());

sl.registerLazySingleton(() => GetAllEventsUseCase(sl()));
sl.registerLazySingleton<GetAllEventsCubit>(() => GetAllEventsCubit(sl()));

sl.registerLazySingleton(() => GetEventBookingsUseCase(sl()));
sl.registerLazySingleton(() => SubmitQuoteDecisionsUseCase(sl()));

sl.registerFactoryParam<EventBookingsDetailsCubit, String, void>(
  (eventId, _) => EventBookingsDetailsCubit(sl(), eventId),
);

sl.registerFactoryParam<QuoteDecisionCubit, String, void>(
  (eventId, _) => QuoteDecisionCubit(sl(), eventId),
);
sl.registerLazySingleton(
  () => CancelEventUseCase(
    sl(),
  ),
);

sl.registerFactory(
  () => CancelEventCubit(  
    sl(),
  ),
);

sl.registerLazySingleton(() => AddServiceToEventUseCase(sl()));
sl.registerFactory<AddServiceToEventCubit>(() => AddServiceToEventCubit(sl()));

// Favorites

sl.registerLazySingleton<FavoriteRemoteDataSource>(
  () => FavoriteRemoteDataSourceImpl(
    sl(),
  ),
);

sl.registerLazySingleton<FavoriteRepository>(
  () => FavoriteRepositoryImpl(sl()),
);

sl.registerLazySingleton(
  () => AddToFavoriteUseCase(
    sl(),
  ),
);

sl.registerLazySingleton<RemoveFromFavoriteUseCase>(
  () => RemoveFromFavoriteUseCase(sl()),
);

sl.registerLazySingleton<GetFavoritesUseCase>(
  () => GetFavoritesUseCase(sl()),
);

/// ⚠️ Singleton — نسخة واحدة فقط طوال عمر التطبيق (مو Factory)
sl.registerLazySingleton<FavoriteStatusCubit>(
  () => FavoriteStatusCubit(sl(), sl(), sl()),
);

sl.registerLazySingleton<FavoritesListCubit>(
  () => FavoritesListCubit(sl()),
);

/// Complaints
sl.registerLazySingleton<ComplaintRemoteDataSource>(
  () => ComplaintRemoteDataSourceImpl(sl()),
);

sl.registerLazySingleton<ComplaintRepository>(
  () => ComplaintRepositoryImpl(sl()),
);

sl.registerLazySingleton(() => CreateComplaintUseCase(sl()));
sl.registerLazySingleton(() => GetComplaintsUseCase(sl()));
sl.registerLazySingleton(() => GetComplaintDetailsUseCase(sl()));

sl.registerFactory<CreateComplaintCubit>(() => CreateComplaintCubit(sl()));
sl.registerFactory<ComplaintsListCubit>(() => ComplaintsListCubit(sl()));
sl.registerFactory<ComplaintDetailsCubit>(() => ComplaintDetailsCubit(sl()));


/// Reviews
sl.registerLazySingleton<ReviewRemoteDataSource>(
  () => ReviewRemoteDataSourceImpl(sl()),
);

sl.registerLazySingleton<ReviewRepository>(
  () => ReviewRepositoryImpl(sl()),
);

sl.registerLazySingleton(() => CreateReviewUseCase(sl()));
sl.registerLazySingleton(() => GetServiceReviewsUseCase(sl()));
sl.registerLazySingleton(() => GetMyReviewUseCase(sl()));

sl.registerFactory<CreateReviewCubit>(() => CreateReviewCubit(sl()));
sl.registerFactory<MyReviewCubit>(() => MyReviewCubit(sl()));
sl.registerFactory<ServiceReviewsCubit>(() => ServiceReviewsCubit(sl()));

}

