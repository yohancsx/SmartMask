import 'package:flutter/material.dart';
import 'package:smart_mask/app/home_page/home_page_model.dart';
import 'package:smart_mask/common/app_style.dart';
import 'package:smart_mask/app/home_page/pressure_plotter.dart';

class HomePage extends StatelessWidget {
  HomePage({@required this.pageModel});

  //the hime page model
  final HomePageModel pageModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppStyle.mainDarkColor,
      ),
      backgroundColor: Colors.white,
      body: Builder(
        builder: (BuildContext context) {
          if (pageModel.pressed) {
            return StreamBuilder(
              stream: pageModel.dataStream,
              builder: (context, snapshot) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    String.fromCharCodes(snapshot.data),
                    style: TextStyle(color: Colors.black, fontSize: 70.0),
                  ),
                );
              },
            );
          } else {
            return Container(
                alignment: Alignment.center,
                child: FlatButton(
                  color: AppStyle.mainDarkColor,
                  child: Text("pressme"),
                  onPressed: () => pageModel.onPressed(),
                ));
          }
        },
      ),
    );
  }
}
