import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpme/models/demande_model.dart';
import 'package:helpme/models/propositions_model.dart';
import 'package:helpme/provider/provider.dart';

class HomeAidantScreen extends ConsumerWidget {
  const HomeAidantScreen({super.key});

  Future<void> proposeAide(
    BuildContext context,
    DemandeModel demande,
    WidgetRef ref,
  ) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final controller = TextEditingController();
    final ok = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Message pour le beneficiaire"),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(hintText: "Ex : je peux vous aide"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Annuler"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Envoyer"),
          ),
        ],
      ),
    );
    if (ok == true && controller.text.isNotEmpty) {
      final proposition = PropositionsModel(
        demandeUid: demande.uid,
        userUid: uid,
        message: controller.text,
      );
      await FirebaseFirestore.instance
          .collection('demandes')
          .doc(demande.uid)
          .collection('propositions')
          .doc(uid)
          .set(proposition.toJson());

      ref.invalidate(existProposition((demande.uid, uid)));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Proposition envoyee',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final demandes = ref.watch(demandePublique);
    final userUid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      body: demandes.when(
        data: (data) {
          if (data.isEmpty) {
            return Center(child: Text('Aucune demande'));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final d = data[index];
              final dejaPropose = ref.watch(existProposition((d.uid, userUid)));

              return Card(
                child: ListTile(
                  title: Text(d.titre),
                  subtitle: Text(
                    '${d.categorie} - ${d.lieu}\n${d.description}',
                  ),
                  isThreeLine: true,
                  trailing: dejaPropose.when(
                    data: (data) {
                      return ElevatedButton(
                        onPressed: data
                            ? null
                            : () {
                                proposeAide(context, d, ref);
                              },
                        child: Text(data ? "Deja propose" : "Aide"),
                      );
                    },
                    error: (error, stackTrace) => Icon(Icons.error),
                    loading: () => SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
