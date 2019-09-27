import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whats_this_kid/screens/alphabets_game_page.dart';
import 'package:whats_this_kid/utlis/constants.dart';

class Numbers extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NumbersState();
  }
}

class NumbersState extends State<Numbers> {

  /*TODO Fetching Shared Pref Data*/

  bool sublevel_lock = false;

  int progressPercentage = 0;

  List<bool> lockList = [];
  List<int> progressList = [];

  Future<List<LevelPoDoNumber>> fetchSharedPrefData() async {

    final prefs = await SharedPreferences.getInstance();
    var localData = prefs.getString(Constant().LOCAL_JSON) ?? "";

    print("local marvel=$localData");

    var decoded = jsonDecode(localData);
    /*TODO loop on local json*/
    var category = decoded["value"];
    print("category marvel=$category");

    for (int i = 0; i < category.length; i++) {

      var mLevels0 = category[1];

      var mLevels = mLevels0["levels"];

      print("levels marvel $mLevels");
      // sublevelList.clear();
      for (int j = 0; j < mLevels.length; j++) {

        var levelObjects = mLevels[j];
        String mPhaseName = levelObjects["level_name"];
        String mPhaseLogo = levelObjects["level_icon"];
        
        print("phasename marvel $mPhaseName");

        var mSubLevel = levelObjects["sub_levels"];

        List<LevelPoDoNumber> usersList = [];

        for (int k = 0; k < mSubLevel.length; k++) {

          var sublevelObject = mSubLevel[k];

          String subLevelName = sublevelObject["sub_levels_name"];

          String subLevelIcon = sublevelObject["sub_level_icon"];

          bool sublevel_lock = sublevelObject["sublevel_lock"];

          var progressPercentage = sublevelObject["progress_percentage"];

          print("subLevelJson ${sublevelObject}");

          var mStages = sublevelObject["stages"];

          print("title1 ${subLevelName}");

          LevelPoDoNumber levelPoDo = LevelPoDoNumber.fromJson(sublevelObject);

          print("levelPoDo ${levelPoDo.listStages[0].stage_name}");

          usersList.add(levelPoDo);
        }

        print(usersList.length);

        return usersList;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getSharedPref4Update();

    fetchSharedPrefData();

    //_getLevels();

    print("progressPerc ${progressPercentage}");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: <Widget>[
        Expanded(
          child: Container(
            width: double.infinity,
            height: 200,
            color: Colors.blue,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(
                          top: 20, bottom: 20, right: 40, left: 0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    )),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.all(20),
                    )),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.stars,
                            color: Colors.amberAccent,
                          ),
                          Text(
                            "250",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )
                        ],
                      ),
                    ))
                  ],
                ),
                Padding(padding: EdgeInsets.all(20)),
                Center(
                  child: Text(
                    "Alphabet",
                    style: TextStyle(color: Colors.white, fontSize: 50),
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
        ),
        Container(
          width: double.infinity,
          height: 400,
          child: FutureBuilder(
              future: fetchSharedPrefData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                print("snapshot ${snapshot.data.length}");

                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: Text("Loading..."),
                    ),
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          color:
                              lockList[index] ? Colors.blue : Color(0xff5DADE2),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: ListTile(
                              leading: Container(
                                  height: 50.0,
                                  width: 50.0,
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xffE74C3C),
                                    radius: 10,
                                    child: Text((index + 1).toString()),
                                  ),
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: new Border.all(
                                      color: Colors.white,
                                      width: 2.0,
                                    ),
                                  )),
                              title: Text(
                                snapshot.data[index].mLevelName,
                                style: TextStyle(fontSize: 18),
                              ),
                              subtitle: Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        height: 4,
                                        color: Colors.cyan,
                                      ),
                                      flex: (progressList[index]),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 4,
                                        color: Colors.white,
                                      ),
                                      flex: progressList[index] == 0
                                          ? 1
                                          : (100 - progressList[index]),
                                    )
                                  ],
                                ),
                              ),
                              trailing: lockList[index]
                                  ? Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: 50,
                                    )
                                  : Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                              onTap: () {
                                print("dataindex ${snapshot.data[index]}");

                                lockList[index]
                                    ? Navigator.pushReplacement(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                AlphabetGamePage(
                                                    snapshot.data[index])))
                                    : Scaffold.of(context)
                                        .showSnackBar(new SnackBar(
                                        duration: const Duration(seconds: 1),
                                        content: new Text(
                                            "Complete previous one..."),
                                      ));
                                ;
                              }),
                        );
                      });
                }
              }),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          width: double.infinity,
          height: 70,
          color: Colors.blue,
          child: Center(
            child: InkWell(
                onTap: () {
                  Navigator.of(context).pop(true);
                },
                child:SvgPicture.asset("images/home.svg",width: 40.0,height: 40.0,color: Colors.white,),),
          ),
        ),
      ],
    )));
  }

  void getSharedPref4Update() async {
    final prefs = await SharedPreferences.getInstance();
    var localData = prefs.getString(Constant().LOCAL_JSON) ?? "";

    var decoded = jsonDecode(localData);
    /*TODO loop on local json*/
    var category = decoded["value"];

    for (int i = 0; i < category.length; i++) {
      var mLevels0 = category[0];

      var mLevels = mLevels0["levels"];

      for (int j = 0; j < mLevels.length; j++) {
        var levelObjects = mLevels[j];

        String mPhaseName = levelObjects["level_name"];
        String mPhaseLogo = levelObjects["level_icon"];

        var mSubLevel = levelObjects["sub_levels"];

        lockList.clear();
        progressList.clear();

        for (int k = 0; k < mSubLevel.length; k++) {
          var sublevelObject = mSubLevel[k];

          String subLevelName = sublevelObject["sub_levels_name"];
          String subLevelIcon = sublevelObject["sub_level_icon"];

          sublevel_lock = sublevelObject["sublevel_lock"];

          progressPercentage = sublevelObject["progress_percentage"];

          print("progressPerc1 ${progressPercentage}");

          progressList.add(progressPercentage);
          print("progressPerc2 ${progressList}");
          // var nextLock=sublevelObject["nextLock"];

          lockList.add(sublevel_lock);

          print("sublevel_lock ${sublevel_lock}");

          print("lockIn level ${lockList}");

          var mStages = sublevelObject["stages"];

          print("title1 ${subLevelName}");

          for (int l = 0; l < mStages.length; l++) {
            var varLast = mStages[l];
          }
        }
      }
    }
  }
}

