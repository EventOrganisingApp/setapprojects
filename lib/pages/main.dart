// flutter run -d chrome
import 'package:setapprojects/pages/profile_controller.dart';

import 'signup.dart';
import 'login.dart';
import 'createEvent.dart';
import 'user_model.dart';
import 'navBar.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Color GlobBackgroundColor = Colors.lightBlue.shade50;
Color GlobButtonColor = Colors.indigoAccent;
Color GlobColor1 = Colors.deepPurple.shade900;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCKiaqMqfbIQDU01955JdYViVCyrNku3Qo",
      appId: "1:1093883717402:web:abb7af20c185cc6b19aea3",
      messagingSenderId: "1093883717402",
      projectId: "setapcoursework",
    ),
  );
  runApp(const HomePage());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Stream<List<Widget>> getEvents(BuildContext context) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userDocumentId)
        .collection('events')
        .snapshots()
        .map((snapshot) {
      List<Widget> eventWidgets = [];
      for (var doc in snapshot.docs) {
        var eventData = doc.data();
        String eventName = eventData['eventName'] ?? 'No Name';
        DateTime eventDate = (eventData['date'] as Timestamp).toDate();
        String eventLocation = eventData['city'] ?? 'No Location';
        String eventType = eventData['eventType'] ?? 'No Type';
        String eventPostcode = eventData['postcode'] ?? 'No Postcode';

        String eventDetails = "Location: $eventLocation\nDate: $eventDate";
        eventWidgets.add(Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.024),
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.28,
              height: MediaQuery.of(context).size.height * 0.4,
              child: SizedBox.expand(
                  child: Material(
                      elevation: 10,
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.zero,
                            shape: BoxShape.rectangle,
                            border: Border.all(
                                color: Colors.indigoAccent, width: 1),
                            color: Colors.indigo.shade200,
                          ),
                          child: Column(children: [
                            Padding(
                                padding: EdgeInsets.fromLTRB(
                                    0.0,
                                    (MediaQuery.of(context).size.width * 0.02),
                                    0.0,
                                    (MediaQuery.of(context).size.width * 0.06)),
                                child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(eventName,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          color: Colors.white,
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.white,
                                        )))),
                            Align(
                                alignment: Alignment.center,
                                child: Text(eventDetails,
                                    style: const TextStyle(
                                        fontSize: 22, color: Colors.white))),
                            Expanded(
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              // ferrel add code here
                                            },
                                            icon: const Icon(Icons.ios_share,
                                                size: 40, color: Colors.black),
                                          )
                                        ])))
                          ]))))),
        ));
      }
      return eventWidgets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: GlobBackgroundColor,
        appBar: AppBar(
          backgroundColor: GlobColor1,
          leading: GestureDetector(
            onTap: () {
              // naya - add nav bar code here
            },
            child: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
        ),
        body: StreamBuilder<List<Widget>>(
          stream: getEvents(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              return ListView(children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(
                                color: Colors.indigoAccent, width: 1),
                            color: Colors.indigo.shade200),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: SizedBox.expand(
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreateEvent()),
                                      );
                                    },
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        5.0)))),
                                    child: const Align(
                                        alignment: Alignment.center,
                                        child: Text("Add event",
                                            style: TextStyle(
                                              fontSize: 25,
                                            ))))))),
                  ),
                ),
                const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Text("Your events",
                          style: TextStyle(
                            fontSize: 30,
                            decoration: TextDecoration.underline,
                          )),
                    )),
                Wrap(
                  spacing: 6.0, // Horizontal space between children
                  runSpacing: 8.0, // Vertical space between runs
                  children: snapshot.data!,
                ),
              ]);
            } else {
              return Center(child: Text("No events found"));
            }
          },
        ),
      ),
    );
  }
}
