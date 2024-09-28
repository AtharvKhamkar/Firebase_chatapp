import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sample_chat_app/models/user_profile.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  CollectionReference? _userCollection;

  DatabaseService() {
    _setupCollectionReferences();
  }

  void _setupCollectionReferences() {
    _userCollection = _firebaseFirestore
        .collection('users')
        .withConverter<UserProfile>(
            fromFirestore: (snapshot, _) =>
                UserProfile.fromJson(snapshot.data()!),
            toFirestore: (userProfile, _) => userProfile.toJson());
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
    await _userCollection?.doc(userProfile.uid).set(userProfile);
  }
}
