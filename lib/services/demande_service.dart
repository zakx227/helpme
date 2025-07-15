import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpme/models/demande_model.dart';

class DemandeService {
  final _firestore = FirebaseFirestore.instance;

  //--------------------Enregistrement d'une demande -----------------------------------------

  Future<void> saveDemande(DemandeModel demande) async {
    await _firestore
        .collection('demandes')
        .doc(demande.uid)
        .set(demande.toJson());
  }
}

Future<void> deleteDemande(DemandeModel demande) async {
  await FirebaseFirestore.instance
      .collection('demandes')
      .doc(demande.uid)
      .delete()
      .catchError(throw Exception());
}
