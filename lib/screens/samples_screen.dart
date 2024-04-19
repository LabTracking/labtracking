import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:labtracking/components/about_window.dart';
import 'package:labtracking/components/sample_item.dart';
import 'package:labtracking/components/samples_list.dart';
import 'package:labtracking/screens/login_screen.dart';
import 'package:labtracking/screens/new_sample_screen.dart';
import 'package:labtracking/screens/new_sample_type_screen.dart';
import 'package:labtracking/utils/routes.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/auth_service.dart';

class SamplesScreen extends StatefulWidget {
  final String labId;
  final String labName;
  final List<dynamic> members;
  const SamplesScreen({
    required this.labId,
    required this.labName,
    required this.members,
    super.key,
  });

  @override
  State<SamplesScreen> createState() => _SamplesScreenState();
}

class _SamplesScreenState extends State<SamplesScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // final arguments = (ModalRoute.of(context)!.settings.arguments ??
    //     <String, dynamic>{}) as Map;

    //final labName = arguments["labName"] as String;

    final labId = widget.labId;
    final labName = widget.labName;
    final members = widget.members;

    getTextWidgets(List<dynamic> strings) {
      List<Widget> list = [];
      for (var i = 0; i < strings.length; i++) {
        list.add(
          Card(
            child: ListTile(
              title: FittedBox(child: Text(strings[i])),
              leading: const Icon(Icons.person, color: Colors.grey),
              trailing: IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                ),
                onPressed: () {},
              ),
            ),
          ),
        );
      }
      return list;
    }

    return Scaffold(
      appBar: AppBar(
        // /automaticallyImplyLeading: false,
        centerTitle: true,
        title: Column(
          children: [
            Image.asset(
              'assets/images/white_icon.png',
              fit: BoxFit.cover,
              height: 30,
            ),
            const Text(
              "LabTracking",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 126, 217, 87),
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.menu,
              size: 30,
            ),
            itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 126, 217, 87),
                      ),
                      Text(" My Account"),
                    ],
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(
                        Icons.settings,
                        color: Color.fromARGB(255, 126, 217, 87),
                      ),
                      Text(" Settings"),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Color.fromARGB(255, 126, 217, 87),
                      ),
                      Text('Add new sample'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 3,
                  child: Row(
                    children: [
                      Icon(
                        Icons.settings_suggest,
                        color: Color.fromARGB(255, 126, 217, 87),
                      ),
                      Text(' Suggest new sample type'),
                    ],
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 4,
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Color.fromARGB(255, 126, 217, 87),
                        size: 23,
                      ),
                      Text(" About"),
                    ],
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 5,
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Color.fromARGB(255, 126, 217, 87),
                        size: 23,
                      ),
                      Text(" Logout"),
                    ],
                  ),
                ),
              ];
            },
            onSelected: (value) async {
              if (value == 0) {
                print("My account menu is selected.");
              } else if (value == 1) {
                print("Settings menu is selected.");
              } else if (value == 2) {
                print("New Sample menu is selected.");
                Navigator.of(context).pushNamed(AppRoutes.NEW_SAMPLE);
              } else if (value == 3) {
                Navigator.of(context).pushNamed(AppRoutes.NEW_SAMPLE_TYPE);
              } else if (value == 4) {
                AboutWindow.aboutDialog(context);
                print("About is selected");
              } else if (value == 5) {
                await AuthService.logout(_auth, _googleSignIn);
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(AppRoutes.HOME, (route) => false);

                print('deslogado');
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            // Image.asset(
            //   'assets/images/logo.png',
            //   width: double.infinity,
            //   height: 200,
            // ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.business,
                  color: Colors.blue,
                ),
                Text(
                  " " + labName,
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Icon(
            //       Icons.person,
            //       color: Colors.grey,
            //     ),
            //     Text(" Members")
            //   ],
            // ),

            Scrollbar(
              child: Container(
                height: 150,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(left: 50.0, right: 50),
                  child: Column(
                    children: [
                      Column(children: getTextWidgets(members)),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(),
            SamplesList(
              labId: labId,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => NewSampleScreen(labId: labId)),
          );
        },
        backgroundColor: const Color.fromARGB(255, 126, 217, 87),
        child: const Icon(Icons.add),
      ),
    );
  }
}
