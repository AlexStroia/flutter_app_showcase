import 'package:flutter/material.dart';
import 'package:flutter_demo/core/utils/mvp_extensions.dart';
import 'package:flutter_demo/features/auth/login/login_presentation_model.dart';
import 'package:flutter_demo/features/auth/login/login_presenter.dart';
import 'package:flutter_demo/localization/app_localizations_utils.dart';

class LoginPage extends StatefulWidget with HasPresenter<LoginPresenter> {
  const LoginPage({
    required this.presenter,
    super.key,
  });

  @override
  final LoginPresenter presenter;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with PresenterStateMixin<LoginViewModel, LoginPresenter, LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: appLocalizations.usernameHint,
                ),
                onChanged: presenter.onUsernameChanged,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: appLocalizations.passwordHint,
                ),
                onChanged: presenter.onPasswordChanged,
              ),
              const SizedBox(height: 16),
              stateObserver(
                builder: (context, state) => state.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: state.isLoadingButtonEnabled
                            ? () => _onLoginTap()
                            : null,
                        child: Text(appLocalizations.logInAction),
                      ),
              ),
            ],
          ),
        ),
      );

  void _onLoginTap() {
    presenter.login();
  }
}
