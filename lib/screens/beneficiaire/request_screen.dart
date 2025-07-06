import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpme/models/demande_model.dart';
import 'package:helpme/provider/provider.dart';
import 'package:helpme/widgets/custom_button.dart';
import 'package:uuid/uuid.dart';

final isLoading = StateProvider((ref) => false);

class RequestScreen extends ConsumerStatefulWidget {
  const RequestScreen({super.key});

  @override
  ConsumerState<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends ConsumerState<RequestScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titreController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _lieuController = TextEditingController();

  final TextEditingController _dateController = TextEditingController();

  String categorie = 'Courses';

  final List<String> categories = [
    'Courses',
    'Baby-sitting',
    'Bricolage',
    'Autre',
  ];
  void saveDemande() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final demande = DemandeModel(
      uid: Uuid().v4(),
      userUid: uid,
      titre: _titreController.text,
      description: _descriptionController.text,
      categorie: categorie,
      lieu: _lieuController.text,
      date: _dateController.text,
    );

    if (_formKey.currentState!.validate()) {
      ref.read(isLoading.notifier).state = true;
      try {
        await ref.read(sqliteProvider).insertDemande(demande);
        await ref.read(demandeServiceProvider).saveDemande(demande);
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Enregistrement reussi !',
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
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } finally {
        ref.read(isLoading.notifier).state = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Le titre est requis';
                    }
                    return null;
                  },
                  obscureText: false,
                  controller: _titreController,
                  decoration: InputDecoration(
                    hintText: 'Titre',
                    hintStyle: TextStyle(color: Colors.black87, fontSize: 18),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.black87),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Color(0xFFedf0f8),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La description est requis';
                    }
                    return null;
                  },
                  maxLength: 100,
                  obscureText: false,
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: TextStyle(color: Colors.black87, fontSize: 18),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.black87),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Color(0xFFedf0f8),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField(
                  value: categorie,
                  items: categories
                      .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                      )
                      .toList(),
                  onChanged: (value) => setState(() {
                    categorie = value!;
                  }),
                  decoration: InputDecoration(labelText: "Categorie"),
                ),
                SizedBox(height: 10),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Le lieu est requis';
                    }
                    return null;
                  },
                  obscureText: false,
                  controller: _lieuController,
                  decoration: InputDecoration(
                    hintText: 'Lieu',
                    hintStyle: TextStyle(color: Colors.black87, fontSize: 18),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.black87),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Color(0xFFedf0f8),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Le date est requis';
                    }
                    return null;
                  },
                  obscureText: false,
                  controller: _dateController,
                  decoration: InputDecoration(
                    hintText: 'Date',
                    hintStyle: TextStyle(color: Colors.black87, fontSize: 18),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.black87),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Color(0xFFedf0f8),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                CustomButton(
                  title: 'CREER VOTREZ COMPTE',
                  color: Colors.green,
                  onPressed: () {
                    saveDemande();
                    ref.invalidate(mesDemandesProvider);
                  },
                  isLoading: ref.watch(isLoading),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