class LevelPoDoNumber {
  String mLevelName;
  String mLevelImage;
  bool mLevelLock, visibilityLock;

  List<StagesPoDoNumbers> listStages;

  LevelPoDoNumber(
      {this.mLevelName,
      this.mLevelImage,
      this.listStages,
      this.mLevelLock,
      this.visibilityLock});

  factory LevelPoDoNumber.fromJson(Map<String, dynamic> json) {
    var list = json['stages'] as List;

    print("from stageslevel=${list}");

    List<StagesPoDoNumbers> stagesList =
        list.map((i) => StagesPoDoNumbers.fromJson(i)).toList();

    return LevelPoDoNumber(
        mLevelImage: json["sub_level_icon"],
        mLevelName: json["sub_levels_name"],
        mLevelLock: json["sublevel_lock"],
        visibilityLock: json["visibility_lock"],
        listStages: stagesList);
  }
}

class StagesPoDoNumbers {
  String stage_name;
  String stage_image_name;
  String stage_hidden_image;
  bool mComplete;

  StagesPoDoNumbers(
      {this.stage_name,
      this.stage_image_name,
      this.stage_hidden_image,
      this.mComplete});

  factory StagesPoDoNumbers.fromJson(Map<String, dynamic> json) {
    return StagesPoDoNumbers(
        mComplete: json["completed"],
        stage_name: json["stage_name"],
        stage_image_name: json["stage_image_name"],
        stage_hidden_image: json["stage_name"]);
  }
}
