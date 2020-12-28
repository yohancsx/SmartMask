import 'package:flutter_blue/flutter_blue.dart';

///class which handles the core bluetooth operations, which are:
///1. check if bluetooth is enabled and maintain connected state
///2. get list of bluetooth enabled devices
///3. determine if bluetooth device is smart mask
///4. retreive the strea of data from the smart mask
///5. disconnect from the mask bluetooth
class BluetoothMaskService {
  ///bluetooth instance
  FlutterBlue flutterBlue = FlutterBlue.instance;

  ///the connected bluetooth device
  BluetoothDevice smartMaskDevice;

  ///determine if we are connected to bluetooth
  Future<bool> isConnectedToBluetooth() async {
    List<BluetoothDevice> connectedDevice = await flutterBlue.connectedDevices;
    if (connectedDevice.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  ///determine if bluetooth is avaiable and enabled, if so set the flags
  Future<bool> determineBluetoothStatus() async {
    bool isAvailable = await flutterBlue.isAvailable;
    bool isOn = await flutterBlue.isOn;
    if (isOn && isAvailable) {
      return true;
    }
    return false;
  }

  ///return a list of scanned bluetooth device results
  Future<List<ScanResult>> scanBluetoothDevices() async {
    //lits of scan results
    List<ScanResult> scanResults = [];

    //start scanning
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    //listen to scan results
    var subscription = flutterBlue.scanResults.listen((results) {
      //add results to list, but only if they are not duplicates
      //and if they have a name
      for (ScanResult r in results) {
        //check if list does not have the device already
        bool alreadyContained = false;
        scanResults.forEach((result) {
          if (result.device.name == r.device.name) {
            alreadyContained = true;
          }
        });

        //if the device has a name and is not already contained
        if (r.device.name != null && !alreadyContained) {
          print('${r.device.name} found! rssi: ${r.rssi}');
          scanResults.add(r);
        }
      }
    });

    //stop scanning
    await flutterBlue.stopScan();

    return scanResults;
  }

  ///connect to the device
  Future<bool> connectToDevice(BluetoothDevice d) async {
    print("connecting to ${d.name}");
    d.connect();
    if (await isConnectedToBluetooth()) {
      return true;
    } else {
      return false;
    }
  }

  ///disconnect from the device
  Future<bool> disconnectFromDevice(BluetoothDevice d) async {
    print("disconnecting from ${d.name}");
    d.disconnect();
    if (await isConnectedToBluetooth()) {
      return false;
    } else {
      return true;
    }
  }

  ///fetches the correct bluetooth service, and returns a stream of byte data
  ///in this case the mask pressure
  Future<Stream<dynamic>> getBluetoothDataStream(BluetoothDevice d) async {
    Stream<dynamic> sensorDataStream;
    //get bluetooth services
    List<BluetoothService> services = await d.discoverServices();
    //find the correct service to listen to
    services.forEach((service) {
      print(service.uuid.toString());
    });

    //return the stream to listen to

    return null;
  }
}
