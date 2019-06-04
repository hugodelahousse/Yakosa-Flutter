import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:yakosa/components/shopping_list/product_tile.dart';
import 'package:yakosa/components/shopping_list/quantity_picker.dart';
import 'package:yakosa/models/product.dart';


class ShoppingListPage extends StatelessWidget {

  final String shoppingListId;

  ShoppingListPage({
    @required this.shoppingListId,
  });

  static const updateQuantityMutation = r"""
  mutation updateQuantity($id: ID!, $quantity: Int!) {
    updateListProduct(id: $id, quantity: $quantity) {
      id
    }
  }
  """;

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
            variables: { "id": shoppingListId },
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
                  final product = ListProduct.fromJson(products[index]);
                  return Mutation(
                      options: MutationOptions(document: updateQuantityMutation),
                      onCompleted: (resultData) {
                        // Close bottom sheet and refetch data
                        Navigator.pop(context);
                        refetch();
                      },
                      builder: (updateQuantity, result) {
                        return ProductTile(
                          product: product,
                          onPressed: () => showModalBottomSheet(
                            context: context,
                            builder: (context) => QuantityPicker(
                              product: product,
                              onUpdateQuantity: (quantity) {
                                if (quantity == product.quantity) {
                                  // No update needed, close the bottom sheet
                                  Navigator.pop(context);
                                  return;
                                }
                                updateQuantity({'id': product.id, 'quantity': quantity});
                              }
                            ),
                          ),
                        );
                  });
                }
            );
          },
        )
    );
  }
}
