

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:intl/intl.dart';

class AddSemster extends StatefulWidget {
  static const routeName = addSemesterRoute;

  @override
  _AddSemesterState createState() => _AddSemesterState();
}


class _AddSemesterState extends State<AddSemster> {
  final semesterController = TextEditingController();
  DateTime _startTime;
  DateTime _endTime;
  bool _showStartTimePicker = false;
  bool _showEndTimePicker = false;

  _AddSemesterState() {
    _startTime = DateTime.now();
    _endTime = DateTime.now().add(Duration(days: 90));
  }


  @override
  Widget build(BuildContext context) {
    final Function addSemester = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('New Semester'),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(CupertinoIcons.back),
              onPressed: () => Navigator.pop(context)
            );
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: getWidgets()
      ),
    );
  }

  List<Widget> getWidgets() {
    List<Widget> allWidgets = <Widget>[];
    allWidgets.add(buildSemesterName());
    allWidgets.add(buildStartTimeTile());
    allWidgets.add(buildStartTime());
    allWidgets.add(buildEndTimeTile());
    allWidgets.add(buildEndTime());
    return allWidgets;
  }

  ListTile buildSemesterName() {
    return ListTile(
      title: TextField(
        controller: semesterController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          icon: Icon(CupertinoIcons.pen)
        ),
      ),
    );
  }

  ListTile buildStartTimeTile() {
    return ListTile(
      onTap: () => setState(() => _showStartTimePicker = !_showStartTimePicker),
      leading: buildText('Start'),
      trailing: getChosenTime(_startTime),
    );
  }

  ListTile buildEndTimeTile() {
    return ListTile(
      onTap: () => setState(() => _showEndTimePicker = !_showEndTimePicker),
      leading: buildText('End'),
      trailing: getChosenTime(_endTime),
    );
  }

  SizedBox buildStartTime() {
    return SizedBox(
      height: 200,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        initialDateTime: _startTime,
        maximumDate: _endTime,
        onDateTimeChanged: (startTime) => 
          setState(() => _startTime = startTime)
      )
    );
  }

  SizedBox buildEndTime() {
    return SizedBox(
      height: 200,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        initialDateTime: _endTime,
        minimumDate: _startTime,
        onDateTimeChanged: (endTime) => 
          setState(() => _endTime = endTime)
      )
    );
  }

  Text getChosenTime(DateTime time) {
    return buildText(
      DateFormat('MMM d, y').format(time), weight: FontWeight.w400, size: 16, color: Colors.blueAccent);
  }

  Text buildText(String text, 
    {FontWeight weight = FontWeight.w600, double size = 16, Color color = Colors.black}) {
    return Text(
      text,
      textAlign: TextAlign.left,
      style: TextStyle(
        color: color,
        fontWeight: weight,
        fontSize: size,
      ),
    );
  }
  
  
}