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
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.teal),
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

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Card(
                  elevation: 5,
                  color: Colors.teal[50],
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(
                          "Message : ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(prop.message),
                      ],
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Titre : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(titre),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Nom beneficiaire : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(beneficiaire),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Statut : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              cloture ? "Cloturée" : "Active",
                              style: TextStyle(
                                color: cloture ? Colors.red : Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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


/*
ListTile(
                leading: const Icon(Icons.history),
                title: Text("Message : ${prop.message}"),
                subtitle: Text(
                  "Titre : $titre\nNom beneficiaire : $beneficiaire\nStatut : ${cloture ? 'Clôturée' : 'Active'}",
                ),
                isThreeLine: true,
              );
*/