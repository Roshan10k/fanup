import 'dart:io';

import 'package:fanup/core/services/notifications/push_notification_service.dart';
import 'package:fanup/features/auth/domain/repositories/auth.repository.dart';
import 'package:fanup/features/auth/data/repositories/auth_repository.dart';
import 'package:fanup/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:fanup/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:fanup/features/auth/domain/usecases/login_usecase.dart';
import 'package:fanup/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fanup/features/auth/domain/usecases/register_usecase.dart';
import 'package:fanup/features/auth/domain/usecases/upload_profile_photo_usecase.dart';
import 'package:fanup/features/auth/presentation/state/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

//provider
final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);

class AuthViewModel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  late final GoogleLoginUsecase _googleLoginUsecase;
  late final GetCurrentUserUsecase _getCurrentUserUsecase;
  late final LogoutUsecase _logoutUsecase;
  late final UploadProfilePhotoUsecase _uploadProfilePhotoUsecase;
  late final IAuthRepository _authRepository;
  late final PushNotificationService _pushNotificationService;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _googleLoginUsecase = ref.read(googleLoginUsecaseProvider);
    _getCurrentUserUsecase = ref.read(getCurrentUserUsecaseProvider);
    _logoutUsecase = ref.read(logoutUsecaseProvider);
    _uploadProfilePhotoUsecase = ref.read(uploadProfilePhotoUsecaseProvider);
    _authRepository = ref.read(authRepositoryProvider);
    _pushNotificationService = ref.read(pushNotificationServiceProvider);
    return const AuthState();
  }

  // Register
  Future<void> registerUser(
    String fullName,
    String email,
    String password,
  ) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = RegisterUsecaseParams(
      fullName: fullName,
      email: email,
      password: password,
    );

    final result = await _registerUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (isRegistered) {
        if (isRegistered) {
          state = state.copyWith(status: AuthStatus.registered);
        } else {
          state = state.copyWith(
            status: AuthStatus.error,
            errorMessage: "Registration failed",
          );
        }
      },
    );
  }

  //Login
  Future<void> loginUser(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = LoginUsecaseParams(email: email, password: password);

    final result = await _loginUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (authEntity) {
        // Register FCM device token after successful authentication.
        _pushNotificationService.initializeForAuthenticatedUser();
        state = state.copyWith(
          status: AuthStatus.authenticated,
          authEntity: authEntity,
        );
      },
    );
  }

  // Google Sign-In
  Future<void> loginWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final googleSignIn = GoogleSignIn.instance;

      // Authenticate with Google (opens the sign-in flow)
      final GoogleSignInAccount account = await googleSignIn.authenticate(
        scopeHint: ['email', 'profile'],
      );

      final idToken = account.authentication.idToken;

      if (idToken == null) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Failed to get Google credentials',
        );
        return;
      }

      final result = await _googleLoginUsecase(idToken);

      result.fold(
        (failure) {
          state = state.copyWith(
            status: AuthStatus.error,
            errorMessage: failure.message,
          );
        },
        (authEntity) {
          _pushNotificationService.initializeForAuthenticatedUser();
          state = state.copyWith(
            status: AuthStatus.authenticated,
            authEntity: authEntity,
          );
        },
      );
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        // User cancelled – go back to unauthenticated quietly
        state = state.copyWith(status: AuthStatus.unauthenticated);
        return;
      }
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Google sign-in failed: ${e.description ?? e.code.name}',
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Google sign-in failed: ${e.toString()}',
      );
    }
  }

  // Logout
  Future<void> logoutUser() async {
    state = state.copyWith(status: AuthStatus.loading);

    // Unregister current device token while auth token is still valid.
    await _pushNotificationService.unregisterCurrentToken();

    final result = await _logoutUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        _pushNotificationService.dispose();
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          authEntity: null,
        );
      },
    );
  }

  // Upload Profile Photo
  Future<void> uploadProfilePhoto(File photo) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _uploadProfilePhotoUsecase(photo);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (filename) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          authEntity: state.authEntity?.copyWith(profilePicture: filename),
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  Future<void> getCurrentUser() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _getCurrentUserUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (authEntity) {
        if (authEntity != null) {
          _pushNotificationService.initializeForAuthenticatedUser();
          state = state.copyWith(
            status: AuthStatus.authenticated,
            authEntity: authEntity,
          );
        } else {
          state = state.copyWith(
            status: AuthStatus.unauthenticated,
            authEntity: null,
          );
        }
      },
    );
  }

  /// Updates local user data and refreshes the state
  Future<bool> updateLocalProfile({String? fullName, String? phone}) async {
    final result = await _authRepository.updateLocalUser(
      fullName: fullName,
      phone: phone,
    );

    return result.fold((failure) => false, (success) {
      // Update local state immediately
      if (state.authEntity != null) {
        state = state.copyWith(
          authEntity: state.authEntity!.copyWith(
            fullName: fullName ?? state.authEntity!.fullName,
            phone: phone ?? state.authEntity!.phone,
          ),
        );
      }
      return true;
    });
  }
}
