import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireproject/Main_pages/Screens/Nutrition.dart';
import 'package:fireproject/Main_pages/Screens/mealspage.dart';
import 'package:fireproject/MorePage/my_profile.dart';

import 'package:fireproject/MorePage/help/help_page.dart';
import 'package:fireproject/adController.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireproject/Main_pages/Screens/steps.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MorePage extends StatefulWidget {
  const MorePage({
    super.key,
  });

  @override
  State<MorePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MorePage> {
  var user = FirebaseAuth.instance.currentUser!;
  Timer? _timer;
  final MyController myController = Get.find();
  @override
  void initState() {
    super.initState();

    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        // Check if the widget is still mounted
        setState(() {
          // Update UI here
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 14, 90, 252),
              Color.fromARGB(255, 2, 194, 241),
            ]),
          ),
          child: Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 22),
              child: Column(children: [
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 16),
                    child: const Text(
                      "Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 25),
                    )),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/care.png',
                      height: 75,
                      width: 75,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .where('uid', isEqualTo: user.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const Text(
                                  "User not found",
                                  style: TextStyle(color: Colors.white),
                                );
                              }

                              var doc = snapshot.data!.docs.first;
                              String firstName = doc["first name"];
                              String lastName = doc["last name"];
                              return Text(
                                "$firstName $lastName ",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              );
                            }),
                        Text(
                          user.email!,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 15),
                        ),
                      ],
                    )
                  ],
                )
              ])),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 160.0),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 25),
                      Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(left: 15),
                          child: const Text("Account Settings",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans'))),
                      const SizedBox(height: 3),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const MyProfile()),
                          );
                        },
                        child: ListTile(
                          leading: Image.asset(
                            "assets/img/user_settings.png",
                            width: 40,
                            height: 40,
                          ),
                          title: const Text(
                            "My Profile",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          subtitle: const Text(
                            "edit your personal account information",
                            style:
                                TextStyle(color: Color.fromARGB(255, 24, 2, 1)),
                          ),
                        ),
                      ),
                      const Divider(
                        thickness: 0.5,
                        indent: 20,
                        endIndent: 20,
                        height: 0,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const stepsTracker()),
                          );
                        },
                        child: ListTile(
                          leading: Image.asset(
                            "assets/img/footprint.png",
                            width: 40,
                            height: 40,
                          ),
                          title: const Text(
                            "Steps",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          subtitle: const Text(
                            "track your daily walking steps",
                            style:
                                TextStyle(color: Color.fromARGB(255, 24, 2, 1)),
                          ),
                        ),
                      ),
                      const Divider(
                        thickness: 0.5,
                        indent: 20,
                        endIndent: 20,
                        height: 0,
                      ),
                      const SizedBox(height: 5),
                      TextButton(
                        onPressed: () {
                          myController.toggleAdVisibility();
                        },
                        child: ListTile(
                          leading: Image.asset(
                            "assets/img/remove-ads.png",
                            width: 40,
                            height: 40,
                          ),
                          title: const Text(
                            "Show Ads",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          trailing: Obx(() => Switch(
                            activeColor: Colors.blue,
                                value: myController.isAdVisible.value,
                                onChanged: (value) {
                                  myController.toggleAdVisibility();
                                },
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                        height: 0,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HelpPage()),
                          );
                        },
                        child: ListTile(
                          leading: Image.asset(
                            "assets/img/question.png",
                            width: 40,
                            height: 40,
                          ),
                          title: const Text(
                            "Help",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 200,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(300, 55),
                            backgroundColor:
                                const Color.fromARGB(255, 240, 94, 84),
                            foregroundColor: Colors.white),
                        child: Text(
                          "Sign out",
                          style: GoogleFonts.baloo2(fontSize: 28),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  )),
            ),
          ),
        ),
      ]),
    );
  }
}
