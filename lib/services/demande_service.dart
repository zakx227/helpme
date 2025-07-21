import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpme/models/demande_model.dart';

class DemandeService {
  final _firestore = FirebaseFirestore.instance;

  //--------------------Enregistrement d'une demande -----------------------------------------

  Future<String?> saveDemande(DemandeModel demande) async {
    try {
      await _firestore
          .collection('demandes')
          .doc(demande.uid)
          .set(demande.toJson());
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}

Future<void> deleteDemande(DemandeModel demande) async {
  await FirebaseFirestore.instance
      .collection('demandes')
      .doc(demande.uid)
      .delete()
      .catchError(throw Exception());
}
