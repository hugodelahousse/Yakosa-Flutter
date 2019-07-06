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
  mutation addListProduct($list: ID!, $product: ID!, $quantity: Int!) {
    addListProduct(list: $list, product: $id, quantity: $quantity) {
      id
    }
  }
  """;

  _fetchProducts() {
    setState(() => loading = true);
    graphQLCLient.value.query(
      QueryOptions(
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
      }
      setState(() => loading = false);
    });
  }

  _addProduct(String productId, int quantity) {
    if (quantity <= 0) return;
    print('adding ' + productId + ' with quantity ' + quantity.toString());
    /*graphQLCLient.value.mutate(
      MutationOptions(
        document: addProductsToList,
        variables: {'list': widget.shoppingListId, 'product': productId, 'quantity': quantity }
      ),
    ).then((result) {
      if (result.errors == null && result.data != null) {
        ListProduct lp = ListProduct.fromJson(result.data['addListProduct']);
        setState(() {
          products.add(lp);
        });
      }
    });*/
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
                  print(result);
                  result.forEach((p, q) => _addProduct(p, q));
                }
              )
            ],
          ),
          Query(
            options: QueryOptions(
              document: fetchShoppingList,
              variables: { "id": widget.shoppingListId },
            ),
            builder: (QueryResult result, { VoidCallback refetch }) {
              if (result.errors != null) {
                return SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Text(result.errors.toString()),
                    ]
                  )
                );
              }
              if (result.loading) {
                return SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.purple))),
                    ]
                  )
                );
              }
              List products = result.data['shoppingList']['products'];
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = ListProduct.fromJson(products[index]);
                    return ProductTile(
                      product: product,
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        builder: (context) =>
                            ShoppingListBottomSheet(product, refetch),
                      ),
                    );
                  },
                  childCount: products.length,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
