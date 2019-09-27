import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utlis/constants.dart';
import 'alphabets_last_page.dart';
import 'alphabets_list.dart';
import 'guess_previous.dart';

class AlphabetGamePage extends StatefulWidget {
  LevelPoDo _levelPoDo;

  AlphabetGamePage(this._levelPoDo);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AlphabetGamePageState();
  }
}

class AlphabetGamePageState extends State<AlphabetGamePage> {
  LastStages lastStages;
  int visibilityCount = 0;
  List<LastStages> stagesList = [];
  List<String> wordList;
  List<String> entryList;
  List<String> wordList2;
  List<bool> listBool, listBool2;
  List<Color> colorList;

  String levelName = "";

  bool levelComplete = false,visibilityLock=false;

  Future<List<LastStages>> getSatges() async {
    for (int i = 0; i < widget._levelPoDo.listStages.length; i++) {
      LastStages lastStages = LastStages(
          widget._levelPoDo.listStages[i].stage_name,
          widget._levelPoDo.listStages[i].stage_image_name,
          widget._levelPoDo.listStages[i].mComplete);

      print("compleee ${widget._levelPoDo.listStages[i].mComplete}");

      if (widget._levelPoDo.listStages[i].mComplete == true) {
        visibilityCount++;
      }

      stagesList.add(lastStages);
    }

    print("stagesList${stagesList[0].gameTitle}");

    print("visibilityCount ${visibilityCount}");

    return stagesList;
  }

  _fetchSharedPrefData() async {
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

        for (int k = 0; k < mSubLevel.length; k++) {
          var sublevelObject = mSubLevel[k];

          String subLevelName = sublevelObject["sub_levels_name"];
          String subLevelIcon = sublevelObject["sub_level_icon"];

          if (widget._levelPoDo.mLevelName ==
              sublevelObject["sub_levels_name"]) {
            levelComplete = sublevelObject["sublevel_lock"];
          }

          var mStages = sublevelObject["stages"];

          print("levelComplete ${levelComplete}");
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      // _fetchSharedPrefData();
    });

    getSatges();

    print("levelCheck ${widget._levelPoDo.mLevelName}");

    levelName = widget._levelPoDo.mLevelName;

    levelComplete = widget._levelPoDo.mLevelLock;

    visibilityLock=widget._levelPoDo.visibilityLock;

    print("levelComplete1 ${levelComplete}");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
        onWillPop: () async {
          Route route = MaterialPageRoute(builder: (context) => Alphabets());
          Navigator.pushReplacement(context, route);

          return false;
        },
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(color: Color(0xffCFE3F4)),
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: 40.0,
              ),
              child: PageView(
                controller: PageController(
                  initialPage: (visibilityLock == true) ? 0 : visibilityCount,
                  viewportFraction: 0.9,
                ),
                children: [
                  Container(
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 05.0,
                      ),
                      child: GameItem(stagesList[0].gameTitle,
                          stagesList[0].gameImage, this, levelName)),
                  Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: 05.0,
                    ),
                    child: !(visibilityCount >= 1)
                        ? GuessPrevious()
                        : GameItem(stagesList[1].gameTitle,
                            stagesList[1].gameImage, this, levelName),
                  ),
                  Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: 05.0,
                    ),
                    child: !(visibilityCount >= 2)
                        ? GuessPrevious()
                        : GameItem(stagesList[2].gameTitle,
                            stagesList[2].gameImage, this, levelName),
                  ),
                  Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: 05.0,
                    ),
                    child: !(visibilityCount >= 3)
                        ? GuessPrevious()
                        : GameItem(stagesList[3].gameTitle,
                            stagesList[3].gameImage, this, levelName),
                  ),
                  Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: 05.0,
                    ),
                    child: !(visibilityCount >= 4)
                        ? GuessPrevious()
                        : GameItem(stagesList[4].gameTitle,
                            stagesList[4].gameImage, this, levelName),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class LastStages {
  String gameTitle;
  String gameImage;
  bool mComplete;

  LastStages(this.gameTitle, this.gameImage, this.mComplete);
}
