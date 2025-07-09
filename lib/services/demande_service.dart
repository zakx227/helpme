import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpme/models/demande_model.dart';

class DemandeService {
  final _firestore = FirebaseFirestore.instance;

  //--------------------Enregistrement d'une demande -----------------------------------------

  Future<void> saveDemande(DemandeModel demande) async {
    try {
      await _firestore
          .collection('demandes')
          .doc(demande.uid)
          .set(demande.toJson());
    } on FirebaseException catch (e) {
      throw Exception(
        '${e.toString()} Une erreur inattendu est survenue veuillez recommence',
      );
    }
  }
}
