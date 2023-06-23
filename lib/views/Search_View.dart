import 'package:Udirectory/model/parse_handler.dart';
import 'package:Udirectory/views/Setting_Page_View.dart';
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
                  searchUsername =
                      value; // Mettre à jour la valeur de recherche
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
              stream: parseHandler.searchUsersByUsernameStream(
                  searchUsername, widget.users),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ParseObject> searchResults = snapshot.data!;

                  return ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      ParseObject user = searchResults[index];
                      String username = user['username'] ?? '';

                      return ElevatedButton(
                        onPressed: () {
                          onUserSelected(user as ParseUser);
                        },
                        child: ListTile(
                          title: Text(username),
                          // Autres informations de l'utilisateur si nécessaire
                        ),
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

  onUserSelected(ParseUser user) {
    showModalBottomSheet(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 0.952),
      useSafeArea: true,
      isScrollControlled: true,
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        final screenHeight = MediaQuery.of(context).size.height;
        final modalHeight = screenHeight * 0.8; // 80% de la hauteur de l'écran

        return SizedBox(
          height: modalHeight,
          child: Column(
            children: [
              // Affichez les informations de l'utilisateur ici
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text(
                      '${user.username}',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  showDialog(
                    barrierColor: Colors.black,
                    context: context,
                    builder: (BuildContext context) {
                      return Dismissible(
                        key: const Key('dialogKey'),
                        direction: DismissDirection.down,
                        onDismissed: (direction) {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50, bottom: 50),
                          child: InteractiveViewer(
                            boundaryMargin: const EdgeInsets.all(0.0),
                            minScale: 0.5,
                            maxScale: 4.0,
                            child: SizedBox(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(45),
                                child: Image.network(
                                  ParseHandler().getImageForUser(user) ??
                                      "assets/UserNoProfilPic.png",
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: SizedBox(
                  height: 140,
                  width: 140,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(75),
                    child: Image.network(
                      ParseHandler().getImageForUser(user) ??
                          "assets/UserNoProfilPic.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user["role"] as String? ?? "",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (user["annee"] != null &&
                      user["annee"].toString().isNotEmpty)
                    Text(
                      user["annee"] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                user["module"] as String? ??
                    user["poste"] as String? ??
                    user["filiere"] as String? ??
                    '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 40),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 15, top: 0, bottom: 10),
                        child: Text(
                          'Contact',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(253, 126, 20, 0.839),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 2,
                    indent: 10,
                    endIndent: 40,
                    color: Color.fromRGBO(253, 126, 20, 0.839),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          user.emailAddress ?? 'Email',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          user["numero"] as String? ?? "",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 15, top: 0, bottom: 10),
                    child: Text(
                      'A propos de moi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(253, 126, 20, 0.839),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 2,
                indent: 10,
                endIndent: 40,
                color: Color.fromRGBO(253, 126, 20, 0.839),
              ),

              // Ajoutez d'autres informations que vous souhaitez afficher
            ],
          ),
        );
      },
    );
  }
}
