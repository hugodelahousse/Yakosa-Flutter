import 'package:flutter/widgets.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:yakosa/components/shopping_list/quantity_picker.dart';
import 'package:yakosa/models/graphql.dart';

class ShoppingListBottomSheet extends StatelessWidget {
  final ListProduct _product;
  final VoidCallback _refresh;

  static const updateQuantityMutation = r"""
  mutation updateQuantity($id: ID!, $quantity: Int!) {
    updateListProduct(id: $id, quantity: $quantity) {
      id
    }
  }
  """;

  ShoppingListBottomSheet(this._product, this._refresh);

  @override
  Widget build(BuildContext context) {
    return GraphQLConsumer(
        builder: (client) => QuantityPicker(
            product: _product,
            onUpdateQuantity: (quantity) {
              if (quantity == _product.quantity) {
                // No update needed, close the bottom sheet
                Navigator.pop(context);
                return;
              }
              client.mutate(MutationOptions(
                document: updateQuantityMutation,
                variables: {'id': _product.id, 'quantity': quantity},
              )).then((result) {
                Navigator.pop(context);
                _refresh();
              });
            }
        )
    );
  }
}
