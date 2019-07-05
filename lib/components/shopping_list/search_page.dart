import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yakosa/components/shopping_list/search_page/search_input.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
  }

  _onTextChanged(String terms) {
    print(terms);
  }

  List<String> list = ['Image in rounded box cover - Brand and title - (+) Count (-)', 'test', 'test'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.white.withOpacity(0),
        middle: SearchInput(_onTextChanged),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.purpleAccent,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Product', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Brand'),
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline, color: Color(0xff9c88ff),),
                    onPressed: () => print('Decrease'),
                  ),
                  Text(
                    "6",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, color: Color(0xff9c88ff),),
                    onPressed:() => print('Increase'),
                  )
                ],
              ),
            ],
          );
        },
      )
    );
  }
}