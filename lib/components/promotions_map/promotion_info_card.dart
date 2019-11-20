import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PromotionInfoCard extends StatefulWidget {
  final String store;
  final double newPrice;
  final double oldPrice;
  final String brand;

  PromotionInfoCard(this.store, this.newPrice, this.oldPrice, this.brand);

  _PromotionInfoCardState createState() => _PromotionInfoCardState();
}

class _PromotionInfoCardState extends State<PromotionInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text("Store",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text("New Price",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text("Brand",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(widget.store != null ? widget.store : "", style: TextStyle(fontSize: 20)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: RichText(
                      text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            if (widget.newPrice != null) TextSpan(
                                text:
                                    '${(widget.newPrice).toStringAsFixed(2)}€',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 20)),
                            if (widget.oldPrice != null) TextSpan(
                                text: ' (',
                                style: TextStyle(
                                    color: Colors.redAccent, fontSize: 20)),
                            if (widget.oldPrice != null) TextSpan(
                                text: '${widget.oldPrice}€',
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.redAccent,
                                    fontSize: 20)),
                            if (widget.oldPrice != null) TextSpan(
                                text: ')',
                                style: TextStyle(
                                    color: Colors.redAccent, fontSize: 20)),
                          ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(widget.brand != null ? widget.brand : "", style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
