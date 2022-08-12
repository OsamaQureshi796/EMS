import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/controller/data_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/message_model.dart';
import '../chat/chat_room_screen.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {


  DataController dataController = Get.find<DataController>();


  String myUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {

    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Message",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: screenheight * 0.03,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Container(
                      height: screenheight * 0.09,
                      width: screenwidth * 0.9,
                      //decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        style: TextStyle(color: Colors.grey),
                        onChanged: (String input){
                          if(input.isEmpty){
                            dataController.filteredUsers.assignAll(dataController.allUsers);
                          }else{
                           List<DocumentSnapshot> users =  dataController.allUsers.value.where((element) {
                        String name;
                               try{
                        name = element.get('first') + ' '+ element.get('last');
                      }catch(e){
                        name = '';
                      }


                              return name.toLowerCase().contains(input.toLowerCase());
                            }).toList();



                          dataController.filteredUsers.value.assignAll(users);
                          setState(() {
                            
                          });
                          

                          }
                        },
                        decoration: InputDecoration(
                          errorBorder: InputBorder.none,
                          errorStyle: TextStyle(fontSize: 0, height: 0),
                          focusedErrorBorder: InputBorder.none,
                          fillColor: Colors.deepOrangeAccent[2],
                          filled: true,
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)),
                          hintText: "Search",
                          prefixIcon: Icon(Icons.search),
                          hintStyle:
                          TextStyle(color: Colors.black, fontSize: 17),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Obx(()=> ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: dataController.filteredUsers.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {


                      String name = '', image = '';
                      try{
                        name = dataController.filteredUsers[index].get('first') + ' '+ dataController.filteredUsers[index].get('last');
                      }catch(e){
                        name = '';
                      }

                      try{
                        image = dataController.filteredUsers[index].get('image');
                      }catch(e){
                        image = '';
                      }


                      String fcmToken = '';
                       try{
                        fcmToken = dataController.filteredUsers[index].get('fcmToken');
                      }catch(e){
                        fcmToken = '';
                      }







                      return dataController.filteredUsers[index].id == FirebaseAuth.instance.currentUser!.uid? Container() : InkWell(
                        onTap: () {

                          String chatRoomId = '';
                          if(myUid.hashCode>dataController.filteredUsers[index].id.hashCode){
                            chatRoomId = '$myUid-${dataController.filteredUsers[index].id}';
                          }else{
                            chatRoomId = '${dataController.filteredUsers[index].id}-$myUid';
                          }

                          Get.to(() => Chat(groupId: chatRoomId,name: name,image: image,fcmToken: fcmToken,uid: dataController.filteredUsers[index].id,));
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          width: screenwidth * 0.01,
                          height: screenheight * 0.08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          child: Row(
                            //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(image),
                                radius: 25,
                              ),
                              SizedBox(
                                width: screenwidth * 0.06,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: screenheight * 0.002,
                                    ),
                                    Text(
                                      name,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: screenheight * 0.001,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Text(''),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: screenwidth * 0.05,
                              ),
                              Image(
                                image: AssetImage('assets/img_8.png'),
                                width: screenwidth * 0.1,
                                height: screenheight * 0.1,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
