import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpme/models/propositions_model.dart';
import 'package:helpme/provider/provider.dart';

class ResponseScreen extends ConsumerWidget {
  const ResponseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historique = ref.watch(mesPropositionsProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Text(''),
        title: const Text(
          "Mes aides proposées",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: historique.when(
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text("Aucune aide proposée."));
          }

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final prop = list[index]['proposition'] as PropositionsModel;
              final titre = list[index]['titre'];
              final beneficiaire = list[index]['beneficiaire'];
              final cloture = list[index]['cloture'] as bool;

              return ListTile(
                leading: const Icon(Icons.history),
                title: Text("Message : ${prop.message}"),
                subtitle: Text(
                  "Titre : $titre\nNom : $beneficiaire\nStatut : ${cloture ? 'Clôturée' : 'Active'}",
                ),
                isThreeLine: true,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text("Une erreur inattendu est survenue veuillez recommence"),
        ),
      ),
    );
  }
}
