import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dynamic_widget/dynamic_widget/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whats_this_kid/screens/alphabets_game_page.dart';

import '../utlis/constants.dart';
import 'alphabets_list.dart';

/*class GameItem extends StatefulWidget {
  String gameTitle;
  String gameImage;
  String gameLevelName;
  AlphabetGamePageState _AlphabetState;

  GameItem(
      this.gameTitle, this.gameImage, this._AlphabetState, this.gameLevelName);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GameItemState();
  }
}

class GameItemState extends State<GameItem> {
  Timer _timer;
  int _start = 0;

  int seconds = 0, minutes = 0, totalTime = 0;

  var timeOnScreen = "";

  LastStages lastStages;
  int successCount = 0, totalPoints = 0, wrongAttempts = 0;

  int gridCount = 0, removeCount = 0, wrongEntryCount = 0;

  int prefProgressPerc = 0;

  int scorePref = 0;
  bool btnCount = false;
  List<LastStages> stagesList = [];
  List<String> wordList;
  List<String> entryList;
  List<String> removeList;
  List<String> wordList2;
  String updateText = "";
  List<bool> listBool, listBoolEntry;
  List<Color> colorList;
  List<int> indexCountList;
  var completeLast = false;
  var mStagesObject;
  List<String> addCharList = [];

  refreshData(String gameTitle, String gameImage) {
    print("gameTitle${gameTitle + gameImage}");

    gridCount = 0;
    addCharList = [];
    wordList = [];
    wordList2 = [];
    listBool = [];
    entryList = [];
    listBoolEntry = [];
    removeList = [];
    indexCountList = [];
    wrongAttempts = 0;

    wordList = gameTitle.toUpperCase().replaceAll(" ", "").split("");
    wordList.shuffle();
    wordList2 = gameTitle.toUpperCase().replaceAll(" ", "").split("");

    for (int i = 0; i < wordList.length; i++) {
      listBool.add(false);
      listBoolEntry.add(false);

      entryList.add("?");
      removeList.add("?");
    }

    totalPoints = wordList.length * 10;

    startTimer();

    _fetchSharesPref();

//    colorList = List(wordList.length);
//    colorList.fillRange(0, wordList.length, Colors.yellow);

    print("entryList $entryList");

    print("wordList${wordList}");
  }

  void buttonPressed(String data, int index) {
    print("data ${data} + index ${index}");

    removeCount = 0;
    removeCount = index;

    print("remove count ${removeCount}");

    if (listBool[index] == true || listBoolEntry[gridCount] == true) {
      listBool[index] == listBool[index];
      listBoolEntry[gridCount] == listBoolEntry[gridCount];

      print("InIf case ${listBool[index]}");
    } else {
      print("InElse  case ${listBool[index]}");

      listBool[index] = !listBool[index];

      print("InElse case1 ${listBool[index]}");

      listBoolEntry[gridCount] = !listBoolEntry[gridCount];

      indexCountList.add(index);

      print("gridCount ${gridCount}");

      print("entryList $entryList");

      print("indexCountList ${indexCountList}");

      addCharList.add(data);

      entryList[gridCount] = addCharList[gridCount];

      print("entryList1 $entryList");

      print("addCharList ${addCharList}");

      gridCount++;
    }
    if (entryList.length == gridCount) {
      //print(entryList);

      resultIsMatch();
    }
  }

  void resultIsMatch() {
    Function eq = const ListEquality().equals;
    print(eq(wordList2, entryList));

    if (eq(wordList2, entryList)) {
      _timer.cancel();

      if (!completeLast) {
        setState(() {
          prefProgressPerc = (widget._AlphabetState.visibilityCount * 20) + 20;

          updateSharedPrefData();
        });
      }
      Dialog errorDialog = Dialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        //this right here
        child: Container(
          height: 550.0,
          width: 400.0,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
              Row(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(left: 30)),
                  Expanded(
                      child: Text(
                        timeOnScreen.toString(),
                        style: TextStyle(color: Colors.indigo, fontSize: 16.0),
                      )),
                  Expanded(
                      child: Text("Animal",
                          style:
                          TextStyle(color: Colors.indigo, fontSize: 20.0))),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.stars,
                          color: Colors.yellow,
                        ),
                        Text(totalPoints.toString(),
                            style:
                            TextStyle(color: Colors.indigo, fontSize: 20.0))
                      ],
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 15)),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  widget.gameTitle,
                  style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 20.0,
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Container(
                    width: double.infinity,
                    height: 250,
                    child:Image.asset("images/${widget.gameImage}"),)
              ),
              Padding(padding: EdgeInsets.all(30.0)),
              FloatingActionButton(
                  elevation: 5.0,
                  backgroundColor: Colors.blue,
                  onPressed: () {
                    print("testComplete2 $completeLast");

                    if (!completeLast) {
                      widget._AlphabetState.setState(() {
                        widget._AlphabetState.visibilityCount++;
                      });
                    }

                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                  ))
            ],
          ),
        ),
      );
      showDialog(
          context: context, builder: (BuildContext context) => errorDialog);
    } else {
      wrongEntryCount++;

      if (wrongEntryCount >= 2) {
        wrongAttempts++;

        print("wrongAttempts ${wrongAttempts}");

        totalPoints = totalPoints - 10;

        if (!completeLast) {
          // _updateWrongAttemptPref();

        }
      }
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Nope! try again"),
      ));
    }
  }

  void _updateWrongAttemptPref() async {
    final pref2 = await SharedPreferences.getInstance();

    var localData = pref2.getString(Constant().LOCAL_JSON) ?? "";

    var decodedLocal = jsonDecode(localData);

    print("decoded data =$decodedLocal");

    var category = decodedLocal["value"]; // as List;

    for (int i = 0; i < category.length; i++) {
      var mCategory = category[i];

      var mLevel = mCategory["levels"];

      for (int j = 0; j < mLevel.length; j++) {
        var mLevelObject = mLevel[j];

        //mObject["sub_levels"] = [];
        var mSubLevel = mLevelObject["sub_levels"];

        for (int k = 0; k < mSubLevel.length; k++) {
          var mSubLvObject = mSubLevel[k];

          var mStages = mSubLvObject["stages"];

          for (int l = 0; l < mStages.length; l++) {
            var mStagesObject = mStages[l];

            print("titleName ${widget.gameTitle}");

            if (widget.gameTitle == mStagesObject["stage_name"]) {
              mStagesObject["score"] = totalPoints;

              mStagesObject["wrong_attempts"] = wrongAttempts;

              // mStagesObject["durations"] = 60;

              break;
            }

            mStages[l] = mStagesObject;
          }

          mSubLevel[k] = mSubLvObject;
        }

        mLevel[j] = mLevelObject;
      }

      mCategory["levels"] = mLevel;

      category[i] = mCategory;
    }

    var encoded1 = jsonEncode(decodedLocal);

    print("encoded2=$encoded1");

    pref2.setString(Constant().LOCAL_JSON,
        encoded1.toString()); //storing data into shared pref

    var localData2 = pref2.getString(Constant().LOCAL_JSON) ?? "";

    print("local data2 =$localData2");
  }

  void updateSharedPrefData() async {
    final pref2 = await SharedPreferences.getInstance();

    var localData = pref2.getString(Constant().LOCAL_JSON) ?? "";

    var decodedLocal = jsonDecode(localData);

    print("decoded data =$decodedLocal");

    var category = decodedLocal["value"]; // as List;

    for (int i = 0; i < category.length; i++) {
      var mCategory = category[i];

      var mLevel = mCategory["levels"];

      for (int j = 0; j < mLevel.length; j++) {
        var mLevelObject = mLevel[j];

        //mObject["sub_levels"] = [];

        var mSubLevel = mLevelObject["sub_levels"];

        for (int k = 0; k < mSubLevel.length; k++) {
          var mSubLvObject = mSubLevel[k];

          print("outSideIf");

          print("levelName ${widget.gameLevelName}");

          if (widget.gameLevelName == mSubLvObject["sub_levels_name"]) {
            mSubLvObject["progress_percentage"] = prefProgressPerc;

            if (prefProgressPerc == 100) {

              mSubLvObject["visibility_lock"] = true;

              if (k <= 3) {
                mSubLevel[k + 1]["sublevel_lock"] = true;
              }

              print("mSublevel ${mSubLvObject["sublevel_lock"]}${k}");
            }
          }

          var mStages = mSubLvObject["stages"];

          for (int l = 0; l < mStages.length; l++) {
            var mStagesObject = mStages[l];

            print("titleName ${widget.gameTitle}");

            if (widget.gameTitle == mStagesObject["stage_name"]) {
              mStagesObject["completed"] = true;

              mStagesObject["score"] = totalPoints;

              mStagesObject["wrong_attempts"] = wrongAttempts;

              mStagesObject["durations"] = totalTime;

              break;
            }

            mStages[l] = mStagesObject;
          }

          mSubLevel[k] = mSubLvObject;

          print("subLevel ${mSubLevel}");
        }

        mLevel[j] = mLevelObject;
      }

      mCategory["levels"] = mLevel;

      category[i] = mCategory;
    }

    var encoded1 = jsonEncode(decodedLocal);

    print("encoded 1=$encoded1");

    pref2.setString(Constant().LOCAL_JSON,
        encoded1.toString()); //storing data into shared pref

    var localData2 = pref2.getString(Constant().LOCAL_JSON) ?? "";

    print("local data =$localData2");
  }

  void deleteMethod() {
    print("gridCount in Delete ${gridCount}");

    if (gridCount >= 1) {
      print("gridCount in Delete ${gridCount}");

      print("indexCountList ${indexCountList}");

      int indexAt = indexCountList[indexCountList.length - 1];

      print("indexAt ${indexAt}");

      gridCount--;

      removeCount--;

      entryList[gridCount] = removeList[gridCount];

      listBool[indexAt] = !listBool[indexAt];

      listBoolEntry[gridCount] = !listBoolEntry[gridCount];

      addCharList.removeAt(gridCount);

      indexCountList.removeAt(gridCount);
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);

    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (seconds == 59) {
            minutes = minutes + 1;

            seconds = 0;
          } else {
            seconds = seconds + 1;
          }

          timeOnScreen = (minutes.toString() + ":" + seconds.toString());

          totalTime = (minutes * 60) + (seconds * 1000);
        },
      ),
    );

    print("timer ${timeOnScreen}");
  }

  void _fetchSharesPref() async {
    Function eq = const ListEquality().equals;

    final prefs = await SharedPreferences.getInstance();
    var localData = prefs.getString(Constant().LOCAL_JSON) ?? "";

    print("local marvel=$localData");
    var decoded = jsonDecode(localData);
    *//*TODO loop on local json*//*
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

        for (int k = 0; k < mSubLevel.length; k++) {
          var sublevelObject = mSubLevel[k];

          String subLevelName = sublevelObject["sub_levels_name"];
          String subLevelIcon = sublevelObject["sub_level_icon"];
          var mStages = sublevelObject["stages"];

          print("prefSubLevel ${sublevelObject["sublevel_lock"]}");

          print("title1 ${subLevelName}");

          for (int l = 0; l < mStages.length; l++) {
            var varLast = mStages[l];

            print("testTitle ${widget.gameTitle}");

            if (widget.gameTitle == varLast["stage_name"]) {
              completeLast = varLast["completed"];

              print("testComplete $completeLast");

              break;
            }
          }
        }
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    refreshData(widget.gameTitle, widget.gameImage);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Stack(children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            decoration: new BoxDecoration(
              color: Colors.indigo,
              borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            width: double.infinity,
            height: 280,
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.keyboard_backspace,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        Route route = MaterialPageRoute(
                            builder: (context) => Alphabets());
                        Navigator.pushReplacement(context, route);
                      });
                    },
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 30)),
                    Expanded(
                        child: Text(
                          completeLast ? "Completed" : timeOnScreen,
                          style: TextStyle(
                              color: completeLast ? Colors.green : Colors.white,
                              fontSize: 16.0),
                        )),
                    Expanded(
                        child: Text(widget.gameLevelName,
                            style: TextStyle(
                                color: Colors.white, fontSize: 20.0))),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.stars,
                            color: Colors.yellow,
                          ),
                          Text(totalPoints.toString(),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0))
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 15)),
                Container(
                  width: double.infinity,
                  height: 180,
                  padding: EdgeInsets.only(left: 5.0, right: 5.0),
                  child: Card(
                    elevation: 4.0,
                    color: Colors.white,
                    child: Image.asset("images/${widget.gameImage}"),
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment(0.0, 0.08),
          child: Container(
            width: double.infinity,
            height: 70,
            child: Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: GridView.count(
                crossAxisCount: 6,
                childAspectRatio: 1,
                padding: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
                mainAxisSpacing: 0,
                crossAxisSpacing: 20.0,
                children: List.generate(entryList.length, (indexEntry) {
                  return Column(
                    children: <Widget>[
                      Text(
                        entryList[indexEntry],
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Container(
                        width: 25,
                        height: 2,
                        color: listBoolEntry[indexEntry]
                            ? Colors.cyanAccent
                            : Colors.grey,
                      )
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment(0.0, 0.7),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              width: double.infinity,
              height: 170,
              decoration: new BoxDecoration(
                color: Colors.indigo[100],
                borderRadius: new BorderRadius.circular(10.0),
              ),
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.2,
                padding: EdgeInsets.all(10.0),
                mainAxisSpacing: 04.0,
                crossAxisSpacing: 10.0,
                children: List.generate(wordList.length, (index) {
                  return Card(
                    color: listBool[index] ? Colors.indigo : Colors.white,
                    child: InkWell(
                      child: Center(
                        child: Text(
                          wordList[index],
                          style: TextStyle(
                              color: listBool[index]
                                  ? Colors.white
                                  : Colors.indigo,
                              fontSize: 16.0),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          print(wordList[index]);

                          buttonPressed(wordList[index], index);
                        });
                      },
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment(-0.9, 0.95),
          child: Container(
            width: 50.0,
            height: 50.0,
            child: Card(
              elevation: 4.0,
              color: Colors.indigo[300],
              child: IconButton(
                icon: Icon(
                  Icons.pause,
                  color: Colors.white,
                ),
                onPressed: () {
                  showAlertDialogPause();
                },
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment(0.9, 0.95),
          child: Container(
            width: 50.0,
            height: 50.0,
            child: Card(
              elevation: 4.0,
              color: Colors.indigo[300],
              child: IconButton(
                icon: Icon(
                  Icons.backspace,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    deleteMethod();

                    //Navigator.pop(context);
                  });
                },
              ),
            ),
          ),
        ),
      ]),
    );
  }

  void showAlertDialogPause() {

    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        height: 550.0,
        width: 400.0,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: Icon(
                            Icons.keyboard_backspace,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {});
                          },
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 30)),
                          Expanded(
                              child: Text(
                                "00.26",
                                style:
                                TextStyle(color: Colors.indigo, fontSize: 16.0),
                              )),
                          Expanded(
                              child: Text("Animal",
                                  style: TextStyle(
                                      color: Colors.indigo, fontSize: 20.0))),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.stars,
                                  color: Colors.yellow,
                                ),
                                Text("250",
                                    style: TextStyle(
                                        color: Colors.indigo, fontSize: 20.0))
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 15)),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                widget.gameTitle,
                style: TextStyle(
                  color: Colors.indigo,
                  fontSize: 20.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Image.asset("images/${widget.gameImage}"),
            ),
            Padding(padding: EdgeInsets.only(top: 30.0)),
            FloatingActionButton(
                elevation: 5.0,
                backgroundColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                ))
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }
}*/
