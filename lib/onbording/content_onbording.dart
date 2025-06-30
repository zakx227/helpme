class ContentOnbording {
  String image;
  String title;
  String description;
  ContentOnbording({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<ContentOnbording> contents = [
  ContentOnbording(
    image: 'assets/images/img.png',
    title: 'TU VEUX AIDER ? TU ES AU BON ENDROIT !',
    description:
        'Merci de rejoindre HELPME. Ton geste , aussi petit soit-il, peut changer la vie de quelqu\'un aujourd\'hui. Ensemble, construisons une communauté solidaire.',
  ),
  ContentOnbording(
    image: 'assets/images/img0.png',
    title: 'Besoin d\'un coup de main ?',
    description:
        'Que ce soit des courses, un service ou un soutien moral, HELPME te connecte à une communauté prete à tendre la main. Tu n\'es pas seul',
  ),
  ContentOnbording(
    image: 'assets/images/img2.png',
    title: 'Pret(e) à faire partie du changement ?',
    description:
        'Rejoins la communauté HELPME dès maintenant. Ensemble, on est plus fort.',
  ),
];
