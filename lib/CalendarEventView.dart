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
  Appointment _selectedAppointment;
  Color _apptColor;
  int _selectedIndex = 0;
  List<SfCalendar> _calendarOptions;

  @override
  void initState() {
    _timeText = '';
    _titleText = '';
    _locText = '';
    _calendarOptions = [
      createCalendar(CalendarView.day),
      createCalendar(CalendarView.week),
      createCalendar(CalendarView.month),
      createCalendar(CalendarView.schedule)
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //   drawer: Drawer(
        //     child: ListView(
        //       children: <Widget>[
        //         ListTile(
        //           leading: Icon(CupertinoIcons.create_solid),
        //           title: Text('New Event', style: TextStyle(color: Colors.blue),),
        //           onTap: () => Navigator.popAndPushNamed(context, AddAppointment.routeName, arguments: addAppointment)
        //         ),
        //         ListTile(
        //           leading: Icon(CupertinoIcons.add_circled),
        //           title: Text('New Semester', style: TextStyle(color: Colors.blue),),
        //         )
        //       ],
        //     ),
        //   ),
        //   appBar: AppBar(
        //     backgroundColor: Colors.blue,
        //     title: Text('Calendar'),
        //       // middle: Text('Calendar'),//, style: TextStyle(color: Colors.black),),
        //       //   // leading: FlatButton(
        //       //   //   //textColor: Colors.white,
        //       //   //   //iconSize: 25,
        //       //   //   child: Icon(CupertinoIcons.add_circled),
        //       //   //   onPressed: () => Navigator.pushNamed(
        //       //   //       context, AddSemster.routeName,
        //       //   //       arguments: addSemester),
        //       //   // ),
        //       //   //Padding(padding: EdgeInsets.only(right: 30),),
        //       //   trailing: IconButton(
        //       //     //textColor: Colors.white,
        //       //     iconSize: 30,
        //       //     icon: Icon(CupertinoIcons.create_solid, color: Colors.black,),
        //       //     onPressed: () => Navigator.pushNamed(
        //       //           context,
        //       //           AddAppointment.routeName,
        //       //           arguments: addAppointment,
        //       //     )
        //       //   ),
        //   ),
        //     body: _calendarOptions[_selectedIndex],
        //     bottomNavigationBar: BottomNavigationBar(
        //       //backgroundColor: Colors.blue,
        //       selectedItemColor: Colors.blue,
        //       unselectedItemColor: Colors.black,
        //       currentIndex: _selectedIndex,
        //       onTap: (value) => setState(() => _selectedIndex = value),
        //       items: [
        //         BottomNavigationBarItem(
        //           icon: Icon(Icons.calendar_today),
        //           title: Text('Day'),
        //           //backgroundColor: Colors.white
        //         ),
        //         BottomNavigationBarItem(
        //           icon: Icon(Icons.view_week),
        //           title: Text('Week'),
        //           //backgroundColor: Colors.blue
        //         ),
        //         BottomNavigationBarItem(
        //           icon: Icon(Icons.date_range),
        //           title: Text('Month'),
        //           //backgroundColor: Colors.blue
        //         ),
        //         BottomNavigationBarItem(
        //           icon: Icon(Icons.schedule),
        //           title: Text('Schedule'),
        //           //backgroundColor: Colors.blue
        //         ),
        //       ],
        //     ),
        body: DefaultTabController(
            length: 4,
            child: Scaffold(
                // bottomNavigationBar: BottomNavigationBar(
                //   onTap: (int index) => setState(() => _selectedIndex = index),
                //   currentIndex: _selectedIndex,
                //   fixedColor: Colors.red,
                //   backgroundColor: Colors.black,
                //   unselectedItemColor: Colors.black,
                //   items: [
                //     BottomNavigationBarItem(
                //       icon: Icon(Icons.calendar_view_day),
                //       title: Text('Day')
                //     ),
                //     BottomNavigationBarItem(
                //       icon: Icon(Icons.view_week),
                //       title: Text('Week'),
                //       backgroundColor: Colors.blue
                //     ),
                //     BottomNavigationBarItem(
                //       icon: Icon(Icons.date_range),
                //       title: Text('Month')
                //     ),
                //     BottomNavigationBarItem(
                //       icon: Icon(Icons.schedule),
                //       title: Text('Schedule')
                //     ),
                //   ],
                // ),
                appBar: AppBar(
                  backgroundColor: Colors.blue,
                  title: Text('Classes',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, color: Colors.white)),
                  bottom: TabBar(
                    tabs: <Widget>[
                      Tab(
                        text: 'Day',
                      ),
                      Tab(
                        text: 'Week',
                      ),
                      Tab(
                        text: 'Month',
                      ),
                      Tab(
                        text: 'Schedule',
                      )
                    ],
                  ),
                  actions: <Widget>[
                    IconButton(
                      //textColor: Colors.white,
                      iconSize: 25,
                      icon: Icon(CupertinoIcons.add_circled),
                      onPressed: () => Navigator.pushNamed(
                          context, AddSemester.routeName,
                          arguments: addSemester),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 30),
                    ),
                    IconButton(
                        //textColor: Colors.white,
                        iconSize: 25,
                        icon: Icon(CupertinoIcons.create_solid),
                        onPressed: () => Navigator.pushNamed(
                              context,
                              AddAppointment.routeName,
                              arguments: addAppointment
                            )),
                  ],
                ),
                body: TabBarView(
                  children: <Widget>[
                    createCalendar(CalendarView.day),
                    createCalendar(CalendarView.week),
                    createCalendar(CalendarView.month),
                    createCalendar(CalendarView.schedule)
                  ],
                ))));
  }

  SfCalendar createCalendar(CalendarView calendarView) {
    return SfCalendar(
      //todayHighlightColor: Colors.blue,
      onTap: (eventDetails) =>
          setState(() => calendarTapped(eventDetails, calendarView)),
      view: calendarView,
      showNavigationArrow: true,
      dataSource: _getCalendarDataSource(),
      monthViewSettings: MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
        showAgenda: true,
      ),
      scheduleViewSettings: ScheduleViewSettings(
          hideEmptyScheduleWeek: true,
          appointmentItemHeight: 45,
          monthHeaderSettings: MonthHeaderSettings(
            backgroundColor: Colors.blueAccent,
            height: 50,
            textAlign: TextAlign.start,
          )),
    );
  }

  void calendarTapped(CalendarTapDetails details, CalendarView view) {
    if ((view == CalendarView.schedule &&
            details.targetElement == CalendarElement.calendarCell) ||
        view != CalendarView.schedule &&
            details.targetElement == CalendarElement.appointment) {
      for (Appointment apt in details.appointments) {
        if (apt.startTime == details.date ||
            DateFormat('K:mm').format(apt.startTime) ==
                DateFormat('K:mm').format(details.date)) {
          _timeText = DateFormat('K:mm a').format(apt.startTime).toString();
          _timeText +=
              ' - ' + DateFormat('K:mm a').format(apt.endTime).toString();
          _locText = apt.location;
          _titleText = apt.subject;
          _apptColor = apt.color;
          _selectedAppointment = apt;
        }
      }
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) => buildEventTappedScreen(details));
    }
  }

  Container buildEventTappedScreen(CalendarTapDetails details) {
    return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(20),
        color: Colors.white,
        width: 375,
        height: 600,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: ListView(children: <Widget>[
            Text(
              '$_titleText',
              style: TextStyle(
                  decorationColor: Colors.white,
                  fontSize: 24,
                  color: _apptColor,
                  fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: EdgeInsets.all(20),
            ),
            Text(
              '$_timeText',
              style: TextStyle(
                  decorationColor: Colors.white,
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            InkWell(
              child: Text(
                '$_locText',
                style: TextStyle(color: _apptColor, fontSize: 18),
              ),
              onTap: () => launchMap(_locText),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 300),
            ),
          ]),
          bottomNavigationBar: ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CupertinoButton(
                  child: Text('Go Back'),
                  onPressed: () => Navigator.pop(context)),
              CupertinoButton(
                  child: Text(
                    'Delete Event',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => CupertinoAlertDialog(
                              title: Text("Delete Event"),
                              content: Text(
                                  "This will delete all events of this type. This action cannot be undone."),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  isDefaultAction: true,
                                  child: Text('Cancel'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                CupertinoDialogAction(
                                    child: Text("Delete"),
                                    isDestructiveAction: true,
                                    onPressed: () {
                                      setState(() => appointments
                                          .remove(_selectedAppointment));
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    })
                              ],
                            ));
                  })
            ],
          ),
        ));
  }

  void launchMap(String loc) {
    if (loc.isNotEmpty) {
      MapsLauncher.launchQuery('$loc');
    }
  }

  void addAppointment(String subj, String loc, DateTime start, DateTime end,
      String recur, Color color) {
    DateTime startDate = DateTime(start.year, start.month, start.day);
    DateTime endDate = DateTime(end.year, end.month, end.day);
    setState(() => appointments.add(Appointment(
        subject: subj,
        location: loc,
        startTime:
            startDate.add(Duration(hours: start.hour, minutes: start.minute)),
        endTime: endDate.add(Duration(hours: end.hour, minutes: end.minute)),
        recurrenceRule: recur,
        color: color)));
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
