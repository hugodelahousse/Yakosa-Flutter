import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: GestureDetector(
                          child: Container(
                            height: 100,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Colors.orangeAccent,
                              boxShadow: [BoxShadow(color: Color(0x40000000), blurRadius: 5, spreadRadius: 2)],
                              gradient: LinearGradient(
                                begin: FractionalOffset.topLeft,
                                end: FractionalOffset.bottomRight,
                                colors: [
                                  Color(0xFF780B7C).withOpacity(0.75),
                                  Color(0xFF780B7C),
                                ],
                                stops: [
                                  0.0,
                                  0.5
                                ]),
                              ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Shopping List ${list.id}",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white))
                              ],
                            )
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ShoppingListPage(
                              shoppingListId: list.id,
                            )),
                          ),
                        )
                      );
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