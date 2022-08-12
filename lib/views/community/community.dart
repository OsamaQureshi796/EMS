import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/controller/data_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/my_widgets.dart';




class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {


  TextEditingController searchController = TextEditingController();

  DataController dataController = Get.find<DataController>();
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          // height: Get.height,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              iconWithTitle(func: () {}, text: 'Community',),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  controller: searchController,
                  onChanged: (String input){


                      if(input.isEmpty){
                        dataController.filteredEvents.assignAll(dataController.allEvents);
                      }else{
                          List<DocumentSnapshot> data = dataController.allEvents.value.where((element) {
                        List tags = [];

                        bool isTagContain = false;

                        try {
                          tags = element
                              .get('tags');
                          for(int i=0;i<tags.length;i++){
                            tags[i] = tags[i].toString().toLowerCase();
                            if(tags[i].toString().contains(searchController.text.toLowerCase())){
                              isTagContain = true;

                            }
                          }
                        } catch (e) {
                          tags = [];
                        }
                        return (element.get('location').toString().toLowerCase().contains(searchController.text.toLowerCase()) 
                        || isTagContain ||
                        element.get('event_name').toString().toLowerCase().contains(searchController.text.toLowerCase()) 
                        );
                      }).toList();
                      dataController.filteredEvents.assignAll(data);
                      }


                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Container(
                      width: 15,
                      height: 15,
                      padding: EdgeInsets.all(15),
                      child: Image.asset(
                        'assets/search.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    hintText: 'Austin,USA',
                    hintStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
             
              Obx(()=> GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 30,
                      childAspectRatio: 0.53),
                  shrinkWrap: true,
                  itemCount: dataController.filteredEvents.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                


                      String userName = '',
                        userImage = '',
                        eventUserId = '',
                        location = '',
                        eventImage='',
                        tagString=''
                    ;
                    eventUserId =
                        dataController.filteredEvents.value[i].get('uid');
                    DocumentSnapshot doc = dataController.allUsers
                        .firstWhere(
                            (element) => element.id == eventUserId);

                    try {
                      userName = doc.get('first');
                    } catch (e) {
                      userName = '';
                    }


                  print('Username is $userName');

                    try {
                      userImage = doc.get('image');
                    } catch (e) {
                      userImage = '';
                    }

                    try {
                      location = dataController.filteredEvents.value[i]
                          .get('location');
                    } catch (e) {
                      location = '';
                    }



                    try {
                      List media =
                      dataController.filteredEvents.value[i].get('media');

                      eventImage = media.firstWhere(
                          (element) => element['isImage'] == true)['url'];
                    } catch (e) {
                      eventImage = '';
                    }

                    List tags = [];

                    try {
                      tags = dataController.filteredEvents.value[i]
                          .get('tags');
                    } catch (e) {
                      tags = [];
                    }

                    if(tags.length ==0){
                      tagString = dataController.filteredEvents.value[i]
                          .get('description');
                    }else{
                      tags.forEach((element) {
                        tagString += "#$element, ";
                      });
                    }



                    String eventName = '';
                    try{
                      eventName = dataController.filteredEvents.value[i].get('event_name');
                    }catch(e){
                      eventName = '';
                    }


                    return InkWell
                      (
                      onTap: (){
                        },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            userProfile(
                              path: userImage,
                              title: userName,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff333333),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Image.asset('assets/location.png'),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: myText(
                                    text: location,

                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff303030),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                eventImage,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),

                            
                        
                            SizedBox(
                              height: 10,
                            ),
                            myText(
                              text: eventName,

                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            myText(
                              text: tagString,
                              

                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
            ),
            ],
          ),
        ),
      ),
    );
  }
}