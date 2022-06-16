
import 'package:cloud_firestore/cloud_firestore.dart';

// Constructeur de la classe Favori via Firebase

class Favori {
  //Attributs
  late String id ;
  late String userId; 
  late String annonceId; 




  //Constructeur
  Favori(DocumentSnapshot snapshot){

    id = snapshot.id;
    Map<String,dynamic> map = snapshot.data() as Map<String,dynamic>;
    userId = map["userId"];
    annonceId = map["annonceId"];
  }



  //Deuxième constructeur qui va affecter les valeurs à vide
  Favori.empty() {
    id = "";
    userId = "";
    annonceId = "";
  }
}