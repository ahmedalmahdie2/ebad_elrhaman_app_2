import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class URLSetting {

  static void launchMapsUrl(double lat, double lon) async {
  final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
static void callPhone(String phone) async {
  final url = 'tel://$phone';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
static void openWhatsapp(String phone) async {
  var url = 'https://';
  if (Platform.isAndroid) {
    // add the [https]
    url += "wa.me/$phone/?text=${Uri.parse('hello')}"; // new line
  } else {
    // add the [https]
    url +=
        "api.whatsapp.com/send?phone=$phone=${Uri.parse('hello')}"; // new line
  }
  print(url);
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
static Future<void> launchInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  } else {
    throw 'Could not launch $url';
  }
}
static Future<void> launchInEmail(String mailTo) async
{
  final Uri params = Uri(
  scheme: 'mailto',
  path: mailTo,
);

var url = params.toString();
if (await canLaunch(url)) {
  print('yes'); 
  await launch(url);
} else {
  throw 'Could not launch $url';
}

}

}