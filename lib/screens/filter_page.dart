import 'package:flutter/cupertino.dart';
import 'package:yakosa/utils/shared_preferences.dart';

import 'package:yakosa/components/settings_page/settings_group.dart';
import 'package:yakosa/components/settings_page/setting_item.dart';

class FilterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FilterPageState();
  }
}

class FilterPageState extends State<FilterPage> {
  String distance = "1000";
  List<String> stores = [];

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LocalPreferences.getString("search_distance", "1000")
        .then((x) => setState(() {
              distance = x;
            }));
    LocalPreferences.getStringList("search_stores", [])
        .then((x) => setState(() {
              stores = x;
            }));
    return CupertinoPageScaffold(
        child: Container(
            color: Color(0xFFEFEFF4),
            child: CustomScrollView(
              slivers: <Widget>[
                CupertinoSliverNavigationBar(
                  largeTitle: Text('Filters'),
                ),
                SliverSafeArea(
                  top: false,
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(<Widget>[
                      SettingsGroup(
                        [
                          SettingItem(
                            'Distance',
                            value: '${distance}m',
                            hasAction: true,
                            action: () => _showDistancePicker(distance),
                          ),
                        ],
                        label: Text('Search'),
                      ),
                    ]),
                  ),
                )
              ],
            )));
  }

  _showDistancePicker(String selected) async {
    List<String> distances = ["250", "500", "750", "1000", "1500", "2000"];
    final FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: distances.indexOf(selected));
    await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            child: CupertinoPicker(
              scrollController: scrollController,
              itemExtent: 32,
              backgroundColor: CupertinoColors.white,
              children: List<Widget>.generate(distances.length, (int index) {
                return Center(
                  child: Text('${distances[index].toString()}m'),
                );
              }),
              onSelectedItemChanged: (int index) {
                LocalPreferences.setString("search_distance", distances[index]);
                setState(() {
                  distance = distances[index];
                });
              },
            ),
          );
        });
  }
}
