
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:intl/intl.dart';


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
      "CREATEDAT": DateTime.now()
    };
    addAnnounce(map);

  }

  Future <Annonce> getAnnounce(String uid) async {
    DocumentSnapshot snapshot = await fire_announce.doc(uid).get();
    return Annonce(snapshot);
  }

  getStreamAnnouncesByUser() async{
    var annoucesByUser = await fire_announce.where("USERID", isEqualTo: GlobalUser.id).orderBy("CREATEDAT", descending: true).get().then(
      (QuerySnapshot querySnapshot) {
        if(querySnapshot != null){
          List listAnnounces = [];
          querySnapshot.docs.forEach((doc) {

            var urlPicture = doc["URLPICTURE"];
            if(urlPicture == ""){
              urlPicture = "https://letetris.fr/sites/default/files/letetris/styles/galerie_photos/public/ged/dsc03041_cmarius_gonzales.jpg?itok=jorASQl4";
            }
            DateTime dateTime = (doc["CREATEDAT"] as Timestamp).toDate();
            var newDateTime = DateFormat("dd/MM/yyyy hh:mm").format(dateTime);
            var rawData = {
              "id" : doc.id,
              "titre" : doc["TITRE"],
              "contenu" : doc["CONTENU"],
              "urlPicture" : urlPicture,
              "created_at" : newDateTime
            };
            listAnnounces.add(rawData);
          });
          return listAnnounces;
        }
      });
     return annoucesByUser;
  }

  getStreamAllAnnounce() async{
    var annoucesByUser = await fire_announce.orderBy("CREATEDAT", descending: false).get().then(
            (QuerySnapshot querySnapshot) {
          if(querySnapshot != null){
            List listAnnounces = [];
            querySnapshot.docs.forEach((doc) {
              var urlPicture = doc["URLPICTURE"];
              if(urlPicture == ""){
                urlPicture = "https://letetris.fr/sites/default/files/letetris/styles/galerie_photos/public/ged/dsc03041_cmarius_gonzales.jpg?itok=jorASQl4";
              }
              DateTime dateTime = (doc["CREATEDAT"] as Timestamp).toDate();
              var newDateTime = DateFormat("dd/MM/yyyy hh:mm").format(dateTime);
              var rawData = {
                "id" : doc.id,
                "titre" : doc["TITRE"],
                "contenu" : doc["CONTENU"],
                "urlPicture" : urlPicture,
                "created_at" : newDateTime
              };
              listAnnounces.add(rawData);
            });
            return listAnnounces;
          }
        });
    return annoucesByUser;
  }

  addAnnounce(Map<String,dynamic> map){
    fire_announce.doc().set(map);
  }

  updateAnnounce(String uid , Map<String,dynamic> map) async{
    return await fire_announce.doc(uid).update(map);
  }

  deleteAnnounce(String uid) async{
    return await fire_announce.doc(uid).delete();
  }

  Future stockageImage(Uint8List bytes, String name, aid) async {
    String url = "";
    String nameFinal = name + aid;

    // stocke l'img dans bdd
    TaskSnapshot taskSnapshot = await storage.ref("ImageAnnounce/$nameFinal").putData(bytes);

    // récupération du lien de l'img dans la bdd
    url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }
}