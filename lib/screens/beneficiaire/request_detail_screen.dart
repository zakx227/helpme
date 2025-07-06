import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpme/models/demande_model.dart';
import 'package:helpme/models/propositions_model.dart';
import 'package:helpme/provider/provider.dart';

class RequestDetailScreen extends ConsumerStatefulWidget {
  final DemandeModel demandeModel;
  const RequestDetailScreen({super.key, required this.demandeModel});

  @override
  ConsumerState<RequestDetailScreen> createState() =>
      _RequestDetailScreenState();
}

class _RequestDetailScreenState extends ConsumerState<RequestDetailScreen> {
  bool? cloture = false;

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

  Future clotureDemande() async {
    try {
      await FirebaseFirestore.instance
          .collection('demandes')
          .doc(widget.demandeModel.uid)
          .update({'cloture': true});
      setState(() {
        cloture = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Demande cloturee avec succès',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
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
      appBar: AppBar(title: Text("Details de la demande")),
      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.demandeModel.titre),
            SizedBox(height: 4),
            Text("Categorie: ${widget.demandeModel.categorie}"),
            Text("Lieu: ${widget.demandeModel.lieu}"),
            Text("Description: ${widget.demandeModel.lieu}"),
            SizedBox(height: 4),
            Divider(),
            Text("Propositions recues :"),
            SizedBox(height: 4),
            Expanded(
              child: propositions.when(
                data: (data) {
                  if (data.isEmpty) {
                    return Text("Aucune propositions");
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final p = data[index];
                      return ListTile(
                        leading: Icon(Icons.handshake),
                        title: Text(p.message),
                        subtitle: Text("ID de l'aidant : ${p.userUid}"),
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
                ? ElevatedButton.icon(
                    onPressed: () {
                      clotureDemande();
                      ref.invalidate(mesDemandesProvider);
                    },
                    label: Text("Cloture la demande"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  )
                : Text(
                    'Cette demande est cloture',
                    style: TextStyle(color: Colors.green),
                  ),
          ],
        ),
      ),
    );
  }
}
