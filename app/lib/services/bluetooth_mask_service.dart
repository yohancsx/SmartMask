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

  //are we connected to bluetooth?
  bool bluetoothConnected;

  ///determine if we are connected to bluetooth, as a one off function
  Future<bool> isConnectedToBluetooth() async {
    List<BluetoothDevice> connectedDevice = await flutterBlue.connectedDevices;
    if (connectedDevice.isEmpty) {
      return false;
    } else {
      //if we are connected but don't have a current smart mask device
      if (smartMaskDevice == null) {
        smartMaskDevice = connectedDevice[0];
      }
      return true;
    }
  }

  ///determine if bluetooth is avaiable and enabled, if so set the flags
  Future<bool> determineBluetoothDeviceStatus() async {
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
    flutterBlue.scanResults.listen((results) {
      //add results to list, but only if they are not duplicates
      //and if they have a name
      for (ScanResult r in results) {
        //print a bunch of data for debugging purposes
        print(r.device.id);
        print(r.device.name);
        print(r.device.type);
        //check if list does not have the device already
        bool alreadyContained = false;
        scanResults.forEach((result) {
          if (result.device.name == r.device.name) {
            alreadyContained = true;
          }
        });

        //if the device has a name and is not already contained
        if (r.device.name != null && r.device.name != "" && !alreadyContained) {
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
    //check if we are already conected
    if (await isConnectedToBluetooth()) {
      return true;
    }

    print("connecting to ${d.name}");
    try {
      await d.connect(timeout: Duration(seconds: 5), autoConnect: false);
    } catch (exception) {
      print("failed to connect");
      return false;
    }

    //if connected return true, else return false
    if (await isConnectedToBluetooth()) {
      print("connected to ${d.name}");
      smartMaskDevice = d;
      return true;
    } else {
      return false;
    }
  }

  ///disconnect from the device
  Future<bool> disconnectFromDevice(BluetoothDevice d) async {
    print("disconnecting from ${d.name}");
    await d.disconnect();
    if (await isConnectedToBluetooth()) {
      return false;
    } else {
      smartMaskDevice = null;
      return true;
    }
  }

  ///check if the device is a smart mask
  bool checkIfSmartMaskDevice(BluetoothDevice d) {
    return true;
  }

  ///from the currently connected device
  ///gets the correct stream of sensor data
  Future<List<Stream<dynamic>>> getBluetoothDataStream() async {
    ///data streams to return
    Stream<dynamic> pressureDataStream;

    Stream<dynamic> proximityDataStream;

    ///the characteristic for pressure data
    BluetoothCharacteristic pressureData;

    ///the characteristic for proximity data
    BluetoothCharacteristic proximityData;

    if (await isConnectedToBluetooth()) {
      print("yeee");

      //discover services of the device
      List<BluetoothService> services =
          await smartMaskDevice.discoverServices();

      //find the correct service to listen to based on the string
      services.forEach((service) {
        ///get the corect service
        if (service.uuid.toString() == "590d65c7-3a0a-4023-a05a-6aaf2f22441c") {
          service.characteristics.forEach((characteristic) {
            //get the correct characteristic from the service
            print("******************************************************");
            print(characteristic.uuid.toString());
            if (characteristic.uuid.toString() ==
                "0000000b-0000-1000-8000-00805f9b34fb") {
              pressureData = characteristic;
            }

            if (characteristic.uuid.toString() ==
                "0000000c-0000-1000-8000-00805f9b34fb") {
              proximityData = characteristic;
            }
          });
        }
      });

      //if we found the correct characteristics, listen to them
      if (pressureData != null) {
        //await pressureData.setNotifyValue(true);
        pressureDataStream = pressureData.value;
      }

      if (proximityData != null) {
        //await proximityData.setNotifyValue(true);
        proximityDataStream = proximityData.value;
      }

      //return the stream to listen to, make sure it is broadcast so it can have multiple
      //listeners
      return [
        pressureDataStream.asBroadcastStream(),
        proximityDataStream.asBroadcastStream()
      ];
    } else {
      print("not connected to a device");
      return null;
    }
  }
}
