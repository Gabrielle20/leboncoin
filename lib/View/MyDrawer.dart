import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leboncoin/Services/FirestoreHelper.dart';
import 'package:leboncoin/Services/global.dart';
import 'package:file_picker/file_picker.dart';
import 'package:leboncoin/View/account.dart';
import 'package:leboncoin/View/Annonces/AnnounceByUser.dart';
import 'package:leboncoin/View/dashBoard.dart';

class MyDrawer extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MyDrawerState();
  }

  void pickImage() {}

}

class MyDrawerState extends  State<MyDrawer>{
  //Variable
  String? nomImage;
  String? urlImage;
  Uint8List? bytesImage;
  bool isEditing = false;
  String pseudoTempo="";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
          child:  Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                //Avatar cliquable
                InkWell(
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(GlobalUser.avatar!),
                          fit: BoxFit.fitHeight
                      ),
                    ),

                  ),
                  onTap: (){
                    print("J'ai cliquer sur l'image");
                    pickImage();
                  },
                ),
                SizedBox(height: 10,),


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
                Text(GlobalUser.nomComplet()),


                // adresee mail
                Text(GlobalUser.mail),

                SizedBox(height: 5),
                ElevatedButton.icon(
                    onPressed: (){

                      // link to favoris

                      // Navigator.push(context, MaterialPageRoute(builder: (context) {
                      //   return account();
                      // }));
                    },
                    icon: const Icon(Icons.heart_broken),
                    label: const Text("Mes Favoris"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    ),
                ),


                SizedBox(height: 5),
                ElevatedButton.icon(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return account();
                      }));
                    },
                    icon: const Icon(Icons.home),
                    label: const Text("Mon Compte")
                ),

                SizedBox(height: 5),
                ElevatedButton.icon(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.exit_to_app_sharp),
                    label: const Text("Fermer")
                ),

                SizedBox(height: 5),
                ElevatedButton.icon(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return dashBoard();
                      }));
                    },
                    icon: const Icon(Icons.my_library_books),
                    label: const Text("Toutes les annonces"),
                ),

                SizedBox(height: 5),
                ElevatedButton.icon(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return announceByUser();
                      }));
                    },
                    icon: const Icon(Icons.my_library_books_outlined),
                    label: const Text("Mes annonces"),
                ),
              ],
            ),
          ),
        ),
    );

  }

  //Fonction

  //Choisir l'image
  Future pickImage() async{
    FilePickerResult? resultat = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.image
    );
    if (resultat != null){
      nomImage = resultat.files.first.name;
      bytesImage = resultat.files.first.bytes;
      MyPopUp();
      
    }



  }
  
  //Création de notre popUp
  MyPopUp(){
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context){
            if(Platform.isIOS){
              return CupertinoAlertDialog(
                title: const Text("Mon image"),
                content: Image.memory(bytesImage!),
                actions: [
                  ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      }, 
                      child: const Text("Annuler"),
                  ),

                  ElevatedButton(
                    onPressed: (){
                      //Stocker et on va récupérer son url
                      FirestoreHelper().stockageImage(bytesImage!, nomImage!).then((value){
                        setState(() {
                          GlobalUser.avatar = value;
                          urlImage = value;
                        });
                        //Mettre à jour notre base de donnée en stockant l'url
                        Map<String,dynamic> map ={
                          //Key : Valeur
                          "AVATAR":urlImage
                        };
                        FirestoreHelper().updateUser(GlobalUser.id, map);



                        Navigator.pop(context);
                      });


                    },
                    child: const Text("Enregistrement"),
                  ),
                ],
              );
            }
            else {
              return AlertDialog(
                title: const Text("Mon image"),
                content: Image.memory(bytesImage!),
                actions: [
                  ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text("Annuler"),
                  ),

                  ElevatedButton(
                    onPressed: (){
                      //Stocker et on va récupérer son url
                      FirestoreHelper().stockageImage(bytesImage!, nomImage!).then((value){
                        setState(() {
                          GlobalUser.avatar = value;
                          urlImage = value;
                        });
                        //Mettre à jour notre base de donnée en stockant l'url
                        Map<String,dynamic> map ={
                          //Key : Valeur
                          "AVATAR":urlImage
                        };
                        FirestoreHelper().updateUser(GlobalUser.id, map);

                        Navigator.pop(context);
                      });
                    },
                    child: const Text("Enregistrement"),
                  ),
                ],
                
              );
            }
          }
      );
  }


}