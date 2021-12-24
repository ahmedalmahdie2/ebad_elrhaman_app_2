import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quranandsunnahapp/Classes/azkar_data.dart';
import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Components/change_lang_button.dart';
import 'package:quranandsunnahapp/Components/list_view_item.dart';
import 'package:quranandsunnahapp/Components/menu_button.dart';
import 'package:quranandsunnahapp/Components/side_menu.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:quranandsunnahapp/Screens/azkar_screen.dart';
import 'package:quranandsunnahapp/Screens/azkar_submain_screen.dart';
import 'package:quranandsunnahapp/Screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AzkarMainCategory extends StatefulWidget {
  static String route = "AzkarMainCategory";
  // static List<AzkarGroupData> azkarSabahAndMasaa = [];
  // static List<AzkarGroupData> azkarElSalah = [];
  // static List<AzkarGroupData> azkarlife = [];
  // static List<AzkarGroupData> azkarSafr = [];
  // static List<AzkarGroupData> azkarHagAndOmra = [];
  // static List<AzkarGroupData> azkarMehnandSrour = [];
  // static List<AzkarGroupData> azkarHemaya = [];
  // static List<AzkarGroupData> azkarMard = [];
  static SharedPreferences pref;
  final int initialTab;

  const AzkarMainCategory({this.initialTab});
  @override
  _AzkarMainCategoryState createState() => _AzkarMainCategoryState();
}

class _AzkarMainCategoryState extends State<AzkarMainCategory> {
  List<AzkarGroupData> azkarGroups = [];
  Map<String, dynamic> azkarFileContent;

  List<List<int>> allIndices = [];
  @override
  void initState() {
    super.initState();

    initializeFavorites();

    // initialize();
  }

  // Future initialize() async {
  //   initializeGroups(await initializeFavorites());
  // }

  Future<void> initializeFavorites() async {
    var tempFile = await HelperMethods.loadAzkarFile();

    // print(parsedAzkarFile);
    setState(() {
      azkarFileContent = tempFile;
    });

    compute(HelperMethods.parseAzkar, azkarFileContent).then(
      (groups) {
        print('we\'ve parsed azkar');
        // groups.forEach((group) {
        //   print(group.azkarGroupNames[0]);
        // });
        setState(() {
          azkarGroups = groups;
        });

        get_favourite(azkar: azkarGroups);
      },
    );
  }

  Future<void> get_favourite({List<AzkarGroupData> azkar}) async {
    allIndices = [];
    var pref = await SharedPreferences.getInstance();
    AzkarMainCategory.pref = pref;
    List<String> myFavouriteIndices =
        AzkarMainCategory.pref.getStringList("fav");
    setState(() {
      if (myFavouriteIndices != null)
        for (int i = 0; i < myFavouriteIndices.length; i++) {
          print('myFavouriteIndices[i]: ${myFavouriteIndices[i]}');
          var subgroupIndex = -1;
          var parentGroupIndex = -1;
          try {
            parentGroupIndex = int.parse(myFavouriteIndices[i].split('_')[0]);
            subgroupIndex = int.parse(myFavouriteIndices[i].split('_')[1]);
          } catch (e) {}
          if (parentGroupIndex >= 0 && subgroupIndex >= 0) {
            allIndices.add([parentGroupIndex, subgroupIndex]);
            azkar[parentGroupIndex].starred = true;
            azkar[parentGroupIndex].subgroups[subgroupIndex].starred = true;
          }
        }
      print(allIndices.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.initialTab ?? 1,
      length: 2,
      child: Scaffold(
        backgroundColor: kMainAppColor02,
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: ListTile(
                  trailing: Icon(
                    Icons.star,
                    color: Colors.white,
                  ),
                  title: Center(child: Text('المفضلة')),
                ),
              ),
              Tab(
                child: ListTile(
                  trailing: Image.asset(
                    'assets/images/duaa.png',
                    width: 25,
                    height: 25,
                    colorBlendMode: BlendMode.color,
                    color: kMainAppColor01,
                  ),
                  title: Center(child: Text('الاذكار')),
                  horizontalTitleGap: 0,
                ),
              ),
            ],
            onTap: (indx) {
              Navigator.popAndPushNamed(context, AzkarMainCategory.route,
                  arguments: indx);
            },
          ),
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
        body: TabBarView(
          children: [
            ListView.separated(
              separatorBuilder: (context, index) {
                print('dividing for $index');
                return Divider();
              },
              itemBuilder: (ctx, indx) {
                return ListTile(
                  leading: Image.asset(
                    kAzkarGroupsImagesPaths[indx],
                    height: 35,
                    width: 35,
                  ),
                  title: Text(
                    azkarGroups[allIndices[indx][0]]
                            .subgroups[allIndices[indx][1]]
                            .azkarSubgroupNames[
                        HelperMethods.isArabic(context) ? 0 : 1],
                    style: TextStyle(
                        color: kMainAppColor01,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    textDirection: TextDirection.rtl,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, AzkarScreen.route,
                        arguments: azkarGroups[allIndices[indx][0]]
                            .subgroups[allIndices[indx][1]]);
                  },
                  trailing: IconButton(
                    icon: Icon(
                      Icons.star,
                      color: kMainAppColor01,
                    ),
                    onPressed: () {
                      List<String> stringOfIndexes = [];
                      stringOfIndexes.addAll(
                          AzkarMainCategory.pref.getStringList("fav") ?? []);

                      stringOfIndexes.remove(
                          '${allIndices[indx][0]}_${allIndices[indx][1]}');
                      print(
                          'remove favorit: ${allIndices[indx][0]}_${allIndices[indx][1]}');
                      AzkarMainCategory.pref
                          .setStringList("fav", stringOfIndexes);
                      setState(() {
                        allIndices.removeAt(indx);
                      });
                    },
                  ),
                );
              },
              itemCount: allIndices.length,
            ),
            SingleChildScrollView(
              child: Column(
                children: azkarGroups.isNotEmpty
                    ? List<Widget>.generate(azkarGroups.length, (index) {
                        return Column(
                          children: [
                            GestureDetector(
                              child: AzkarCardListView(
                                image: kAzkarGroupsImagesPaths[index],
                                zekrGroup: azkarGroups[index],
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AzkarSubCategoryScreen.route,
                                  arguments: azkarGroups[index].subgroups,
                                );
                              },
                            ),
                            Divider(
                              thickness: 1.0,
                              height: 15,
                              color: Colors.grey,
                            ),
                          ],
                        );
                      })
                    : [],
              ),
            ),
          ],
          physics: NeverScrollableScrollPhysics(),
        ),
        drawer: SideMenu(),
      ),
    );
  }
}
