import 'package:flutter/material.dart';
import 'package:quranandsunnahapp/Classes/DuaaModel.dart';
import 'package:quranandsunnahapp/Components/change_lang_button.dart';
import 'package:quranandsunnahapp/Components/duaa_widget.dart';
import 'package:quranandsunnahapp/Components/menu_button.dart';
import 'package:quranandsunnahapp/Components/side_menu.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';

class DuaaScreen extends StatefulWidget {
  static const String route = "DuaaScreen";
  final DuaaGroup duaaGroup;
  DuaaScreen({this.duaaGroup});
  @override
  _DuaaScreenState createState() => _DuaaScreenState();
}

class _DuaaScreenState extends State<DuaaScreen> {
  Widget duaaaListWidget;
  @override
  void initState() {
    super.initState();
    duaaaListWidget = updateAzkarListWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: Container(
      //   width: MediaQuery.of(context).size.width,
      //   height: kHeightForBanner,
      //   child: banner==null?SizedBox(height: 20):AdWidget(ad:banner),
      // ),
      backgroundColor: kMainAppColor02,
      appBar: AppBar(
        backgroundColor: kMainAppColor01,
        leading: BackButton(
          color: kMainAppColor03,
        ),
        title: Text(
          widget.duaaGroup.duaaNameGroup,
          style: kAppBarTitleStyle,
        ),
        centerTitle: true,
        actions: [ChangeLanguageButton(), MenuButton()],
        // actions: [LangButton(), MenuButton()],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(child: duaaaListWidget),
          ),
        ),
      ),
      drawer: SideMenu(),
      endDrawer: SideMenu(),
    );
  }

  Widget updateAzkarListWidget() {
    int i = 0;
    List<Widget> tempDuaaWidgets = [];
    widget.duaaGroup.duaaList.forEach(
      (duaa) {
        // print(zekr.zekr);
        tempDuaaWidgets.add(DuaaWidget(duaa: duaa, index: i++));
      },
    );
    return Column(
      children: tempDuaaWidgets,
    );
  }
}
