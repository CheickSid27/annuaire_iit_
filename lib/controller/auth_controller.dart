import 'package:annuaire_iit_/model/login_response.dart';
import 'package:annuaire_iit_/model/parse_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class AuthController extends StatefulWidget {
  const AuthController({super.key});

  @override
  AuthState createState() => AuthState();
}

class AuthState extends State<AuthController> {
  int authType = 0;
  Map<int, Widget> values = {
    0: Text(
      "Connexion",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    ),
    1: Text(
      "Inscription",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    ),
  };
  bool isLoading = false;

  String? selectedRole = 'Étudiant';
  String? selectedFilliere = 'Informatique et Génie Logiciel';
  String? selectedModule = '';
  String? selectedPoste = 'Directeur des études';
  String? selectedAnnee = '';

  late TextEditingController mailController;
  late TextEditingController passwordController;
  late TextEditingController usernameController;
  late TextEditingController telController;

  @override
  void initState() {
    mailController = TextEditingController();
    passwordController = TextEditingController();
    usernameController = TextEditingController();
    telController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    mailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    telController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.tertiary
              ],
              stops: const [0, .5, 1],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset(
                  "assets/iit-logo.png",
                  height: MediaQuery.of(context).size.height / 5,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                      color: Colors.white,
                    ),
                    height: MediaQuery.of(context).size.height * 0.50,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          CupertinoSlidingSegmentedControl<int>(
                            children: values,
                            onValueChanged: (int? newValue) {
                              setState(() {
                                authType = newValue ?? 0;
                              });
                            },
                            backgroundColor: Colors.grey.shade300,
                            thumbColor: Color.fromRGBO(253, 126, 20, 0.999),
                            groupValue: authType,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          (authType == 1)
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 20,
                                    left: 25,
                                    right: 25,
                                  ),
                                  child: myTextField(usernameController,
                                      "Nom complet", false, true, false),
                                )
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 20,
                              left: 25,
                              right: 25,
                            ),
                            child: myTextField(
                                mailController,
                                "Adresse mail Institutionnelle",
                                false,
                                false,
                                false),
                          ),
                          (authType == 1)
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 20,
                                    left: 25,
                                    right: 25,
                                  ),
                                  child: myTextField(telController, "numero",
                                      false, false, true),
                                )
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 20,
                              left: 25,
                              right: 25,
                            ),
                            child: myTextField(passwordController,
                                "Mot de passe", true, false, false),
                          ),
                          SizedBox(height: 10),
                          (authType == 1)
                              ? Container()
                              : Row(
                                  children: [
                                    SizedBox(
                                      width: 30,
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(20.0),
                                                  topRight:
                                                      Radius.circular(20.0),
                                                ),
                                              ),
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ClipRRect(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            mailController,
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .none,
                                                        autocorrect: false,
                                                        decoration: InputDecoration(
                                                            border: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .black)),
                                                            labelText:
                                                                'E-mail'),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Container(
                                                        height: 50,
                                                        child: ElevatedButton(
                                                          child: const Text(
                                                              'Reset Password'),
                                                          onPressed: () =>
                                                              doUserResetPassword(),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                        child: Text('Mot de passe oublier ?'))
                                  ],
                                ),
                          (authType == 1)
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 27,
                                    ),
                                    Text(
                                      'Année de cursus: (Uniquement pour les étudiants)',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          (authType == 1)
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: 27,
                                        ),
                                        ChoiceChip(
                                          label: Text('License 1'),
                                          selected:
                                              selectedAnnee == 'License 1',
                                          selectedColor: Colors.blue,
                                          onSelected: (bool selected) {
                                            setState(() {
                                              selectedAnnee =
                                                  selected ? 'License 1' : null;
                                            });
                                          },
                                        ),
                                        SizedBox(width: 10),
                                        ChoiceChip(
                                          label: Text('License 2'),
                                          selected:
                                              selectedAnnee == 'License 2',
                                          selectedColor: Colors.blue,
                                          onSelected: (bool selected) {
                                            setState(() {
                                              selectedAnnee =
                                                  selected ? 'License 2' : null;
                                            });
                                          },
                                        ),
                                        SizedBox(width: 10),
                                        ChoiceChip(
                                          label: Text('License 3'),
                                          selected:
                                              selectedAnnee == 'License 3',
                                          selectedColor: Colors.blue,
                                          onSelected: (bool selected) {
                                            setState(() {
                                              selectedAnnee =
                                                  selected ? 'License 3' : null;
                                            });
                                          },
                                        ),
                                        SizedBox(width: 10),
                                        ChoiceChip(
                                          label: Text('Master 1'),
                                          selected: selectedAnnee == 'Master 1',
                                          selectedColor: Colors.blue,
                                          onSelected: (bool selected) {
                                            setState(() {
                                              selectedAnnee =
                                                  selected ? 'Master 1' : null;
                                            });
                                          },
                                        ),
                                        SizedBox(width: 10),
                                        ChoiceChip(
                                          label: Text('Master 2'),
                                          selected: selectedAnnee == 'Master 2',
                                          selectedColor: Colors.blue,
                                          onSelected: (bool selected) {
                                            setState(() {
                                              selectedAnnee =
                                                  selected ? 'Master 2' : null;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                (authType == 1)
                                    ? DropdownButton<String>(
                                        value: selectedRole,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedRole = value;
                                            selectedFilliere = null;
                                            selectedModule = null;
                                            selectedPoste = null;
                                          });
                                        },
                                        items: <String>[
                                          'Étudiant',
                                          'Enseignant',
                                          'Personnel administratif'
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      )
                                    : Container(),
                                if (selectedRole == 'Étudiant')
                                  (authType == 1)
                                      ? DropdownButton<String>(
                                          alignment: Alignment.topLeft,
                                          value: selectedFilliere,
                                          onChanged: (Filierevalue) {
                                            setState(() {
                                              selectedFilliere = Filierevalue;
                                              selectedModule = null;
                                              selectedPoste = null;
                                            });
                                          },
                                          items: <String>[
                                            'Informatique et Génie Logiciel',
                                            'Réseaux, Systèmes et Sécurité',
                                            'Réseaux et Télécommunications',
                                            'Génie Civil et Technologies du Bâtiment',
                                            'Génie Electrique et Energies',
                                            'Génie Biomédical ',
                                            'Biotechnologies',
                                            'Finance et Comptabilité d’entreprise',
                                            'Communication Digitale et Multimédia',
                                            'Gestion Commerciale et Marketing Digital',
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        )
                                      : Container(),
                                if (selectedRole == 'Enseignant')
                                  (authType == 1)
                                      ? DropdownButton<String>(
                                          value: selectedModule,
                                          onChanged: (Modulevalue) {
                                            setState(() {
                                              selectedModule = Modulevalue;
                                              selectedFilliere = null;
                                              selectedPoste = null;
                                            });
                                          },
                                          items: <String>[
                                            'Module 1',
                                            'Module 2',
                                            'Module 3',
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        )
                                      : Container(),
                                if (selectedRole == 'Personnel administratif')
                                  (authType == 1)
                                      ? DropdownButton<String>(
                                          value: selectedPoste,
                                          onChanged: (Postevalue) {
                                            setState(() {
                                              selectedPoste = Postevalue;
                                              selectedFilliere = null;
                                              selectedModule = null;
                                            });
                                          },
                                          items: <String>[
                                            'Scolarité',
                                            'Conseiller d\'education,',
                                            'Directeur des études',
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        )
                                      : Container(),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromRGBO(253, 126, 20, 0.839),
                            ),
                            onPressed: isLoading
                                ? null
                                : handleAuth, // Désactiver le bouton pendant le chargement
                            child: isLoading
                                ? CircularProgressIndicator(
                                    color: Color.fromRGBO(253, 126, 20, 0.839),
                                    strokeWidth: 1,
                                  ) // Afficher l'indicateur de progression circulaire
                                : (authType == 1)
                                    ? Text("INSCRIPTION")
                                    : Text("CONNEXION"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myTextField(TextEditingController controller, String hint,
      bool isPassword, bool isUsername, bool isnumero) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintStyle: TextStyle(
          fontSize: 19,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w500,
        ),
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      obscureText: isPassword,
      textCapitalization:
          isUsername ? TextCapitalization.words : TextCapitalization.none,
      keyboardType: isnumero ? TextInputType.phone : TextInputType.text,
    );
  }

  handleAuth() async {
    setState(() {
      isLoading = true; // Activer l'indicateur de chargement
    });
    FocusScope.of(context).requestFocus(FocusNode());
    final username = usernameController.text;
    final emailAddress = mailController.text.trim();
    final numero = telController.text.trim();
    final password = passwordController.text.trim();
    if (authType == 1) {
      final loginResponse = await ParseHandler().createUser(
        username: username,
        emailAddress: emailAddress,
        numero: numero,
        password: password,
        role: selectedRole,
        filiere: selectedFilliere,
        module: selectedModule,
        poste: selectedPoste,
        annee: selectedAnnee,
      );
      handleAuthResponse(loginResponse);
    } else {
      final loginResponse = await ParseHandler().signIn(
        emailAddress: emailAddress,
        password: password,
      );
      handleAuthResponse(loginResponse);
    }

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      isLoading = false; // Désactiver l'indicateur de chargement
    });
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

  handleAuthResponse(LoginResponse loginResponse) {
    if (loginResponse.result == true) {
      //On goBack
      ParseHandler().goBack(context);
    } else if (loginResponse.error != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Erreur',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Text(loginResponse.error!),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
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
