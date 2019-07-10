import 'package:flutter/widgets.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:yakosa/components/shopping_list/quantity_picker.dart';
import 'package:yakosa/models/product.dart';

class ShoppingListBottomSheet extends StatelessWidget {
  final ListProduct _product;

  static const updateQuantityMutation = r"""
  mutation updateQuantity($id: ID!, $quantity: Int!, $unit: MeasuringUnits!) {
    updateListProduct(id: $id, quantity: $quantity, unit: $unit) {
      id
    }
  }
  """;

  ShoppingListBottomSheet(this._product);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GraphQLConsumer(
        builder: (client) => QuantityPicker(
            product: _product,
            onUpdateQuantity: (quantity) {
              if (quantity == _product.quantity) {
                // No update needed, close the bottom sheet
                Navigator.pop(context, false);
                return;
              }
              client
                  .mutate(MutationOptions(
                document: updateQuantityMutation,
                variables: {
                  'id': _product.id,
                  'quantity': quantity,
                  'unit': 'UNIT'
                },
              ))
                  .then((result) {
                Navigator.pop(context, true);
              });
            }),
      ),
    );
  }
}
