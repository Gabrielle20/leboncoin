import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:leboncoin/Services/FirestoreAnnouncesHelper.dart';
import 'package:leboncoin/Services/librairie.dart';
import 'package:leboncoin/View/MyDrawer.dart';

class dashBoard extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState(){
    return dashboardState();
  }
}

class dashboardState extends State<dashBoard>{
  String titre = "";
  String contenu = "";
  String urlPicture = "";
  String userId = GlobalUser.id;

  var isNewAnnounce;
  String state = "list";
  bool occass = true;

  void _setIsNewAnnouce(){
    if(state == "list"){
      setState(() {
        state = "addNew";
      });
    }


  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      drawer: Container(
        width: MediaQuery.of(context).size.width/2,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: MyDrawer()
      ),
      appBar : AppBar(
        title : const Text("Ma deuxième page"),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.yellow,
      body : Padding(
        padding: EdgeInsets.all(20),
        child: displayAnnounces()
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _setIsNewAnnouce,
        tooltip: 'Ajouter un nouvel article',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget displayAnnounces(){
    getAnnouncesByUser();
    return (state == "addNew") ? addNewAnnounce() :  Scaffold(
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
            ],
          ),
        )
    );
  }

  Widget addNewAnnounce(){
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height : 10),

          TextField(
              decoration : InputDecoration(
                  hintText : "Entrer votre Titre",
                  border : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  )
              ),
              onChanged : (String value){
                setState((){
                  titre = value;
                });
              }

          ),
          const SizedBox(height : 10),

          TextField(
              decoration : InputDecoration(
                  hintText : "Entrer votre Contenu",
                  border : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  )
              ),
              onChanged : (String value){
                setState((){
                  contenu = value;
                });
              }

          ),
          const SizedBox(height : 10),

          TextField(
              decoration : InputDecoration(
                  hintText : "L'url de votre image",
                  border : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  )
              ),
              onChanged : (String value){
                setState((){
                  urlPicture = value;
                });
              }

          ),
          Row(
            mainAxisAlignment:  MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child:
                  ElevatedButton(
                      onPressed : () {
                        newAnnounce();
                      },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20)

                      ),
                      child : const Text("Ajouter")
                  ),
              ),

              ElevatedButton(
                  onPressed : () {
                    cancelNew();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 20)
                  ),
                  child : const Text("Annuler")
              )
            ],
          )



        ]
      )
    );
  }


  newAnnounce(){
    FirestoreAnnounceHelper().createAnnounce(titre, contenu, userId, urlPicture).then((value) =>
        setState(() {
          state = "list";
        })
    ).catchError((error) => print(error));
  }

  cancelNew(){
    setState(() {
      state = "list";
    });
  }

  getAnnouncesByUser(){
    FirestoreAnnounceHelper().getStreamAnnouncesByUser();
  }
}