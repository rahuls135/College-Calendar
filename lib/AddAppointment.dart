import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hello_world/constants.dart';
import 'package:numberpicker/numberpicker.dart';

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
        title: Text('Add event'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: getWidgets(addAppointment),
      ),
    );
  }

  List<Widget> getWidgets(Function addAppointment) {
    List<Widget> allWidgets = <Widget>[];
    allWidgets.add(buildSubject(nameController, TextInputType.text, 'Event name'));
    allWidgets.add(buildWidgetPadding());
    allWidgets.add(buildTimeText('Start time'));
    allWidgets.add(buildWidgetPadding(padding: 0));
    allWidgets.add(buildStartTime());
    allWidgets.add(buildWidgetPadding(padding: 5));
    allWidgets.add(buildTimeText('End time'));
    allWidgets.add(buildEndTime());
    allWidgets.add(buildWidgetPadding());
    allWidgets.add(buildRecurDropDown());
    if (_recurFreqStr != 'NONE')  {
      allWidgets.add(buildRecurInterval());
      if (_recurFreqStr == 'WEEKLY') {
        allWidgets.add(buildWidgetPadding());
        allWidgets.add(buildDaysWeek());
      }
    }
    allWidgets.add(buildWidgetPadding(padding: 10));
    allWidgets.add(buildCallBackSubmit(addAppointment));
    return allWidgets;
  }

  Widget buildDaysWeek() {
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

  Row buildRecurDropDown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          'Frequency',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        recurDropDown(_recurFreq),
      ],
    );
  }

  Row buildRecurInterval() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          'Interval',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        recurIntervalPicker(),
      ],
    );
  }

  Padding buildWidgetPadding({double padding = 10}) {
    return Padding(padding: EdgeInsets.all(padding));
  }

  Text buildTimeText(String text) {
    return Text(
      text,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 20,
      ),
    );
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

  CupertinoButton buildCallBackSubmit(Function addAppointment) {
    return CupertinoButton.filled(
      child: Text('Create', style: TextStyle(color: Colors.white)),
      onPressed: () {
        String subj = nameController.text;
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
              recurStr += 'BYMONTHDAY=$_startTime.day';
            }
        }
        if (subj.isNotEmpty) {
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
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
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

  DropdownButton recurDropDown(List<String> recurList) {
    print('recur drop down ' + DateTime.now().toIso8601String());
    return DropdownButton<String>(
      value: _recurFreqStr,
      icon: Icon(Icons.arrow_downward),
      iconSize: 20,
      style: TextStyle(color: Colors.blue),
      underline: Container(
        height: 3,
        color: Colors.blueAccent,
      ),
      onChanged: (String newValue) => setState(() => _recurFreqStr = newValue
        
      ),
      items: recurList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
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

  void clearTextFields() {
    nameController.clear();
  }
}
