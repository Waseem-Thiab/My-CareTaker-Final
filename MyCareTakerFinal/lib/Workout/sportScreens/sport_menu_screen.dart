import 'package:fireproject/Workout/sportScreens/training_button.dart';
import 'package:fireproject/Workout/data/button_data.dart';
import 'package:flutter/material.dart';

class SportMenuScreen extends StatelessWidget {
  const SportMenuScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        flexibleSpace: Container(),
        title: const Text(
          "Training",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.white,
                Color.fromARGB(255, 97, 171, 255),

                Color.fromARGB(255, 97, 171, 255),
                Color.fromARGB(255, 70, 155, 252),
                Color.fromARGB(255, 56, 148, 253),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          child: const Text(
                        "WHAT DO YOU WANT TO \nTRAIN ?",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  trainingButton(
                    asset: assets[0],
                    title: titles[0],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  trainingButton(
                    asset: assets[1],
                    title: titles[1],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  trainingButton(
                    asset: assets[2],
                    title: titles[2],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  trainingButton(
                    asset: assets[3],
                    title: titles[3],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
