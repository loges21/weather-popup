import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:minipoj/page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectitem = 0;
  var _page = [Page1(), Page2()];
  var _pagecontroller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Weather Alarm"),
        actions: [IconButton(icon: Icon(Icons.more_vert), onPressed: () {})],
      ),
      body: PageView(
        children: _page,
        onPageChanged: (index) {
          setState(() {
            _selectitem = index;
          });
        },
        controller: _pagecontroller,
      ),
      drawer: Drawer(
          child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("AppName"),
            accountEmail: Text(" "),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
            ),
          ),
          ListTile(
            title: Text("Help"),
            leading: Icon(Icons.help),
          ),
          Divider(
            height: 0.1,
          ),
          ListTile(
            title: Text("About"),
            leading: Icon(Icons.settings),
          ),
          Divider(
            height: 0.1,
          ),
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.cloud), title: Text('weather')),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), title: Text('Alarm'))
        ],
        currentIndex: _selectitem,
        onTap: (int index) {
          setState(() {
            _selectitem = index;
            _pagecontroller.animateToPage(_selectitem,
                duration: Duration(microseconds: 200), curve: Curves.linear);
          });
        },
      ),
    );
  }
}
