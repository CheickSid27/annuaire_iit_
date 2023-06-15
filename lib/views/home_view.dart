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
                                            style: const ButtonStyle(),
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
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),

                                                    // Text(
                                                    //   users.emailAddress ?? "",
                                                    //   style: TextStyle(
                                                    //     fontSize: 25,
                                                    //     fontWeight:
                                                    //         FontWeight.bold,
                                                    //   ),
                                                    // ),
                                                    const SizedBox(
                                                        height:
                                                            5), // Ajout d'un espace entre le titre et le sous-titre
                                                    Text(
                                                      users["role"]
                                                              as String? ??
                                                          "",
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    // Text(
                                                    //   users["annee"]
                                                    //           as String? ??
                                                    //       "",
                                                    //   style: const TextStyle(
                                                    //     fontSize: 18,
                                                    //     fontWeight:
                                                    //         FontWeight.bold,
                                                    //   ),
                                                    // ),
                                                    if (users["annee"] !=
                                                            null &&
                                                        users["annee"]
                                                            .toString()
                                                            .isNotEmpty)
                                                      Text(
                                                        users["annee"]
                                                            as String,
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    if (users["annee"] ==
                                                            null ||
                                                        users["annee"]
                                                            .toString()
                                                            .isEmpty)
                                                      Container(height: 0),

                                                    const SizedBox(height: 5),
                                                    Text(
                                                      users["module"]
                                                              as String? ??
                                                          users["poste"]
                                                              as String? ??
                                                          users["filiere"]
                                                              as String? ??
                                                          '',
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
                                          child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                // useSafeArea: true,
                                                barrierColor: Colors.black,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Dismissible(
                                                    key: const Key('dialogKey'),
                                                    direction:
                                                        DismissDirection.down,
                                                    onDismissed: (direction) {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 50,
                                                              bottom: 50),
                                                      child: InteractiveViewer(
                                                        boundaryMargin:
                                                            const EdgeInsets
                                                                .all(0.0),
                                                        minScale: 0.5,
                                                        maxScale: 4.0,
                                                        child: SizedBox(
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        45),
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
                                              height: 160,
                                              width: 170,
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
            : const Text("Recherche..."),
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