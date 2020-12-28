import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:smart_mask/app/home_page/home_page.dart';
import 'package:smart_mask/common/app_style.dart';
import 'package:smart_mask/services/bluetooth_mask_service.dart';

///model for the bluetooth connection page
class BluetoothConnectionPageModel extends ChangeNotifier {
  BluetoothConnectionPageModel({@required this.maskService});

  ///the bluetooth mask service class
  BluetoothMaskService maskService;

  ///the button text
  String buttonText = "Scan";

  ///a list of the scan results
  List<ScanResult> scanResults = [];

  ///when the button for the bluetooth selection page is pressed
  ///changes based on the scanning state
  Future<void> onButtonPressed(BuildContext context) async {
    //scan for devices while showing a loading dialouge
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppStyle.mainLightColor,
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  strokeWidth: 6.0,
                ),
                SizedBox(height: 10.0),
                Text(
                  "Scanning for Devices",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    //scan and then pop the dialouge when complete
    scanResults = await maskService.scanBluetoothDevices();
    await Future.delayed(Duration(seconds: 3));
    print(scanResults.length);
    Navigator.of(context).pop();

    //we have scanned, so change button text to refresh
    buttonText = "Refresh";

    //notify and rebuild
    notifyListeners();
  }

  ///connect to a device
  Future<void> connectToDevice(
      BluetoothDevice device, BuildContext context) async {
    //connect to selected device while showing a loading image
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppStyle.mainLightColor,
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  strokeWidth: 6.0,
                ),
                SizedBox(height: 10.0),
                Text(
                  "Connecting to Mask: ${device.name}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    ///attempt to connect then pop the dialouge
    await Future.delayed(Duration(seconds: 2));
    bool deviceConnected =
        await maskService.connectToDevice(device).then((value) {
      Navigator.of(context).pop();
      return value;
    });

    //if connected navigate to home page
    if (deviceConnected) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => HomePageWrapper()));
    } else {
      //else show dialouge that you failed
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: AppStyle.mainLightColor,
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Connecting to Mask: ${device.name} has failed! Try turning off and on the device and your bluetooth, or restarting the app",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  FlatButton(
                    color: AppStyle.mainDarkColor,
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  ///get the list of device widgets to select from
  List<Widget> getListOfDevices(BuildContext context) {
    List<Widget> deviceList = [];

    scanResults.forEach((result) {
      deviceList.add(
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          color: AppStyle.mainLightColor,
          child: ListTile(
            trailing: FlatButton(
              onPressed: () => connectToDevice(result.device, context),
              child: Text(
                "Connect!",
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
            ),
            title: Text(
              result.advertisementData.localName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
          ),
        ),
      );
      deviceList.add(SizedBox(height: 20.0));
    });

    return deviceList;
  }
}
