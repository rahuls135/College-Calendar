
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
  final subjectController = TextEditingController();

  List<String> _recurFreq = ['None', 'Daily', 'Weekly', 'Monthly'];
  String _recurFreqStr;
  Map<String, bool> _recurByDay = new Map();
  String _recurByDayStr = 'BYDAY=';
  int _recurInterval;
  DateTime _startTime;
  DateTime _endTime;
  List<Text> allDays = <Text>[];
  bool _canSubmit = false;
  

  _AddAppointmentState() {
    _recurFreqStr = _recurFreq[0];
    _recurInterval = 1;
    _startTime = DateTime.now();
    _endTime = DateTime.now().add(Duration(hours: 1));
    _recurByDay['SU'] = false;
    _recurByDay['MO'] = false;
    _recurByDay['TU'] = false;
    _recurByDay['WE'] = false;
    _recurByDay['TH'] = false;
    _recurByDay['FR'] = false;
    _recurByDay['SA'] = false;
  }

  
  @override
  Widget build(BuildContext context) {
    final Function addAppointment = ModalRoute.of(context).settings.arguments;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.blue,
        actionsForegroundColor: Colors.white,
        leading: GestureDetector(
          child: Icon(CupertinoIcons.left_chevron),
          onTap: () => Navigator.pop(context)
        ),
        middle: Text('New Event', style: TextStyle(color: Colors.white),),
      ),
      child: GestureDetector(
        onHorizontalDragEnd: (_) => Navigator.pop(context),
        child: Scaffold(
          body: ListView(
            padding: EdgeInsets.all(20),
            children: getWidgets(addAppointment),),
        )
      ),
    );
      
      
      // return Scaffold(
      //   appBar: AppBar(
      //     title: Text('New Event'),
      //     centerTitle: true,
      //     leading: Builder(
      //       builder: (BuildContext context) {
      //         return IconButton(
      //           icon: Icon(CupertinoIcons.back),
      //           onPressed: () => Navigator.pop(context)
      //         );
      //       },
      //     ),
      //   ),
      //   body: ListView(
      //     padding: EdgeInsets.all(20),
      //     children: getWidgets(addAppointment)
      //   ),
      // )
  }

  List<Widget> getWidgets(Function addAppointment) {
    List<Widget> allWidgets = <Widget>[];
    allWidgets.add(buildSubjectTile(subjectController, TextInputType.text, 'Event name'));
    if (subjectController.text != '') {
      _canSubmit = true;
    }
    allWidgets.add(buildWidgetPadding());
    allWidgets.add(buildStartTime());
    allWidgets.add(buildEndTime());
    allWidgets.add(buildWidgetPadding(padding: 5));
    allWidgets.add(buildDropDownTile());
    if (_recurFreqStr != 'None')  {
      allWidgets.add(buildIntervalTile());
      if (_recurFreqStr == 'Weekly') {
          _canSubmit = false;
        allWidgets.add(buildWidgetPadding(padding: 5));
        allWidgets.add(buildDaysTile());
        if (subjectController.text != '') {
          for (var entry in _recurByDay.entries) {
            if (entry.value) {
              _canSubmit = true;
              break;
            }
          }
        }
      }
    }
    allWidgets.add(buildWidgetPadding());
    allWidgets.add(buildCallBackSubmit(addAppointment));
    return allWidgets;
  }

  
  // Widget to build the subject
  ListTile buildSubjectTile(controller, keyType, label) {
    return ListTile(
      title: buildSubject(controller, keyType, label),);
  }
  TextField buildSubject(controller, keyType, label) {
    return TextField(
      controller: controller,
      keyboardType: keyType,
      onChanged: (String value) => setState(() {
        if (value == '') {
          _canSubmit = false;
        }
      }),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        icon: Icon(CupertinoIcons.pen),
        labelText: label,
      ),
    );
  }

  // Widget to build the Start time
  ListTile buildStartTime() {
    return ListTile(
      leading: buildText('Start'),
      trailing: getChosenTime(_startTime),
      onTap: () => showCupertinoModalPopup(
          context: context,
          builder: (context) => startDatePicker()
      ),
    );
  }
  Container startDatePicker() {
    return Container(
      height: 300,
      color: Colors.white,
      child: CupertinoDatePicker(
      initialDateTime: _startTime,
      //maximumDate: _endTime,
      onDateTimeChanged: (startTime) => 
        setState(() => _startTime = startTime)
      ),
    );
  }

  ListTile buildEndTime() {
    return ListTile(
      leading: buildText('End'),
      trailing: getChosenTime(_endTime),
      onTap: () => showCupertinoModalPopup(
          context: context,
          builder: (context) => endDatePicker()
      )
    );
  }
  Container endDatePicker() {
    return Container(
      height: 300,
      color: Colors.white,
      child: CupertinoDatePicker(
      initialDateTime: _endTime,
      //maximumDate: _startTime,
      onDateTimeChanged: (endTime) => 
        setState(() => _endTime = endTime)
      ),
    );
  }

  Text getChosenTime(DateTime time) {
    // if hour midnight or noon, hardcode 12 in
    // will show 0 instead of 12 otherwise
    if (time.hour == 0 || time.hour == 12) {
      return buildText(DateFormat('E MMM d, y   12:mm a').format(time), color: Colors.blue);
    }
    return buildText(DateFormat('E MMM d, y   K:mm a').format(time), color: Colors.blue);
  }

  ListTile buildDropDownTile() {
    return ListTile(
      leading: buildText('Frequency'),
      //trailing: recurDropDown(_recurFreq),
      //trailing: recurButton(),
      trailing: buildText(_recurFreqStr, color: Colors.blue),
      onTap: () => showCupertinoModalPopup(
          context: context,
          builder: (context) => dropDownActionSheet()
      ),
    );
  }
  CupertinoActionSheet dropDownActionSheet() {
    return CupertinoActionSheet(
      actions: dropDownFreqList(),
      cancelButton: CupertinoActionSheetAction(
        isDestructiveAction: true,
        isDefaultAction: true,
        child: Text('Cancel'),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
  List<CupertinoActionSheetAction> dropDownFreqList() {
    List<CupertinoActionSheetAction> freqList = <CupertinoActionSheetAction>[];
    for (int i = 0; i < _recurFreq.length; i++) {
      freqList.add(
        CupertinoActionSheetAction(
          child: Text(_recurFreq[i]),
          onPressed: () {
            setState(() => _recurFreqStr = _recurFreq[i]);
            Navigator.pop(context);
          },
        )
      );
    }
    return freqList;
  }

  ListTile buildIntervalTile() {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 50.0, 0.0),
      leading: buildText('Interval'),
      trailing: recurIntervalPicker(),
    );
  }
  NumberPicker recurIntervalPicker() {
    return NumberPicker.horizontal(
      initialValue: _recurInterval,
      minValue: 1,
      maxValue: 99,
      onChanged: (newValue) {
        print('INTERVAL VALUE: $_recurInterval');
        setState(() => _recurInterval = newValue);
      }
    );
  }

  ListTile buildDaysTile() {
    return ListTile(
      title: buildText('Repeats'),
      subtitle: buildDaysWeek(),
    );
  }
  Center buildDaysWeek() {
    //List<bool> list = _recurByDay.values;
    return Center(
      child: ToggleButtons(
        borderRadius: BorderRadius.all(Radius.elliptical(20,15)),
        selectedBorderColor: Colors.blueAccent,
        isSelected: _recurByDay.values.toList(),
        children: buildDay(),
        onPressed: (val) {
          setState(() {
            print(allDays[val].data);
            _recurByDay[allDays[val].data] = !_recurByDay[allDays[val].data];
          });
        },
      ),
    );
  }
  List<Text> buildDay() {
    allDays = <Text>[];
    for (String day in _recurByDay.keys) {
      allDays.add(Text(day));
    }
    return allDays;
  }

  CupertinoButton buildCallBackSubmit(Function addAppointment) {
    if (_canSubmit) {
      return CupertinoButton.filled(
        child: Text('Add'),
        onPressed: () => createRecurAndSubmit(addAppointment),
      );
    }
    return CupertinoButton.filled(
      child: Text('Add'),
      disabledColor: Colors.grey,
      onPressed: null
    );
  }
  void createRecurAndSubmit(Function addAppointment) {
    _recurFreqStr = _recurFreqStr.toUpperCase();
    //String recur = 'FREQ=WEEKLY;INTERVAL=1;BYDAY=FR,;COUNT=10';
    String recurStr =
        'FREQ=$_recurFreqStr;INTERVAL=$_recurInterval;COUNT=15;';
    if (_recurFreqStr == 'NONE') {
      recurStr = null;
    } else {
        if (_recurFreqStr == 'WEEKLY') {
          print('START DAY: _startTime.day');
          for (var entry in _recurByDay.entries) {
            if (entry.value) {
              _recurByDayStr += '' + entry.key;
            }
          }
          // user didn't click any days to repeat event on
            recurStr += _recurByDayStr;
        } else if (_recurFreqStr == 'MONTHLY') {
          recurStr += 'BYMONTHDAY=' + _startTime.day.toString();
        }
    }
    addAppointment(subjectController.text, _startTime, _endTime, recurStr);
    clearTextFields();
    Navigator.pop(context);
  }

  Padding buildWidgetPadding({double padding = 10}) {
    return Padding(padding: EdgeInsets.all(padding));
  }

  Text buildText(String text, 
    {FontWeight weight = FontWeight.w400, double size = 16, Color color = Colors.black}) {
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

  void clearTextFields() {
    subjectController.clear();
  }
}
