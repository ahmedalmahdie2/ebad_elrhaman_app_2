import 'package:flutter/material.dart';
import 'package:quranandsunnahapp/Misc/constants.dart';

import 'clipped_card.dart';

class DownloadProgressIndicator extends StatelessWidget {
  final int downloadPercentege;
  final Function onCancel;
  const DownloadProgressIndicator({this.downloadPercentege, this.onCancel});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 150,
        child: ClippedCard(
          color: kMainAppColor02,
          isClipped: true,
          shadowColor: kMainAppColor03,
          hasBorder: true,
          borderColor: kMainAppColor01,
          child: Column(
            children: [
              Row(
                //
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.close,
                        color: kMainAppColor01,
                        size: 35,
                      ),
                      onPressed: onCancel),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 15,
                ),
                child: Column(
                  children: [
                    Text(
                      downloadPercentege != null && downloadPercentege >= 0
                          ? 'Downloading: % $downloadPercentege'
                          : 'checking files ..',
                      style: TextStyle(fontSize: 25, color: kMainAppColor01),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: LinearProgressIndicator(
                        backgroundColor: kMainAppColor03,
                        value: downloadPercentege / 100,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(kMainAppColor01),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
