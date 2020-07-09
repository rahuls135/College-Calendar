import 'package:flutter/material.dart';
import 'package:hello_world/constants.dart';
import 'CalendarEventView.dart';
import 'Router.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  static const routeName = homeRoute;
  // This widget is the root of your application.   
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CalendarEventView(),
      routes: Router.getRoutes(),
    );
  }
}

