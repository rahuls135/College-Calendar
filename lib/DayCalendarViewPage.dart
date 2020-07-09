


// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_week_view/flutter_week_view.dart';
// import 'package:hello_world/DayEventViewPage.dart';
// import 'package:hello_world/constants.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';


// class DayCalendarViewPage extends StatefulWidget {
//   static const routeName = '/calendarView';
//   DayCalendarViewPage();

//   @override
//   _DayCalendarViewState createState() => _DayCalendarViewState();
// }

// class _DayCalendarViewState extends State<DayCalendarViewPage> {

//   final nameController = TextEditingController();
//   final descController = TextEditingController();
//   final startTimeController = TextEditingController();
//   final endTimeController = TextEditingController();

  

//   List<FlutterWeekViewEvent> events = [];


//   @override
//   Widget build(BuildContext context) {
//     DateTime now = DateTime.now();
//     DateTime date = DateTime(now.year, now.month, now.day);

//     events.add(createEvent(date, 'First', 'Desc', 8, 10));
//     events.add(createEvent(date, 'Second', 'Desc', 14, 15));
  
//     return Scaffold (
//       appBar: AppBar(
//         title: Text("Calendar", style: TextStyle(color: Colors.white)),
//         actions: <Widget>[
//           FloatingActionButton(
//             tooltip: 'Add class',
//             foregroundColor: Colors.white,
//             child: Icon(Icons.add),
//             onPressed: () => _showDialog(context, date),
//           )
//         ],
//       ),
//       body: WeekView (
//         dates: [date.subtract(Duration(days: 1)), date, date.add(Duration(days: 1))],
//         events: getEvents(),
//       ),
//     );
//   }

//   FlutterWeekViewEvent createEvent(date, name, desc, start, end) {
//     return FlutterWeekViewEvent(
//       title: name,
//       description: desc,
//       start: date.add(Duration(hours: start)),
//       end: date.add(Duration(hours: end))
//     );
//   }

//   Future<void> _showDialog(context, date) async {

//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Add Event', style: TextStyle(color: Colors.black)),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 createTextField(true, nameController, TextInputType.text, 'Event name'),
//                 createTextField(false, descController, TextInputType.text, 'Event description'),
//                 createTextField(false, startTimeController, TextInputType.number, 'Start time: 24hrs'),
//                 createTextField(false, endTimeController, TextInputType.number, 'End time: 24hrs'),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             RaisedButton(
//               child: Text('Submit', style: TextStyle(color: Colors.black)),
//               onPressed: () {
//                 events.add(createEvent(
//                   date,
//                   nameController.text,
//                   descController.text,
//                   int.parse(startTimeController.text),
//                   int.parse(endTimeController.text)
//                 ));
//                 setState(() {});
//                 Navigator.pop(context);
//               },
//             ),
//             RaisedButton(
//               child: Text('Cancel', style: TextStyle(color: Colors.black)),
//               onPressed: () {
//                 clearTextFields();
//                 Navigator.pop(context);
//               }
//             )
//           ],
//         );
//       }
//     );
//   }

//   TextField createTextField(focus, controller, keyType, hint) {
//     return TextField(
//       autofocus: focus,
//       controller: controller,
//       keyboardType: keyType,
//       decoration: InputDecoration(
//         border: OutlineInputBorder(),
//         hintText: hint,
//       ),
//     );
//   }

//   void clearTextFields() {
//     nameController.clear();
//     descController.clear();
//     startTimeController.clear();
//     endTimeController.clear();
//   }

//   List<FlutterWeekViewEvent> getEvents() {
//     clearTextFields();
//     return events;
//   }
  
//   List<FlutterWeekViewEvent> hardCodedEvents(DateTime date, String eventTitle, String eventDesc) {
//     String title = 'Event One';
//     String desc = 'First event desc';
//     FlutterWeekViewEvent evOne = 
//       FlutterWeekViewEvent (
//         title: 'Event 1',
//         description: desc,
//         start: date.add(Duration(hours: 5)),
//         end: date.add(Duration(hours: 8)),
//         onTap: () => Navigator.pushNamed(
//           context,
//           DayEventViewState.routeName,
//           arguments: DayEventViewPage(title, desc)),
//       );
//       FlutterWeekViewEvent evTwo = 
//         FlutterWeekViewEvent (
//           title: 'Event 2',
//           description: 'Second desc',
//           start: date.add(Duration(hours: 16)),
//           end: date.add(Duration(hours: 18)),
//           onTap: () => Navigator.pushNamed(
//             context,
//             DayEventViewState.routeName,
//             arguments: DayEventViewPage(title, desc)),
//         );
//     events.add(evOne);
//     events.add(evTwo);
//     clearTextFields();
//     return events;
//   }

// }