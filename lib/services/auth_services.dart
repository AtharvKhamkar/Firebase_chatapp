import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sample_chat_app/services/alert_service.dart';
import 'package:sample_chat_app/services/navigation_service.dart';

class AuthService {
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;
  late AlertService _alertService;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  User? _user;

  User? get user {
    return _user;
  }

  AuthService() {
    _firebaseAuth.authStateChanges().listen(authServiceChangesStreamListner);
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
  }

  Future<bool> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> logout() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> signup(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        _user = credential.user;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  void authServiceChangesStreamListner(User? user) {
    if (user != null) {
      _user = user;
    } else {
      _user = null;
    }
  }

  Future<bool> isUserRegistered(String email) async {
    try {
      QuerySnapshot query = await _firebaseFirestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      print(query.docs);

      return query.docs.isNotEmpty;
    } catch (e) {
      print('error: $e');
      return false;
    }
  }

  Future<void> handleGoogleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        print('google Id of the user is $googleUser.id');

        //check user exists or not
        bool userExists = await isUserRegistered(googleUser.email);

        print('Checking user exists or not $userExists');

        if (userExists) {
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
          User? user = userCredential.user;

          if (user != null) {
            print('User signed in: ${user.email}');
            _navigationService.pushReplacementNamed('/home');
          }
        } else {
          _alertService.showToast(text: 'You have not registered yet!');
        }
      }
    } catch (e) {
      print(e.toString());
      _alertService.showToast(text: 'An error occured while signing user');
    }
  }
}
