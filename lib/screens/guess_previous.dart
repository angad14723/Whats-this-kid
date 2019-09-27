import 'package:flutter/material.dart';

class GuessPrevious extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GuessPreviousState();
  }
}

class GuessPreviousState extends State<GuessPrevious> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: new BoxDecoration(
        color: Color(0xff0B3672),
        borderRadius: new BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset("images/reveal_icon.png"),
              ),
            ),
          ),
          Expanded(
              child: Align(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Guess previous one to unlock it?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 30.0),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
