import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/constants.dart';
import 'CalendarEventView.dart';
import 'Router.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const routeName = homeRoute;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //theme: ThemeData.dark(),
      home: CalendarEventView(),
      routes: Router.getRoutes(),
    );
  }
}

