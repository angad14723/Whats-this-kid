import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:whats_this_kid/screens/alphabets_list.dart';
import 'dart:convert';
import 'package:whats_this_kid/utlis/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  String mName = "";
  String mUrl = "";
  String mEmail = "";
  String mFbId = "";
  var mCategory0 = "";
  var mCategory1 = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSharedPrefData();
    _getUserName();
  }

  _getUserName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print("test ${pref.getString(Constant().U_IMAGE) ?? ""}");
    setState(() {
      mName = pref.getString(Constant().U_NAME) ?? "";
      mUrl = pref.getString(Constant().U_IMAGE) ?? "";
      mEmail = pref.getString(Constant().U_EMAIL) ?? "";
      mFbId = pref.getString(Constant().U_FBID) ?? "";

      _postUserDetail(mName, mUrl, mEmail, mFbId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 40.0, left: 20.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(""),
                    ),
                    title: Text(
                      "Lion King",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    subtitle: Text(
                      "points",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    trailing: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 60, bottom: 60, right: 20, left: 20),
                  child: Image.asset("images/reveal_icon.png"),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Alphbets(),
                          ));
                    },
                    /*TODO Marvel Screen*/
                    child: Container(
                      alignment: Alignment.center,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        mCategory0,
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),
                  ),
                ),

                /*TODO GOT Screen*/
                Padding(
                  padding: EdgeInsets.only(right: 20, left: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                           // builder: (context) => GOT(),
                          ));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        mCategory1,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 30, left: 30),
                            child: Container(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.category),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 30, left: 30),
                            child: Container(
                              alignment: Alignment.center,
                              child: Card(
                                  child: Container(
                                      height: 40,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Scores",
                                      ))),
                            ),
                          ),
                        )
                      ],
                    )),
              ],
            )));
  }

  Future<http.Response> _postUserDetail(
      String name, String url, String email, String fbId) async {
    // print("testApi $name $email $fbId");

    final uri = 'http://test.terasol.in/reveal/reveal_action.php';
    Map body = {
      "request": "R01",
      "name": "$name",
      "email": "$email",
      "facebook_id": "$fbId",
      "profile_url": "$url",
      "country": "india"
    };

    final headers = {
      "Accept": "application/json",
      "content-type": "application/json",
    };
    String jsonBody = json.encode(body);

    final encoding = Encoding.getByName("utf-8");

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;

    print("statusCode $statusCode");
    print("response $responseBody");
  }

  void _loadSharedPrefData() async {

    final pref = await SharedPreferences.getInstance();

    var prefData = pref.getString(Constant().LOCAL_JSON) ?? "";

    print("prefData $prefData");

    var decoded = jsonDecode(prefData);

    print("decoded data= $decoded");

    /*TODO loop on decoded data*/

    var category = decoded["value"]; // as List;
    print("category = $category");

    for (int i = 0; i < category.length; i++) {

      var cat = category[0];
      var cat1 = category[1];

      mCategory0 = cat["category"];
      mCategory1 = cat1["category"];

      print("category name ${mCategory0 + mCategory1}");
    }
  }
}
