import 'package:cloud_firestore/cloud_firestore.dart';


// Constructeur de la classe utilisateur via Firebase

class Annonce {
  late String id ;
  late String titre;
  late String contenu;
  late String idUser;
  String? pictureUrl;
  DateTime createdAt = DateTime.now();

    Annonce(DocumentSnapshot snapshot){
      String? urlPicture;

      id = snapshot.id;
      Map<String,dynamic> map = snapshot.data() as Map<String,dynamic>;
      titre = map["TITRE"];
      contenu = map["CONTENU"];
      idUser = map["USERID"];

      urlPicture = map["URLPICTURE"];
      if(urlPicture == null){
        // Une image spécifique que je vais luis donner
        pictureUrl = "";
      }
      else
      {
        pictureUrl = urlPicture;
      }
      Timestamp timestamp = map["CREATEDAT"];
      createdAt = timestamp.toDate();
    }
  }