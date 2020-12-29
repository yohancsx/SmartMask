import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_mask/app/splash_page.dart';
import 'package:smart_mask/services/bluetooth_mask_service.dart';

void main() {
  runApp(SmartMaskApp());
}

class SmartMaskApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //the bluetooth mask service used to get data from the mask
        Provider<BluetoothMaskService>(
          create: (_) => BluetoothMaskService(),
        ),
      ],
      child: MaterialApp(
        title: 'Smart Mask',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashPage(),
      ),
    );
  }
}
