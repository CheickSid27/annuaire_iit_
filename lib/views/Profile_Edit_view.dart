import 'dart:io';
import 'package:Udirectory/model/parse_handler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class ProfileEditView extends StatefulWidget {
  final ParseUser user;

  const ProfileEditView({Key? key, required this.user});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<ProfileEditView> {
  late TextEditingController usernameController;
  late TextEditingController descriptionController;
  late TextEditingController telController;
  ImagePicker imagePicker = ImagePicker();
  String? url;
  bool isTextFieldSelectedUsername = false;
  bool isTextFieldSelectednumero = false;
  bool isTextFieldSelecteddescrip = false;

  @override
  void initState() {
    usernameController = TextEditingController();
    descriptionController = TextEditingController();
    telController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    descriptionController.dispose();
    telController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    url = ParseHandler().getImageForUser(widget.user);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mettre à jour mon profil'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(62, 158, 158, 158),
                            blurRadius: 10,
                            spreadRadius: 5)
                      ]),
                  height: MediaQuery.of(context).size.height / 3,
                  child: (url == null)
                      ? Center(
                          child: Text(
                            'Ajouter une photo de profil',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        )
                      : Image.network(url!)),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: (() => takeAPic(ImageSource.gallery)),
                      child: Text("Gallerie")),
                  ElevatedButton(
                      onPressed: (() => takeAPic(ImageSource.camera)),
                      child: Text("Appareil photo")),
                ],
              ),
              Column(
                children: [
                  TextField(
                    onTap: () {
                      setState(() {
                        isTextFieldSelectedUsername = true;
                      });
                    },
                    controller: usernameController,
                    decoration: InputDecoration(
                        hintText: widget.user.username,
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
                  if (isTextFieldSelectedUsername)
                    ElevatedButton(
                      onPressed: () {
                        updateUser(
                          key: "username",
                          value: usernameController.text.trim(),
                        );
                        setState(() {
                          isTextFieldSelectedUsername = false;
                        });
                      },
                      child: Text('Modifier'),
                    ),
                ],
              ),
              Column(
                children: [
                  TextField(
                    onTap: () {
                      setState(() {
                        isTextFieldSelectednumero = true;
                      });
                    },
                    controller: telController,
                    decoration: InputDecoration(
                        hintText: widget.user["numero"],
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    maxLines: null,
                  ),
                  if (isTextFieldSelectednumero)
                    ElevatedButton(
                      onPressed: () {
                        updateUser(
                            key: "numero", value: telController.text.trim());
                        setState(() {
                          isTextFieldSelectednumero = false;
                        });
                      },
                      child: Text('Modifier'),
                    ),
                ],
              ),
              Column(
                children: [
                  TextField(
                    onTap: () {
                      setState(() {
                        isTextFieldSelecteddescrip = true;
                      });
                    },
                    controller: descriptionController,
                    decoration: InputDecoration(
                        hintText: widget.user["description"],
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    maxLines: null,
                  ),
                  if (isTextFieldSelecteddescrip)
                    ElevatedButton(
                      onPressed: () {
                        updateUser(
                          key: "description",
                          value: descriptionController.text.trim(),
                        );
                        setState(() {
                          isTextFieldSelecteddescrip = false;
                        });
                      },
                      child: Text('Modifier'),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                    "Oublliez pas de cliquer sur le bouton 'modifier' pour enregistrer vos modification"),
              )
            ],
          ),
        ),
      ),
    );
  }

  takeAPic(ImageSource source) async {
    final XFile? xFile = await imagePicker.pickImage(source: source);
    if (xFile == null) return;
    final File file = File(xFile.path);
    ParseFile? parseFile = await ParseHandler().saveImage(file);
    if (parseFile == null) return;
    updateUser(key: "image", value: parseFile);
  }

  updateUser({required String key, required dynamic value}) async {
    FocusScope.of(context).requestFocus(FocusNode());
    ParseHandler()
        .updateUser(user: widget.user, key: key, value: value)
        .then((value) => setState(() {}));
  }
}
