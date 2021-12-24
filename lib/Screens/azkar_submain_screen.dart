import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quranandsunnahapp/Classes/azkar_data.dart';
import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Components/change_lang_button.dart';
import 'package:quranandsunnahapp/Components/menu_button.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:quranandsunnahapp/Screens/azkar_main_category.dart';
import 'package:quranandsunnahapp/Screens/azkar_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AzkarSubCategoryScreen extends StatefulWidget {
  final List<AzkarSubgroupData> subAzkarList;
  static String route = "AzkarSubCategoryScreen";
  AzkarSubCategoryScreen({this.subAzkarList});

  @override
  _AzkarSubCategoryScreenState createState() => _AzkarSubCategoryScreenState();
}

class _AzkarSubCategoryScreenState extends State<AzkarSubCategoryScreen> {
  List<AzkarSubgroupData> subAzkarList;
  @override
  void initState() {
    super.initState();
    subAzkarList = widget.subAzkarList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainAppColor02,
      appBar: AppBar(
        backgroundColor: kMainAppColor01,
        leading: BackButton(
          color: kMainAppColor03,
        ),
        title: Text(
          'أذكــار',
          style: kAppBarTitleStyle,
        ),
        centerTitle: true,
        actions: [ChangeLanguageButton(), MenuButton()],
        // actions: [LangButton(), MenuButton()],
      ),
      body: ListView.separated(
        itemBuilder: (_, index) {
          return ListTile(
            title: Text(
              subAzkarList[index]
                  .azkarSubgroupNames[HelperMethods.isArabic(context) ? 0 : 1],
              style: TextStyle(
                color: kMainAppColor01,
                fontSize: 18,
              ),
              textDirection: TextDirection.rtl,
            ),
            onTap: () {
              Navigator.pushNamed(context, AzkarScreen.route,
                  arguments: subAzkarList[index]);
            },
            trailing: IconButton(
              icon: Icon(
                subAzkarList[index].starred == true
                    ? Icons.star
                    : Icons.star_border,
                color: kMainAppColor01,
              ),
              onPressed: () {
                // print("favo");

                List<String> stringOfIndexes = [];
                stringOfIndexes
                    .addAll(AzkarMainCategory.pref.getStringList("fav") ?? []);
                if (!stringOfIndexes.contains(
                    '${subAzkarList[index].parentGroupIndex}_${subAzkarList[index].azkarSubgroupIndex}')) {
                  print(
                      'favoring: ${subAzkarList[index].parentGroupIndex}_${subAzkarList[index].azkarSubgroupIndex}');
                  stringOfIndexes.add(
                      '${subAzkarList[index].parentGroupIndex}_${subAzkarList[index].azkarSubgroupIndex}');
                  setState(() {
                    subAzkarList[index].starred = true;
                  });
                } else {
                  print(
                      'remove favorit from: ${subAzkarList[index].parentGroupIndex}_${subAzkarList[index].azkarSubgroupIndex}');
                  stringOfIndexes.remove(
                      '${subAzkarList[index].parentGroupIndex}_${subAzkarList[index].azkarSubgroupIndex}');
                  setState(() {
                    subAzkarList[index].starred = false;
                  });
                }
                AzkarMainCategory.pref.setStringList("fav", stringOfIndexes);
              },
            ),
          );
        },
        separatorBuilder: (_, indx) => Divider(
          thickness: 1.0,
        ),
        itemCount: widget.subAzkarList.length,
      ),
    );
  }
}
