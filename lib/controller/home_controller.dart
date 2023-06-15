import 'package:annuaire_iit_/model/parse_handler.dart';
import 'package:annuaire_iit_/views/Search_View.dart';
import 'package:annuaire_iit_/views/Setting_Page_View.dart';
import 'package:annuaire_iit_/views/home_view.dart';
import 'package:annuaire_iit_/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class HomeController extends StatefulWidget {
  final ParseUser user;
  final ParseUser users;

  const HomeController({Key? key, required this.user, required this.users})
      : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomeController> {
  List<ParseObject> objects = [];

  @override
  void initState() {
    //get users
    getUsers();
    // searchpage(widget.users);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int currentIndex = 0;

  ParseHandler parseHandler = ParseHandler(); // Instanciez votre ParseHandler

  String searchUsername = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: currentIndex == 0
            ? Colors.transparent
            : Theme.of(context).colorScheme.tertiary,
        title: Padding(
          padding: const EdgeInsets.only(top: 50, left: 30),
          child: Text(
            currentIndex == 0 ? 'Accueil' : '',
            style: const TextStyle(
                color: Color.fromRGBO(253, 126, 20, 0.839), fontSize: 30),
          ),
        ),
        toolbarHeight: 80,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: IconButton(
              onPressed: () => usersetting(widget.user),
              icon: const Icon(
                Icons.settings_outlined,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: IndexedStack(
          index: currentIndex,
          children: [
            home_view(
              users: widget.user,
            ),
            ProfileView(
              user: widget.user,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        elevation: 20,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(
                Icons.people_outline_sharp,
                size: 30,
              ),
              color: currentIndex == 0
                  ? const Color.fromRGBO(253, 126, 20, 0.839)
                  : Colors.grey,
              onPressed: () {
                setState(() {
                  currentIndex = 0;
                });
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.person_2_outlined,
                size: 30,
              ),
              color: currentIndex == 1
                  ? const Color.fromRGBO(253, 126, 20, 0.839)
                  : Colors.grey,
              onPressed: () {
                setState(() {
                  currentIndex = 1;
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(255, 146, 43, 0.943),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: 5,
        child: const SizedBox(
          child: Icon(
            Icons.search_outlined,
            size: 40,
          ),
        ),
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
                borderRadius: BorderRadius.circular(20),
                child: Column(
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
                        decoration: const InputDecoration(
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

                                return ListTile(
                                  title: Text(username),
                                  // Autres informations de l'utilisateur si nécessaire
                                );
                              },
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      backgroundColor: Colors.white,
    );
  }

  getUsers() async {
    final users = await ParseHandler().list(parseUser: widget.users);
    setState(() {
      objects = users;
    });
  }

  searchpage(ParseUser users) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => User_Search_View(
                users: users,
              )),
    );
  }

  usersetting(ParseUser user) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SettingView(
                user: user,
              )),
    );
  }
}
