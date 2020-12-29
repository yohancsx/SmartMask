import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:smart_mask/common/app_style.dart';

class PressurePlotter extends StatefulWidget {
  PressurePlotter({@required this.pressureData, @required this.bufferLength});

  final Stream<dynamic> pressureData;

  final int bufferLength;

  @override
  _PressurePlotterState createState() => _PressurePlotterState();
}

class _PressurePlotterState extends State<PressurePlotter> {
  List<dynamic> dataBuffer = [];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
        stream: widget.pressureData,
        builder: (context, snapshot) {
          if (dataBuffer.length < widget.bufferLength) {
            dataBuffer.add(snapshot);
          } else {
            dataBuffer.removeAt(0);
            dataBuffer.add(snapshot);
          }
          return Sparkline(
            data: null,
            lineGradient: new LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.green[200],
                Colors.green[800],
              ],
            ),
            pointsMode: PointsMode.last,
            pointSize: 8.0,
            pointColor: AppStyle.mainLightColor,
          );
        });
  }
}
