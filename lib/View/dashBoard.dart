import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leboncoin/Services/FirestoreAnnouncesHelper.dart';
import 'package:leboncoin/Services/librairie.dart';
import 'package:leboncoin/Services/FirestoreHelper.dart';
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
  String idAnnounce = "";
  String userId = GlobalUser.id;


  var listAnnoucesByUser = null;
  var bytesImage;
  var nomImage;

  String state = "list";
  var isEditing = false;

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
        title : const Text("Listes des annonces"),
        backgroundColor: Colors.blue,
      ),
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
    if(state != "addNew"){
      getAllAnnounces();
    }
    return (state == "addNew") ? addNewAnnounce() :  SingleChildScrollView(
        child:  Column(
            children: <Widget> [
            Table(
            border: TableBorder.symmetric(
              outside: BorderSide.none,
              inside: const BorderSide(width: 1, color: Colors.grey, style: BorderStyle.solid),
            ),
            columnWidths: {
            },
            children: [
                for(var announce in listAnnoucesByUser) TableRow(children: [
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.arrow_drop_down_circle),
                      title: Text(announce["titre"]),
                      subtitle: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: (
                                Text("de Anonyme le ${announce["created_at"]}",
                                  style: TextStyle(color: Colors.black.withOpacity(0.6)),)
                            )
                          ),
                          Ink(
                            decoration: const ShapeDecoration(
                              color: Colors.lightBlue,
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.favorite_border_rounded),
                              color: Colors.white,
                              onPressed: () {createFav();},
                            ),
                          ),
                        ],
                      )
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        announce["contenu"],
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                    Image.network(announce["urlPicture"]),
                  ],
                ),
              ),
            ])
            ],

            )]),
        );
  }

  Widget addNewAnnounce(){
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height : 10),

          TextFormField(
              decoration : InputDecoration(
                  hintText : "Entrer votre Titre",
                  border : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  )
              ),
              initialValue: titre,
              onChanged : (String value){
                setState((){
                  titre = value;
                });
              }

          ),
          const SizedBox(height : 10),

          TextFormField(
              decoration : InputDecoration(
                  hintText : "Entrer votre Contenu",
                  border : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  )
              ),
              initialValue: contenu,
              onChanged : (String value){
                setState((){
                  contenu = value;
                });
              }

          ),
          const SizedBox(height : 20),


          InkWell(
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                    image: NetworkImage((urlPicture == "") ? "https://immo-fonctionnaire.fr/_nuxt/img/no-picture.a21d576.jpeg" : urlPicture),
                    fit: BoxFit.fitWidth
                ),
              ),

            ),
            onTap: (){
              pickImage();
            },
          ),
          SizedBox(height: 10,),
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

createFav(){
    FirestoreHelper().createFavoris("test").then((value) {

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return dashBoard();
          }));
        }).catchError((error){
          // afficher popup connexion échouée
          print(error);
        });
  }

  newAnnounce(){
    FirestoreAnnounceHelper().createAnnounce(titre, contenu, userId, urlPicture).then((value) =>
        setState(() {
          state = "list";
          titre = "";
          contenu = "";
          urlPicture = "";
        })
    ).catchError((error) => print(error));
  }

  cancelNew(){
    setState(() {
      state = "list";
      state = "list";
      titre = "";
      contenu = "";
      urlPicture = "";
    });
  }

  getAllAnnounces(){
    FirestoreAnnounceHelper().getStreamAllAnnounce().then((result) => {
      setState((){
        listAnnoucesByUser = result;
        print(result);
      })
    });
  }

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
                    FirestoreAnnounceHelper().stockageImage(bytesImage!, nomImage!, idAnnounce).then((value){
                      setState(() {
                        urlPicture = value;
                      });
                      Navigator.pop(context);
                    });
                  },
                  child: const Text("Enregistrement"),
                ),
              ],

            );
          }
    );
  }
}