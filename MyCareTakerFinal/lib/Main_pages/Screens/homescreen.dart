import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireproject/Medicine_log/models/medicine.dart';
import 'package:fireproject/Medicine_log/services/medication_service.dart';
import 'package:fireproject/Main_pages/goals/tdee.dart';
import 'package:fireproject/Main_pages/goals/tdee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:sensors/sensors.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';
import 'package:fireproject/adController.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({
    super.key,
    required this.pageController,
  });

  final PageController pageController;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var firebaseUser = FirebaseAuth.instance.currentUser;
Timer? _timer;
  Map<String, double> mealCategories = {
    'Breakfast': 0,
    'Lunch': 0,
    'Dinner': 0,
    'Snack': 0,
  };

  // Define custom colors for each category
  final List<Color> categoryColors = [
    const Color.fromARGB(255, 255, 17, 0),
    Color.fromARGB(255, 0, 4, 255),
    Color.fromARGB(255, 43, 255, 0),
    Color.fromARGB(255, 255, 208, 0),
  ];

  // Mock data for goals

  final DateTime selectedDate = DateTime.now();
  int _stepCount = 0;

  var myContr = Get.put(MyController());

  @override
  void initState() {
    super.initState();
     _startTimer();
    updateMealCategories();
    myContr.loadAd();
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (mounted) {
        setState(() {
          if (event.z > 10.0) {
            _stepCount++;
          }
        });
      }
    });
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

  Future<Map<String, double>> fetchMealCalories() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .collection("food")
        .get();

    Map<String, double> mealCalories = {
      'Breakfast': 0,
      'Lunch': 0,
      'Snack': 0,
      'Dinner': 0,
    };

    querySnapshot.docs.forEach((DocumentSnapshot doc) {
      String mealType = doc['meal'];
      int calories = doc['calories'];
      mealCalories[mealType] = (mealCalories[mealType]! + calories);
    });

    return mealCalories;
  }

  Future<void> updateMealCategories() async {
    // Fetch and update meal categories
    Map<String, double> fetchedMealCalories = await fetchMealCalories();
    if (mounted) {
      setState(() {
        mealCategories = fetchedMealCalories;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    myContr.dispose();
    widget.pageController.dispose();
    myContr.nativeAd!.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double totalCalories =
        mealCategories.values.fold(0, (prev, curr) => prev + curr);

    // Calculate total percentage of calories

    Stream<QuerySnapshot> medicationStream =
        MedicationService().fetchMedicine(selectedDate);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.dashboard, size: 28),
            SizedBox(width: 8),
            Text(
              'Dashboard',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(firebaseUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          var user = snapshot.data;
                          if (user == null || !snapshot.hasData) {
                            return const Center(
                              child: Text('No user data found.'),
                            );
                          }
                          var firstName = user['first name'];
                          return Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Welcome, $firstName',
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w800),
                            ),
                          );
                        }
                      })
                ],
              ),
              SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                  stream: medicationStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      // Displays an error message if there's an error in the stream.
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData) {
                      // Shows a progress indicator while data is loading.
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return _buildContainer(
                        child: Container(
                          padding: EdgeInsets.only(left: 15),
                          width: double.infinity,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/images/medical_record.png",
                                    height: 40,
                                    width: 40,
                                  ),
                                  const Text(
                                    'Your scheduled medicine',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              const Row(
                                children: [
                                  Text(
                                    "There is no scheduled\n reminders yet",
                                    style: TextStyle(
                                        color: Color.fromARGB(200, 255, 0, 0),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }

                    final medicine =
                        Medicine.fromFirestore(snapshot.data!.docs.last);
                    return _buildContainer(
                      child: Container(
                        padding: EdgeInsets.only(left: 15),
                        width: double.infinity,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/images/medical_record.png",
                                  height: 40,
                                  width: 40,
                                ),
                                const Text(
                                  'Your scheduled medicine',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Card(
                                  color:
                                      const Color.fromARGB(255, 152, 211, 238),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 1,
                                  margin: const EdgeInsets.all(8),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        right: 80, left: 15, top: 5, bottom: 7),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        Text(
                                          '${medicine.name} ',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.watch_later_outlined,
                                              size: 18,
                                            ),
                                            Text(
                                              DateFormat('HH:mm').format(
                                                  medicine.reminderTime.first
                                                      .toDate()),
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: TextButton.icon(
                                      style: TextButton.styleFrom(
                                          backgroundColor:
                                              Colors.white.withOpacity(0.3)),
                                      icon: const Icon(
                                        Icons.more,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        widget.pageController.animateToPage(
                                          2, // Index of the 3rd tab
                                          duration:
                                              const Duration(milliseconds: 150),
                                          curve: Curves.ease,
                                        );
                                      },
                                      label: const Text(
                                        "View all",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
              SizedBox(height: 16),
              _buildContainer(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 15),
                      child: const Text(
                        'Food Report',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PieChart(
                              dataMap: mealCategories,
                              chartType: ChartType.ring,
                              chartRadius: 105, // Adjust chart size as needed
                              legendOptions: const LegendOptions(
                                legendPosition: LegendPosition.bottom,
                                showLegends: false, // Hiding legends
                              ),
                              // Remove displaying values inside the pie chart
                              chartValuesOptions: const ChartValuesOptions(
                                showChartValueBackground: false,
                                showChartValues: false,
                              ),
                              colorList: categoryColors,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var i = 0; i < mealCategories.length; i++)
                                  Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        color: categoryColors[i],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${mealCategories.keys.elementAt(i)} (${(totalCalories > 0 ? ((mealCategories.values.elementAt(i) / totalCalories) * 100).toStringAsFixed(1) : "0.0")}%)',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    child: Expanded(
                      child: _buildContainer(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(firebaseUser!.uid)
                              .collection("goal")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              // If there is no data (no goal added yet)
                              return Column(
                                children: [
                                  ListTile(
                                    leading: Image.asset(
                                      "assets/img/target.png",
                                      width: 30,
                                      height: 30,
                                    ),
                                    title: const Text(
                                      "Goals",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              GoalSelectionPage(),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor:
                                          Colors.white.withOpacity(0.4),
                                    ),
                                    child: const Text(
                                      "Set your goal",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              // If there is data (goal added)
                              var goal = Goals.fromFirestore(
                                  snapshot.data!.docs.first);
                              return Column(
                                children: [
                                  ListTile(
                                    leading: Image.asset(
                                      "assets/img/target.png",
                                      width: 30,
                                      height: 30,
                                    ),
                                    title: const Text(
                                      "Goals",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    '${goal.tdee} to ${goal.goal}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              GoalSelectionPage(),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor:
                                          Colors.white.withOpacity(0.4),
                                    ),
                                    child: const Text(
                                      "Update your goal",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildContainer(
                        child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 20, top: 14),
                          child: const Text(
                            "Steps",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ListTile(
                          leading: Image.asset(
                            "assets/images/running.png",
                            width: 33,
                            height: 33,
                          ),
                          title: Text(
                            "$_stepCount",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20),
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(firebaseUser!.uid)
                                  .collection('Steps')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return const Text(
                                    "Goal: 5000 steps ",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 44, 41, 41),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  );
                                } else {
                                  var doc = snapshot.data!.docs.first;

                                  var steps = doc["dailyGoal"];

                                  return Text("Goal: $steps Steps",
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 44, 41, 41),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14));
                                }
                              }),
                        ),
                      ],
                    )),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.all(10.0),
                width: 400,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Obx(() =>
                        myContr.isAdVisible.value && myContr.isAdLoaded.value
                            ? Flexible(child: AdWidget(ad: myContr.nativeAd!))
                            : SizedBox(
                                child: Text(
                                  "Keep it up ⬆️",
                                  style: GoogleFonts.fjallaOne(
                                      fontSize: 50, color: Colors.blue),
                                ),
                              )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContainer({Widget? child}) {
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 5),
      height: 180, // Adjust height as needed
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}
