import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hello_world/constants.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';

class AddAppointment extends StatefulWidget {
  static const routeName = addAppointmentRoute;

  @override
  _AddAppointmentState createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  final nameController = TextEditingController();

  List<String> _recurFreq = ['NONE', 'DAILY', 'WEEKLY', 'MONTHLY'];
  String _recurFreqStr;
  List<String> _recurByDay = ['SU', 'MO', 'TU', 'WE', 'TH', 'FR', 'SA'];
  List<bool> _recurByDayValues = [false, false, false, false, false, false, false];
  String _recurByDayStr;
  int _recurInterval;
  DateTime _startTime;
  DateTime _endTime;
  bool _showStartTimePicker = false;
  bool _showEndTimePicker = false;
  

  _AddAppointmentState() {
    _recurFreqStr = _recurFreq[0];
    _recurInterval = 1;
    _startTime = DateTime.now();
    _endTime = DateTime.now().add(Duration(hours: 1));
  }
  
  @override
  Widget build(BuildContext context) {
    final Function addAppointment = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('New Event'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: getWidgets(addAppointment)
      ),
    );
  }

  List<Widget> getWidgets(Function addAppointment) {
    List<Widget> allWidgets = <Widget>[];
    allWidgets.add(buildSubjectTile(nameController, TextInputType.text, 'Event name'));
    allWidgets.add(buildWidgetPadding());
    allWidgets.add(buildStartTimeTile());
    if (_showStartTimePicker) {
      allWidgets.add(buildStartTime());
    }
    allWidgets.add(buildEndTimeTile());
    if (_showEndTimePicker) {
      allWidgets.add(buildEndTime());
    }
    allWidgets.add(buildWidgetPadding(padding: 5));
    allWidgets.add(buildDropDownTile());
    if (_recurFreqStr != 'NONE')  {
      allWidgets.add(buildIntervalTile());
      if (_recurFreqStr == 'WEEKLY') {
        allWidgets.add(buildWidgetPadding(padding: 5));
        allWidgets.add(buildDaysTile());
      }
    }
    allWidgets.add(buildWidgetPadding());
    allWidgets.add(buildCallBackTile(addAppointment));
    return allWidgets;
  }

  ListTile buildSubjectTile(controller, keyType, label) {
    return ListTile(
      title: buildSubject(controller, keyType, label),);
  }

  TextField buildSubject(controller, keyType, label) {
    return TextField(
      controller: controller,
      keyboardType: keyType,
      decoration: InputDecoration(
        icon: Icon(CupertinoIcons.pencil),
        filled: false,
        labelText: label,
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

  Text getChosenTime(DateTime time) {
    return buildText(DateFormat('MMM d, y   K:mm a').format(time), weight: FontWeight.w400, size: 15);
  }


  SizedBox buildStartTime() {
    return SizedBox(
      height: 110,
      child: CupertinoDatePicker(
        initialDateTime: _startTime,
        onDateTimeChanged: (startTime) => 
          setState(() => _startTime = startTime)
      )
    );
  }


  SizedBox buildEndTime() {
    return SizedBox(
      height: 110,
      child: CupertinoDatePicker(
        initialDateTime: _endTime,
        onDateTimeChanged: (endTime) => 
          setState(() => _endTime = endTime)
      )
    );
  }

  ListTile buildDropDownTile() {
    return ListTile(
      //contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 50.0, 0.0),
      leading: buildText('Frequency'),
      trailing: recurDropDown(_recurFreq),
    );
  }

  Row buildRecurDropDown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        recurDropDown(_recurFreq),
      ],
    );
  }

  DropdownButton recurDropDown(List<String> recurList) {
    print('recur drop down ' + DateTime.now().toIso8601String());
    return DropdownButton<String>(
      value: _recurFreqStr,
      //icon: Icon(Icons.arrow_downward),
      iconSize: 0,
      style: TextStyle(color: Colors.blue, fontSize: 15),
      underline: Container(height: 0,),
      onChanged: (String newValue) => setState(() => _recurFreqStr = newValue),
      items: recurList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: buildText(value, weight: FontWeight.w400, size: 16),
        );
      }).toList(),
    );
  }

  ListTile buildIntervalTile() {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 50.0, 0.0),
      leading: buildText('Interval'),
      title: recurIntervalPicker(),
    );
  }

  NumberPicker recurIntervalPicker() {
    return NumberPicker.integer(
      initialValue: _recurInterval,
      minValue: 1,
      maxValue: 999,
      onChanged: (newValue) {
        print('INTERVAL VALUE: $_recurInterval');
        setState(() => _recurInterval = newValue);
      }
    );
  }

  ListTile buildDaysTile() {
    return ListTile(
      title: buildText('Repeating days'),
      subtitle: buildDaysWeek(),
    );
  }

  Center buildDaysWeek() {
    return Center(
      child: ToggleButtons(
        disabledBorderColor: Colors.black38,
        borderRadius: BorderRadius.all(Radius.elliptical(20,15)),
        selectedBorderColor: Colors.blueAccent,
        isSelected: _recurByDayValues,
        children: buildDay(),
        onPressed: (value) {
          setState(() {
            _recurByDayValues[value] = !_recurByDayValues[value];
            print(_recurByDayValues);
          });
        },
      ),
    );
  }

  List<Text> buildDay() {
    List<Text> allDaysTextList = <Text>[];
    for (int i = 0; i < _recurByDay.length; i++) {
      allDaysTextList.add(Text(_recurByDay[i]));
    }
    return allDaysTextList;
  }

  ListTile buildCallBackTile(Function addAppointment) {
    return ListTile(
      title: buildCallBackSubmit(addAppointment),
    );
  }

  CupertinoButton buildCallBackSubmit(Function addAppointment) {
    return CupertinoButton.filled(
      child: Text('Create', style: TextStyle(color: Colors.white)),
      onPressed: () {
        String subj = nameController.text;
        if (subj.isNotEmpty) {
          //String recur = 'FREQ=WEEKLY;INTERVAL=1;BYDAY=FR,;COUNT=10';
          String recurStr =
              'FREQ=' + _recurFreqStr + ';INTERVAL=$_recurInterval;COUNT=15;';
          if (_recurFreqStr == 'NONE') {
            recurStr = null;
          } else {
              if (_recurFreqStr == 'WEEKLY') {
                print('START DAY: _startTime.day');
                recurStr += 'BYDAY=';
                for (int i = 0; i < _recurByDayValues.length; i++) {
                  if (_recurByDayValues[i]) {
                    recurStr += '' + _recurByDay[i];
                  }
                }
              } else if (_recurFreqStr == 'MONTHLY') {
                recurStr += 'BYMONTHDAY=' + _startTime.day.toString();
              }
          }
          print(recurStr);
          addAppointment(subj, _startTime, _endTime, recurStr);
          clearTextFields();
          Navigator.pop(context);
        }
        else {
          _submitWithoutComplete();
        }
      });
  }

  Future<void> _submitWithoutComplete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Enter an event name!'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop()
            ),
          ],
        );
      },
    );
  }


  Padding buildWidgetPadding({double padding = 10}) {
    return Padding(padding: EdgeInsets.all(padding));
  }

  Text buildText(String text, {FontWeight weight = FontWeight.w600, double size = 16}) {
    return Text(
      text,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontWeight: weight,
        fontSize: size,
      ),
    );
  }

  void clearTextFields() {
    nameController.clear();
  }
}
