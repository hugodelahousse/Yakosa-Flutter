import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:yakosa/components/shopping_list/bottom_sheet.dart';
import 'package:yakosa/components/shopping_list/product_tile.dart';
import 'package:yakosa/components/shopping_list/search_page.dart';
import 'package:yakosa/models/product.dart';
import 'package:yakosa/utils/graphql.dart';

class ShoppingListPage extends StatefulWidget {
  final String shoppingListId;

  ShoppingListPage({
    @required this.shoppingListId,
  });

  @override
  State<StatefulWidget> createState() {
    return ShoppingListPageState();
  }
}

class ShoppingListPageState extends State<ShoppingListPage> {
  List<ListProduct> products;
  bool loading = false;


  static const fetchShoppingList = r"""
  query ShoppingList($id: ID!){
	  shoppingList(id: $id){
      id
	    products {
	      id
        quantity
        product {
          info {
            image_url
            product_name_fr
          }
        }
			}
    } 	
  }
  """;

  static const addProductsToList = r"""
  mutation addListProduct($list: ID!, $barcode: String, $quantity: Int, $unit: MeasuringUnits!) {
    addListProductWithbarcode(list: $list, barcode: $barcode, quantity: $quantity, unit: $unit) {
      id
    }
  }
  """;

  @override
  void initState() {
    super.initState();
    _fetchProducts(true);
  }

  _fetchProducts(bool withCache) {
    setState(() => loading = true);
    graphQLCLient.value.query(
      QueryOptions(
        fetchPolicy: withCache ? FetchPolicy.cacheFirst : FetchPolicy.networkOnly,
        document: fetchShoppingList,
        variables: { "id": widget.shoppingListId },
      )
    ).then((result) {
      if (result.errors == null && result.data != null) {
        List list = result.data['shoppingList']['products'];
        List<ListProduct> tmpList = [];
        for (var i = 0; i < list.length; i++) {
          tmpList.add(ListProduct.fromJson(list[i]));    
        }
        setState(() => products = tmpList);
      } else {
        print(result.errors.toString());
      }
      setState(() => loading = false);
    });
  }

  _addProduct(String productId, int quantity) {
    if (quantity <= 0) return;
    graphQLCLient.value.mutate(
      MutationOptions(
        document: addProductsToList,
        variables: {'list': widget.shoppingListId, 'barcode': productId, 'quantity': quantity, 'unit': 'UNIT' }
      ),
    ).then((result) {
      if (result.errors == null && result.data != null) {
        _fetchProducts(false);
      } else {
        print(result.errors.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Color(0xFF780B7C),
            expandedHeight: 180.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Shopping List ${widget.shoppingListId}"),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.topLeft,
                    end: FractionalOffset.bottomRight,
                    colors: [
                      Color(0xFF780B7C),
                      Color(0xFF780B7C).withRed(200),
                    ],
                  )
                )
              ),
            ),
            actions: <Widget>[
              IconButton(
                padding: EdgeInsets.only(bottom: 10),
                icon: Icon(CupertinoIcons.add_circled_solid, size: 35),
                onPressed: () async {
                  final Map<String, int> result = await Navigator.push(context, CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (BuildContext context) => SearchPage(),
                  ));
                  result.forEach((p, q) => _addProduct(p, q));
                }
              )
            ],
          ),
          loading ? SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 50),
                child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.purple)))
              )
            ) : ((products.length > 0) ? SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ProductTile(
                    product: products[index],
                    onPressed: () async { 
                      final bool result = await showModalBottomSheet(
                        context: context,
                        builder: (context) =>
                          ShoppingListBottomSheet(products[index]),
                      );
                      if (result != null && result) { _fetchProducts(false); }
                    });
                },
                childCount: products.length,
              ),
            ) : SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 50),
                child: Center(child: Text("No products :(", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.grey)))
                ) 
              )
            )
        ],
      ),
    );
  }
}
