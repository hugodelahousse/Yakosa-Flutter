import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:yakosa/components/shopping_list/bottom_sheet.dart';
import 'package:yakosa/components/shopping_list/product_tile.dart';
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
    return Scaffold(
        body: Query(
      options: QueryOptions(
        document: fetchShoppingList,
        variables: {"id": shoppingListId},
      ),
      builder: (QueryResult result, {VoidCallback refetch}) {
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
        );
      },
    ));
  }
}
