import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_mask/app/bt_connection_page/bt_connection_page.dart';
import 'package:smart_mask/app/bt_connection_page/bt_connection_page_model.dart';
import 'package:smart_mask/services/bluetooth_mask_service.dart';

class BluetoothConnectionPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BluetoothMaskService maskService =
        Provider.of<BluetoothMaskService>(context, listen: false);

    return ChangeNotifierProvider<BluetoothConnectionPageModel>(
      create: (context) =>
          BluetoothConnectionPageModel(maskService: maskService),
      child: Consumer<BluetoothConnectionPageModel>(
        builder: (context, model, child) {
          return BluetoothConnectionPage(pageModel: model);
        },
      ),
    );
  }
}
