
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fireproject/Medicine_log/screens/med_home_screen.dart';
import 'package:fireproject/Medicine_log/services/medication_service.dart';
import '../models/medicine.dart';

class MedicationDetailsPage extends StatefulWidget {
  final Medicine medicine;

  const MedicationDetailsPage({super.key, required this.medicine});

  @override
  MedicationDetailsPageState createState() => MedicationDetailsPageState();
}

class MedicationDetailsPageState extends State<MedicationDetailsPage> {
  List<bool> checkedState = [];
User? user = FirebaseAuth.instance.currentUser;
  // Retrieves the saved checkbox states from Firestore
void retrieveCheckboxStates() async {
  try {
    // Get the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // Get the document reference for the medication
    DocumentReference documentReference = firestore.collection('users').doc(user!.uid).collection('intake_state').doc(widget.medicine.id);
    // Get the document snapshot
    DocumentSnapshot documentSnapshot = await documentReference.get();
    // Check if the document exists
    if (documentSnapshot.exists) {
      // Get the data from the document
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      // Retrieve the checkbox data from the data
      List<Map<String, dynamic>> checkboxData = List<Map<String, dynamic>>.from(data['checkboxData']);
      // Initialize checkedState with default values
      List<bool> updatedCheckedState = List<bool>.filled(widget.medicine.reminderTime.length, false);
      // Update the checkedState list based on the retrieved checkbox data
      for (int i = 0; i < checkboxData.length; i++) {
        if (i < updatedCheckedState.length) {
          updatedCheckedState[i] = checkboxData[i]['isChecked'] ?? false;
        }
      }
      // Update the UI with the retrieved checkbox states
      setState(() {
        checkedState = updatedCheckedState;
      });
    }
  } catch (e) {
    print('Error retrieving checkbox states: $e');
  }
}


  // Saves the checkbox states to Firestore
 void saveCheckboxStates() async {
  try {
    // Get the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // Get the document reference for the medication
    DocumentReference documentReference = firestore.collection('users').doc(user!.uid).collection('intake_state').doc(widget.medicine.id);
    
    // Prepare data to be saved
    List<Map<String, dynamic>> checkboxData = [];
    for (int i = 0; i < checkedState.length; i++) {
      checkboxData.add({
        'time': DateFormat('HH:mm').format(DateTime.now()), // Save current time
        'isChecked': checkedState[i], // Save checkbox state
      });
    }
    
    // Save the data to Firestore
    await documentReference.set({
      'checkboxData': checkboxData,
    });
  } catch (e) {
    print('Error saving checkbox states: $e');
  }
}

  @override
  void initState() {
    super.initState();
    // Initialize the checked states for each reminder time to be unchecked (false)
    checkedState =
        List<bool>.filled(widget.medicine.reminderTime.length, false);

    // Initialize the checked states for each reminder time to be unchecked (false)
    checkedState =
        List<bool>.filled(widget.medicine.reminderTime.length, false);

    // Retrieve checkbox states from Firestore when the page is loaded
    retrieveCheckboxStates();
  }

  // Converts the list of Timestamps to a list of formatted time strings
  List<String> formatReminderTimes(List<Timestamp> reminderTimes) {
    return reminderTimes
        .map((timestamp) => DateFormat('HH:mm').format(timestamp.toDate()))
        .toList();
  }

  

