import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:yakosa/models/shopping_list.dart';
import 'package:yakosa/screens/shopping_list.dart';

class ShoppingListsPage extends StatelessWidget {
  static const shoppingListQuery = r"""
  query ShoppingListsQuery {
    user: currentUser {
      lists: shoppingLists {
        id
      }
    } 
  }
  """;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(body: Query(
      options: QueryOptions(document: shoppingListQuery),
      builder: (result, { refetch }) {
        if (result.errors != null) {
          return Text(result.errors.toString());
        }
        if (result.loading) {
          return Center(child: CircularProgressIndicator());
        }
        List lists = result.data['user']['lists'];
        return ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: lists.length,
          itemBuilder: (context, index) {
            final list = ShoppingList.fromJson(lists[index]);

            return ListTile(
              title: Text('Shopping List #${list.id}'),
              onTap: () =>  Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShoppingListPage(
                  shoppingListId: list.id,
                )),
              )
            );
          }
        );
      }
    ));
  }
}