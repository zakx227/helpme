class PropositionsModel {
  final String demandeUid;
  final String userUid;
  final String message;

  PropositionsModel({
    required this.demandeUid,
    required this.userUid,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {'demandeUid': demandeUid, 'userUid': userUid, 'message': message};
  }

  factory PropositionsModel.fromJson(Map<String, dynamic> map) {
    return PropositionsModel(
      demandeUid: map['demandeUid'],
      userUid: map['userUid'],
      message: map['message'],
    );
  }
}
