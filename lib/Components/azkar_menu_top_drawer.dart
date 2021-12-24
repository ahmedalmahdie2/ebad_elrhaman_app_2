import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:flutter/material.dart';

import 'main_category_button.dart';

class AzkarPicker extends StatefulWidget {
  @override
  _AzkarPickerState createState() => _AzkarPickerState();
}

class _AzkarPickerState extends State<AzkarPicker>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> slideAnimation;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    slideAnimation = Tween<Offset>(begin: Offset(0.0, -4.0), end: Offset.zero)
        .animate(CurvedAnimation(parent: controller, curve: Curves.decelerate));
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: BackButton(),
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          padding: const EdgeInsets.all(13.0),
          // height: MediaQuery.of(context).size.height / 2.7,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                CategoryButton(
                  text: kSubCatergoriesNames[0][0],
                  onTap: () {},
                  width: MediaQuery.of(context).size.width / 5,
                  fontSize: 15,
                ),
                CategoryButton(
                  text: kSubCatergoriesNames[1][0],
                  onTap: () {},
                  width: MediaQuery.of(context).size.width / 5,
                  fontSize: 15,
                ),
                CategoryButton(
                  text: kSubCatergoriesNames[2][0],
                  onTap: () {},
                  width: MediaQuery.of(context).size.width / 5,
                  fontSize: 15,
                ),
                CategoryButton(
                  text: kSubCatergoriesNames[3][0],
                  onTap: () {},
                  width: MediaQuery.of(context).size.width / 5,
                  fontSize: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
