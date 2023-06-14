import 'package:annuaire_iit_/model/parse_handler.dart';
import 'package:annuaire_iit_/views/Profile_Edit_view.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class SettingView extends StatefulWidget {
  final ParseUser user;

  const SettingView({Key? key, required this.user}) : super(key: key);

  @override
  State<SettingView> createState() => _SettingViewState();
  
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () => EditProfil(widget.user),
              child: Row(
                children: const [
                  Icon(Icons.edit_sharp),
                  Text('Mettre à jour votre profil'),
                ],
              )),
          ElevatedButton(
              onPressed: () {},
              child: Row(
                children: const [
                  Icon(Icons.edit_sharp),
                  Text('Mettre à jour votre profil'),
                ],
              )),
          ElevatedButton(
              onPressed: () {
                ParseHandler().logout(widget.user, context);
              },
              child: const Text("Se Déconnecter")),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  EditProfil(ParseUser user) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProfileEditView(
                user: user,
              )),
    );
  }
}