  @override
  Widget build(BuildContext context) {
    // Get the size of the screen (or parent widget)
    var screenSize = MediaQuery.of(context).size;

    // Calculate the size of the image
    var imageWidth =
        screenSize.width * 0.5; // for example, 50% of the screen width
    var imageHeight =
        imageWidth * (3 / 4); // maintain the aspect ratio of the image

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Details',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.delete_forever_outlined,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () async {
                // Confirm before deleting
                bool confirmDelete = await showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('Remove Reminder'),
                      content: const Text(
                          'Are you sure you want to remove this reminder?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text(
                            'Remove',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pop(true);
                                 // Dismiss and return true
                          },
                        ),
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context)
                                .pop(false); // Dismiss and return false
                          },
                        ),
                      ],
                    );
                  },
                );

                // If delete is confirmed
                if (confirmDelete) {
                  String? medicineId = widget.medicine.id;
                  if (medicineId != null) {
                    try {
                      MedicationService medicationService = MedicationService();
                      await medicationService.deleteMedicine(medicineId);
                      Navigator.of(context)
                          .pop(); // Go back to the previous screen
                        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
            content: const Text('Reminder Removed successfully', style: TextStyle(color:Color.fromARGB(255, 18, 142, 214), fontWeight: FontWeight.bold)),
            backgroundColor: Colors.white,
                duration: const Duration(seconds:3 ), // Adjust duration as needed
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ), // Adjust duration as needed
            
          ));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
            content: const Text('Unable to remove the medication', style: TextStyle(color:Color.fromARGB(255, 18, 142, 214), fontWeight: FontWeight.bold)),
            backgroundColor: Colors.white,
                duration: const Duration(seconds:3 ), // Adjust duration as needed
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ), // Adjust duration as needed
            
          ));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Medicine ID is null')),
                    );
                  }
                }
              },
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: screenSize.height * 0.02), // space from the top

              // Display the medication image
              SizedBox(
                width: imageWidth,
                height: imageHeight,
                child: Image.asset(
                  widget.medicine.image, // Replace with the actual image path
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.medicine.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.medicine.dosage,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 129, 126, 126),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Edit button
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color of the circle
                      shape: BoxShape.circle, // Makes the container a circle
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(
                              0.5), // Shadow color with some transparency
                          spreadRadius: 2, // Spread radius of the shadow
                          blurRadius: 5, // Blur radius of the shadow
                          offset: const Offset(0, 3), // Position of the shadow
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.edit_note_outlined,
                        color: Color.fromARGB(255, 54, 98, 244),
                      ),
                      onPressed: () {

                        
                        // Navigate to the HomeScreen for editing
                       Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => medScreen(medicineToEdit: widget.medicine),
                        ));
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color(0xFFeff0f4),
                      ),
                      child: Center(
                          child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                           Icon(
                            Icons.medication,
                            color: Colors.red[600],
                            size: 30,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.medicine.dosage,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const Text('Dosage')
                            ],
                          )
                        ],
                      )),
                    ),
                  ),
                  const SizedBox(
                      width:
                          10), // This will provide spacing between the two containers
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color(0xFFeff0f4),
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.watch_later_rounded,
                              color: Color.fromARGB(255, 59, 133, 218),
                              size: 30,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.medicine.amount,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text('By day')
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Agenda',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),

              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: const Color(0xFFeff0f4),
                ),
                child: ListView.builder(
                  padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
                  itemCount: widget.medicine.reminderTime.length,
                  itemBuilder: (context, index) {
                    // Formatting each reminder time for display
                    String formattedTime =
                        widget.medicine.reminderTime.isNotEmpty
                            ? formatReminderTimes(
                                widget.medicine.reminderTime)[index]
                            : 'No time set';

                    // Row for each reminder time with a corresponding checkbox
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formattedTime,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 71, 118, 248),
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          Checkbox(
                            value: checkedState[index],
                            onChanged: (bool? newValue) {
                              // Update the state when the checkbox is toggled
                              setState(() {
                                checkedState[index] = newValue ?? false;
                              });
                            },
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),
              InkWell(
                onTap: () {
                  saveCheckboxStates();
                   Navigator.pop(context);
                   // Call the function to save the checked state
                  // You can perform any additional actions here if needed
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20), // Reduced horizontal padding
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 60, 150, 224), // Button color
                    borderRadius: BorderRadius.circular(
                        30), // High border radius for pill shape
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Center the contents horizontally
                      children: [
                        Icon(Icons.save, color: Colors.white),
                        SizedBox(width: 10), // Spacing between icon and text
                        Text(
                          "Save",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ])));
  }
}
