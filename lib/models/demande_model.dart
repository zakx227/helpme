class DemandeModel {
  final String uid;
  final String userUid;
  final String titre;
  final String description;
  final String categorie;
  final String lieu;
  final String date;
  final bool? cloture;

  DemandeModel({
    required this.uid,
    required this.userUid,
    required this.titre,
    required this.description,
    required this.categorie,
    required this.lieu,
    required this.date,
    this.cloture = false,
  });
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'userUid': userUid,
      'titre': titre,
      'description': description,
      'categorie': categorie,
      'lieu': lieu,
      'date': date,
      'cloture': cloture,
    };
  }

  factory DemandeModel.fromJson(Map<String, dynamic> map) {
    return DemandeModel(
      uid: map['uid'],
      userUid: map['userUid'],
      titre: map['titre'],
      description: map['description'],
      categorie: map['categorie'],
      lieu: map['lieu'],
      date: map['date'],
      cloture: map['cloture'] ?? false,
    );
  }
}
