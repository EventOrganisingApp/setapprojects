import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'profile_controller.dart';
import 'user_model.dart';
import 'package:flutter/cupertino.dart';
import 'user_repository.dart';

class EditEvents extends StatefulWidget {
  const EditEvents({Key? key}) : super(key: key);

  @override
  _EditEventsState createState() => _EditEventsState();
}

class _EditEventsState extends State<EditEvents> {
  Future<List<Widget>> getEvents() async {
    List<Widget> toReturn = [];

    CollectionReference<Map> userDataList = FirebaseFirestore.instance
        .collection("users")
        .doc(userDocumentId)
        .collection("events");

    QuerySnapshot<Map> querySnapshot = await userDataList.get();

    for (var doc in querySnapshot.docs) {
      Map<dynamic, dynamic> data = doc.data();

      List<dynamic> eventDetailList = [
        data['eventName'],
        data['eventType'],
        data['date'],
        data['city'],
        data['postcode'],
        doc.id,
      ];

      toReturn.add(Padding(
          padding: EdgeInsets.all(20),
          child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 0.5,
              child: SizedBox.expand(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditPage(eventDetails: eventDetailList),
                      ),
                    );
                  },
                  child: Text(
                    eventDetailList[0],
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ))));
    }

    return toReturn;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: ListView(
              children: [
                Align(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: EdgeInsets.all(25),
                        child: Text("Select an event to edit",
                            style: TextStyle(
                              fontSize: 30,
                            )))),
                FutureBuilder<List<Widget>>(
                  future: getEvents(),
                  builder:
                      (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text(
                          'Error: ${snapshot.error}');
                    } else {
                      return Column(children: snapshot.data!);
                    }
                  },
                )
              ],
            )));
  }
}

class EditPage extends StatefulWidget {
  final List<dynamic> eventDetails;

  EditPage({required this.eventDetails});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  late TextEditingController eventNameController = TextEditingController(text: widget.eventDetails[0]);
  late TextEditingController eventTypeController = TextEditingController(text: widget.eventDetails[1]);
  late TextEditingController cityController = TextEditingController(text: widget.eventDetails[3]);
  late TextEditingController postcodeController = TextEditingController(text: widget.eventDetails[4]);
  late TextEditingController timeController = TextEditingController();

