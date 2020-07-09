import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/AddAppointment.dart';
import 'CalendarEventView.dart';

class Router {
  static Map<String, Widget Function(BuildContext)> getRoutes() {
    return <String, WidgetBuilder> {
        CalendarEventView.routeName: (BuildContext context) => CalendarEventView(),
        AddAppointment.routeName: (BuildContext context) => AddAppointment(),
    };
  }
}