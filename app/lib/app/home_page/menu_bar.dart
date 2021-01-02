import 'package:flutter/material.dart';
import 'package:smart_mask/app/home_page/home_page_model.dart';
import 'package:smart_mask/common/app_style.dart';

///Menu Bar for the home page
class MenuBar extends StatefulWidget {
  MenuBar({@required this.pageModel});

  final HomePageModel pageModel;
  @override
  State<StatefulWidget> createState() {
    return MenuBarState();
  }
}

class MenuBarState extends State<MenuBar> {
  bool clickedCentreFAB =
      false; //boolean used to handle container animation which expands from the FAB
  //to handle which item is currently selected in the bottom app bar
  int selectedIndex = 0;

  //call this method on click of each bottom app bar item to update the screen
  void updateTabSelection(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 20.0,
      child: Container(
        margin: EdgeInsets.only(left: 25.0, right: 25.0),
        height: 60.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              //update the bottom app bar view each time an item is clicked
              onPressed: () {
                updateTabSelection(0);
                widget.pageModel.switchPage(0);
              },
              iconSize: 28.0,
              icon: Icon(
                Icons.show_chart,
                //darken the icon if it is selected or else give it a different color
                color: selectedIndex == 0
                    ? AppStyle.secondaryLightColor
                    : Colors.grey[350],
              ),
            ),

            //friends page button
            IconButton(
              onPressed: () {
                updateTabSelection(1);
                widget.pageModel.switchPage(1);
              },
              iconSize: 28.0,
              icon: Icon(
                Icons.table_chart,
                color: selectedIndex == 1
                    ? AppStyle.secondaryLightColor
                    : Colors.grey[350],
              ),
            ),

            //calendar button
            IconButton(
              onPressed: () {
                updateTabSelection(2);
                widget.pageModel.switchPage(2);
              },
              iconSize: 28.0,
              icon: Icon(
                Icons.calendar_today,
                color: selectedIndex == 2
                    ? AppStyle.secondaryLightColor
                    : Colors.grey[350],
              ),
            ),
          ],
        ),
      ),

      //color of the BottomAppBar
      color: Colors.white,
    );
  }
}
