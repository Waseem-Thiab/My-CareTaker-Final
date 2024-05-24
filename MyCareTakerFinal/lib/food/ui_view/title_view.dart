import 'package:fireproject/food/fitness_app_theme.dart';
import 'package:fireproject/food/ui_view/add_custom_food.dart';
import 'package:flutter/material.dart';

class TitleView extends StatelessWidget {
  final String titleTxt;
  final String subTxt;

  const TitleView({
    Key? key,
    this.titleTxt = "",
    this.subTxt = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Row(
          children: <Widget>[
           const Expanded(
              child: Text(
                "Meals Today",
                textAlign: TextAlign.left,
                style:  TextStyle(
                  fontFamily: FitnessAppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  letterSpacing: 0.5,
                  color: FitnessAppTheme.lightText,
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>  const customFood()),
                  );
                },
                child: const Text("ADD FOOD"))
          ],
        ),
      ),
    );
  }
}
