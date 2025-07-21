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

      body: RefreshIndicator(
        color: Colors.green,
        onRefresh: () => ref.refresh(mesPropositionsProvider.future),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Mes aides proposées:",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.green,
                  fontSize: 25,
                  // decoration: TextDecoration.underline,
                  // decorationColor: Colors.green,
                  // decorationThickness: 2,
                ),
              ),
            ),
            Expanded(
              child: historique.when(
                data: (list) {
                  if (list.isEmpty) {
                    return const Center(child: Text("Aucune aide proposée."));
                  }

                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final prop =
                          list[index]['proposition'] as PropositionsModel;
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(titre),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Nom bénéficiaire : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(beneficiaire),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Statut : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      cloture ? "Cloturée" : "Active",
                                      style: TextStyle(
                                        color: cloture
                                            ? Colors.red
                                            : Colors.green,
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
                  child: Text("Une erreur est survenue, veuillez réessayer."),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
