import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:helpme/models/user_model.dart';

class UserService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  //---------------- Enregistrement d'un user ----------------------------
  Future<String?> signUp(
    String name,
    String email,
    String quartier,
    String tel,
    String role,
    String password,
  ) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    String uid = userCredential.user!.uid;
    UserModel userModel = UserModel(
      uid: uid,
      name: name,
      email: email,
      quartier: quartier,
      tel: tel,
      role: role,
    );
    await _firestore
        .collection('users')
        .doc(userModel.uid)
        .set(userModel.toJson());
    return null;
  }

  //-------------------------Obtenir un user-----------------------
  Future<UserModel?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  //-----------------------Maitre a jour un user----------------
  Future<void> updateUser(UserModel userModel) async {
    await _firestore
        .collection('users')
        .doc(userModel.uid)
        .update(userModel.toJson());
  }
  //---------------supprime un user -----------------

  Future<void> deleteUser(UserModel userModel) async {
    await _firestore.collection('users').doc(userModel.uid).delete();
  }
}
