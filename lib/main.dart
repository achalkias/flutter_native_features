import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

String _batteryLevel = "Unkown";
static const platform = const MethodChannel(CHANNEL_BATTERY);

Future<void> _getBatteryLvell() async {
  String batteryLevel;

  try {
  final int result = await platform.invokeMethod(CHANNEL_METHOD_BATTERY_GET);
  batteryLevel = '${result}% Battery Level.';

  } on PlatformException catch(e) {
    batteryLevel = "Failed to get battery level: '${e.message}.";
  } catch (e) {
    batteryLevel = "Error: '${e.message}";
  }

  setState(() {
    _batteryLevel = batteryLevel;
  });
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(_batteryLevel,style: TextStyle(fontSize: 26),),
              ),
              RaisedButton(child: Text('Get Battery Level'),
              onPressed: _getBatteryLvell),
              
          ],
        ),
      ),
    );
  }
}
