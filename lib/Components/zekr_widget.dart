import 'package:quranandsunnahapp/Classes/azkar_data.dart';
import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Components/clipped_card.dart';
import 'package:quranandsunnahapp/Components/times_counter_button.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:flutter/material.dart';
//
// class AzkarWidget extends StatelessWidget {
//   final AzkarData zekr;
//
//   const AzkarWidget({
//     this.zekr,
//   });
//
//   List<TextSpan> allText() {
//     String afterParsing = HelperMethods.parseHtmlString(zekr.zekr);
//     List<String> mystr = afterParsing.split(" ");
//     List<TextSpan> allTextWidget = [];
//     for (int i = 0; i < mystr.length; i++) {
//       if (mystr[i] == "اللَّهُمَّ") {
//         allTextWidget.add(TextSpan(
//           text: '\n' + mystr[i],
//           style: kTextStyleRedNormal.copyWith(fontSize: 25),
//           // textAlign: TextAlign.justify,
//           // textDirection: TextDirection.rtl,
//         ));
//         allTextWidget.add(TextSpan(text: " "));
//       } else {
//         // print(mystr[i]);
//         allTextWidget.add(TextSpan(
//           text: mystr[i],
//           style: kTextStyleBlackNormal.copyWith(fontSize: 22),
//           //textAlign: TextAlign.justify,
//           //textDirection: TextDirection.rtl,
//         ));
//         allTextWidget.add(TextSpan(text: " "));
//       }
//     }
//     return allTextWidget;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               if (zekr.intro != null && zekr.intro.isNotEmpty)
//                 Text(
//                   HelperMethods.parseHtmlString(zekr.intro),
//                   style: kTextStyleBlackNormal.copyWith(
//                       fontSize: 22, color: kMainAppColor01),
//                   textAlign: TextAlign.justify,
//                   textDirection: TextDirection.rtl,
//                 ),
//               RichText(
//                 text: TextSpan(children: allText())
//                 //HelperMethods.parseHtmlString(zekr.zekr),
//                 ,
//                 textAlign: TextAlign.justify,
//                 textDirection: TextDirection.rtl,
//               ),
//               Divider(
//                 thickness: 1.0,
//                 height: 15,
//                 color: Colors.grey,
//               ),
//               //Text(zekr.zekr),
//               if (zekr.reference != null && zekr.reference.isNotEmpty)
//                 Text(
//                   HelperMethods.parseHtmlString(zekr.reference),
//                   style: kTextStyleBlackNormal.copyWith(
//                       fontSize: 22, color: kMainAppColor01),
//                   textAlign: TextAlign.justify,
//                   textDirection: TextDirection.rtl,
//                 ),
//               if (zekr.description != null && zekr.description.isNotEmpty)
//                 Text(
//                   HelperMethods.parseHtmlString(zekr.description),
//                   style: kTextStyleBlackNormal.copyWith(
//                       fontSize: 22, color: kMainAppColor01),
//                   textAlign: TextAlign.justify,
//                   textDirection: TextDirection.rtl,
//                 ),
//             ],
//           ),
//         ),
//         TimesCounterButton(
//           times: zekr.count,
//           index: zekr.azkarGroupIndex,
//           text: zekr.zekr,
//         ),
//       ],
//     );
//   }
// }
