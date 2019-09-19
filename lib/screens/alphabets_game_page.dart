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

  Future<List<LevelPoDo>> _fetchSharedPrefData() async {
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

          print("levelPoDo ${levelPoDo.listStages[k].stage_name}");

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

    // _fetchSharedPrefData();

    getSatges();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.lightBlue[100]),
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: 40.0,
          ),
          child: PageView(
            controller: PageController(
              initialPage: 0,
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
                      stagesList[0].gameImage, this)),
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
                    : GameItem(
                    stagesList[1].gameTitle, stagesList[1].gameImage, this),
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
                    : GameItem(
                    stagesList[2].gameTitle, stagesList[2].gameImage, this),
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
                    : GameItem(
                    stagesList[3].gameTitle, stagesList[3].gameImage, this),
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
                    : GameItem(
                    stagesList[4].gameTitle, stagesList[4].gameImage, this),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LastStages {
  String gameTitle;
  String gameImage;
  bool mComplete;

  LastStages(this.gameTitle, this.gameImage, this.mComplete);
}
