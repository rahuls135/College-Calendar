import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  _CalendarEventViewState createState() => _CalendarEventViewState();
}

class _CalendarEventViewState extends State<CalendarEventView>
    with SingleTickerProviderStateMixin {
  final schedule = Firestore.instance;
  List<Appointment> appointments = <Appointment>[];
  List<DateTime> semesters = <DateTime>[];
  SfCalendar calendar;
  CalendarView calendarView;
  String _timeText, _titleText, _locText;
  Appointment _selectedAppointment;
  Color _apptColor;
  List<Widget> _calendarOptions;
  TabController _tabController;
  DateTime _currDate;
  bool animate = false;
  bool _showAgenda = false;

  @override
  void initState() {
    _currDate = DateTime.now();
    _timeText = '';
    _titleText = '';
    _locText = '';
    _calendarOptions = getCalendars();
    _tabController = new TabController(vsync: this, length: viewTabs.length);
    readDatabase();
    super.initState();
  }

  final List<Tab> viewTabs = <Tab>[
    Tab(text: 'Day',),
    Tab(text: 'Week',),
    Tab(text: 'Month',),
    Tab(text: 'Schedule',),
    Tab(text: 'Class schedule')
  ];

  List<Widget> getCalendars() {
    return <Widget>[
      createCalendar(CalendarView.day),
      createCalendar(CalendarView.week),
      createCalendar(CalendarView.month),
      createCalendar(CalendarView.schedule),
      classSchedule(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
            length: viewTabs.length,
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.blue,
                  title: Text('College Calendar',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, color: Colors.white)),
                  bottom: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabs: viewTabs),
                  actions: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: IconButton(
                        iconSize: 25,
                        icon: Icon(CupertinoIcons.home),
                        onPressed: () =>
                            setState(() => _currDate = DateTime.now()),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: IconButton(
                        iconSize: 25,
                        icon: Icon(CupertinoIcons.add_circled),
                        onPressed: () => Navigator.pushNamed(
                            context, AddSemester.routeName,
                            arguments: addSemester),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: IconButton(
                          iconSize: 25,
                          icon: Icon(CupertinoIcons.create_solid),
                          onPressed: () => Navigator.pushNamed(
                              context, AddAppointment.routeName,
                              arguments: AddAppointment(
                                addAppointment: addAppointment,
                                curDate: DateTime.now(),))),
                    ),
                  ],
                ),
                body: TabBarView(
                    controller: _tabController,
                    children: getCalendars()))));
  }

  SfCalendar createCalendar(CalendarView calendarView) {
    return SfCalendar(
      initialDisplayDate: _currDate,
      initialSelectedDate: _currDate,
      minDate: _currDate.subtract(Duration(days: DateTime.now().year)),
      timeSlotViewSettings: TimeSlotViewSettings(
        timeFormat: 'h:mm a',
      ),
      selectionDecoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.blue, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            shape: BoxShape.rectangle,
      ),
      todayHighlightColor: Colors.blue,
      onLongPress: (calendarLongPressDetails) {
        _currDate = calendarLongPressDetails.date;
        Navigator.pushNamed(
          context, AddAppointment.routeName,
          arguments: AddAppointment(addAppointment: addAppointment, curDate: _currDate,));
      },
      onTap: (eventDetails) =>
          setState(() => calendarTapped(eventDetails, calendarView)),
      view: calendarView,
      dataSource: _getCalendarDataSource(),
      monthViewSettings: MonthViewSettings(
        agendaViewHeight: 250,
        appointmentDisplayMode: monthDisplayType(),
        showAgenda: _showAgenda,
      ),
      scheduleViewSettings: ScheduleViewSettings(
        appointmentTextStyle: TextStyle(
          color: Colors.white,
        ),
        hideEmptyScheduleWeek: true,
        appointmentItemHeight: 45,
        monthHeaderSettings: MonthHeaderSettings(
          monthTextStyle: TextStyle(fontSize: 18, height: 1.05),
          backgroundColor: Colors.blue,
          height: 50,
          textAlign: TextAlign.start,
        )
      ),
    );
  }

  void calendarTapped(CalendarTapDetails details, CalendarView view) {
    // click cell in month - inverse show agenda
    if (view == CalendarView.month && details.targetElement == CalendarElement.calendarCell) {
      if (_currDate == details.date) {
        _showAgenda = !_showAgenda;
      }
      _currDate = details.date;
    }
    // click any cell - set current date to tapped date
    else if (((view == CalendarView.month || view == CalendarView.schedule) &&
               details.targetElement == CalendarElement.appointment) || 
               view == CalendarView.week && details.targetElement == CalendarElement.calendarCell) {
      _currDate = details.date;
      _calendarOptions[0] = createCalendar(CalendarView.day);
      if (view != CalendarView.week) {
        _tabController.animateTo(0);
      }
    }

    else if (details.targetElement == CalendarElement.agenda) {
      _tabController.animateTo(0);
    }

    // click appointment in daily or weekly view - show info screen
    else if (details.targetElement == CalendarElement.appointment) {
      for (Appointment apt in details.appointments) {
        if (apt.startTime == details.date ||
            DateFormat('K:mm').format(apt.startTime) ==
            DateFormat('K:mm').format(details.date)) {
          _timeText =
              formatDate(apt.startTime) + ' - ' + formatDate(apt.endTime);
          _locText = apt.location;
          _titleText = apt.subject;
          _apptColor = apt.color;
          _selectedAppointment = apt;
          print(_selectedAppointment.notes);
        }
      }
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => buildEventTappedScreen(details));
    }
  }

  MonthAppointmentDisplayMode monthDisplayType() {
    if (_showAgenda) {
      return MonthAppointmentDisplayMode.indicator;
    }
    return MonthAppointmentDisplayMode.appointment;
  }

  String formatDate(DateTime date) {
    if (date.hour == 12 || date.hour == 0) {
      return DateFormat('12:mm a').format(date).toString();
    }
    return DateFormat('K:mm a').format(date).toString();
  }

  Widget classSchedule() {
    List<Appointment> monClasses = <Appointment>[];
    List<Appointment> tuesClasses = <Appointment>[];
    List<Appointment> wedClasses = <Appointment>[];
    List<Appointment> thurClasses = <Appointment>[];
    List<Appointment> friClasses = <Appointment>[];

    // for (Appointment appt in appointments) {
    //   int recurDaysIndex = appt.recurrenceRule.indexOf('BYDAY');
    //   if (appt.recurrenceRule.contains('WEEKLY')) {
    //     if(appt.recurrenceRule.substring(recurDaysIndex).contains('MO')) {
    //       monClasses.add(appt);
    //     }
    //     if(appt.recurrenceRule.substring(recurDaysIndex).contains('TU')) {
    //       tuesClasses.add(appt);
    //     }
    //     if(appt.recurrenceRule.substring(recurDaysIndex).contains('WE')) {
    //       wedClasses.add(appt);
    //     }
    //     if(appt.recurrenceRule.substring(recurDaysIndex).contains('TH')) {
    //       thurClasses.add(appt);
    //     }
    //     if(appt.recurrenceRule.substring(recurDaysIndex).contains('FR')) {
    //       friClasses.add(appt);
    //    }
    //   }
    // }
    return ListView(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
          dayClasses('Monday', monClasses),
          dayClasses('Tuesday', tuesClasses),
          dayClasses('Wednesday', wedClasses),
          dayClasses('Thursday', thurClasses),
          dayClasses('Friday', friClasses),
        ],
    );
  }

  Card dayClasses(String day, List<Appointment> classes) {
    return Card(
      elevation: 0.9,
      // child: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: <Widget>[
      //     Padding(
      //       padding: EdgeInsets.fromLTRB(10, 20, 5, 20),
      //       child: Text(day, style: TextStyle(fontWeight: FontWeight.bold),),
      //     ),
      //     Padding(
      //       padding: EdgeInsets.fromLTRB(10, 20, 5, 20),
      //       child: Column(
      //         children: daySubjs(classes),
      //       )
      //     ),
      //     Padding(
      //       padding: EdgeInsets.fromLTRB(10, 20, 5, 20),
      //       child: Column(
      //         children: dayTimes(classes),
      //       )
      //     )
      //   ],
      // ),
      child: ListTile(
        title: Text(day),
        subtitle: Column(
          children:
            daySubjs(classes)
        ),
        trailing: Column(
          children: dayTimes(classes)
        ),
      )
    );
  }

  List<Text> daySubjs(List<Appointment> classDay) {
    List<Text> subjects = <Text>[];
    for (Appointment day in classDay) {
      subjects.add(Text(day.subject, textAlign: TextAlign.justify,));
    }
    return subjects;
  }

  List<Text> dayTimes(List<Appointment> classDay) {
    List<Text> times = <Text>[];
    for (Appointment day in classDay) {
      times.add(
        Text(formatDate(day.startTime) + ' - ' + formatDate(day.endTime),
          textAlign: TextAlign.left,)
      );
    }
    return times;
  }

  Container buildEventTappedScreen(CalendarTapDetails details) {
    return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(20),
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 1/2,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: ListView(children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Text(
                '$_titleText',
                style: TextStyle(
                    decorationColor: Colors.white,
                    fontSize: 24,
                    color: _apptColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Text(
                '$_timeText',
                style: TextStyle(
                    decorationColor: Colors.white,
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            ),
            InkWell(
              child: Text(
                '$_locText',
                style: TextStyle(color: _apptColor, fontSize: 18),
              ),
              onTap: () => launchMap(_locText),
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
                                  child: Text('Cancel'),
                                  isDefaultAction: true,
                                  onPressed: () => Navigator.pop(context),
                                ),
                                CupertinoDialogAction(
                                    child: Text("Delete"),
                                    isDestructiveAction: true,
                                    onPressed: () {
                                      // print(_selectedAppointment.subject);
                                      delete(_selectedAppointment.notes);
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
        )
      );
  }

  void delete(String id) async {
    await schedule.collection('events').document(id).delete();
  }
  
  void launchMap(String loc) {
    if (loc.isNotEmpty) {
      MapsLauncher.launchQuery('$loc');
    }
  }

  void addAppointment(String subj, String loc, DateTime start, DateTime end,
                      String recur, Color color, String id) {
    DateTime startDate = DateTime(start.year, start.month, start.day);
    DateTime endDate = DateTime(end.year, end.month, end.day);
    setState(() {
      appointments.add(Appointment(
        subject: subj,
        location: loc,
        startTime: startDate.add(Duration(hours: start.hour, minutes: start.minute)),
        endTime: endDate.add(Duration(hours: end.hour, minutes: end.minute)),
        recurrenceRule: recur,
        color: color,
        notes: id
      ));
      _currDate = startDate;
      _calendarOptions = getCalendars();
    });
  }

  void addSemester(String name, DateTime start, DateTime end) {
    DateTime startDate = DateTime(start.year, start.month, start.day);
    DateTime endDate = DateTime(end.year, end.month, end.day);
  }

  void readDatabase() async {
    schedule.collection('events').getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((element) {
        appointments.add(Appointment(
          subject: element.data['name'],
          location: element.data['loc'],
          startTime: DateTime.parse(element.data['start']),
          endTime: DateTime.parse(element.data['end']),
          recurrenceRule: element.data['recur'],
          color: Color.fromRGBO(element.data['color']['r'],
                                element.data['color']['g'],
                                element.data['color']['b'], 1),
          notes: element.documentID
        ));
      });
    });
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
