import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/sign_up_usecase.dart';
import 'domain/usecases/sign_in_usecase.dart';
import 'domain/usecases/sign_out_usecase.dart';
import 'domain/usecases/get_current_user_usecase.dart';
import 'domain/usecases/send_password_reset_usecase.dart';
import 'domain/usecases/update_password_usecase.dart';
import 'presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  sl.registerLazySingleton<SupabaseClient>(
    () => Supabase.instance.client,
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => SendPasswordResetUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePasswordUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => AuthBloc(
      signUpUseCase: sl(),
      signInUseCase: sl(),
      signOutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      sendPasswordResetUseCase: sl(),
      updatePasswordUseCase: sl(),
      authRepository: sl(),
    ),
  );
}
