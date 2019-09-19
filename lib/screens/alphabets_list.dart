import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whats_this_kid/screens/alphabets_game_page.dart';
import 'package:whats_this_kid/utlis/constants.dart';

class Alphbets extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AlphbetsState();
  }
}

class AlphbetsState extends State<Alphbets> {
  /*TODO Fetching Shared Pref Data*/

  Future<List<LevelPoDo>> fetchSharedPrefData() async {
    final prefs = await SharedPreferences.getInstance();

    var localData = prefs.getString(Constant().LOCAL_JSON) ?? "";

    print("local marvel=$localData");
    var decoded = jsonDecode(localData);
    /*TODO loop on local json*/
    var category = decoded["value"];
    print("category marvel=$category");

    for (int i = 0; i < category.length; i++) {
      var mLevels0 = category[0];

      var mLevels = mLevels0["levels"];
      print("levels marvel $mLevels");
      // sublevelList.clear();
      for (int j = 0; j < mLevels.length; j++) {
        var levelObjects = mLevels[j];
        String mPhaseName = levelObjects["level_name"];
        String mPhaseLogo = levelObjects["level_icon"];
        print("phasename marvel $mPhaseName");
        var mSubLevel = levelObjects["sub_levels"];

        List<LevelPoDo> usersList = [];

        for (int k = 0; k < mSubLevel.length; k++) {
          var sublevelObject = mSubLevel[k];

          String subLevelName = sublevelObject["sub_levels_name"];
          String subLevelIcon = sublevelObject["sub_level_icon"];
          var mStages = sublevelObject["stages"];

          print("title1 ${subLevelName}");

          LevelPoDo levelPoDo = LevelPoDo.fromJson(sublevelObject);

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

    fetchSharedPrefData();

    //_getLevels();
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
                                  color: Colors.white,
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            snapshot.data[index].mLevelImage),
                                      ),
                                      title: Text(snapshot.data[index].mLevelName,style: TextStyle(fontSize: 18),),
                                      subtitle: Container(
                                        width: double.infinity,
                                        height: 4,
                                        color: Colors.amberAccent,
                                      ),
                                      trailing: Icon(
                                        Icons.play_arrow,
                                        color: Colors.blue,
                                        size: 30,
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    AlphabetGamePage(snapshot.data[index])));
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
                          child: CircleAvatar(
                            radius: 30,
                            child: Icon(
                              Icons.home,
                              size: 40,
                              color: Colors.white,
                            ),
                          )),
                    )),
              ],
            )));
  }
}

class LevelPoDo {
  String mLevelName;
  String mLevelImage;

  List<StagesPoDo> listStages;

  LevelPoDo({this.mLevelName, this.mLevelImage, this.listStages});

  factory LevelPoDo.fromJson(Map<String, dynamic> json) {
    var list = json['stages'] as List;

    print("from stageslevel=${list}");

    List<StagesPoDo> stagesList =
    list.map((i) => StagesPoDo.fromJson(i)).toList();

    return LevelPoDo(
        mLevelImage: json["sub_level_icon"],
        mLevelName: json["sub_levels_name"],
        listStages: stagesList);
  }
}

class StagesPoDo {
  String stage_name;
  String stage_image_name;
  String stage_hidden_image;
  bool mComplete;

  StagesPoDo(
      {this.stage_name,
        this.stage_image_name,
        this.stage_hidden_image,
        this.mComplete});

  factory StagesPoDo.fromJson(Map<String, dynamic> json) {
    return StagesPoDo(
        mComplete: json["completed"],
        stage_name: json["stage_name"],
        stage_image_name: json["stage_image_name"],
        stage_hidden_image: json["stage_name"]);
  }
}
