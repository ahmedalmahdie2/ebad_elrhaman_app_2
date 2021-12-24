import 'package:flutter/material.dart';
import 'package:quranandsunnahapp/Components/menu_button.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:easy_localization/easy_localization.dart'as easy;

class SettingScreen extends StatefulWidget {
  static String route = "Setting Screen";
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainAppColor02,
      appBar: AppBar(
        backgroundColor: kMainAppColor01,
        leading: BackButton(
          color: kMainAppColor03,
          onPressed: () async {
            // await _player.dispose();
            Navigator.pop(context);
          },
        ),
        title: Text(
          'settings',
          style: kAppBarTitleStyle,
        ).tr(),
        centerTitle: true,
        actions: [MenuButton()],
      ),
      body: Directionality(
            textDirection: TextDirection.rtl,
              child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0,right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'askinglanguage',
                    style: TextStyle(
                        color: kMainAppColor03,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ).tr(),
                  Switch(
                    value: isSwitched,
                    
                    onChanged: (value) async{
                      
                        if (value) {
                         await context.setLocale(Locale("ar", "AR"));
                        } else {
                         await context.setLocale(Locale("en", "US"));
                        }
                      setState(() {
                        isSwitched = value;
                        
                      });
                    },
                    activeTrackColor: Colors.green,
                    activeColor: kMainAppColor01,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
