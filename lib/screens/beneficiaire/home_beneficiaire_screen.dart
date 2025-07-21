import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpme/provider/provider.dart';
import 'package:helpme/screens/beneficiaire/request_detail_screen.dart';
import 'package:helpme/screens/beneficiaire/request_screen.dart';

class HomeBeneficiaireScreen extends ConsumerWidget {
  const HomeBeneficiaireScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final demandes = ref.watch(mesDemandesProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: demandes.when(
        data: (data) {
          if (data.isEmpty) {
            return Center(
              child: Text(
                textAlign: TextAlign.center,
                "Aucune demande trouvée.\nVous pouvez en créer une en appuyant sur le bouton '+' en bas à droite.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final d = data[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RequestDetailScreen(demandeModel: d),
                    ),
                  );
                },
                child: Card(
                  elevation: 5,
                  color: Colors.teal[50],
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      d.titre,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Date: ${d.date}\n${d.description}",
                      style: TextStyle(fontSize: 13),
                    ),
                    isThreeLine: true,
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          d.cloture == true ? "Cloture" : "En cours",
                          style: TextStyle(
                            color: d.cloture == true
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) =>
            Center(child: Text("Une erreur est survenue, veuillez réessayer.")),
        loading: () => Center(child: CircularProgressIndicator()),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RequestScreen()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
