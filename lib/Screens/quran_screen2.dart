import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quranandsunnahapp/Classes/helper_methods.dart';
import 'package:quranandsunnahapp/Quran/quran_bloc.dart';
import 'package:quranandsunnahapp/newQuran/newquran_bloc.dart';

class QuranScreenAlt extends StatefulWidget {
  static String route = "QuranScreenAlt";
  @override
  _QuranScreenAltState createState() => _QuranScreenAltState();
}

class _QuranScreenAltState extends State<QuranScreenAlt> {
  @override
  void initState() {
    BlocProvider.of<QuranBloc>(context).add(QuranInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NewquranBloc, NewquranState>(
        builder: (context, state) {
          if (state is NewquranInitial) {
            return HelperMethods.loadingWidget;
          } else if (state is NewquranLoaded) {
            return SingleChildScrollView(
                child: Text(state.allSurahs[0].ayatWithNumbers));
          }
        },
      ),
    );
  }
}
