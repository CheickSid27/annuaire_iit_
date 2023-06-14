import 'package:annuaire_iit_/model/connection_widget.dart';
import 'package:annuaire_iit_/model/parse_handler.dart';
import 'package:annuaire_iit_/views/Search_View.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:swipable_stack/swipable_stack.dart';

class home_view extends StatefulWidget {
  ParseUser users;

  home_view({Key? key, required this.users}) : super(key: key);
  @override
  MatchState createState() => MatchState();
}

class MatchState extends State<home_view> {
  List<ParseObject> objects = [];
  late SwipableStackController controller;

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: objects.isNotEmpty
            ? Column(
                children: [
                  // RefreshIndicator(child:_build , onRefresh: onRefresh),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.only(bottom: 15, left: 9),
                              height: MediaQuery.of(context).size.height * 0.76,
                              child: ListView.builder(
                                itemCount: objects.length,
                                itemBuilder: (context, index) {
                                  final users = objects[index] as ParseUser;
                                  return Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: SizedBox(
                                          // decoration: BoxDecoration(
                                          //     boxShadow: [
                                          //       BoxShadow(
                                          //           color: Theme.of(context)
                                          //               .colorScheme
                                          //               .tertiary,
                                          //           offset: const Offset(0, 2),
                                          //           blurRadius: 1)
                                          //     ],
                                          //     borderRadius:
                                          //         BorderRadius.circular(25)),
                                          height: 180,
                                          width: size.width - 50,
                                          child: ElevatedButton(
                                            style: ButtonStyle(),
                                            onPressed: () {
                                              showUserInfoModal(
                                                  objects[index] as ParseUser);
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 125, top: 25),
                                              child: ListTile(
                                                title: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      users.username ?? '',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    
                                                    Text(
                                                      users.emailAddress ?? "",
                                                      style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        height:
                                                            15), // Ajout d'un espace entre le titre et le sous-titre
                                                    Text(
                                                      users["numero"]
                                                              as String? ??
                                                          "",
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 15),
                                                    Text(
                                                      users["description"]
                                                              as String? ??
                                                          "",
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    ),
                                                  ],
                                                ), // Ajoutez d'autres informations utilisateur que vous souhaitez afficher
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 63, left: 45),
                                        child: SizedBox(
                                          height: 90,
                                          width: 90,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(45),
                                            child: (ParseHandler()
                                                        .getImageForUser(
                                                            users) ==
                                                    null)
                                                ? Image.asset(
                                                    "assets/UserNoProfilPic.png")
                                                : Image.network(
                                                    ParseHandler()
                                                        .getImageForUser(
                                                            users)!,
                                                    fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const Text("Aucun utilisateur trouvé"),
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

  showUserInfoModal(ParseUser user) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // Contenu du ModalBottomSheet avec les informations de l'utilisateur
          child: Column(
            children: [
              // Affichez les informations de l'utilisateur ici
              Text('Username: ${user.username ?? ""}'),
              Text('Email: ${user.emailAddress ?? ""}'),
              // Ajoutez d'autres informations que vous souhaitez afficher
            ],
          ),
        );
      },
    );
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
}













//   (objects.isEmpty)
    //       ? ConnectionWidget().noneBody()
    //       : Column(
    //           children: [
    //             Container(
    //                 height: MediaQuery.of(context).size.height * 0.70,
    //                 child: Padding(
    //                   padding: EdgeInsets.all(20),
    //                   child:
    //                   // SwipableStack(
    //                   //   controller: controller,
    //                   //   detectableSwipeDirections: const {
    //                   //     SwipeDirection.up,
    //                   //     SwipeDirection.down,
    //                   //   },
    //                   //   stackClipBehaviour: Clip.none,
    //                   //   horizontalSwipeThreshold: 0.5,
    //                   //   verticalSwipeThreshold: 0.5,
    //                   //   // onSwipeCompleted: onSwipeCompleted,
    //                   //   builder: (context, properties) {
    //                   //     final currentIndex = properties.index % objects.length;
    //                   //     return Stack(
    //                   //       children: [
    //                   //         UserCard(
    //                   //             parseUser: objects[currentIndex] as ParseUser)
    //                   //       ],
    //                   //     );
    //                   //   },
    //                   // ),

    //                 )),
               

    // onSwipeCompleted(int index, SwipeDirection direction) {
    //   ParseUser user = objects[index] as ParseUser;
    //   if (index == objects.length - 1) {
    //     controller.currentIndex = -1;
    //   }
    //   switch (direction) {
    //     case SwipeDirection.left: break;
    //     case SwipeDirection.right: ParseHandler().addLikes(user: widget.user, id: user.objectId).then((success) {
    //       if (success) {
    //         print(success);
    //         //Check Match
    //         ParseHandler().checkMatch(me: widget.user, potentialMatch: user).then((newMatch) {
    //           if (newMatch) {
    //             SnackBar snackBar = SnackBar(content: Text("Vous avez un nouveau Match"));
    //             ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //           }
    //         });
    //       }
    //     });
    //     break;
    //     default: break;
    //   }
    // }

    // rewind() => controller.rewind();
    // superLike() {}
    // like() => controller.next(swipeDirection: SwipeDirection.right);
    // disLike() => controller.next(swipeDirection: SwipeDirection.left);