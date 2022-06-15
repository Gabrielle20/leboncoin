
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:leboncoin/Model/Annonce.dart';
import '../Services/global.dart';


class FirestoreAnnounceHelper{

  //Attributs
  final auth = FirebaseAuth.instance;
  final fire_announce = FirebaseFirestore.instance.collection("Annonce");
  final storage = FirebaseStorage.instance;

  //Méthodes
  Future createAnnounce(String titre, String contenu, String userId, String urlPicture) async {
    Map<String,dynamic> map = {
      "TITRE": titre,
      "CONTENU" : contenu,
      "URLPICTURE" : urlPicture,
      "USERID" : GlobalUser.id,
    };
    addAnnounce(map);

  }

  Future <Annonce> getAnnounce(String uid) async {
    DocumentSnapshot snapshot = await fire_announce.doc(uid).get();
    return Annonce(snapshot);
  }

  getStreamAnnouncesByUser() async{
     var annoucesByUser = await fire_announce.where("USERID", isEqualTo: GlobalUser.id).get().then(
      (QuerySnapshot querySnapshot) {
        if(querySnapshot != null){
          return querySnapshot;

          /*querySnapshot.docs.forEach((doc) {
            print(doc["first_name"]);
          });*/
        }
      });
  }

  addAnnounce(Map<String,dynamic> map){
    fire_announce.doc().set(map);
  }

  updateAnnounce(String uid , Map<String,dynamic> map){
    fire_announce.doc(uid).update(map);
  }

  /*Future stockageImage(Uint8List bytes, String name) async {
    String url = "";
    String nameFinal = name + getIdentifiant();

    // stocke l'img dans bdd
    TaskSnapshot taskSnapshot = await storage.ref("ProfilImage/$nameFinal").putData(bytes);

    // récupération du lien de l'img dans la bdd
    url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }*/
}