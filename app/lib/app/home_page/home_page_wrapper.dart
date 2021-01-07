import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_mask/app/bt_connection_page/bt_connection_page_wrapper.dart';
import 'package:smart_mask/app/home_page/home_page.dart';
import 'package:smart_mask/app/home_page/home_page_model.dart';
import 'package:smart_mask/common/app_style.dart';
import 'package:smart_mask/services/bluetooth_mask_service.dart';

class HomePageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BluetoothMaskService maskService =
        Provider.of<BluetoothMaskService>(context, listen: false);
    //check for device state
    return StreamBuilder<bool>(
        stream: Stream.periodic(Duration(seconds: 1), (_) {
          return maskService.isConnectedToBluetooth();
        }).asyncMap((value) async => await value),
        initialData: true,
        builder: (context, snapshot) {
          //if we are connected to bluetooth

          if (snapshot.data == true) {
            return ChangeNotifierProvider<HomePageModel>(
              create: (context) => HomePageModel(maskService: maskService),
              child: Consumer<HomePageModel>(
                builder: (context, model, child) {
                  return HomePage(pageModel: model);
                },
              ),
            );
          } else {
            //otherwise go to the connection page
            return Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.all(20.0),
                    padding: EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: AppStyle.mainDarkColor,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Please connect to a SmartMask device!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  //go back to connection
                  FlatButton(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    color: AppStyle.mainLightColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0)),
                    height: 50.0,
                    onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                BluetoothConnectionPageWrapper())),
                    child: Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.0,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}
