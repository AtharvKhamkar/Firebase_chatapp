import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sample_chat_app/consts.dart';
import 'package:sample_chat_app/services/alert_service.dart';
import 'package:sample_chat_app/services/auth_services.dart';
import 'package:sample_chat_app/services/navigation_service.dart';
import 'package:sample_chat_app/widgets/custom_form_field.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _loginFormKey = GlobalKey();

  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;
  String? email, password;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [Expanded(child: _buildUI())],
      ),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(
          children: [
            _headerText(),
            _loginForm(),
            const Spacer(),
            _createAnAccount()
          ],
        ),
      ),
    );
  }

  Widget _headerText() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: const Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi Welcome Back!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          Text(
            'Hello again, you have been missed',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.5,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.05,
      ),
      child: Form(
          key: _loginFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomFormField(
                height: MediaQuery.sizeOf(context).height * 0.1,
                hintText: 'Email',
                validationRegEx: EMAIL_VALIDATION_REGEX,
                onSave: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              CustomFormField(
                height: MediaQuery.sizeOf(context).height * 0.1,
                hintText: 'Password',
                validationRegEx: PASSWORD_VALIDATION_REGEX,
                isSuffixIcon: true,
                obsecureText: true,
                onSave: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              _loginButton(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              const Text('Or'),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              _socialSignInSection(),
            ],
          )),
    );
  }

  Widget _loginButton() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.05,
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
        onPressed: () async {
          if (_loginFormKey.currentState?.validate() ?? false) {
            _loginFormKey.currentState?.save();
            print(email);
            print(password);
            bool result = await _authService.login(email!, password!);
            print(result);
            if (result) {
              _navigationService.pushReplacementNamed('/home');
            } else {
              _alertService.showToast(
                  text: 'Failed to login, Please try again!',
                  icon: Icons.error);
            }
          }
        },
        color: Theme.of(context).colorScheme.primary,
        child: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _createAnAccount() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text('Dont have an account?'),
        GestureDetector(
          onTap: () {
            _navigationService.pushNamed('/register');
          },
          child: const Text(
            'Sign Up',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        )
      ],
    );
  }

  Widget _socialSignInSection() {
    return Column(
      children: [
        const Text('Sign In with'),
        SignInButton(Buttons.google, onPressed: _authService.handleGoogleSignIn)
      ],
    );
  }
}
