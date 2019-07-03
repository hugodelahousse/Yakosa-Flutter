import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:yakosa/components/shopping_lists/shopping_lists_item.dart';
import 'package:yakosa/models/shopping_list.dart';

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
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text('Shopping Lists'),
            trailing: IconButton(
              padding: EdgeInsets.only(bottom: 10),
              icon: Icon(CupertinoIcons.add_circled, size: 35,),
              onPressed: () => print('ADD'),
            ),
          ),
          SliverSafeArea(
            top: false,
            sliver: Query(
              options: QueryOptions(document: shoppingListQuery),
              builder: (result, { refetch }) {
                if (result.errors != null) {
                  return SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Center(child: Text(result.errors.toString()))
                      ]
                    ),
                  );
                }
                if (result.loading) {
                  return SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Center(child: CircularProgressIndicator())
                      ]
                    ),
                  );
                }
                List lists = result.data['user']['lists'];
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final list = ShoppingList.fromJson(lists[index]);
                      return ShoppingListsItem(list.id, Color(0xFF780B7C), "Shopping List ${list.id}", list.products.length);
                    },
                    childCount: lists.length,
                  ),
                );
              }
            )
          )
        ],
      )
    );
  }
}