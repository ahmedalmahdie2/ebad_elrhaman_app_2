import 'package:flutter/material.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';
import 'package:easy_localization/easy_localization.dart';

class ChangeLanguageButton extends StatelessWidget {
  const ChangeLanguageButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(child: context.locale.countryCode=="US"?Image.asset('assets/images/AR.png',color: kMainAppColor03,height: 40,width: 40,)
    :Image.asset("assets/images/EN.png",color: kMainAppColor03,height: 35,width: 35,),onTap: ()async{
      if(context.locale.countryCode=="US")
      {
             await context.setLocale(Locale("ar", "AR"));
      }
      else 
      {
           await context.setLocale(Locale("en", "US"));
      }
    },);
  }
}