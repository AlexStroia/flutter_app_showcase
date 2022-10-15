import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_demo/core/domain/model/user.dart';
import 'package:flutter_demo/features/auth/domain/model/log_in_failure.dart';
import 'package:flutter_demo/features/auth/domain/use_cases/log_in_use_case.dart';
import 'package:flutter_demo/features/auth/login/login_initial_params.dart';
import 'package:flutter_demo/features/auth/login/login_presentation_model.dart';
import 'package:flutter_demo/features/auth/login/login_presenter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/mocks.dart';
import '../../../test_utils/test_utils.dart';
import '../mocks/auth_mock_definitions.dart';
import '../mocks/auth_mocks.dart';

const _username = "test";
const _password = "test123";
const _id = "id";

const _failUsername = "fail";
const _failPassword = "failPassword";

void main() {
  late LoginPresentationModel model;
  late LoginPresenter presenter;
  late MockLoginNavigator navigator;
  late LogInUseCase logInUseCase;

  setUp(() {
    model = LoginPresentationModel.initial(const LoginInitialParams());
    logInUseCase = AuthMocks.logInUseCase;

    navigator = MockLoginNavigator();
    presenter = LoginPresenter(model, navigator, logInUseCase);
  });

  group('Login Presenter Test', () {
    const user = User(id: _id, username: _username);
    test(
      'should call appInitUseCase on start',
      () async {
        // GIVEN
        whenListen(
          Mocks.userStore,
          Stream.fromIterable([user]),
        );
        when(
          () => AuthMocks.logInUseCase.execute(
            username: _username,
            password: _password,
          ),
        ).thenAnswer((_) => successFuture(user));

        await presenter.login();

        // // THEN
        verify(
          () => AuthMocks.logInUseCase
              .execute(username: _username, password: _password),
        );
        verify(() => Mocks.userStore.stream);
      },
    );

    test(
      'should show error when loginUseCase fails',
      () async {
        // GIVEN
        whenListen(
          Mocks.userStore,
          Stream.fromIterable([const User.anonymous()]),
        );
        when(
          () => AuthMocks.logInUseCase.execute(
            username: _failUsername,
            password: _failPassword,
          ),
        ).thenAnswer((_) => failFuture(const LogInFailure.unknown()));
        when(() => navigator.showError(any()))
            .thenAnswer((_) => Future.value());

        // WHEN
        await presenter.login();

        // THEN
        verify(() => navigator.showError(any()));
      },
    );

    test('Should set isLoadingButtonEnabled to true ', () {
      blocTest<LoginPresenter, LoginViewModel>(
        'emits [LoginPresenter, LoginViewModel]',
        build: () => presenter,
        act: (presenter) {
          presenter.onUsernameChanged(_username);
          presenter.onPasswordChanged(_password);
        },
        expect: () {
          isA<LoginViewModel>().having(
            (state) => state.isLoadingButtonEnabled,
            'state',
            equals(true),
          );
        },
      );
    });
  });
}
