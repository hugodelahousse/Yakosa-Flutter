import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VoteCard extends StatefulWidget {
  int positiveVotes;
  int negativeVotes;
  int selected;
  final Function onVote;

  VoteCard(this.positiveVotes, this.negativeVotes,this.onVote, { this.selected = 0 });

  _VoteCardState createState() => _VoteCardState();
}

class _VoteCardState extends State<VoteCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      key: Key(UniqueKey().toString()),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () => {vote(1)},
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: FractionalOffset.topLeft,
                      end: FractionalOffset.bottomRight,
                      colors: [
                        Colors.deepPurpleAccent[100],
                        Colors.deepPurpleAccent[400],
                      ],
                      stops: [
                        0.0,
                        1
                      ]),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      widget.positiveVotes.toString(),
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.thumb_up,
                      color: widget.selected == 1 ? Colors.black : Colors.white,
                      size: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => { vote(-1) },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: FractionalOffset.topLeft,
                      end: FractionalOffset.bottomRight,
                      colors: [
                        Colors.red[400],
                        Colors.pink[400],
                      ],
                      stops: [
                        0.0,
                        0.9
                      ]),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      widget.negativeVotes.toString(),
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.thumb_down,
                      color: widget.selected == -1 ? Colors.black : Colors.white,
                      size: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  vote(count) {
    widget.onVote(count);
    setState(() {
      if (count == -1) {
        if (widget.selected == -1) {
          widget.negativeVotes--;
          widget.selected = 0;
        }
        else if (widget.selected == 0) {
          widget.negativeVotes++;
          widget.selected = -1;
        } else {
          widget.positiveVotes--;
          widget.negativeVotes++;
          widget.selected = -1;
        }
      }
      if (count == 1) {
        if (widget.selected == 1) {
          widget.positiveVotes--;
          widget.selected = 0;
        }
        else if (widget.selected == 0) {
          widget.positiveVotes++;
          widget.selected = 1;
        } else {
          widget.negativeVotes--;
          widget.positiveVotes++;
          widget.selected = 1;
        }
      }
    });
  }
}
