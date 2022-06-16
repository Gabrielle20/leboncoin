import 'dart:io';
import 'dart:typed_data';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leboncoin/Services/FirestoreHelper.dart';
import 'package:leboncoin/Services/global.dart';
import 'package:file_picker/file_picker.dart';
import 'package:leboncoin/View/MyDrawer.dart';

class account extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState(){
    return accountState();
  }
}

class accountState extends State<account>{
  //Variable
  String? nomImage;
  String? urlImage;
  Uint8List? bytesImage;
  bool isEditing = false;
  String pseudoTempo="";

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar : AppBar(
        title : const Text("Mon compte"),
        backgroundColor: Colors.blue,
      ),
      body : Padding(
        padding: const EdgeInsets.all(10),
        child: accountPage()
      ),
    );
  }


  Widget accountPage() {
    return SingleChildScrollView(
        child : Center(
            child: Column(
              children: [
                InkWell(
                  child: Container(
                    height: 120,
                    width:120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(GlobalUser.avatar!),
                          fit: BoxFit.fill
                      ),
                    ),

                  ),
                  onTap: (){
                    MyDrawer().pickImage();
                  },
                ),




                SizedBox(height: 20,),
                //Pseudo qui pourra changer
                TextButton.icon(

                   onPressed: (){

                     if (isEditing == true){
                       setState(() {
                         GlobalUser.pseudo = pseudoTempo;
                         Map<String,dynamic> map = {
                           "PSEUDO": pseudoTempo
                         };
                         FirestoreHelper().updateUser(GlobalUser.id, map);
                       });

                     }
                     setState(() {
                       isEditing = !isEditing;
                     });

                   } ,
                   icon: (isEditing)?const Icon(Icons.check,color: Colors.green,):const Icon(Icons.edit),
                   label: (isEditing)?TextField(
                     decoration: const InputDecoration(
                       hintText: "Entrer le pseudo",
                     ),
                     onChanged: (newValue){
                       setState(() {
                         pseudoTempo=newValue;
                       });
                     },

                   ):
                   Text(GlobalUser.pseudo!)
               ),





                // nom et prénom complet
                const SizedBox(height:10),
                Text("Nom :", textAlign: TextAlign.left,),
                TextField(
                  decoration: InputDecoration(
                    hintText: GlobalUser.nom,
                    icon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                  onChanged: (String value) {
                    setState(() {
                         GlobalUser.nom = value;
                         Map<String,dynamic> map = {
                           "NOM": value
                         };
                         FirestoreHelper().updateUser(GlobalUser.id, map);
                    });
                  }
                ),


                // prenom
                const SizedBox(height:10),
                Text("Prénom :", textAlign: TextAlign.left,),
                TextField(
                  decoration: InputDecoration(
                    hintText: GlobalUser.prenom,
                    icon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                  onChanged: (String value) {
                    setState(() {
                         GlobalUser.prenom = value;
                         Map<String,dynamic> map = {
                           "PRENOM": value
                         };
                         FirestoreHelper().updateUser(GlobalUser.id, map);
                    });
                  }
                ),


                // adresee mail
                const SizedBox(height:10),
                Text("Email :", textAlign: TextAlign.left,),
                TextField(
                  decoration: InputDecoration(
                    hintText: GlobalUser.mail,
                    icon: const Icon(Icons.mail),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                  onChanged: (String value) {
                    setState(() {
                         GlobalUser.mail = value;
                         Map<String,dynamic> map = {
                           "MAIL": value
                         };
                         FirestoreHelper().updateUser(GlobalUser.id, map);
                    });
                  }
                ),

              ]
            )
          )
      );
  }
}