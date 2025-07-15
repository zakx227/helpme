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

//----------------------- Provider pour recupere un user avec son uid-----------------------
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

//------------------------Provider pour recupere une demande en base de donnes local---------------

final sqliteProvider = Provider<SqliteService>((ref) => SqliteService());
final demandeServiceProvider = Provider<DemandeService>(
  (ref) => DemandeService(),
);

final demandeProvider = FutureProvider<List<DemandeModel>>((ref) async {
  final db = ref.watch(sqliteProvider);
  return db.getDemandes();
});
//------------------------------------------------------------------------------

//-----------------------Provider pour recupere les demandes d'un user -----------------
final mesDemandesProvider = FutureProvider<List<DemandeModel>>((ref) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final snapshot = await FirebaseFirestore.instance
      .collection('demandes')
      .where('userUid', isEqualTo: uid)
      .get();
  return snapshot.docs.map((doc) => DemandeModel.fromJson(doc.data())).toList();
});
//---------------------------------------------------------------------------------------

//-------------------------Provider pour ecouter les demandes public ---------------------------
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

//--------------------------------------------------------------------------------------------------

//------------------------Provider pour recupere les proposition d'un user----------------------------
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

//---------------------------------------------------------------------------------------

//---------------------------Provider pour verifier si une proposition existe--------------------
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

//--------------------------------------------------------------------------------------------

//-------------------------- Provider pour filtre les demande par recherche ------------------------
final searchProvider = StateProvider<String>((ref) => '');

final demandesFiltresProvider = StreamProvider<List<DemandeModel>>((ref) {
  final search = ref.watch(searchProvider).toLowerCase();
  return FirebaseFirestore.instance
      .collection('demandes')
      .where('cloture', isEqualTo: false)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => DemandeModel.fromJson(doc.data()))
            .where(
              (d) =>
                  d.lieu.toLowerCase().contains(search) ||
                  d.categorie.toLowerCase().contains(search),
            )
            .toList(),
      );
});

//-----------------------------------------------------------------------------------------------

//------------------------Provider pour recupere les proposition d'un user pou l'historique---------------
final mesPropositionsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final demandesSnap = await FirebaseFirestore.instance
      .collection("demandes")
      .get();

  List<Map<String, dynamic>> historique = [];

  for (final demandeDoc in demandesSnap.docs) {
    final propDoc = await demandeDoc.reference
        .collection("propositions")
        .doc(uid)
        .get();
    if (propDoc.exists) {
      final prop = PropositionsModel.fromJson(propDoc.data()!);
      final demandeData = demandeDoc.data();
      final titre = demandeData['titre'];
      final cloture = demandeData['cloture'];
      final userUid = demandeData['userUid'];

      String nomBeneficiaire = "";
      if (userUid != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc(userUid)
            .get();
        if (userDoc.exists) {
          nomBeneficiaire = userDoc.data()!['name'];
        }
      }

      historique.add({
        "proposition": prop,
        "titre": titre,
        "beneficiaire": nomBeneficiaire,
        "cloture": cloture,
      });
    }
  }

  return historique;
});
//-----------------------------------------------------------------------------------------------------------
