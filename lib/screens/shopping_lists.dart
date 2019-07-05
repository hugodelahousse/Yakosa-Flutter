import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:yakosa/components/shopping_lists/shopping_lists_item.dart';
import 'package:yakosa/models/shopping_list.dart';
import 'package:yakosa/utils/graphql.dart';

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
        products {
          id
        }
      }
    } 
  }
  """;

  static const shoppingListCreateMutation = r"""
  mutation createList {
    createList {
      id,
      products {
        id
      }
    }
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
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text('Shopping Lists'),
            trailing: IconButton(
              padding: EdgeInsets.only(bottom: 10),
              icon: Icon(CupertinoIcons.add_circled, size: 35,),
              onPressed: () => createList(),
            ),
          ),
          SliverSafeArea(
            top: false,
            sliver: loading ?
              SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator())
              )
            : (shoppingLists.length > 0 ?
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ShoppingListsItem(shoppingLists[index].id, Color(0xFF780B7C), "Shopping List ${shoppingLists[index].id}", shoppingLists[index].products.length);
                    },
                    childCount: shoppingLists.length,
                  ),
                )
              :
                SliverToBoxAdapter(
                  child: Center(child: Text("Add a new list", style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold)))
                )
              )
          )
        ],
      )
    );
  }

  fetchLists() {
    setState(() {
      loading = true;
    });
    graphQLCLient.value.query(
      QueryOptions(document: shoppingListQuery),
    ).then((result) {
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

  createList() {
    graphQLCLient.value.query(
      QueryOptions(document: shoppingListCreateMutation),
    ).then((result) {
      if (result.errors == null && result.data != null) {
        ShoppingList sl = ShoppingList.fromJson(result.data['createList']);
        setState(() {
          shoppingLists.add(sl);
        });
      }
    });
  }
}