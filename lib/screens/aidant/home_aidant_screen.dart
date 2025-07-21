import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpme/models/demande_model.dart';
import 'package:helpme/models/propositions_model.dart';
import 'package:helpme/provider/provider.dart';

class HomeAidantScreen extends ConsumerStatefulWidget {
  const HomeAidantScreen({super.key});

  @override
  ConsumerState<HomeAidantScreen> createState() => _HomeAidantScreenState();
}

class _HomeAidantScreenState extends ConsumerState<HomeAidantScreen> {
  //------------------- Fonction pour Propose son aide -------------------------------------------
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
        title: Text("Message pour le bénéficiaire"),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(hintText: "Ex : je peux vous aider."),
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
      ref.invalidate(mesPropositionsProvider);
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Proposition envoyée',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  //---------------------------------------------------------------------------------------------------

  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: ref.read(searchProvider));
    searchController.addListener(() {
      ref.read(searchProvider.notifier).state = searchController.text;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final demandes = ref.watch(demandesFiltresProvider);
    final userUid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        color: Colors.green,
        onRefresh: () => ref.refresh(demandesFiltresProvider.future),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green, width: 2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green, width: 2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        hintText: 'Recherche par lieu/catégorie',
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                          onPressed: () {
                            searchController.clear();
                            ref.watch(searchProvider.notifier).state = '';
                          },
                          icon: Icon(Icons.clear),
                        ),
                      ),
                      onChanged: (value) =>
                          ref.read(searchProvider.notifier).state = value,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                "Demande d'aide public disponible : ",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: demandes.when(
                data: (data) {
                  if (data.isEmpty) {
                    return Center(
                      child: Text('Aucune demande d\'aide disponible'),
                    );
                  }

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final d = data[index];
                      final dejaPropose = ref.watch(
                        existProposition((d.uid, userUid)),
                      );

                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Card(
                          elevation: 5,
                          color: Colors.teal[50],
                          child: ListTile(
                            title: Text(
                              d.titre.toUpperCase(),
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Date : ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(d.date.toLowerCase()),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Catégorie : ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(d.categorie.toLowerCase()),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Lieu : ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(d.lieu.toLowerCase()),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Description',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(d.description.toLowerCase()),
                                  ],
                                ),
                              ],
                            ),
                            isThreeLine: true,
                            trailing: dejaPropose.when(
                              data: (data) {
                                return ElevatedButton(
                                  onPressed: data
                                      ? null
                                      : () {
                                          try {
                                            proposeAide(context, d, ref);
                                          } catch (e) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  e.toString(),
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                backgroundColor: Colors.green,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                              ),
                                            );
                                          }
                                        },
                                  child: Text(data ? "Déjà propose" : "Aide"),
                                );
                              },
                              error: (error, stackTrace) => Icon(Icons.error),
                              loading: () => SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                error: (error, stackTrace) =>
                    Center(child: Text(error.toString())),
                loading: () => Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
