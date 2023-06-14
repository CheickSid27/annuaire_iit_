import 'package:annuaire_iit_/controller/auth_controller.dart';
import 'package:annuaire_iit_/controller/home_controller.dart';
import 'package:annuaire_iit_/model/connection_widget.dart';
import 'package:annuaire_iit_/model/keys.dart';
import 'package:annuaire_iit_/model/parse_handler.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Parse().initialize(
    Keys.applicationID,
    Keys.serverID,
    clientKey: Keys.clientID,
    autoSendSessionId: true,
    liveQueryUrl: "https://annuaire.b4a.io",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const primaryColor = Color.fromARGB(255, 240, 3, 3);
  static const secondaryColor = Color.fromARGB(255, 240, 2, 2);
  static const tertiaryColor = Color.fromARGB(214, 253, 41, 41);

  static final MaterialColor materialColor = MaterialColor(0xFFFD297D, swatch);

  static final Map<int, Color> swatch = {
    50: Color.fromARGB(24, 253, 41, 41),
    100: Color.fromARGB(51, 226, 152, 152),
    200: Color.fromARGB(75, 253, 41, 41),
    300: Color.fromARGB(102, 253, 41, 41),
    400: Color.fromARGB(126, 253, 41, 41),
    500: Color.fromARGB(153, 253, 41, 41),
    600: Color.fromARGB(177, 253, 41, 41),
    700: Color.fromARGB(204, 253, 41, 41),
    800: Color.fromARGB(228, 253, 41, 41),
    900: Color.fromARGB(255, 253, 41, 41),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: materialColor,
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: primaryColor,
              secondary: secondaryColor,
              tertiary: tertiaryColor,
            ),
        textTheme: const TextTheme(
          button: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Utilisez l'écran de démarrage comme écran initial
      routes: {
        '/home': (context) => FutureBuilder<ParseUser?>(
              future: ParseHandler().isAuth(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return ConnectionWidget().noneScaffold();
                  case ConnectionState.waiting:
                    return ConnectionWidget().waitingScaffold();
                  default:
                    return (snapshot.hasData && snapshot.data != null)
                        ? HomeController(
                            user: snapshot.data!,
                            users: snapshot.data!,
                          )
                        : AuthController();
                }
              },
            ),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp(); // Ajoutez ici tout code d'initialisation ou de traitement que vous souhaitez effectuer pendant l'écran de démarrage
  }

  Future<void> _initializeApp() async {
    // Ajoutez ici le code d'initialisation ou de traitement que vous souhaitez effectuer

    // Exemple : Attendre quelques secondes, puis passer à l'écran suivant
    await Future.delayed(const Duration(seconds: 3));

    // Naviguer vers l'écran suivant, par exemple votre écran d'accueil
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}
