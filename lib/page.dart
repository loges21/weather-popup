// TODO Implement this library.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:minipoj/location.dart';

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  var temp;
  var windspeed;
  var currently;
  var description;
  var humit;
  var apikey = "3675c38766f64d6b613f71fefd019b3d";
  Future getWeather() async {
    Location location = Location();
    http.Response response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/onecall?lat=${location.lat}&lon=${location.long}&exclude=hourly,daily&appid=3675c38766f64d6b613f71fefd019b3d&units=metric"));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      setState(() {
        this.temp = result['current']['temp'];
        this.description = result['current']['weather'][0]['description'];
        this.currently = result['current']['weather'][0]['main'];
        this.humit = result['current']['humidity'];
        this.windspeed = result['current']['wind_speed'];
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    super.initState();
    this.getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Container(
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width,
        color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "Currently in Namakkal",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(temp != null ? temp.toString() + "\u00B0C" : 'loading',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                )),
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                currently != null ? currently.toString() : 'loading',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              ListTile(
                leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                title: Text("Temperature"),
                trailing: Text(
                    temp != null ? temp.toString() + "\u00B0C" : 'loading'),
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.cloud),
                title: Text("weather"),
                trailing: Text(
                    description != null ? description.toString() : 'loading'),
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.sun),
                title: Text("Humidity"),
                trailing:
                    Text(humit != null ? humit.toString() + "%" : 'loading'),
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.wind),
                title: Text("Wind Speed"),
                trailing: Text(windspeed != null
                    ? windspeed.toString() + "m/s"
                    : 'loading'),
              ),
            ],
          ),
        ),
      )
    ]));
  }
}

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  var selected_time;
  var num = 0;
  var chose = "daily";
  var duration = "daily";

  List repeat = ["daily", "mon-sat"];
  var time = TimeOfDay.now();
  @override
  void initstate() {
    super.initState();
    time = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(32),
          color: Colors.black12,
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(22),
                title: Text(
                  "Set time : ${(time.hour == 0) ? "12" : ((time.hour) > 12 ? (time.hour) - 12 : time.hour)}:${(time.minute)} ${(time.period.index == 1) ? "pm" : "am"} ",
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'avenir',
                      fontSize: 26,
                      fontWeight: FontWeight.w500),
                ),
                trailing: Icon(Icons.keyboard_arrow_down),
                onTap: _pickTime,
              ),
              DropdownButton(
                items: repeat.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                value: chose,
                onChanged: (newValue) {
                  setState(() {
                    this.chose = newValue as String;
                  });
                },
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  settime();
                  setduration();
                },
                icon: Icon(Icons.alarm),
                label: Text('Save'),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Alarm time = ${(num == 1) ? "${(selected_time.hour == 0) ? "12" : ((selected_time.hour) > 12 ? (selected_time.hour) - 12 : selected_time.hour)}:${(selected_time.minute)} ${(selected_time.period.index == 1) ? "pm" : "am"} " : "not set"}",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'avenir',
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                "${duration}",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'avenir',
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.black54,
                  onPressed: () {
                    setState(() {
                      duration = "daily";
                      num = 0;
                    });
                  }),
            ],
          ),
        )
      ],
    ));
  }

  void _pickTime() async {
    var t = await showTimePicker(context: context, initialTime: time);
    if (t != null)
      setState(() {
        time = t;
      });
  }

  void settime() {
    setState(() {
      selected_time = time;
      num = 1;
    });
  }

  void setduration() {
    setState(() {
      duration = chose;
    });
  }
}
