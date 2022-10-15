import 'package:dartz/dartz.dart';
import 'package:flutter_demo/core/domain/model/user.dart';
import 'package:flutter_demo/core/utils/bloc_extensions.dart';
import 'package:flutter_demo/features/auth/domain/model/log_in_failure.dart';
import 'package:flutter_demo/features/auth/login/login_initial_params.dart';

/// Model used by presenter, contains fields that are relevant to presenters and implements ViewModel to expose data to view (page)
class LoginPresentationModel implements LoginViewModel {
  LoginPresentationModel.initial(
    LoginInitialParams initialParams,
  )   : loginResult = const FutureResult.empty(),
        username = "",
        password = "";

  /// Used for the copyWith method
  LoginPresentationModel._(
    this.loginResult,
    this.username,
    this.password,
  );

  final FutureResult<Either<LogInFailure, User>> loginResult;

  @override
  final String password;

  @override
  final String username;

  @override
  bool get isLoadingButtonEnabled => username.isNotEmpty && password.isNotEmpty;

  @override
  bool get isLoading => loginResult.isPending();

  LoginPresentationModel copyWith({
    FutureResult<Either<LogInFailure, User>>? loginResult,
    bool? isLoadingButtonEnabled,
    String? username,
    String? password,
  }) {
    return LoginPresentationModel._(
      loginResult ?? this.loginResult,
      username ?? this.username,
      password ?? this.password,
    );
  }
}

/// Interface to expose fields used by the view (page).
abstract class LoginViewModel {
  String get username;

  String get password;

  bool get isLoadingButtonEnabled;

  bool get isLoading;
}
