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
      body: SizedBox(
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

                                return ElevatedButton(
                                  onPressed: () {
                                    showUserInfoModal(
                                        objects[index] as ParseUser);
                                  },
                                  child: ListTile(
                                    title: Text(username),
                                    // Autres informations de l'utilisateur si nécessaire
                                  ),
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

  showUserInfoModal(ParseUser user) {
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
                          fontSize: 25, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                    child: Text(
                      'Mon Cursus',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(253, 126, 20, 0.839),
                      ),
                    ),
                  )
                ],
              ),
              const Divider(
                height: 2,
                indent: 10,
                endIndent: 40,
                color: Color.fromRGBO(253, 126, 20, 0.839),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 140,
                width: 140,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      // useSafeArea: true,
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
                                  child: (ParseHandler()
                                              .getImageForUser(user) ==
                                          null)
                                      ? Image.asset(
                                          "assets/UserNoProfilPic.png")
                                      : Image.network(
                                          ParseHandler().getImageForUser(user)!,
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(75),
                      child: (ParseHandler().getImageForUser(user) == null)
                          ? Image.asset("assets/UserNoProfilPic.png")
                          : Image.network(ParseHandler().getImageForUser(user)!,
                              fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
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
                  if (user["annee"] == null || user["annee"].toString().isEmpty)
                    Container(height: 0),
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
                    fontStyle: FontStyle.italic),
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
                      )
                    ],
                  ),
                  const Divider(
                    height: 2,
                    indent: 10,
                    endIndent: 40,
                    color: Color.fromRGBO(253, 126, 20, 0.839),
                  ),
                  Row(
                    children: [
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
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                user["numero"] as String? ?? "",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 15, top: 0, bottom: 10),
                    child: Text(
                      'A propros de moi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(253, 126, 20, 0.839),
                      ),
                    ),
                  )
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
