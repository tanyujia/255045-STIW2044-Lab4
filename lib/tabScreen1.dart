import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'food.dart';
import 'foodDetail.dart';
import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'SlideRightRoute.dart';

double perpage = 1;

class TabScreen extends StatefulWidget {
  final User user;

  TabScreen({Key key, this.user});

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = "Searching current location...";
  List data;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.indigo[800]));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: RefreshIndicator(
              key: refreshKey,
              color: Colors.indigo[900],
              onRefresh: () async {
                await refreshList();
              },
              child: ListView.builder(
                  //Step 6: Count the data
                  itemCount: data == null ? 1 : data.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Stack(children: <Widget>[
                              Image.asset(
                                "assets/images/background.jpg",
                                fit: BoxFit.fitWidth,
                              ),
                              Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: Container(
                                      padding: EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                          color: Colors.black26,
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(0.0, 15.0),
                                              blurRadius: 15.0,
                                            ),
                                            BoxShadow(
                                              color: Colors.black12,
                                              offset: Offset(0.0, -10.0),
                                              blurRadius: 10.0,
                                            ),
                                          ]),
                                      child: Text("My Food Never Waste",
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 300,
                                    height: 140,
                                    child: Card(
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.person,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    widget.user.name
                                                            .toUpperCase() ??
                                                        "Not registered",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.location_on,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(_currentAddress),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              color: Colors.indigo[800],
                              child: Center(
                                child: Text("PickUp Food Available Today",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (index == data.length && perpage > 1) {
                      return Container(
                        width: 250,
                        color: Colors.white,
                        child: MaterialButton(
                          child: Text(
                            "Load More",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {},
                        ),
                      );
                    }
                    index -= 1;
                    return Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Card(
                        elevation: 2,
                        child: InkWell(
                          onTap: () => _onFoodDetail(
                            data[index]['foodid'],
                            data[index]['foodprice'],
                            data[index]['fooddesc'],
                            data[index]['foodowner'],
                            data[index]['foodimage'],
                            data[index]['foodtime'],
                            data[index]['foodtitle'],
                            data[index]['foodlatitude'],
                            data[index]['foodlongitude'],
                            data[index]['foodrating'],
                            widget.user.radius,
                            widget.user.name,
                            widget.user.credit,
                          ),
                          onLongPress: _onFoodDelete,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white),
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                                "http://mobilehost2019.com/MyFoodNeverWaste/image/${data[index]['foodimage']}.jpg")))),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                            data[index]['foodtitle']
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        RatingBar(
                                          itemCount: 5,
                                          itemSize: 12,
                                          initialRating: double.parse(
                                              data[index]['foodrating']
                                                  .toString()),
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (double value) {},
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("RM " + data[index]['foodprice']),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(data[index]['foodtime']),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            )));
  }

  _getCurrentLocation() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print(_currentPosition);
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name},${place.locality}, ${place.postalCode}, ${place.country}";
        init(); //load data from database into list array 'data'
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String> makeRequest() async {
    String urlLoadFood =
        "http://mobilehost2019.com/MyFoodNeverWaste/php/load_food_user.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading Food");
    pr.show();
    http.post(urlLoadFood, body: {
      "email": widget.user.email ?? "notavail",
      "latitude": _currentPosition.latitude.toString(),
      "longitude": _currentPosition.longitude.toString(),
      "radius": widget.user.radius ?? "10",
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["food"];
        perpage = (data.length / 10);
        print("data");
        print(data);
        pr.dismiss();
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }

  Future init() async {
    this.makeRequest();
    //_getCurrentLocation();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }

  void _onFoodDetail(
      String foodid,
      String foodprice,
      String fooddesc,
      String foodowner,
      String foodimage,
      String foodtime,
      String foodtitle,
      String foodlatitude,
      String foodlongitude,
      String foodrating,
      String email,
      String name,
      String credit) {
    Food food = new Food(
        foodid: foodid,
        foodtitle: foodtitle,
        foodowner: foodowner,
        fooddes: fooddesc,
        foodprice: foodprice,
        foodtime: foodtime,
        foodimage: foodimage,
        foodworker: null,
        foodlat: foodlatitude,
        foodlon: foodlongitude,
        foodrating: foodrating);
    //print(data);

    Navigator.push(context,
        SlideRightRoute(page: FoodDetail(food: food, user: widget.user)));
  }

  void _onFoodDelete() {
    print("Delete");
  }
}
