import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/AddAppointment.dart';
import 'package:hello_world/constants.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarEventView extends StatefulWidget {
  static const routeName = calendarViewRoute;
  CalendarEventView({Key key}) : super(key: key);

  @override
  _CalendarEventViewState createState() => _CalendarEventViewState();
}

class _CalendarEventViewState extends State<CalendarEventView> {
  List<Appointment> appointments = <Appointment>[];
  SfCalendar calendar;
  CalendarView calendarView;

  _CalendarEventViewState() {
    calendarView = CalendarView.month;
  }
  
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Calendar", style: TextStyle(color: Colors.white)),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(text: 'Day',),
                Tab(text: 'Week',),
                Tab(text: 'Month',)
              ],
            ),
            actions: <Widget>[
              FlatButton(
                textColor: Colors.white,
                child: Icon(Icons.event),
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
            ],)
        )
      )
    );
  }

  SfCalendar createCalendar(CalendarView calendarView) {
    return SfCalendar(
      view: calendarView,
      dataSource: _getCalendarDataSource(),
      /*onTap: (calendarTapDetails) {
        if (calendarTapDetails != null) {
          print('$calendarTapDetails.appointments');
          calendarTapped(calendarTapDetails);
        }
      },*/
      monthViewSettings: MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        showAgenda: true
      ),
    );
  }

  void calendarTapped(CalendarTapDetails details) {
    if (details == null) {
      print('nul');
    } else {
      String subject = details.appointments[0].subject;
      print(subject);
    }
  }


  void addAppointment(String subj, DateTime start, DateTime end, String recur) {
    DateTime startDate = DateTime(start.year, start.month, start.day);
    DateTime endDate = DateTime(end.year, end.month, end.day);
    appointments.add(createAppointment(startDate, endDate, subj, start, end, recur));
    setState(() {});
  }

  Appointment createAppointment(DateTime startDate, DateTime endDate, String subj, DateTime start, DateTime end, String recur) {
    return Appointment(
      startTime: startDate.add(Duration(hours: start.hour, minutes: start.minute)),
      endTime: endDate.add(Duration(hours: end.hour, minutes: end.minute)),
      subject: subj,
      recurrenceRule: recur
    );
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