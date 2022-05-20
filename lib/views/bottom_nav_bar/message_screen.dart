import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/message_model.dart';
import '../chat/chat_room_screen.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<Messagedetail> detail = [
    Messagedetail(
        image: 'assets/img.png',
        name: 'Sara Smith',
        desc: 'Good Morning 12h',
        click: 'assets/img_8.png'),
    Messagedetail(
        image: 'assets/img_1.png',
        name: 'Robert Pratrica',
        desc: 'Good Morning 12h',
        click: 'assets/img_8.png'),
    Messagedetail(
        image: 'assets/img_2.png',
        name: 'kishori',
        desc: 'Good Morning 12h',
        click: 'assets/img_8.png'),
    Messagedetail(
        image: 'assets/img_3.png',
        name: 'Manish Yadav',
        desc: 'Good Morning 12h',
        click: 'assets/img_8.png'),
    Messagedetail(
        image: 'assets/img_4.png',
        name: 'Jagdeep samota',
        desc: 'Good Morning 12h',
        click: 'assets/img_8.png'),
    Messagedetail(
        image: 'assets/img_5.png',
        name: 'Abhay Saroj',
        desc: 'Good Morning 12h',
        click: 'assets/img_8.png'),
    Messagedetail(
        image: 'assets/img_6.png',
        name: 'Syed wamick',
        desc: 'Good Morning 12h',
        click: 'assets/img_8.png'),
    Messagedetail(
        image: 'assets/img_7.png',
        name: 'John snow',
        desc: 'Good Morning 12h',
        click: 'assets/img_8.png'),
  ];
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
                width: screenwidth * 0.9,
                height: screenheight * 1,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: detail.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Get.to(() => Chat());
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
                              Image(
                                image: AssetImage('${detail[index].image}'),
                                width: screenwidth * 0.1,
                                height: screenheight * 0.1,
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
                                      '${detail[index].name}',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: screenheight * 0.001,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Text('${detail[index].desc}'),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: screenwidth * 0.05,
                              ),
                              Image(
                                image: AssetImage('${detail[index].click}'),
                                width: screenwidth * 0.1,
                                height: screenheight * 0.1,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
