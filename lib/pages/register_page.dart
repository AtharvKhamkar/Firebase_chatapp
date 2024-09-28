import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sample_chat_app/consts.dart';
import 'package:sample_chat_app/models/user_profile.dart';
import 'package:sample_chat_app/services/alert_service.dart';
import 'package:sample_chat_app/services/auth_services.dart';
import 'package:sample_chat_app/services/database_service.dart';
import 'package:sample_chat_app/services/media_service.dart';
import 'package:sample_chat_app/services/navigation_service.dart';
import 'package:sample_chat_app/services/storage_service.dart';
import 'package:sample_chat_app/widgets/custom_form_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Initialization of services
  final GetIt _getIt = GetIt.instance;
  late MediaService _mediaService;
  late NavigationService _navigationService;
  late AuthService _authService;
  late StorageService _storageService;
  late DatabaseService _databaseService;
  late AlertService _alertService;

  final GlobalKey<FormState> _registerFormKey = GlobalKey();

  String? email, password, name;
  File? selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _mediaService = _getIt.get<MediaService>();
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
    _storageService = _getIt.get<StorageService>();
    _databaseService = _getIt.get<DatabaseService>();
    _alertService = _getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        child: Column(
          children: [
            _headerText(),
            if (!_isLoading) _registerForm(),
            const Spacer(),
            if (!_isLoading) _loginAccountLink(),
            if (_isLoading)
              const Expanded(
                  child: Center(
                child: CircularProgressIndicator.adaptive(),
              ))
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
            "Let's get going",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          Text(
            'Register an account using the form below',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _registerForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.60,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.05,
      ),
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pfpSelectionField(),
            CustomFormField(
              hintText: 'Name',
              height: MediaQuery.of(context).size.height * 0.1,
              validationRegEx: NAME_VALIDATION_REGEX,
              onSave: (value) {
                name = value;
              },
            ),
            CustomFormField(
              hintText: 'Email',
              height: MediaQuery.of(context).size.height * 0.1,
              validationRegEx: EMAIL_VALIDATION_REGEX,
              onSave: (value) {
                email = value;
              },
            ),
            CustomFormField(
              hintText: 'Password',
              height: MediaQuery.of(context).size.height * 0.1,
              validationRegEx: PASSWORD_VALIDATION_REGEX,
              isSuffixIcon: true,
              obsecureText: true,
              onSave: (value) {
                password = value;
              },
            ),
            _registerButton()
          ],
        ),
      ),
    );
  }

  Widget _pfpSelectionField() {
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaService.getImageFromGallery();
        if (file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.15,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

  Widget _registerButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
        color: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          try {
            setState(() {
              _isLoading = true;
            });
            if ((_registerFormKey.currentState?.validate() ?? false) &&
                selectedImage != null) {
              _registerFormKey.currentState?.save();
              bool result = await _authService.signup(email!, password!);
              if (result) {
                String? pfpUrl = await _storageService.uploadUserPfp(
                    file: selectedImage!, uid: _authService.user!.uid);
                if (pfpUrl != null) {
                  await _databaseService.createUserProfile(
                    userProfile: UserProfile(
                        uid: _authService.user!.uid,
                        name: name,
                        pfpURL: pfpUrl),
                  );
                  _alertService.showToast(
                      text: 'You have registered successfully',
                      icon: Icons.check);
                  _navigationService.goBack();
                  _navigationService.pushReplacementNamed('/home');
                } else {
                  throw Exception('Unable to upload user profile picture');
                }
              } else {
                throw Exception('Unable to register user');
              }
            }
          } catch (e) {
            print(e);
            _alertService.showToast(
                text: 'Failed to register, Please try again later',
                icon: Icons.error);
          }
          setState(() {
            _isLoading = false;
          });
        },
        child: const Text(
          'Register',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLink() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text('Already have an account? '),
        GestureDetector(
          onTap: () {
            _navigationService.goBack();
          },
          child: const Text(
            'Login',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        )
      ],
    );
  }
}
