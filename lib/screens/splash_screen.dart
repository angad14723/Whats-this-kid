import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whats_this_kid/utlis/constants.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SplashState();
  }
}

class SplashState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    modifyLocalJson();

    callWaitMethod();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/splash.png"), fit: BoxFit.cover),
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Padding(
                padding: EdgeInsets.only(right: 10.0, left: 10.0),
                child: Center(
                  child: Image.asset("images/reveal_icon.png"),
                )),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 20.0, top: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "povered by",
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                    Image.asset(
                      "images/terasol_logo.png",
                      width: 30,
                      height: 30,
                    ),
                    Text(
                      "Terasol Technologies",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    )
                  ],
                ),
              )),
        ],
      ),
    ));
  }

  void callWaitMethod() async {

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  void modifyLocalJson() async {

    final pref2 = await SharedPreferences.getInstance();

    print("prefLogged1 ${pref2.getBool(Constant().LOGGEDIN) ?? false}");

    var loggedIn = pref2.getBool(Constant().LOGGEDIN) ?? false;

    if (!loggedIn) {

      pref2.setBool(Constant().LOGGEDIN, true);

      print("prefLogged2 ${pref2.getBool(Constant().LOGGEDIN) ?? false}");

      String data = await DefaultAssetBundle.of(context)
          .loadString("json/local_json.json");

      print("json from assets$data");

      var decoded = jsonDecode(data);

      print("decoded 1=$decoded");

      var encoded = jsonEncode(decoded);

      print("encoded 1=$encoded");

      /*TODO LOADING DATA FROM SHARED-PREF*/

      pref2.setString(Constant().LOCAL_JSON,
          encoded.toString()); //storing data into shared pref

      var localData = pref2.getString(Constant().LOCAL_JSON) ?? "";

      var decodedLocal = jsonDecode(localData);

      print("decoded data =$decodedLocal");

      /*TODO LOOP ON DECODED DATA*/

      /*var category = decoded["value"]; // as List;
    print("category = $category");

    for(int i=0;i<category.length;i++){
      var mCategory = category[i];

      var mLevel = mCategory["levels"];
      for(int j=0;j<mLevel.length;j++){
        var mObject = mLevel[j];
        print("Testing Json $mObject");
        mObject["sub_levels"] = [];
        mObject["level_lock"] = true;
        mLevel[j] = mObject;
      }
      mCategory["levels"] = mLevel;

      category[i] = mCategory;
    }
    decoded["value"] = category;

    print("Testing Json $decoded");*/

      /*TODO Operation on json*/

      var category = decodedLocal["value"]; // as List;

      print("category = $category");

      for (int i = 0; i < category.length; i++) {
        var mCategory = category[i];

        var mLevel = mCategory["levels"];

        for (int j = 0; j < mLevel.length; j++) {
          var mLevelObject = mLevel[j];

          print("Testing Json $mLevelObject");

          //mObject["sub_levels"] = [];

          mLevelObject["level_lock"] = true;

          var mSubLevel = mLevelObject["sub_levels"];

          for (int k = 0; k < mSubLevel.length; k++) {

            var mSubLvObject = mSubLevel[k];

            k == 0
                ? mSubLvObject["sublevel_lock"] = true
                : mSubLvObject["sublevel_lock"] = false;

            mSubLvObject["visibility_lock"] = false;

            mSubLvObject["progress_percentage"] = 0;

            // mSubLvObject["stages"]=[];

            var mStages = mSubLvObject["stages"];

            for (int l = 0; l < mStages.length; l++) {
              var mStagesObject = mStages[l];

              mStagesObject["completed"] = false;
              mStagesObject["wrong_attempts"] = 0;
              mStagesObject["durations"] = 0;
              mStagesObject["score"] = 0;

              mStages[l] = mStagesObject;
            }

            mSubLevel[k] = mSubLvObject;
          }

          mLevel[j] = mLevelObject;
        }

        mCategory["levels"] = mLevel;

        category[i] = mCategory;
      }
      decoded["value"] = category;

      print("Testing Json $decoded");

      var encoded1 = jsonEncode(decodedLocal);

      print("encoded 1=$encoded1");

      pref2.setString(Constant().LOCAL_JSON,
          encoded1.toString()); //storing data into shared pref

      var localData2 = pref2.getString(Constant().LOCAL_JSON) ?? "";

      print("local data =$localData2");

      /*TODO ADDING DATA IN  MODELCLASS*/

      /* DataModel dataModel = new DataModel.fromJson(decodedLocal);
    print("data 2=${dataModel.jsonModel[0].category}");*/

    }
  }
}