  late String dropdownValue;

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 200,
        color: CupertinoColors.white,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: selectedDate,
          onDateTimeChanged: (DateTime newDateTime) {
            setState(() {
              selectedDate = newDateTime;
            });
          },
        ),
      ),
    );
  }

  void _showTimePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 200,
        color: CupertinoColors.white,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.time,
          initialDateTime: DateTime(0, selectedTime.hour, selectedTime.minute),
          onDateTimeChanged: (DateTime newDateTime) {
            setState(() {
              selectedTime = TimeOfDay.fromDateTime(newDateTime);
              timeController.text = "${selectedTime.hour}:${selectedTime.minute}";
            });
          },
        ),
      ),
    );
  }

  void createEvent() async {
    List<String> timeParts = timeController.text.split(':');
    DateTime eventTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );

    EventModel event = EventModel(
      eventName: eventNameController.text,
      eventType: eventTypeController.text,
      city: cityController.text,
      postcode: postcodeController.text,
      date: selectedDate,
      time: eventTime,
    );

    var eventId = widget.eventDetails[5];

    UserRepository.instance.updateUserEvent(userDocumentId, eventId, event);
  }

  @override
  void initState() {
    super.initState();
    eventNameController = TextEditingController(text: widget.eventDetails[0]);
    eventTypeController = TextEditingController(text: widget.eventDetails[1]);
    cityController = TextEditingController(text: widget.eventDetails[3]);
    postcodeController = TextEditingController(text: widget.eventDetails[4]);
    timeController = TextEditingController(text: "${selectedTime.hour}:${selectedTime.minute}");
    dropdownValue = widget.eventDetails[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image(
                image: NetworkImage(
                  "https://cdn3.iconfinder.com/data/icons/network-and-communications-6/130/291-128.png",
                ),
                height: 90,
                width: 90,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 30),
                child: Text(
                  "Planify",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 20,
                    color: Color(0xff3a57e8),
                  ),
                ),
              ),
              Text(
                "Edit Event",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 24,
                  color: Color(0xff000000),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: TextField(
                  controller: eventNameController,
                  obscureText: false,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    color: Color(0xff000000),
                  ),
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(color: Color(0xff9e9e9e), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(color: Color(0xff9e9e9e), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(color: Color(0xff9e9e9e), width: 1),
                    ),
                    labelText: "Event Name",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Color(0xff9e9e9e),
                    ),
                    filled: true,
                    fillColor: Color(0x00ffffff),
                    isDense: false,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: DropdownButtonFormField(
                  value: dropdownValue,
                  items: [
                    DropdownMenuItem(
                      child: Text("Birthday Party"),
                      value: "Birthday Party",
                    ),
                    DropdownMenuItem(
                      child: Text("Wedding"),
                      value: "Wedding",
                    ),
                    DropdownMenuItem(
                      child: Text("School Reunion"),
                      value: "School Reunion",
                    ),
                    DropdownMenuItem(
                      child: Text("Holiday"),
                      value: "Holiday",
                    ),
                    DropdownMenuItem(
                      child: Text("Funeral"),
                      value: "Funeral",
                    ),
                    DropdownMenuItem(
                      child: Text("Graduation"),
                      value: "Graduation",
                    ),
                    DropdownMenuItem(
                      child: Text("Conference"),
                      value: "Conference",
                    ),
                    DropdownMenuItem(
                      child: Text("Workshop"),
                      value: "Workshop",
                    ),
                    DropdownMenuItem(
                      child: Text("Concert"),
                      value: "Concert",
                    ),
                    DropdownMenuItem(
                      child: Text("Festival"),
                      value: "Festival",
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      dropdownValue = value.toString();
                      eventTypeController.text = value.toString();
                    });
                  },
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(color: Color(0xff9e9e9e), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(color: Color(0xff9e9e9e), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(color: Color(0xff9e9e9e), width: 1),
                    ),
                    labelText: "Event Type",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Color(0xff9e9e9e),
                    ),
                    filled: true,
                    fillColor: Color(0x00ffffff),
                    isDense: false,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: TextField(
                  controller: cityController,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    color: Color(0xff000000),
                  ),
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(color: Color(0xff9e9e9e), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(color: Color(0xff9e9e9e), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(color: Color(0xff9e9e9e), width: 1),
                    ),
                    labelText: "City / Town",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Color(0xff9e9e9e),
                    ),
                    filled: true,
                    fillColor: Color(0x00ffffff),
                    isDense: false,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: TextField(
                  controller: postcodeController,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    color: Color(0xff000000),
                  ),
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(color: Color(0xff9e9e9e), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(color: Color(0xff9e9e9e), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(color: Color(0xff9e9e9e), width: 1),
                    ),
                    labelText: "Event Postcode",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Color(0xff9e9e9e),
                    ),
                    filled: true,
                    fillColor: Color(0x00ffffff),
                    isDense: false,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: CupertinoTextField(
                  onTap: () {
                    _showDatePicker(context);
                  },
                  readOnly: true,
                  controller: TextEditingController(
                      text: "${selectedDate.toLocal()}".split(' ')[0]),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: CupertinoColors.white,
                    border: Border.all(color: CupertinoColors.systemGrey),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: CupertinoTextField(
                  onTap: () {
                    _showTimePicker(context);
                  },
                  readOnly: true,
                  controller: timeController,
                  placeholder: 'Select Time',
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: CupertinoColors.white,
                    border: Border.all(color: CupertinoColors.systemGrey),
                  ),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 30, 0),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Color(0xff3a57e8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: BorderSide(
                        color: Color(0xff9e9e9e),
                        width: 1,
                      ),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    textColor: Color(0xffffffff),
                    height: 40,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: MaterialButton(
                    onPressed: () {
                      createEvent();
                      Navigator.of(context).pop();
                    },
                    color: Color(0xff3a57e8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: BorderSide(
                        color: Color(0xff9e9e9e),
                        width: 1,
                      ),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Edit Event",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    textColor: Color(0xffffffff),
                    height: 40,
                  ),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
