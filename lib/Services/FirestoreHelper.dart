
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:leboncoin/Model/Utilisateur.dart';

class FirestoreHelper{

  //Attributs
   final auth = FirebaseAuth.instance;
   final fire_users = FirebaseFirestore.instance.collection("Utilisateurs");
   final storage = FirebaseStorage.instance;





   //Méthodes
    Future createUser(String nom, DateTime birthday, String password, String mail, String prenom) async {
       UserCredential resultat = await auth.createUserWithEmailAndPassword(email: mail, password: password);
       User userFirebase = resultat.user!;
       String uid = userFirebase.uid;
       Map<String,dynamic> map = {
         "MAIL": mail,
         "AVATAR" : null,
         "PSEUDO" : null,
         "PRENOM" : prenom,
         "NOM": nom,
         "BIRTHDAY": birthday,

       };
       addUser(uid, map);

    }


    Future <Utilisateur> connectUser(String mail, String password) async {
      UserCredential resultat = await auth.signInWithEmailAndPassword(email: mail, password: password);
      String uid = resultat.user!.uid;
      return getUser(uid);
    }


    Future <Utilisateur> getUser(String uid) async {
      DocumentSnapshot snapshot = await fire_users.doc(uid).get();
      return Utilisateur(snapshot);
    }

    String getIdentifiant() {
      return auth.currentUser!.uid;
    }

    addUser(String uid , Map<String,dynamic> map){
       fire_users.doc(uid).set(map);
    }

    updateUser(String uid , Map<String,dynamic> map){
      fire_users.doc(uid).update(map);
    }

    Future stockageImage(Uint8List bytes, String name) async {
      String url = "";
      String nameFinal = name + getIdentifiant();

      // stocke l'img dans bdd
      TaskSnapshot taskSnapshot = await storage.ref("ProfilImage/$nameFinal").putData(bytes);

      // récupération du lien de l'img dans la bdd
      url = await taskSnapshot.ref.getDownloadURL();
      return url;
    }
}