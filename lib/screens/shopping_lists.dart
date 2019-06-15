import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:yakosa/components/shopping_lists/shopping_lists_item.dart';
import 'package:yakosa/models/shopping_list.dart';
import 'package:yakosa/screens/shopping_list.dart';

class ShoppingListsPage extends StatelessWidget {
  static const shoppingListQuery = r"""
  query ShoppingListsQuery {
    user: currentUser {
      lists: shoppingLists {
        id,
        products {
          id
        }
      }
    } 
  }
  """;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 15.0, top: 20.0, bottom: 10.0),child: Text("Shopping Lists", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35.0, color: Colors.black))),
            Query(
              options: QueryOptions(document: shoppingListQuery),
              builder: (result, { refetch }) {
                if (result.errors != null) {
                  return Text(result.errors.toString());
                }
                if (result.loading) {
                  return Center(child: CircularProgressIndicator());
                }
                List lists = result.data['user']['lists'];
                return Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: lists.length,
                    itemBuilder: (context, index) {
                      final list = ShoppingList.fromJson(lists[index]);
                      return ShoppingListsItem(list.id, Color(0xFF780B7C), "Shopping List ${list.id}", list.products.length);
                    }
                  )
                );
              }
            )
          ],
        )
      );
  }
}