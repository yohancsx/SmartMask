import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_mask/app/home_page/home_page.dart';
import 'package:smart_mask/app/home_page/home_page_model.dart';
import 'package:smart_mask/services/bluetooth_mask_service.dart';

class HomePageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BluetoothMaskService maskService =
        Provider.of<BluetoothMaskService>(context, listen: false);

    return ChangeNotifierProvider<HomePageModel>(
      create: (context) => HomePageModel(maskService: maskService),
      child: Consumer<HomePageModel>(
        builder: (context, model, child) {
          return HomePage(pageModel: model);
        },
      ),
    );
  }
}
