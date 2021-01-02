import 'package:flutter/material.dart';
import 'package:smart_mask/app/home_page/home_page_model.dart';
import 'package:smart_mask/app/home_page/menu_bar.dart';
import 'package:smart_mask/app/home_page/pressure_view_page.dart';
import 'package:smart_mask/app/home_page/pressure_plot_page.dart';
import 'package:smart_mask/common/app_style.dart';

class HomePage extends StatelessWidget {
  HomePage({@required this.pageModel});

  //the home page model
  final HomePageModel pageModel;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        //if we have started the session, return the pageview of the user data
        if (pageModel.sessionStarted) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppStyle.mainDarkColor,
              title: Text(pageModel.maskService.smartMaskDevice.name),
            ),
            bottomNavigationBar: MenuBar(
              pageModel: pageModel,
            ),
            body: PageView.builder(
              controller: pageModel.controller,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return PressurePlotPage(pageModel: pageModel);
                } else if (index == 1) {
                  return PressureViewPage(pageModel: pageModel);
                } else {
                  return Container();
                }
              },
            ),
          );
        } else {
          //otherwise request that the user starts a session
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppStyle.mainDarkColor,
            ),
            body: Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: FlatButton(
                height: 50.0,
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                color: AppStyle.mainLightColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0)),
                onPressed: () => pageModel.onBeginSession(context),
                child: Text(
                  "Begin Session",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
