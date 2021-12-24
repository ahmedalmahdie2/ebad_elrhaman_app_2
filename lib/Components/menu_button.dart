import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Scaffold.of(context).openDrawer(),
      icon: Icon(
        Icons.menu,
        color: kMainAppColor03,
        size: MediaQuery.of(context).size.width / 15,
      ),
      // iconSize: 35,
    );
  }
}
