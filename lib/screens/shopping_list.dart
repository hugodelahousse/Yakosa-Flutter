import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:yakosa/components/shopping_list/bottom_sheet.dart';
import 'package:yakosa/components/shopping_list/product_tile.dart';
import 'package:yakosa/components/shopping_list/search_page.dart';
import 'package:yakosa/models/product.dart';


class ShoppingListPage extends StatelessWidget {

  final String shoppingListId;

  ShoppingListPage({
    @required this.shoppingListId,
  });


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
              title: Text("Shopping List ${this.shoppingListId}"),
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
                onPressed: () => Navigator.push(context, CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (BuildContext context) => SearchPage(),
                )),
              )
            ],
          ),
          Query(
            options: QueryOptions(
              document: fetchShoppingList,
              variables: { "id": shoppingListId },
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
