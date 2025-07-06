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
      body: demandes.when(
        data: (data) {
          if (data.isEmpty) {
            return Center(child: Text('Aucune demande'));
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
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(d.titre),
                    subtitle: Text(
                      "${d.categorie} - ${d.date}\n${d.description}",
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
        error: (error, stackTrace) => Center(child: Text(error.toString())),
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
