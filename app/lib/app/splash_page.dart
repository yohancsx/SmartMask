import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_mask/app/bt_connection_page/bt_connection_page_wrapper.dart';
import 'package:smart_mask/app/home_page/home_page_wrapper.dart';
import 'package:smart_mask/services/bluetooth_mask_service.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BluetoothMaskService maskService =
        Provider.of<BluetoothMaskService>(context, listen: false);

    return FutureBuilder<bool>(
      future: Future.delayed(Duration(seconds: 2)).then((value) {
        return maskService.isConnectedToBluetooth();
      }),
      builder: (context, snapshot) {
        //if we have not checked yet
        if (!snapshot.hasData) {
          return Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Image.asset("assets/icon/smart_mask_icon.png"),
          );
        } else {
          //if we are connected
          if (snapshot.data) {
            return HomePageWrapper();
          } else {
            return BluetoothConnectionPageWrapper();
          }
        }
      },
    );
  }
}
