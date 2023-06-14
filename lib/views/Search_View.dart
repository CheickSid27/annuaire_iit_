

import 'package:annuaire_iit_/model/parse_handler.dart';
import 'package:annuaire_iit_/views/Setting_Page_View.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class User_Search_View extends StatefulWidget {
   ParseUser users;

  User_Search_View({Key? key, required this.users}) : super(key: key);

  @override
  State<User_Search_View> createState() => _User_Search_ViewState();
}

class _User_Search_ViewState extends State<User_Search_View> {

  ParseHandler parseHandler = ParseHandler(); // Instanciez votre ParseHandler

  String searchUsername = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recherche d\'utilisateur'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchUsername = value; // Mettre à jour la valeur de recherche
                });
              },
              decoration: InputDecoration(
                labelText: 'Nom d\'utilisateur',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ParseObject>>(
              stream: parseHandler.searchUsersByUsernameStream(searchUsername, widget.users),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ParseObject> searchResults = snapshot.data!;

                  return ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      ParseObject user = searchResults[index];
                      String username = user['username'] ?? '';

                      return ListTile(
                        title: Text(username),
                        // Autres informations de l'utilisateur si nécessaire
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  }
