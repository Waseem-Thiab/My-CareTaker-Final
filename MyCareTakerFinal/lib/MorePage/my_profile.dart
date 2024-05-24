import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({
    super.key,
  });

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final user = FirebaseAuth.instance.currentUser;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _newPasswordController.dispose();
    _oldPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    changePassword(email, oldPassword, newPassword) async {
      // if(_oldPasswordController.text.isNotEmpty && _newPasswordController.text.isNotEmpty){
      var cred =
          EmailAuthProvider.credential(email: email, password: oldPassword);

      await user!.reauthenticateWithCredential(cred).then(
        (value) {
          user.updatePassword(newPassword);
        },
      ).catchError((error) {
        print(error.toString());
      });
    }

    updateProfile(String firstName, String lastName) async {
      // Update user's profile in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'first name': firstName,
        'last name': lastName,
      });
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          centerTitle: true,
          title: const Text(
            "My Profile",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Color.fromARGB(255, 171, 225, 248),
                Color.fromARGB(255, 68, 191, 243),
                Color.fromARGB(255, 2, 124, 238)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // -- Form Fields
                Form(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .where('uid', isEqualTo: user!.uid)
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

                              if (_firstNameController.text.isEmpty &&
                                  _lastNameController.text.isEmpty) {
                                _firstNameController.text = firstName;
                                _lastNameController.text = lastName;
                              }
                              return Column(
                                children: [
                                  TextFormField(
                                    controller: _firstNameController,
                                    decoration: InputDecoration(
                                      labelText: firstName,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _lastNameController,
                                    decoration: InputDecoration(
                                      labelText: lastName,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: '${user.email}',
                                      enabled: false,
                                      prefixIcon:
                                          const Icon(Icons.email_rounded),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _oldPasswordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: "Old Password",
                                      prefixIcon: const Icon(Icons.fingerprint),
                                      suffixIcon: IconButton(
                                        icon: const Icon(
                                            Icons.remove_red_eye_rounded),
                                        onPressed: () {},
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _newPasswordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: "New Password",
                                      prefixIcon: const Icon(Icons.fingerprint),
                                      suffixIcon: IconButton(
                                        icon: const Icon(
                                            Icons.remove_red_eye_rounded),
                                        onPressed: () {},
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                      const SizedBox(height: 25),

                      // -- Form Submit Button
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_oldPasswordController.text.isNotEmpty &&
                                _newPasswordController.text.isNotEmpty) {
                              await changePassword(
                                  user.email,
                                  _oldPasswordController.text,
                                  _newPasswordController.text);

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    title: const Text(
                                      'Profile updated successfully',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 18, 80, 214),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  );
                                },
                              );
                              ////////snackbar/////////
                              ///
                            }

                            updateProfile(_firstNameController.text,
                                _lastNameController.text);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  title: const Text(
                                    'Profile updated successfully',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 18, 80, 214),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Edit Profile",
                            style: GoogleFonts.balooDa2(
                              color: Colors.white,
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(
                        height: 30,
                      ),
                      // -- Created Date and Delete Button
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
