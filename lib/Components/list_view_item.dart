import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:quranandsunnahapp/Classes/azkar_data.dart';
import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';

class AzkarCardListView extends StatelessWidget {
  final AzkarGroupData zekrGroup;
  final String image;
  AzkarCardListView({
    this.zekrGroup,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    zekrGroup.azkarGroupNames[
                        HelperMethods.isArabic(context) ? 0 : 1],
                    style: TextStyle(
                        color: kMainAppColor01,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    getDetails(HelperMethods.isArabic(context)),
                    style: TextStyle(color: Colors.grey, height: 1.0),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            Image.asset(
              image,
              height: 35,
              width: 35,
            ),
          ],
        ),
      ),
    );
  }

  String getDetails(bool isArabic) {
    var details = '';
    zekrGroup.subgroups.forEach((subgroup) {
      return details += subgroup.azkarSubgroupNames[isArabic ? 0 : 1] + ", ";
    });
    return details;
  }
}
