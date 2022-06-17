import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/app_color.dart';
import '../../widgets/my_widgets.dart';

class UserNotificationScreen extends StatefulWidget {
  @override
  _UserNotificationScreenState createState() => _UserNotificationScreenState();
}

class _UserNotificationScreenState extends State<UserNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10),
                child: iconWithTitle(func: () {}, text: 'Notifications'),
              ),
              buildDate("Today"),
              SizedBox(
                height: 13,
              ),
              Container(
                color: Color(0xffEEEEEE).withOpacity(0.9),
                padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Column(
                  children: [
                    buildTile(
                      "Mla Anders ",
                      "has invited you to yoga Weekend Retreat",
                      "1 hour ago",
                      "assets/img.png",
                    ),
                    buildTile(
                      "Shahid Noor ",
                      "has send you a friend request",
                      "1 hour ago",
                      "assets/img_3.png",
                    ),
                    buildTile(
                      "Mla Anders ",
                      "has invited you to yoga Weekend Retreat",
                      "1 hour ago",
                      'assets/#3.png',
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              buildDate("Yesterday"),
              SizedBox(
                height: 5,
              ),
              Container(
                color: Colors.grey.withOpacity(0.1),
                padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                // height: 250,
                child: Column(
                  children: [
                    buildTile(
                        "Mla Anders ",
                        "has invited you to yoga Weekend Retreat",
                        "1 hour ago",
                        "assets/#3.png"),
                    buildTile(
                        "Mla Anders ",
                        "has invited you to yoga Weekend Retreat",
                        "1 hour ago",
                        "assets/#2.png"),
                    buildTile(
                        "Mla Anders ",
                        "has invited you to yoga Weekend Retreat",
                        "1 hour ago",
                        'assets/#3.png'),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              buildDate("This Weak"),
              SizedBox(
                height: 5,
              ),
              Container(
                color: Colors.grey.withOpacity(0.1),
                padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                // height: 250,
                child: Column(
                  children: [
                    buildTile(
                        "Mla Anders ",
                        "has invited you to yoga Weekend Retreat",
                        "1 hour ago",
                        "assets/#3.png"),
                    buildTile(
                        "Mla Anders ",
                        "has invited you to yoga Weekend Retreat",
                        "1 hour ago",
                        "assets/#2.png"),
                    buildTile(
                        "Mla Anders ",
                        "has invited you to yoga Weekend Retreat",
                        "1 hour ago",
                        'assets/#3.png'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildTile(String name, String title, String subTitle, String image) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(image),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: AppColors.black,
                        ),
                      ),
                      TextSpan(
                        text: title,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 73),
            child: Text(
              subTitle,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.genderTextColor,
              ),
            ),
          ),
          Divider(
            color: Colors.grey.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  buildDate(String time) {
    return Container(
      margin: EdgeInsets.only(left: 20),
      child: Text(
        time,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: AppColors.black,
        ),
      ),
    );
  }
}