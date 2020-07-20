import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/AddAppointment.dart';
import 'package:hello_world/AddSemester.dart';
import 'package:hello_world/constants.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';



class CalendarEventView extends StatefulWidget {
  static const routeName = calendarViewRoute;
  //CalendarEventView({Key key}) : super(key: key);

  @override
  _CalendarEventViewState createState() => _CalendarEventViewState();
}

class _CalendarEventViewState extends State<CalendarEventView> {
  List<Appointment> appointments = <Appointment>[];
  List<DateTime> semesters = <DateTime>[];
  SfCalendar calendar;
  CalendarView calendarView;
  String _timeText, _titleText, _locText;
 
@override
void initState() {
  _timeText='';
  _titleText='';
	_locText = '';
  super.initState();
}

  _CalendarEventViewState() {
    calendarView = CalendarView.month;
  }
  
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text('Classes', style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white)),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(text: 'Day',),
                Tab(text: 'Week',),
                Tab(text: 'Month',),
                Tab(text: 'Schedule',)
              ],
            ),
            actions: <Widget>[
              FlatButton (
                textColor: Colors.white,
                child: Icon(CupertinoIcons.add_circled),
                onPressed: () => Navigator.pushNamed(
                  context,
                  AddSemster.routeName,
                  arguments: addSemester),
              ),
              FlatButton(
                textColor: Colors.white,
                child: Icon(CupertinoIcons.create_solid),
                onPressed: () => Navigator.pushNamed(
                  context,
                  AddAppointment.routeName,
                  arguments: addAppointment,
                )
              ),
            ],
          ),
          body: TabBarView(
            children: <Widget>[
              createCalendar(CalendarView.day),
              createCalendar(CalendarView.week),
              createCalendar(CalendarView.month),
              createCalendar(CalendarView.schedule)
            ],
          )
        )
      )
    );
  }

  SfCalendar createCalendar(CalendarView calendarView) {
    return SfCalendar(
      //todayHighlightColor: Colors.blue,
      onTap: (eventDetails) => calendarTapped(eventDetails, calendarView),
      view: calendarView,
      showNavigationArrow: true,
      dataSource: _getCalendarDataSource(),
      monthViewSettings: MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        showAgenda: false,
        agendaStyle: AgendaStyle(appointmentTextStyle: TextStyle(backgroundColor: Colors.red))
      ),
      scheduleViewSettings: ScheduleViewSettings(
        hideEmptyScheduleWeek: true,
        appointmentItemHeight: 45,
        monthHeaderSettings: MonthHeaderSettings(
          backgroundColor: Colors.blueAccent,
          height: 50,
          textAlign: TextAlign.start,
        )
      ),
    );
  }

void calendarTapped(CalendarTapDetails details, CalendarView view) {
	String id = '';
  print(details.targetElement);
  print(view);
  if ((view == CalendarView.schedule && details.targetElement == CalendarElement.calendarCell) ||
      view != CalendarView.schedule && details.targetElement == CalendarElement.appointment) {
    print('in appointment');
    for (Appointment apt in details.appointments) {
      if (apt.startTime == details.date) {
        _timeText = DateFormat('K:mm a').format(apt.startTime).toString();
        _timeText += ' - ' + DateFormat('K:mm a').format(apt.endTime).toString() + '\n';
        _locText = apt.notes;
				id = apt.notes;
        _titleText=apt.subject;
      }
    }
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return Container(
				alignment: Alignment.centerLeft,
				padding: EdgeInsets.all(20),
        color: Colors.white,
        width: 375,
        height: 600,
        child: Column(
					children: <Widget>[
						//Padding(padding: EdgeInsets.only(top: 10)),
						Text('$_titleText', style: TextStyle(decorationColor: Colors.white, fontSize: 24, color: Colors.blue, fontWeight: FontWeight.w600),),
						Padding(padding: EdgeInsets.all(10),),
						Text('$_timeText', style: TextStyle(decorationColor: Colors.white, fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),),
						CupertinoButton(
							child: Text('$_locText'),
							onPressed: () => MapsLauncher.launchQuery('$_locText'),
						),
					],
				),
      );
    }
  );
  }
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title:Container(child: new Text(" $_titleText")),
    //       content:Container(child: new Text(" $_text")),
    //       actions: <Widget>[
    //         new FlatButton(onPressed: () {
    //           Navigator.of(context).pop();
    //         }, child: new Text('Close'))
    //       ],
    //     );
    //   });
}


  void addAppointment(String subj, String loc, DateTime start, DateTime end, String recur, Color color, int eventID) {
    DateTime startDate = DateTime(start.year, start.month, start.day);
    DateTime endDate = DateTime(end.year, end.month, end.day);
    setState(() =>
      appointments.add(
        Appointment(
          subject: subj,
          location: loc,
					notes: eventID.toString(),
          startTime: startDate.add(Duration(hours: start.hour, minutes: start.minute)),
          endTime: endDate.add(Duration(hours: end.hour, minutes: end.minute)),
          recurrenceRule: recur,
          color: color
        )
      )
    );
  }


  void addSemester(String name, DateTime start, DateTime end) {
    DateTime startDate = DateTime(start.year, start.month, start.day);
    DateTime endDate = DateTime(end.year, end.month, end.day);
  }

  _AppointmentDataSource _getCalendarDataSource() {
    return _AppointmentDataSource(appointments);
  }
}


class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}