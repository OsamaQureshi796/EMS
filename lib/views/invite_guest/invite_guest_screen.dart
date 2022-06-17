import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../model/ticket_model.dart';
import '../../utils/app_color.dart';
import '../../widgets/check_box.dart';
import '../../widgets/my_widgets.dart';

class Inviteguest extends StatefulWidget {
  const Inviteguest({Key? key}) : super(key: key);

  @override
  _InviteguestState createState() => _InviteguestState();
}

class _InviteguestState extends State<Inviteguest> {
  bool value = false;
  List<Storycircle> circle = [
    Storycircle(
      image: 'assets/#1.png',
    ),
    Storycircle(
      image: 'assets/#2.png',
    ),
    Storycircle(
      image: 'assets/#3.png',
    ),
  ];
  List<Inviteperson> invite = [
    Inviteperson(name: 'Sara Smith', image: 'assets/img.png'),
    Inviteperson(name: 'Robert Particia', image: 'assets/img_1.png'),
    Inviteperson(name: 'Kishori', image: 'assets/img_2.png'),
    Inviteperson(name: 'Manesh Yadev', image: 'assets/img_3.png'),
    Inviteperson(name: 'Jagdeep Samota', image: 'assets/img_4.png'),
    Inviteperson(name: 'Abhey Saroj', image: 'assets/img_5.png'),
  ];
  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 16));

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              iconWithTitle(text: 'Invite Guests'),
              Container(
                height: 45,
                width: screenwidth * 0.9,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: TextFormField(
                  style: TextStyle(color: AppColors.black.withOpacity(0.6)),
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
                    hintText: "Search friends to invite",
                    prefixIcon: Image.asset(
                      'assets/search.png',
                      cacheHeight: 17,
                    ),
                    hintStyle: TextStyle(color: AppColors.black, fontSize: 15),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                width: double.infinity,
                height: 40,
                child: ListView.builder(
                  itemCount: circle.length,
                  //  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    return Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Image.asset(
                              circle[index].image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Suggested',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    //alignment: Alignment.center,

                    width: 100,
                    height: 31,
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          backgroundColor: AppColors.blue),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2, left: 2),
                        child: Text(
                          'Invite all',
                          style: GoogleFonts.poppins(
                            color: AppColors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: screenheight * 0.6,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: invite.length,
                  itemBuilder: (context, index) {
                    return
                        //InkWell(
                        //onTap: () {
                        //  Get.to(() => Chat());
                        // },
                        //  child:
                        Container(
                      margin: EdgeInsets.only(bottom: 10),
                      width: 57,
                      height: 57,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            height: 65,
                            width: 57,
                            child: Image(
                              image: AssetImage('${invite[index].image}'),
                            ),
                          ),
                          SizedBox(
                            width: 13,
                          ),
                          Text(
                            '${invite[index].name}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          ChecksBox(),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: myText(
                    text: "Send",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xffFFFFFF),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}