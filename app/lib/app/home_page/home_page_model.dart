import 'package:flutter/material.dart';
import 'package:smart_mask/services/bluetooth_mask_service.dart';

class HomePageModel extends ChangeNotifier {
  HomePageModel({@required this.maskService});

  ///the bluetooth mask service class
  BluetoothMaskService maskService;

  ///the pressure data stream
  Stream<List<int>> dataStream;

  //have we begun the session
  bool sessionStarted = false;

  //the pressure data to show
  List<double> pressureData = [];

  ///The page controller for the page view
  PageController controller = PageController(initialPage: 0);

  ///Function to switch between pages of the app
  ///which actually do not use the navigator
  void switchPage(int pageNum) {
    controller.animateToPage(
      pageNum,
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 700),
    );
  }

  ///begins the bluetooth mask session
  void onBeginSession(BuildContext context) async {
    sessionStarted = true;
    //get the data stream
    dataStream = await maskService.getBluetoothDataStream();
    notifyListeners();
  }
}
