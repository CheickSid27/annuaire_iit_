import 'package:Udirectory/model/parse_handler.dart';
import 'package:Udirectory/views/Profile_Edit_view.dart';
import 'package:Udirectory/views/Search_View.dart';
import 'package:Udirectory/views/Setting_Page_View.dart';
import 'package:Udirectory/views/home_view.dart';
import 'package:Udirectory/views/profile_view.dart';
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
            child: (currentIndex == 0)
                ? IconButton(
                    onPressed: () => usersetting(widget.user),
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(253, 126, 20, 0.839),
                    ),
                    onPressed: () => EditProfil(widget.user),
                    child: Row(
                      children: [
                        Text('Modifier profil'),
                        Icon(
                          Icons.mode_edit_outline_outlined,
                          color: Color.fromRGBO(255, 255, 255, 1),
                          size: 20,
                        ),
                      ],
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
        onPressed: () => searchpage(widget.users),
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

  EditProfil(ParseUser user) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProfileEditView(
                user: user,
              )),
    );
  }
}
