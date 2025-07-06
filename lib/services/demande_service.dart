import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpme/models/demande_model.dart';

class DemandeService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> saveDemande(DemandeModel demande) async {
    await _firestore
        .collection('demandes')
        .doc(demande.uid)
        .set(demande.toJson());
  }
}
