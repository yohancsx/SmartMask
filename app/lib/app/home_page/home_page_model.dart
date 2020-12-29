import 'package:flutter/material.dart';
import 'package:smart_mask/services/bluetooth_mask_service.dart';

class HomePageModel extends ChangeNotifier {
  HomePageModel({@required this.maskService});

  ///the bluetooth mask service class
  BluetoothMaskService maskService;

  ///the pressure data stream
  Stream<List<int>> dataStream;

  bool pressed = false;

  void onPressed() async {
    pressed = true;
    print("getting the data stream");
    dataStream = await maskService.getBluetoothDataStream();
    notifyListeners();
  }
}
