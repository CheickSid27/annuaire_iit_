import 'package:Udirectory/model/parse_handler.dart';
import 'package:Udirectory/views/Setting_Page_View.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class ProfileView extends StatefulWidget {
  final ParseUser user;

  const ProfileView({Key? key, required this.user}) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<ProfileView> {
  late RefreshIndicatorState refreshIndicatorState;
  bool isLoading = false;
  String? url;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showIndicator();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showIndicator() {
    refreshIndicatorState.show();
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
                  padding: const EdgeInsets.only(top: 100),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.65,
                    width: MediaQuery.of(context).size.width * 80,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      color: Colors.white,
                    ),
                    child: RefreshIndicator(
                      key: Key('refreshIndicator'),
                      onRefresh: () async {
                        setState(() {
                          isLoading =
                              true; // Afficher l'animation de chargement
                        });

                        // Mettez ici votre logique de rafraîchissement des données
                        // Par exemple, vous pouvez appeler la fonction getImageForUser de la classe ParseHandler

                        try {
                          url =
                              await ParseHandler().getImageForUser(widget.user);
                        } catch (e) {
                          // Gérer les erreurs de récupération de l'image depuis la source externe
                          print(
                              "Erreur lors du rafraîchissement de l'image : $e");
                        }

                        // Simulez une attente de quelques secondes pour l'exemple
                        await Future.delayed(Duration(seconds: 2));

                        // Après avoir terminé le rafraîchissement des données, masquez l'animation de chargement
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 80,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, top: 10),
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Text(
                                    widget.user.username ?? '',
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                    Icon(
                                      Icons.mail_outline_outlined,
                                      color:
                                          Color.fromRGBO(253, 126, 20, 0.839),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        widget.user["numero"],
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.phone_outlined,
                                      color:
                                          Color.fromRGBO(253, 126, 20, 0.839),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                    if (widget.user["annee"] != null &&
                                        widget.user["annee"]
                                            .toString()
                                            .isNotEmpty)
                                      Text(
                                        widget.user["annee"] as String,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    if (widget.user["annee"] == null ||
                                        widget.user["annee"].toString().isEmpty)
                                      Container(height: 0),
                                    Icon(
                                      Icons.school_outlined,
                                      color:
                                          Color.fromRGBO(253, 126, 20, 0.839),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        widget.user["filiere"] ??
                                            widget.user["module"] ??
                                            widget.user["poste"],
                                        style: const TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.history_edu_outlined,
                                      color:
                                          Color.fromRGBO(253, 126, 20, 0.839),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        widget.user["description"] ?? '',
                                        style: const TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.edit_note_outlined,
                                      color:
                                          Color.fromRGBO(253, 126, 20, 0.839),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 430,
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
                          child: Container(
                            color: Colors.deepOrangeAccent,
                            child: (url == null)
                                ? Image.asset("assets/UserNoProfilPic.png")
                                : Image.network(url!, fit: BoxFit.cover),
                          ),
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
