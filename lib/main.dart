import 'package:Udirectory/controller/auth_controller.dart';
import 'package:Udirectory/controller/home_controller.dart';
import 'package:Udirectory/model/connection_widget.dart';
import 'package:Udirectory/model/keys.dart';
import 'package:Udirectory/model/parse_handler.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Parse().initialize(
    Keys.applicationID,
    Keys.serverID,
    clientKey: Keys.clientID,
    autoSendSessionId: true,
    liveQueryUrl: "https://udirectory.b4a.io",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const primaryColor = Color.fromRGBO(220, 53, 70, 0.911);
  static const secondaryColor = Color.fromARGB(255, 240, 2, 2);
  static const tertiaryColor = Color.fromARGB(214, 253, 41, 41);

  static final MaterialColor materialColor = MaterialColor(0xFFFD297D, swatch);

  static final Map<int, Color> swatch = {
    50: const Color.fromARGB(24, 253, 41, 41),
    100: const Color.fromARGB(51, 226, 152, 152),
    200: const Color.fromARGB(75, 253, 41, 41),
    300: const Color.fromARGB(102, 253, 41, 41),
    400: const Color.fromARGB(126, 253, 41, 41),
    500: const Color.fromARGB(153, 253, 41, 41),
    600: const Color.fromARGB(177, 253, 41, 41),
    700: const Color.fromARGB(204, 253, 41, 41),
    800: const Color.fromARGB(228, 253, 41, 41),
    900: const Color.fromARGB(255, 253, 41, 41),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'U-Directory',
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
                        : const AuthController();
                }
              },
            ),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;

  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    final CurvedAnimation curve =
        CurvedAnimation(parent: controller, curve: Curves.ease);
    animation = Tween(begin: 1.0, end: 0.60).animate(curve);

    animation.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.forward().whenComplete(() {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(179, 44, 44, 1),
      body: Center(
        child: ScaleTransition(
          scale: animation,
          child: Image.asset('assets/UdirectoryFrais.png'),
        ),
      ),
    );
  }
}
