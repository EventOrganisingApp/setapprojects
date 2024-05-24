import 'package:setapprojects/pages/profile_controller.dart';
import 'signup.dart';
import 'login.dart';
import 'createEvent.dart';
import 'user_model.dart';
import 'navBar.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



Color GlobBackgroundColor = Colors.lightBlue.shade50;
Color GlobButtonColor = Colors.indigoAccent;
Color GlobColor1 = Colors.deepPurple.shade900;


void main() async{
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
          String eventLocation = eventData['city'] ?? 'No Location';
          String eventType = eventData['eventType'] ?? 'No Type';
          String eventPostcode = eventData['postcode'] ?? 'No Postcode';
          DateTime eventTime = (eventData['time'] as Timestamp).toDate();
          String eventDetails = "Location: $eventLocation\nDate: ${eventTime.day}/${eventTime.month}/${eventTime.year} Time: ${eventTime.hour}:${eventTime.minute.toString().padLeft(2, '0')}\nPostcode: $eventPostcode";

          eventWidgets.add(
        Padding(
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
                    border: Border.all(color: Colors.indigoAccent, width: 1),
                    color: Colors.indigo.shade200,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, (MediaQuery.of(context).size.width * 0.02), 0.0, (MediaQuery.of(context).size.width * 0.06)),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            eventName,
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            )
                          )
                        )
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          eventDetails,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white
                          )
                        )
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: (){
                                  // ferrel add code here
                                },
                                icon: const Icon(Icons.ios_share, size: 40, color: Colors.black),
                              )
                            ]
                          )
                        )
                      )
                    ]
                  )
                )
              )
            )
          ),
        )
      );
      }
      return eventWidgets;
    }
    );
  }


  @override
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      body: StreamBuilder<List<Widget>>(
        stream: getEvents(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return ListView(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: SizedBox.expand(
                          child: Column(
                            children: [
                              Image.network(
                                "https://cdn3.iconfinder.com/data/icons/network-and-communications-6/130/291-128.png",
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),

                              const Text(
                                "Planify",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 28,
                                  color: Color(0xff3a57e8),
                                ),
                              ),

                            ]
                          )
                        )

                      )

                  ),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Your events",
                      style: TextStyle(
                        fontSize: 30,
                        decoration: TextDecoration.underline,
                      )
                    ),
                  )
                ),
                Wrap(
                  spacing: 6.0, // Horizontal space between children
                  runSpacing: 8.0, // Vertical space between runs
                  children: snapshot.data!,
                ),
              ]
            );
          } else {
            return Center(child: Text("No events found"));
          }
        },
      ),
    ),
  );
}}

