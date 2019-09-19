import 'package:flutter/material.dart';
import './screens/splash_screen.dart';


void main(){
  //debugPaintSizeEnabled=true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }


}