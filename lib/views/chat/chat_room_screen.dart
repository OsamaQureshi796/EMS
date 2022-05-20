
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';



class ChatObj {
  String name;
  String message;
  bool isSender;
  ChatObj(this.isSender, this.name, this.message);
}

class Chat extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return _Chat();
  }
}

class _Chat extends State<Chat> {
  // File? result;
  // String? imagePath;
  // File? file;
  // ImagePicker _picker = ImagePicker();
  // Future selectfile() async {
  //
  //   final  image = await _picker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     file = File(image?.path);
  //     imagePath = image!.path;
  //   });
  // }

  List<ChatObj> list = [
    ChatObj(true, "Hashir", "Hello"),
    ChatObj(false, "Muhammad", "Kasa ha?"),
  ];

  var _messageController = new TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  Widget _body() {

    return Column(
      children: <Widget>[
        Flexible(
          flex: 10,
          child: _topView(),
        ),
        Flexible(
          flex: 1,
          child: _bottomView(),
        ),
      ],
    );
  }

  Widget _topView() {
    return Container(
      color: Colors.grey.shade200,
      height: double.infinity,
      width: double.infinity,
      child: AnimatedList(
        key: _listKey,
        reverse: true,
        initialItemCount: list.length,
        itemBuilder: (context, index, animation) {
          return _listViewContent(list[index].isSender, index);
        },
      ),
    );
  }

  Widget _listViewContent(bool isSender, int index) {
    var screenheight=MediaQuery.of(context).size.height;
    var screenwidth=MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          children: [
            Image(image: AssetImage('assets/img.png'),width: screenwidth*0.09,height: screenheight*0.09,),
            Container(
              margin: isSender
                  ? EdgeInsets.only(right: 100, bottom: 5, left: 10)
                  : EdgeInsets.only(left: 200, bottom: 5, right: 1),
              // decoration: BoxDecoration(shape:BoxShape.circle,color: Colors.black),
              child:
              Card(

                color: Colors.transparent,
                elevation: 0,
                child: ClipPath(
                  clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(bottomRight: Radius.zero,bottomLeft: Radius.circular(15),topRight: Radius.circular(15),topLeft: Radius.circular(15)),
                    ),
                  ),
                  child: Container(

                    decoration: BoxDecoration(borderRadius: BorderRadius.only(
                      bottomRight: Radius.zero,

                    ),
                      color: isSender
                          ? Colors.lightBlueAccent.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.2),

                    ),

                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        //Image(image: AssetImage('assets/img.png')),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Text(
                              list[index].name,
                              style: TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5, bottom: 5, left: 10),
                              child: Text(
                                list[index].message,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),

                          ],
                        ),

                      ],
                    ),
                  ),
                ),

              ),

            ),

          ],
        ),

        Text("2m ago"),

      ],
    );

  }

  Widget _bottomView() {
    var screenheight=MediaQuery.of(context).size.height;
    var screenwidth=MediaQuery.of(context).size.width;
    return  Row(
      children: <Widget>[
        Flexible(
          flex: 4,
          child: Container(
            padding: EdgeInsets.only(left: 20),

            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,),
            child: TextFormField(
              controller: _messageController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                errorBorder: InputBorder.none,
                errorStyle: TextStyle(fontSize: 0, height: 0),
                focusedErrorBorder: InputBorder.none,
                fillColor: Colors.white,
                filled: true,
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10)
                ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10)
                ),
                border: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10)
                ),
                hintText: "Type Message",


                hintStyle: TextStyle(color: Colors.black,fontSize: 17),
              ),

            ),

          ),

        ),
        InkWell(
          onTap: () async {
            final ImagePicker _picker = ImagePicker();
            // Pick an image
            final  image = await _picker.pickImage(source: ImageSource.gallery);
          },
          child: Icon(
            Icons.image,
            color: Colors.blue,
          ),
        ),
        Flexible(
          flex: 1,
          child: InkWell(
            onTap: () {
              if (_messageController.value.text.isNotEmpty) {
                print("Message Send");

                var rnd = Random();

                var check = rnd.nextBool();
                print(check);

                list.insert(
                    0,
                    ChatObj(
                        check, "Muhammad", _messageController.value.text));
                _messageController.value = TextEditingValue(text: "");
                _listKey.currentState!.insertItem(0);

                setState(() {});
                FocusScope.of(context).unfocus();
              }
            },

            child: Container(
              width: double.infinity,
              child: Icon(
                Icons.send,
                color: Colors.blue,
              ),
            ),
          ),
        ),

      ],

    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: _body()
    );
  }
}
