import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpme/models/demande_model.dart';
import 'package:helpme/models/propositions_model.dart';
import 'package:helpme/models/user_model.dart';
import 'package:helpme/services/demande_service.dart';
import 'package:helpme/services/user_service.dart';
import 'package:helpme/sqlite/sqlite_service.dart';

final isLoadingProvider = StateProvider((ref) => false);

final authStateProvider = StreamProvider((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final userServiceProvider = Provider((ref) {
  return UserService();
});

final userProvider = FutureProvider<UserModel?>((ref) async {
  final user = await ref.watch(authStateProvider.future);
  if (user != null) {
    return ref.watch(userServiceProvider).getUser(user.uid);
  }
  return null;
});

//-------------------------------------------------------------------

final sqliteProvider = Provider<SqliteService>((ref) => SqliteService());
final demandeServiceProvider = Provider<DemandeService>(
  (ref) => DemandeService(),
);

final demandeProvider = FutureProvider<List<DemandeModel>>((ref) async {
  final db = ref.watch(sqliteProvider);
  return db.getDemandes();
});

final mesDemandesProvider = FutureProvider<List<DemandeModel>>((ref) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final snapshot = await FirebaseFirestore.instance
      .collection('demandes')
      .where('userUid', isEqualTo: uid)
      .get();
  return snapshot.docs.map((doc) => DemandeModel.fromJson(doc.data())).toList();
});

final demandePublique = StreamProvider<List<DemandeModel>>((ref) {
  final query = FirebaseFirestore.instance
      .collection('demandes')
      .where('cloture', isEqualTo: false);

  return query.snapshots().map((snapshot) {
    return snapshot.docs
        .map((doc) => DemandeModel.fromJson(doc.data()))
        .toList();
  });
});

final propositionsProvider =
    StreamProvider.family<List<PropositionsModel>, String>((ref, demandUid) {
      final stream = FirebaseFirestore.instance
          .collection('demandes')
          .doc(demandUid)
          .collection('propositions')
          .snapshots();
      return stream.map(
        (snapshot) => snapshot.docs
            .map((doc) => PropositionsModel.fromJson(doc.data()))
            .toList(),
      );
    });

final existProposition =
    FutureProvider.family<bool, (String demandeUid, String userUid)>((
      ref,
      args,
    ) async {
      final (demandeUid, userUid) = args;
      final doc = await FirebaseFirestore.instance
          .collection('demandes')
          .doc(demandeUid)
          .collection('propositions')
          .doc(userUid)
          .get();
      return doc.exists;
    });
