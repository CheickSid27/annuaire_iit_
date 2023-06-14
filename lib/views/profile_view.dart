import 'package:annuaire_iit_/model/parse_handler.dart';
import 'package:annuaire_iit_/views/Setting_Page_View.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class ProfileView extends StatefulWidget {
  final ParseUser user;

  const ProfileView({Key? key, required this.user}) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<ProfileView> {
  String? url;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    url = ParseHandler().getImageForUser(widget.user);
    return Container(
      width: double.infinity, // Définir la largeur maximale
      height: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
              colors: [
            Theme.of(context).colorScheme.tertiary,
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.primary
          ],
              stops: const [
            0,
            .5,
            1
          ])),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 160),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.55,
                    width: MediaQuery.of(context).size.width * 80,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 80,
                      ),
                      child: Column(
                        children: [
                          Text(
                            widget.user.username ?? '',
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.mail_outline_outlined,
                                color: Colors.redAccent,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Icon(
                                Icons.phone_outlined,
                                color: Colors.redAccent,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.user.emailAddress ?? '',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 1,
                                height: 30,
                                child: Container(
                                  color: Colors.black,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  widget.user["numero"],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(22.0),
                            child: SizedBox(
                              width: 100,
                              height: 1,
                              child: Container(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.school_outlined,
                                color: Colors.redAccent,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Icon(
                                Icons.history_edu_outlined,
                                color: Colors.redAccent,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.user['role'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 1,
                                height: 30,
                                child: Container(
                                  color: Colors.black,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  widget.user["filiere"] ??
                                      widget.user["module"] ??
                                      widget.user["poste"],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 450,
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.transparent,
                              content: SizedBox(
                                height: 300,
                                width: 300,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(180),
                                  child: (url == null)
                                      ? Image.asset(
                                          "assets/UserNoProfilPic.png")
                                      : Image.network(url!, fit: BoxFit.cover),
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
                          borderRadius: BorderRadius.circular(20),
                          child: (url == null)
                              ? Image.asset("assets/UserNoProfilPic.png")
                              : Image.network(url!, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
