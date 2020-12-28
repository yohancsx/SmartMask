import 'package:flutter/material.dart';
import 'package:smart_mask/app/bt_connection_page/bt_connection_page_model.dart';
import 'package:smart_mask/common/app_style.dart';

///Promts the user to connect to a bluetooth mask, then routes to the home page
class BluetoothConnectionPage extends StatelessWidget {
  BluetoothConnectionPage({@required this.pageModel});

  ///the model for the bluetooth connection page
  final BluetoothConnectionPageModel pageModel;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Smart Mask"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.info,
              size: 30.0,
              color: Colors.white,
            ),
            onPressed: null,
          )
        ],
        backgroundColor: AppStyle.mainDarkColor,
      ),
      body: Container(
        color: Colors.white,
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //scrollable list of bluetooth devices, or text depending on the state
              Builder(
                builder: (context) {
                  //if we have not scanned, show instructions to scan
                  if (pageModel.buttonText == "Scan") {
                    return Container(
                      margin: EdgeInsets.only(
                          bottom: 20.0,
                          left: 20.0,
                          right: 20.0,
                          top: size.height * 0.3),
                      padding: EdgeInsets.all(30.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: AppStyle.mainDarkColor,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Press SCAN to scan for a smart mask nearby. Make sure to turn your mask and bluetooth on.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20.0,
                        ),
                      ),
                    );
                    //else show the list of devices found by the scan, or warning if none
                  } else {
                    //build the list of selected devices from the scanned devices
                    if (pageModel.scanResults.isEmpty) {
                      return Container(
                        margin: EdgeInsets.only(
                            bottom: 20.0,
                            left: 20.0,
                            right: 20.0,
                            top: size.height * 0.3),
                        padding: EdgeInsets.all(30.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: AppStyle.mainDarkColor,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "No devices found! Check that your bluetooth and smart mask are turned on and try again!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20.0,
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: AppStyle.mainDarkColor,
                        ),
                        margin: EdgeInsets.all(20.0),
                        padding: EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: size.height * 0.7,
                          child: ListView(
                            children: pageModel.getListOfDevices(context),
                          ),
                        ),
                      );
                    }
                  }
                },
              ),

              //scan or connect button
              Container(
                margin: EdgeInsets.only(top: 10.0),
                child: FlatButton(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0),
                  color: AppStyle.mainLightColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0)),
                  height: 50.0,
                  onPressed: () => pageModel.onButtonPressed(context),
                  child: Text(
                    pageModel.buttonText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                    ),
                  ),
                ),
              ),

              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
