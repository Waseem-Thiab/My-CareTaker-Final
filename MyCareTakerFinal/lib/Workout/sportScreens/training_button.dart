import 'package:fireproject/Workout/sportScreens/Running.dart';
import 'package:fireproject/Workout/sportScreens/cycling.dart';
import 'package:fireproject/Workout/sportScreens/swimming.dart';
import 'package:fireproject/Workout/sportScreens/weight_lifting.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: camel_case_types
class trainingButton extends StatelessWidget {
  const trainingButton({super.key, required this.asset,required this.title});
  final String asset;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (title) {
          case 'Running':
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const Running()),
            );
            break;
          case 'Cycling':
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const cycling()),
            );
            break;
          case 'Swimming':
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const swimming()),
            );
            break;
          case 'Weight Lifting':
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const WeightLifting()),
            );
            break;
          default:
            // Handle unknown title here, if needed
            break;
        }
      },
      child: Container(
        height: 200,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(asset),
            fit: BoxFit.cover,
            opacity: 0.8
          ),
       
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          margin: const EdgeInsets.only(top: 60, left: 30),
          child: Text(
            title,
            style: GoogleFonts.notoSans(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }
}
