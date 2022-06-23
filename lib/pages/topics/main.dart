import 'package:flutter/material.dart';
import 'package:math_geometry/widgets/option.dart';

class Topics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Option(
                  text: 'Training \n Station',
                  route: () => Navigator.pushNamed(context,
                      './pages/topics/transformations/levels/training_station')),
              Option(
                  text: "Beginner",
                  route: () => Navigator.pushNamed(context,
                      './pages/topics/transformations/levels/beginner_level')),
              Option(
                text: "Intermediate",
                route: () {},
              ),
              Option(text: "Advanced", route: () {})
            ],
          ),
        ),
      ),
    );
  }
}
