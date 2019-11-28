import 'package:flutter/material.dart';
import 'package:my_food_never_waste/user.dart';
import 'tabScreen1.dart';
import 'tabScreen2.dart';
import 'tabScreen3.dart';
import 'tabScreen4.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({Key key, this.user}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Widget> tabs;
  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      TabScreen(user: widget.user),
      TabScreen2(user: widget.user),
      TabScreen3(user: widget.user),
      TabScreen4(user: widget.user),
    ];
  }

  String $pagetitle = "My Food Never Waste";

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.indigo[900]));

    return Scaffold(
        body: tabs[currentTabIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: tap,
          currentIndex: currentTabIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.blue),
              title: Text("Home"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.green),
              title: Text("Delivery"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message, color: Colors.red),
              title: Text("Order"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.yellow),
              title: Text("Profile"),
            ),
          ],
        ));
  }

  void tap(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }
}
