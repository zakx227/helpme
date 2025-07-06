import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpme/models/user_model.dart';
import 'package:helpme/provider/provider.dart';
import 'package:helpme/services/user_service.dart';
import 'package:helpme/widgets/custom_button.dart';

final isLoading = StateProvider((ref) => false);

class EditProfileScreen extends ConsumerStatefulWidget {
  final UserModel userModel;
  const EditProfileScreen({super.key, required this.userModel});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController quartierController;
  late TextEditingController telController;
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userModel.name);
    quartierController = TextEditingController(text: widget.userModel.quartier);
    telController = TextEditingController(text: widget.userModel.tel);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.green),
        ),
      ),
      body: user.when(
        data: (data) {
          nameController = TextEditingController(text: data?.name);
          quartierController = TextEditingController(text: data?.quartier);
          telController = TextEditingController(text: data?.tel);
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Text(
                      'MODIFIER SON COMPTE',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Le nom est requis';
                        }
                        return null;
                      },
                      obscureText: false,
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Nom et Prenom',
                        hintStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                        ),
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
                          return 'Le quartier est requis';
                        }
                        return null;
                      },
                      obscureText: false,
                      controller: quartierController,
                      decoration: InputDecoration(
                        hintText: 'Quartier',
                        hintStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        ),
                        prefixIcon: Icon(Icons.villa, color: Colors.black87),
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
                          return 'Numéro de téléphone invalide';
                        }
                        return null;
                      },
                      obscureText: false,
                      controller: telController,
                      decoration: InputDecoration(
                        hintText: 'Telephone',
                        hintStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        ),
                        prefixIcon: Icon(Icons.phone, color: Colors.black87),
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
                      title: 'MODIFIER',
                      color: Colors.green,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          ref.read(isLoading.notifier).state = true;
                          try {
                            UserModel userModel = UserModel(
                              uid: widget.userModel.uid,
                              name: nameController.text,
                              email: widget.userModel.email,
                              quartier: quartierController.text,
                              tel: telController.text,
                              role: widget.userModel.role,
                            );

                            UserService().updateUser(userModel);
                            ref.invalidate(userProvider);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Modification reussi !',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            Navigator.pop(context);
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
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } finally {
                            ref.read(isLoading.notifier).state = false;
                          }
                        }
                      },
                      isLoading: ref.watch(isLoading),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        error: (error, stackTrace) => Center(child: Text(error.toString())),

        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
