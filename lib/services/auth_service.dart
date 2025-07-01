import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  //----------------------Connexion---------------------------------
  Future<String?> signIn(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    DocumentSnapshot userDoc = await _firestore
        .collection('users')
        .doc(userCredential.user!.uid)
        .get();
    return userDoc['role'];
  }

  //--------------------Deconnxion--------------------------------
  Future<String?> logout() async {
    try {
      await _auth.signOut();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code.toString();
    }
  }

  //------------------------ Mode de passe oublie------------------
  Future<String?> passwordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code.toString();
    }
  }
}
