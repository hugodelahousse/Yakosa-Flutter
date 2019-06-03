import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:yakosa/components/shopping_list/product_tile.dart';
import 'package:yakosa/models/product.dart';


class ShoppingListPage extends StatelessWidget {
  static const query = r"""
  query ShoppingList($id: ID!){
	  shoppingList(id: $id){
	    products {
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

    return Scaffold(
      body: Query(
        options: QueryOptions(
            document: query,
            variables: { "id": 2 },
        ),
        builder: (QueryResult result, { VoidCallback refetch }) {
          if (result.errors != null) {
            return Text(result.errors.toString());
          }
          if (result.loading) {
            return Center(child: CircularProgressIndicator());
          }

          List products = result.data['shoppingList']['products'];

          return ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductTile(ListProduct.fromJson(
                  products[index],
                ));
              }
          );
        },
      )
    );
  }
}
