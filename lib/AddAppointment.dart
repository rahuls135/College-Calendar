
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:hello_world/constants.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';


class AddAppointment extends StatefulWidget {
  static const routeName = addAppointmentRoute;
  

  @override
  _AddAppointmentState createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  final subjectController = TextEditingController();
  final locationController = TextEditingController();

  List<String> _recurFreq = ['None', 'Daily', 'Weekly', 'Monthly'];
  String _recurFreqStr;
  Map<String, bool> _recurByDay = new Map();
  String _recurByDayStr = 'BYDAY=';
  int _recurInterval;
  DateTime _startTime;
  DateTime _endTime;
  List<Text> allDays = <Text>[];
  bool _canSubmit = false;
  bool _changeStartTime = false;
  String _currentColorText;
  Color _currentColorColor;
  Map<String, Color> _eventColors = new Map();
  

  _AddAppointmentState() {
    _startTime = DateTime.now();
    _endTime = DateTime.now().add(Duration(hours: 1));
  }

  _AddAppointmentState._(DateTime start, DateTime end) {
    _startTime = start;
    _endTime = end;
  }

  @override
  void initState() {
    _recurFreqStr = _recurFreq[0];
    _recurInterval = 1;
    _recurByDay['SU'] = false;
    _recurByDay['MO'] = false;
    _recurByDay['TU'] = false;
    _recurByDay['WE'] = false;
    _recurByDay['TH'] = false;
    _recurByDay['FR'] = false;
    _recurByDay['SA'] = false;
    _eventColors['Red'] = Colors.red;
    _eventColors['Orange'] = Colors.deepOrange;
    _eventColors['Yellow'] = Colors.amber;
    _eventColors['Green'] = Colors.green;
    _eventColors['Blue'] = Colors.blue;
    _eventColors['Indigo'] = Colors.indigo;
    _eventColors['Violet'] = Colors.purple;
    _currentColorText = 'Blue';
    _currentColorColor = _eventColors[_currentColorText];
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    final Function addAppointment = ModalRoute.of(context).settings.arguments;
    //initState();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.blue,
        actionsForegroundColor: Colors.white,
        leading: GestureDetector(
          child: Icon(CupertinoIcons.left_chevron),
          onTap: () => Navigator.pop(context)
        ),
        middle: Text('New event', style: TextStyle(color: Colors.white),),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          padding: EdgeInsets.all(15),
          children: getWidgets(addAppointment),
        ),
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
    allWidgets.add(buildInputText(subjectController, 'Event name', CupertinoIcons.pen));
    allWidgets.add(buildInputText(locationController, 'Event location', CupertinoIcons.location_solid));
    if (subjectController.text != '') {
      _canSubmit = true;
    }
    allWidgets.add(buildWidgetPadding());
    allWidgets.add(buildTime(_startTime, 'Start', true));
    allWidgets.add(buildTime(_endTime, 'End', false));
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
    allWidgets.add(buildColorChooser());
    allWidgets.add(buildWidgetPadding());
    allWidgets.add(buildCallBackSubmit(addAppointment));
    return allWidgets;
  }

  
  // Widget to build text fields
  ListTile buildInputText(controller, hint, icon) {
    return ListTile(
      title: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        keyboardType: TextInputType.text,
        onChanged: (String value) => setState(() {
          if (value == '') {
            _canSubmit = false;
          }
        }),
        decoration: InputDecoration(
          icon: Icon(icon),
          hintText: hint
        ),
      )
    );
  }

  // Widget to build the Start and End time
  ListTile buildTime(DateTime time, String title, bool change) {
    checkTime();
    return ListTile(
      leading: buildText(title),
      trailing: getChosenTime(time),
      onTap: () {
        _changeStartTime = change;
        showCupertinoModalPopup(
          context: context,
          builder: (context) => buildDatePicker(time));
      }  
    );
  }
  Widget buildDatePicker(DateTime initTime) {
    return Container(
      height: 325,
      color: Colors.white,
      child: CupertinoDatePicker(
      initialDateTime: initTime,
      onDateTimeChanged: (newTime) => 
        setState(() => setTime(newTime))
      ),
    );
  }
  void setTime(DateTime newTime) {
    if (_changeStartTime) {
      _startTime = newTime;
    } else {
      _endTime = newTime;
    }
  }
  void checkTime() {
    if (_startTime.isAfter(_endTime)) {
      setState(() => _canSubmit = false);
    }
  }
  Text getChosenTime(DateTime time) {
    // if hour midnight or noon, hardcode 12 in
    // will show 0 instead of 12 otherwise
    if (time.hour == 0 || time.hour == 12) {
      return buildText(DateFormat('E MMM d, y   12:mm a').format(time), color: Colors.blue);
    }
    return buildText(DateFormat('E MMM d, y   K:mm a').format(time), color: Colors.blue);
  }

  // Widget to build event frequency widget
  ListTile buildDropDownTile() {
    return ListTile(
      leading: buildText('Frequency'),
      trailing: buildText(_recurFreqStr, color: Colors.blue),
      onTap: () => showCupertinoModalPopup(
          context: context,
          builder: (context) => dropDownActionSheetFreqPicker()
      ),
    );
  }
  CupertinoActionSheet dropDownActionSheetFreqPicker() {
    return CupertinoActionSheet(
      actions: dropDownFreqList(),
      cancelButton: CupertinoActionSheetAction(
        isDestructiveAction: true,
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

  // Widget to build event interval widget
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

  // Widget to build recurring days
  ListTile buildDaysTile() {
    return ListTile(
      title: buildText('Repeats'),
      subtitle: buildDaysWeek()
    );
  }
  Container buildDaysWeek() {
    //List<bool>list = _recurByDay.values;
    return Container(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 75),
      child: ToggleButtons(
        constraints: BoxConstraints.expand(
          width: MediaQuery.of(context).size.width / 9,
          height: 50
        ),
        borderRadius: BorderRadius.all(Radius.elliptical(20,15)),
        selectedBorderColor: Colors.blueAccent,
        isSelected: _recurByDay.values.toList(),
        children: buildDay(),
        onPressed: (val) =>
          setState(() => _recurByDay[allDays[val].data] = !_recurByDay[allDays[val].data])
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

  // Widget to build event color picker
  ListTile buildColorChooser() {
    return ListTile(
      leading: buildText('Color'),
      trailing: buildText(_currentColorText, color: _currentColorColor),
      onTap: () => showCupertinoModalPopup(
        context: context,
        builder: (context) => dropDownActionSheetColorChooser())
    );
  }
  CupertinoActionSheet dropDownActionSheetColorChooser() {
    return CupertinoActionSheet(
      actions: dropDownColors(),
    );
  }
  List<CupertinoActionSheetAction> dropDownColors() {
    List<CupertinoActionSheetAction> colorsList = <CupertinoActionSheetAction>[];
    for (String colorText in _eventColors.keys) {
      colorsList.add(
        CupertinoActionSheetAction(
          child: Text(colorText, style: TextStyle(color: _eventColors[colorText]),),
          onPressed: () {
            setState(() {
              _currentColorText = colorText;
              _currentColorColor = _eventColors[colorText];
            });
            Navigator.pop(context);
          },)
      );
    }
    return colorsList;
  }

  // Widget to build submit/add button
  CupertinoButton buildCallBackSubmit(Function addAppointment) {
    Function submitFunc;
    if (_canSubmit) {
      submitFunc = () => createRecurAndSubmit(addAppointment);
    }
    return CupertinoButton.filled(
      child: Text('Save'),
      disabledColor: Colors.grey,
      onPressed: submitFunc
    );
  }
  void createRecurAndSubmit(Function addAppointment) {
    _recurFreqStr = _recurFreqStr.toUpperCase();
    //String recur = 'FREQ=WEEKLY;INTERVAL=1;BYDAY=FR,;COUNT=10';
    String recurStr = 'FREQ=$_recurFreqStr;INTERVAL=$_recurInterval;COUNT=15;';
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
          recurStr += _recurByDayStr;
        } else if (_recurFreqStr == 'MONTHLY') {
          recurStr += 'BYMONTHDAY=' + _startTime.day.toString();
        }
    }
    addAppointment(subjectController.text, locationController.text, _startTime, _endTime, recurStr, _currentColorColor);
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
