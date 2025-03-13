import 'package:flutter/material.dart';

import 'package:labtracking/screens/new_user_form_screen.dart';

//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  //final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Future<void> logOut() async {
  //   Auth auth = Provider.of<Auth>(context, listen: false);
  //   await auth.signOut(_auth, _googleSignIn);
  // }

  Widget _createDrawerItem(IconData icon, String label, Function onTap) {
    return TextButton(
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(label),
      ),
      onPressed: () => onTap(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          AppBar(
            title: const Text("Menu"),
            automaticallyImplyLeading: false,
          ),
          //_createDrawerItem(Icons.person, "Editar conta", () => print("ok")),
          // _createDrawerItem(Icons.logout, "Home", () {
          //   Navigator.of(context)
          //       .pushNamedAndRemoveUntil(AppRoutes.HOME, (route) => false);
          //   //logOut();
          // }),
          _createDrawerItem(Icons.person, "New user", () {
            //logOut();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewUserFormScreen()),
            );
          })
        ],
      ),
    );
  }
}
