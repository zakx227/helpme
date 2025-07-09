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
  DateTime date = DateTime.now();

  String categorie = 'Courses';

  //--------------Liste des categorie ----------------------------
  final List<String> categories = [
    'Courses',
    'Baby-sitting',
    'Bricolage',
    'Autre',
  ];
  //-----------------------------------------------------------------

  //--------------------Fonction pour enregistre une demande------------------------------
  void saveDemande() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    String finalDate = '${date.day}/${date.month}/${date.year}';

    final demande = DemandeModel(
      uid: Uuid().v4(),
      userUid: uid,
      titre: _titreController.text,
      description: _descriptionController.text,
      categorie: categorie,
      lieu: _lieuController.text,
      date: finalDate,
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
              'Demande ajoute',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        _titreController.clear();
        _descriptionController.clear();
        _lieuController.clear();
        _dateController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Une erreur inattendu est survenue veuillez recommence",
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
  //----------------------------------------------------------------------------------

  //--------------------Fonction recupere une date---------------------------------------
  getDate() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: DateTime(2121),
    );
    if (pickerDate != null) {
      setState(() {
        date = pickerDate;
      });
    }
  }

  //-----------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'AJOUTE UNE DEMANDE',
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
            child: Column(
              children: [
                SizedBox(height: 20),
                //--------------------TextFormFilel pour titre -----------------------------------------
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
                //--------------------TextFormFilel pour description -----------------------------------------
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
                //--------------------TextFormFilel pour categorie -----------------------------------------
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
                  decoration: InputDecoration(
                    labelText: "Categorie",
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Color(0xFFedf0f8),

                    labelStyle: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),

                SizedBox(height: 20),
                //--------------------TextFormFilel pour lieu -----------------------------------------
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
                //--------------------TextFormFilel pour date -----------------------------------------
                TextFormField(
                  readOnly: true,
                  onTap: getDate,
                  obscureText: false,
                  controller: _dateController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.calendar_month_outlined),
                    hintText: '${date.day}/${date.month}/${date.year}',
                    hintStyle: TextStyle(color: Colors.black87, fontSize: 18),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),

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
                  title: 'Ajouter',
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
