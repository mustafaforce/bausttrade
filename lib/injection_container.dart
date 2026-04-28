import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/presentation/controllers/auth_bloc.dart' as auth;
import 'features/listings/data/datasources/listing_remote_datasource.dart';
import 'features/listings/data/repositories/listing_repository_impl.dart';
import 'features/listings/domain/repositories/listing_repository.dart';
import 'features/listings/domain/usecases/create_listing_usecase.dart';
import 'features/listings/domain/usecases/delete_listing_usecase.dart';
import 'features/listings/domain/usecases/get_categories_usecase.dart';
import 'features/listings/domain/usecases/get_listings_usecase.dart';
import 'features/listings/domain/usecases/search_listings_usecase.dart';
import 'features/listings/domain/usecases/update_listing_usecase.dart';
import 'features/listings/presentation/controllers/listing_bloc.dart';
import 'features/profile/domain/usecases/update_profile_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => Supabase.instance.client);

  // Auth BLoC
  sl.registerFactory(
    () => auth.AuthBloc(
      registerUseCase: sl(),
      loginUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      updateProfileUseCase: sl(),
    ),
  );

  // Listing BLoC
  sl.registerFactory(
    () => ListingBloc(
      createListingUseCase: sl(),
      getListingsUseCase: sl(),
      getCategoriesUseCase: sl(),
      deleteListingUseCase: sl(),
      updateListingUseCase: sl(),
      searchListingsUseCase: sl(),
    ),
  );

  // Auth Use cases
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));

  // Listing Use cases
  sl.registerLazySingleton(() => CreateListingUseCase(sl()));
  sl.registerLazySingleton(() => GetListingsUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => DeleteListingUseCase(sl()));
  sl.registerLazySingleton(() => UpdateListingUseCase(sl()));
  sl.registerLazySingleton(() => SearchListingsUseCase(sl()));

  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Listing Repository
  sl.registerLazySingleton<ListingRepository>(
    () => ListingRepositoryImpl(remoteDataSource: sl()),
  );

  // Auth Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // Listing Data sources
  sl.registerLazySingleton<ListingRemoteDataSource>(
    () => ListingRemoteDataSourceImpl(supabaseClient: sl()),
  );
}
