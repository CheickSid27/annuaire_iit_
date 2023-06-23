// ignore: file_names
import 'package:Udirectory/model/parse_handler.dart';
import 'package:Udirectory/views/Profile_Edit_view.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class SettingView extends StatefulWidget {
  final ParseUser user;

  const SettingView({Key? key, required this.user}) : super(key: key);

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  late TextEditingController mailController;

  @override
  void initState() {
    mailController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    mailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
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
                onPressed: () {
                  showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      context: context,
                      builder: (BuildContext context) {
                        return ClipRRect(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextField(
                                controller: mailController,
                                keyboardType: TextInputType.emailAddress,
                                textCapitalization: TextCapitalization.none,
                                autocorrect: false,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    labelText: 'E-mail'),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                height: 50,
                                child: ElevatedButton(
                                  child: const Text('Reinitialisé MDP'),
                                  onPressed: () => doUserResetPassword(),
                                ),
                              )
                            ],
                          ),
                        );
                      });
                },
                child: Row(
                  children: const [
                    Icon(Icons.edit_sharp),
                    Text('Reinitialisé mon mot de passe'),
                  ],
                )),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Confirmation"),
                      content:
                          Text("Êtes-vous sûr de vouloir vous déconnecter ?"),
                      actions: [
                        TextButton(
                          child: Text("Annuler"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text("Déconnexion"),
                          onPressed: () {
                            ParseHandler().logout(widget.user, context);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text("Se Déconnecter"),
            ),
          ],
        ),
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

  void doUserResetPassword() async {
    final ParseUser user = ParseUser(null, null, mailController.text.trim());
    final ParseResponse parseResponse = await user.requestPasswordReset();
    if (parseResponse.success) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Réinitialisation du mot de passe'),
            content: Text(
                'Les instructions de réinitialisation du mot de passe ont été envoyées par e-mail !'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur de réinitialisation du mot de passe'),
            content: Text(parseResponse.error!.message),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
