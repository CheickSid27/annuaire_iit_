import 'dart:io';
import 'package:annuaire_iit_/model/parse_handler.dart';
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
  late TextEditingController mailController;
  late TextEditingController telController;
  ImagePicker imagePicker = ImagePicker();
  String? url;

  @override
  void initState() {
    usernameController = TextEditingController();
    descriptionController = TextEditingController();
    mailController = TextEditingController();
    mailController = TextEditingController();
    telController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    descriptionController.dispose();
    mailController.dispose();
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
                  height: MediaQuery.of(context).size.height / 2,
                  child:
                      (url == null) ? Icon(Icons.person) : Image.network(url!)),
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
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(hintText: widget.user.username),
                  )),
                  IconButton(
                      onPressed: (() => updateUser(
                          key: "username",
                          value: usernameController.text.trim())),
                      icon: const Icon(Icons.send))
                ],
              ),
              // Row(
              //   children: [
              //     Expanded(
              //         child: TextField(
              //       controller: mailController,
              //       decoration:
              //           InputDecoration(hintText: widget.user.emailAddress),
              //     )),
              //     IconButton(
              //         onPressed: (() => updateUser(
              //             key: "email", value: mailController.text.trim())),
              //         icon: const Icon(Icons.send))
              //   ],
              // ),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: mailController,
                    decoration: InputDecoration(hintText: widget.user["email"]),
                    maxLines: null,
                  )),
                  IconButton(
                      onPressed: (() => updateUser(
                          key: "email", value: mailController.text.trim())),
                      icon: const Icon(Icons.send))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: telController,
                    decoration:
                        InputDecoration(hintText: widget.user["numero"]),
                    maxLines: null,
                  )),
                  IconButton(
                      onPressed: (() => updateUser(
                          key: "numero", value: telController.text.trim())),
                      icon: const Icon(Icons.send))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                        hintText: widget.user["description"] ??
                            'Ce que les autres doivent savoir sur vous'),
                    maxLines: null,
                  )),
                  IconButton(
                      onPressed: (() => updateUser(
                          key: "description",
                          value: descriptionController.text.trim())),
                      icon: const Icon(Icons.send))
                ],
              ),
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
