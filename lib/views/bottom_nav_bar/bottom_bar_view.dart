import 'package:ems/controller/data_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/notification_service.dart';
import '../community/community.dart';
import '../home/home_screen.dart';
import '../profile/profile.dart';
import 'create_event.dart';
import 'message_screen.dart';

class BottomBarView extends StatefulWidget {
  BottomBarView({Key? key}) : super(key: key);

  @override
  State<BottomBarView> createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView> {
  int currentIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  List<Widget> widgetOption = [
    HomeScreen(),
    CommunityScreen(),
     CreateEventView(),
    MessageScreen(),
    ProfileScreen()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(DataController(),permanent: true);
        FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) {
      
      LocalNotificationService.display(message);
    });

  LocalNotificationService.storeToken();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          // height: 50,
          child: BottomNavigationBar(
            onTap: onItemTapped,
            selectedItemColor: Colors.black,
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Image.asset(
                      currentIndex == 0
                          ? 'assets/Group 43 (1).png'
                          : 'assets/Group 43.png',
                      width: 22,
                      height: 22,
                    ),
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Image.asset(
                      currentIndex == 1
                          ? 'assets/Group 18340 (1).png'
                          : 'assets/Group 18340.png',
                      width: 22,
                      height: 22,
                    ),
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Image.asset(
                        currentIndex == 2
                            ? 'assets/Group 18528 (1).png'
                            : 'assets/Group 18528.png',
                        width: 22,
                        height: 22),
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Image.asset(
                        currentIndex == 3
                            ? 'assets/Group 18339 (1).png'
                            : 'assets/Group 18339.png',
                        width: 22,
                        height: 22),
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Image.asset(
                      currentIndex == 4
                          ? 'assets/Group 18341 (1).png'
                          : 'assets/Group 18341.png',
                      width: 22,
                      height: 22,
                    ),
                  ),
                  label: ''),
            ],
          ),
        ),
        body: widgetOption[currentIndex]);
  }
}
