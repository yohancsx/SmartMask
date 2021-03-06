import 'package:flutter/material.dart';
import 'package:smart_mask/app/home_page/home_page_model.dart';

///view the pressure numbers and graph
class PressureViewPage extends StatelessWidget {
  PressureViewPage({@required this.pageModel});

  //the home page model
  final HomePageModel pageModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StreamBuilder(
            stream: pageModel.proximityDataStream,
            initialData: [0, 0, 0, 0, 0, 0],
            builder: (context, snapshot) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  "Distance: " + String.fromCharCodes(snapshot.data),
                  style: TextStyle(color: Colors.black, fontSize: 50.0),
                ),
              );
            },
          ),
          SizedBox(height: 50.0),
          StreamBuilder(
            stream: pageModel.pressureDataStream,
            initialData: [0, 0, 0, 0, 0, 0],
            builder: (context, snapshot) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  "Pressure: " + String.fromCharCodes(snapshot.data),
                  style: TextStyle(color: Colors.black, fontSize: 50.0),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
