import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yakosa/components/shopping_list/search_page/search_input.dart';
import 'package:yakosa/utils/api.dart';

class OpenFoodFactsProduct {
  final String brands;
  final String product_fr;
  final String barcode;
  final String imageUrl;

  OpenFoodFactsProduct(this.brands, this.product_fr, this.barcode, this.imageUrl);
}

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {
  List<OpenFoodFactsProduct> products = [];
  Map<String, int> selected = {};
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        padding: EdgeInsetsDirectional.only(start: 10),
        leading: GestureDetector(child: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min,children: <Widget>[ Text('Close', style: TextStyle(color: CupertinoColors.activeBlue, fontSize: 20))]), onTap: () => Navigator.of(context).pop(selected)),
        backgroundColor: Colors.white.withOpacity(0),
        middle: SearchInput(searchProducts),
      ),
      body: loading ?
        Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.purple))) : 
          ( products.length == 0 ? Center(child: Text('No results', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.grey)))
            : ListView.separated(
        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final quantity = selected.containsKey(products[index].barcode) ? selected[products[index].barcode] : 0;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(child:
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        image: products[index].imageUrl != null ? DecorationImage(image: NetworkImage(products[index].imageUrl), fit: BoxFit.cover) : null,
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),
                  Flexible(child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(products[index].product_fr, style: TextStyle(fontWeight: FontWeight.bold), softWrap: true,),
                        Text(products[index].brands, softWrap: true,)
                      ],
                    )
                  )
                ],
              ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline, color: Color(0xff9c88ff),),
                    onPressed: () => _decreaseProduct(products[index].barcode)
                  ),
                  Text(
                    quantity.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, color: Color(0xff9c88ff),),
                    onPressed:() => _increaseProduct(products[index].barcode)
                  )
                ],
              ),
            ],
          );
        },
      ))
    );
  }

  _increaseProduct(String barcode) {
    if (selected.containsKey(barcode) && this.mounted) setState(() => selected[barcode]++);
    else if (this.mounted) setState(() => selected.putIfAbsent(barcode, () => 1));
  }

  _decreaseProduct(String barcode) {
    if (selected.containsKey(barcode) && this.mounted) setState(() => selected[barcode] = max(0, selected[barcode] - 1));
  }

  searchProducts(String terms) async {
    terms = Uri.encodeFull(terms.trim());
    if (terms.length < 3) {
      if (this.mounted) {
        setState(() {
          products = [];
        });
      }
      return;
    }
    if (this.mounted) setState(() => loading = true);

    var result = await Api.searchProduct(terms);
    if (result.statusCode == 200) {
      var jsonResponse = await json.decode(result.body);
      List<OpenFoodFactsProduct> tmpList = [];
      for (var i = 0; i < jsonResponse['products'].length; i++) {
        final productName = jsonResponse['products'][i]['product_name_fr'] ?? jsonResponse['products'][i]['product_name'];
        var product = OpenFoodFactsProduct(
          jsonResponse['products'][i]['brands'] ?? '',
          productName ?? '',
          jsonResponse['products'][i]['code'] ?? '',
          jsonResponse['products'][i]['image_url']);
        tmpList.add(product);
      }
      if (this.mounted) {
        setState(() {
          products = tmpList;
        });
      }
    }
    if (this.mounted) setState(() => loading = false);
  }
}