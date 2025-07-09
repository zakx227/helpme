import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpme/models/demande_model.dart';
import 'package:helpme/models/propositions_model.dart';
import 'package:helpme/models/user_model.dart';
import 'package:helpme/provider/provider.dart';
import 'package:helpme/widgets/custom_button.dart';

final isLoading = StateProvider((ref) => false);

class RequestDetailScreen extends ConsumerStatefulWidget {
  final DemandeModel demandeModel;
  const RequestDetailScreen({super.key, required this.demandeModel});

  @override
  ConsumerState<RequestDetailScreen> createState() =>
      _RequestDetailScreenState();
}

class _RequestDetailScreenState extends ConsumerState<RequestDetailScreen> {
  bool? cloture = false;

  //--------------------- Fonction recupere les proposition-----------------------------------
  Future<List<PropositionsModel>> fetchProposition() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('dmande')
        .doc(widget.demandeModel.uid)
        .collection('proposition')
        .get();
    return snapshot.docs
        .map((doc) => PropositionsModel.fromJson(doc.data()))
        .toList();
  }
  //---------------------------------------------------------------------------------------------

  //---------------------------Fonction cloture une demande ----------------------------------
  Future clotureDemande() async {
    try {
      await FirebaseFirestore.instance
          .collection('demandes')
          .doc(widget.demandeModel.uid)
          .update({'cloture': true});
      setState(() {
        cloture = true;
      });
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Demande cloturee avec succès',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  //--------------------------------------------------------------------------------------

  //-----------------------Fonction pour recupere un user -------------------------------------
  Future<UserModel?> fetchUser(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    if (!doc.exists) {
      return null;
    }
    return UserModel.fromJson(doc.data()!);
  }
  //-----------------------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    cloture = widget.demandeModel.cloture;
  }

  @override
  Widget build(BuildContext context) {
    final propositions = ref.watch(
      propositionsProvider(widget.demandeModel.uid),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'DETAIL DE LA DEMANDE',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.green),
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.demandeModel.titre.toUpperCase(),
              style: TextStyle(
                fontSize: 20,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'CATEGORIE : ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
                Text(widget.demandeModel.categorie.toUpperCase()),
              ],
            ),

            Row(
              children: [
                Text(
                  'LIEU : ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
                Text(widget.demandeModel.lieu.toUpperCase()),
              ],
            ),

            Text(
              'DESCRIPTION',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.green,
              ),
            ),
            Text(
              widget.demandeModel.description.toLowerCase(),
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Divider(color: Colors.black),
            Text(
              "Propositions recues :",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 4),
            Expanded(
              child: propositions.when(
                data: (data) {
                  if (data.isEmpty) {
                    return Center(child: Text("Aucune propositions"));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final p = data[index];
                      return FutureBuilder(
                        future: fetchUser(p.userUid),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return ListTile(
                              title: Text(p.message),
                              subtitle: Text("Chargement des infos"),
                            );
                          }
                          final user = snapshot.data!;
                          return ListTile(
                            leading: Icon(
                              Icons.handshake,
                              color: Colors.green,
                              size: 50,
                            ),
                            title: Text(p.message),
                            subtitle: Text(
                              "Nom : ${user.name} \nContact : ${user.tel}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                error: (error, stackTrace) =>
                    Center(child: Text(error.toString())),
                loading: () => Center(child: CircularProgressIndicator()),
              ),
            ),
            cloture == false
                ? SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        clotureDemande();
                        ref.invalidate(mesDemandesProvider);
                      },
                      label: Text(
                        "Cloture la demande",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cette demande est cloture',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 70,
                        width: 130,
                        child: CustomButton(
                          color: Colors.red,
                          title: 'Supprimer',
                          isLoading: ref.watch(isLoading),
                          onPressed: () async {
                            try {
                              ref.read(isLoading.notifier).state = true;
                              final docRef = FirebaseFirestore.instance
                                  .collection('demandes')
                                  .doc(widget.demandeModel.uid);
                              await docRef.delete();
                              if (!context.mounted) {
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Demande Supprime',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              Navigator.pop(context);
                              ref.invalidate(mesDemandesProvider);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Une erreur inattendu est survenue veuillez recommence",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            } finally {
                              ref.read(isLoading.notifier).state = false;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

/*
 ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () async {
                          try {
                            final docRef = FirebaseFirestore.instance
                                .collection('demandes')
                                .doc(widget.demandeModel.uid);
                            await docRef.delete();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Demande Supprime',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            Navigator.pop(context);
                            ref.invalidate(mesDemandesProvider);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  e.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Supprimer",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

*/
