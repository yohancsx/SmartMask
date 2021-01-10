import 'package:flutter/material.dart';
import 'package:smart_mask/services/bluetooth_mask_service.dart';

class HomePageModel extends ChangeNotifier {
  HomePageModel({@required this.maskService});

  ///the bluetooth mask service class
  BluetoothMaskService maskService;

  //list of data streams
  List<Stream<dynamic>> dataStreams;

  ///the pressure data stream
  Stream<List<int>> pressureDataStream;

  ///the proximity data stream
  Stream<List<int>> proximityDataStream;

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
    //get the data streams
    dataStreams = await maskService.getBluetoothDataStream();

    //set the streams
    pressureDataStream = dataStreams[0];
    proximityDataStream = dataStreams[1];

    notifyListeners();
  }
}
