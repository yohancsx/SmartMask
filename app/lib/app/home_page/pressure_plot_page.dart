import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_mask/app/home_page/home_page_model.dart';
import 'package:smart_mask/common/app_style.dart';

class PressurePlotPage extends StatelessWidget {
  PressurePlotPage({@required this.pageModel});

  //the home page model
  final HomePageModel pageModel;

  //the gradient colors
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<double>(
      initialData: 100.0,
      stream: pageModel.pressureDataStream
          .map((event) => double.parse(String.fromCharCodes(event))),
      builder: (context, snapshot) {
        if (pageModel.pressureData.length <= 150) {
          pageModel.pressureData.add(snapshot.data);
        } else {
          pageModel.pressureData.removeAt(0);
          pageModel.pressureData.add(snapshot.data);
        }

        double index = 0.0;
        List<FlSpot> spots = [];
        pageModel.pressureData.forEach(
          (value) {
            spots.add(FlSpot(index, value));
            index = index + 1;
          },
        );

        return Container(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.04),
              Container(
                width: size.width * 0.9,
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: AppStyle.mainDarkColor,
                ),
                child: LineChart(
                  LineChartData(
                    clipData: FlClipData(
                        top: true, bottom: true, left: false, right: false),
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      drawVerticalLine: true,
                      horizontalInterval: 0.05,
                      verticalInterval: 5.0,
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: SideTitles(
                        showTitles: false,
                      ),
                      leftTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (value) => const TextStyle(
                          color: Color(0xff67727d),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        interval: 0.05,
                        reservedSize: 28,
                        margin: 12,
                      ),
                    ),
                    borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                            color: const Color(0xff37434d), width: 1)),
                    minX: 0,
                    maxX: 160,
                    minY: 100,
                    maxY: 101,
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        colors: gradientColors,
                        barWidth: 5,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: false,
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          colors: gradientColors
                              .map((color) => color.withOpacity(0.3))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
