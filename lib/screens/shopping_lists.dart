import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:yakosa/components/shopping_lists/shopping_lists_item.dart';
import 'package:yakosa/models/shopping_list.dart';
import 'package:yakosa/utils/graphql.dart';
import 'package:yakosa/components/common/simple_cupertino_modal.dart';
import 'package:yakosa/components/common/input_text.dart';
import 'package:reorderables/reorderables.dart';

class ShoppingListsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ShoppingListsPageState();
  }
}

class ShoppingListsPageState extends State<ShoppingListsPage> {
  static const shoppingListQuery = r"""
  query ShoppingListsQuery {
    user: currentUser {
      lists: shoppingLists {
        id,
        name,
        products {
          id
        }
      }
    }
  }
  """;

  static const shoppingListCreateMutation = r"""
  mutation createList($name: String!) {
    createList(name: $name) {
      id,
      name,
      products {
        id
      }
    }
  }
  """;

  static const removeShoppingList = r"""
  mutation removeShoppingList($id: ID!) {
    deleteList(id: $id)
  }
  """;

  List<ShoppingList> shoppingLists = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();

    fetchLists();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController =
        PrimaryScrollController.of(context) ?? ScrollController();
    return CupertinoPageScaffold(
        backgroundColor: Colors.white,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              backgroundColor: CupertinoColors.white,
              key: UniqueKey(),
              largeTitle:
                  Text('Shopping Lists', style: TextStyle(color: Colors.black)),
              trailing: IconButton(
                padding: EdgeInsets.only(bottom: 10),
                icon: Icon(
                  CupertinoIcons.add_circled,
                  size: 35,
                ),
                onPressed: () => createList(),
              ),
            ),
            SliverSafeArea(
                top: false,
                sliver: loading
                    ? SliverToBoxAdapter(
                        child: Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.purple)))))
                    : (shoppingLists.length > 0
                        ? ReorderableSliverList(
                            delegate: ReorderableSliverChildBuilderDelegate(
                              (context, index) {
                                return Dismissible(
                                  key: Key(UniqueKey().toString()),
                                  onDismissed: (direction) =>
                                      removeList(shoppingLists[index], index),
                                  confirmDismiss: (direction) async {
                                    final bool res = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            SimpleCupertinoModal(
                                                'Remove list',
                                                Text(
                                                    'Are you sure to remove this list ?'),
                                                'Remove List',
                                                () => Navigator.of(context)
                                                    .pop(true)));
                                    return res;
                                  },
                                  child: ShoppingListsItem(
                                      shoppingLists[index].id,
                                      Color(0xFF780B7C),
                                      shoppingLists[index].name,
                                      shoppingLists[index].products.length,
                                      () => fetchLists()),
                                );
                              },
                              childCount: shoppingLists.length,
                            ),
                            onReorder: (oldi, newi) => setState(() {
                              ShoppingList row = shoppingLists.removeAt(oldi);
                              shoppingLists.insert(newi, row);
                            }),
                          )
                        : SliverToBoxAdapter(
                            child: Center(
                                child: Text("Add a new list",
                                    style: TextStyle(
                                        fontSize: 45,
                                        fontWeight: FontWeight.bold))))))
          ],
        ));
  }

  fetchLists() {
    if (shoppingLists.length == 0)
      setState(() {
        loading = true;
      });
    graphQLCLient.value
        .query(
      QueryOptions(
          document: shoppingListQuery,
          fetchPolicy: FetchPolicy.cacheAndNetwork),
    )
        .then((result) {
      if (result.errors == null && result.data != null) {
        List list = result.data['user']['lists'];
        List<ShoppingList> tmpList = [];
        for (var i = 0; i < list.length; i++) {
          tmpList.add(ShoppingList.fromJson(list[i]));
        }
        setState(() {
          shoppingLists = tmpList;
        });
      }
      setState(() {
        loading = false;
      });
    });
  }

  createList() async {
    String name = "";
    final bool res = await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => SimpleCupertinoModal(
            "Choose a name",
            InputText((input) => name = input),
            "Add",
            () => Navigator.of(context).pop(true)));
    if (!res) return;
    graphQLCLient.value
        .mutate(
      MutationOptions(
        document: shoppingListCreateMutation,
        variables: {'name': name},
      ),
    )
        .then((result) {
      if (result.errors == null && result.data != null) {
        ShoppingList sl = ShoppingList.fromJson(result.data['createList']);
        setState(() {
          shoppingLists.add(sl);
        });
      }
    });
  }

  removeList(ShoppingList sl, int index) {
    setState(() {
      shoppingLists.removeAt(index);
    });
    graphQLCLient.value
        .mutate(
      MutationOptions(
        document: removeShoppingList,
        variables: {'id': sl.id},
      ),
    )
        .then((result) {
      if (result.errors == null && result.data != null) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("List removed"),
          duration: Duration(seconds: 1),
        ));
      }
    });
  }
}
