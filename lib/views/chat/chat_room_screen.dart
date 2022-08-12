import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:ems/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/svg.dart';

import '../../controller/data_controller.dart';
import '../../utils/app_color.dart';
import '../../widgets/my_widgets.dart';

class Chat extends StatefulWidget {
  Chat({this.image, this.name, this.groupId, this.fcmToken,this.uid});

  String? image, name, groupId, fcmToken,uid;

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool isSendingMessage = false;
  bool isEmojiPickerOpen = false;
  String myUid = '';
  var screenheight;

  var screenwidth;

  DataController? dataController;
  TextEditingController messageController = TextEditingController();
  FocusNode inputNode = FocusNode();
  String replyText = '';
  void openKeyboard() {
    FocusScope.of(context).requestFocus(inputNode);
  }

  _onEmojiSelected(Emoji emoji) {
    messageController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: messageController.text.length));
  }

  _onBackspacePressed() {
    messageController
      ..text = messageController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: messageController.text.length));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataController = Get.find<DataController>();
    myUid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    screenheight = MediaQuery.of(context).size.height;
    screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            widget.image!.isEmpty
                ? CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  )
                : CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(widget.image!),
                  ),
            SizedBox(
              width: 5,
            ),
            Column(
              children: [
                myText(
                  text: widget.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                myText(
                  text: 'sara_smith',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff918F8F),
                  ),
                ),
              ],
            ),
          ],
        ),
        leading: InkWell(
          child: Container(
            padding: EdgeInsets.all(15),
            width: 20,
            height: 20,
            child: SvgPicture.asset(
              'assets/Header.svg',
              fit: BoxFit.cover,
            ),
          ),
          onTap: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: Obx(()=> dataController!.isMessageSending.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : StreamBuilder<QuerySnapshot>(
                      builder: (ctx, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        List<DocumentSnapshot> data =
                            snapshot.data!.docs.reversed.toList();

                        return ListView.builder(
                          reverse: true,
                          itemBuilder: (ctx, index) {
                            String messageUserId = data[index].get('uid');
                            String messageType = data[index].get('type');

                            Widget messageWidget = Container();

                            if (messageUserId == myUid) {
                              switch (messageType) {
                                case 'iSentText':
                                  messageWidget = textMessageISent(data[index]);
                                  break;

                                case 'iSentImage':
                                messageWidget = imageSent(data[index]);  
                                break;
                                case 'iSentReply':
                                messageWidget = sentReplyTextToText(data[index]);  
                              }
                            } else {
 switch (messageType) {
                                case 'iSentText':
                                  messageWidget = textMessageIReceived(data[index]);
                                  break;

                                case 'iSentImage':
                                messageWidget = imageReceived(data[index]);  
                                break;
                                case 'iSentReply':
                                messageWidget = receivedReplyTextToText(data[index]); 
                              }
                            }

                            return messageWidget;
                          },
                          itemCount: data.length,
                        );
                      },
                      stream: FirebaseFirestore.instance
                          .collection('chats')
                          .doc(widget.groupId)
                          .collection('chatroom')
                          .snapshots(),
                    ))
                    
                    
                    ),
          
          
          Container(
            height: isEmojiPickerOpen ? 300 : 75,
            // padding: MediaQuery.of(context).viewInsets,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 9,
                  blurRadius: 9,
                  offset: Offset(3, 0), // changes position of shadow
                ),
              ],
              color: AppColors.white,
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 15,
                    left: 20,
                    right: 20,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white2.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isEmojiPickerOpen = !isEmojiPickerOpen;
                          });
                        },
                        child: Icon(Icons.tag_faces_outlined),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        // width: 200,
                        // height: 50,
                        child: TextFormField(
                          focusNode: inputNode,
                          controller: messageController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type Your Message',
                            hintStyle: TextStyle(
                              color: AppColors.whitegrey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.13,
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              openMediaDialog();
                            },
                            child: Image(
                              image: AssetImage('assets/gallary.png'),
                              width: 20,
                              height: 20,
                            ),
                          ),
                          SizedBox(
                            width: screenwidth * 0.03,
                          ),
                          InkWell(
                            onTap: () {
                              if (messageController.text.isEmpty) {
                                return;
                              }
                              String message = messageController.text;
                              messageController.clear();
                              

                              Map<String, dynamic> data = {
                                'type': 'iSentText',
                                'message': message,
                                'timeStamp': DateTime.now(),
                                'uid': myUid
                              };

                              if(replyText.length>0){
                                data['reply'] = replyText;
                                data['type'] = 'iSentReply';
                                replyText = '';
                              }

                              dataController!.sendMessageToFirebase(
                                  data: data,
                                  grouid: widget.groupId,
                                  lastMessage: message);

dataController!.createNotification(widget.uid!);

                              LocalNotificationService.sendNotification(title: 'New message',message: message,token: widget.fcmToken);

                            },
                            child: Container(
                              width: 41,
                              height: 41,
                              child: Image.asset(
                                'assets/blackSendIcon.png',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Offstage(
                  offstage: !isEmojiPickerOpen,
                  child: SizedBox(
                    height: 230,
                    child: EmojiPicker(
                        onEmojiSelected: (Category category, Emoji emoji) {
                          _onEmojiSelected(emoji);
                        },
                        onBackspacePressed: _onBackspacePressed,
                        config: Config(
                            columns: 7,
                            // Issue: https://github.com/flutter/flutter/issues/28894
                            emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                            verticalSpacing: 0,
                            horizontalSpacing: 0,
                            initCategory: Category.RECENT,
                            bgColor: const Color(0xFFF2F2F2),
                            indicatorColor: Colors.blue,
                            iconColor: Colors.grey,
                            iconColorSelected: Colors.blue,
                            progressIndicatorColor: Colors.blue,
                            backspaceColor: Colors.blue,
                            showRecentsTab: true,
                            recentsLimit: 28,
                            noRecentsText: 'No Recents',
                            noRecentsStyle: const TextStyle(
                                fontSize: 20, color: Colors.black26),
                            tabIndicatorAnimDuration: kTabScrollDuration,
                            categoryIcons: const CategoryIcons(),
                            buttonMode: ButtonMode.MATERIAL)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  textMessageIReceived(DocumentSnapshot doc) {
    String message = '';
    try{
      message = doc.get('message');
    }catch(e){
      message = '';
    }
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Dismissible(
        confirmDismiss: (a) async {
        replyText = message;
        await Future.delayed(Duration(seconds: 1));
        openKeyboard();
        return false;
        },
        key: UniqueKey(),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: widget.image!.isEmpty
                      ? CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(widget.image!),
                        ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  width: 200,
                  // height: screenheight * 0.06,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      topLeft: Radius.zero,
                    ),
                    color: AppColors.greychat,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      message,
                      style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 70, top: 5),
                  child: Text(
                    "2 days ago",
                    style: TextStyle(
                      color: AppColors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
        direction: DismissDirection.startToEnd,
      ),
    );
  }

  textMessageISent(DocumentSnapshot doc) {
    String message = doc.get('message');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(right: 20),
          width: screenwidth * 0.38,
          // height: screenheight * 0.06,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                topRight: Radius.zero,
                topLeft: Radius.circular(18),
              ),
              color: Colors.black),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, right: 20),
              child: Text(
                "Yesterday",
                style: TextStyle(
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  imageSent(DocumentSnapshot doc) {


    String message = '';

    try{
      message  = doc.get('message');
    }catch(e){
      message = '';
    }


    return Container(
      margin: EdgeInsets.only(right: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: screenwidth * 0.42,
                height: screenheight * 0.18,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(18),
                        topLeft: Radius.circular(18),
                        bottomLeft: Radius.circular(18)),
                    image: DecorationImage(
                        image: NetworkImage(message),
                        fit: BoxFit.fill)),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 0,
                ),
                child: Text(
                  "06:25 PM",
                  style: TextStyle(
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  imageReceived(DocumentSnapshot doc) {
    String message = '';
    try{
      message = doc.get('message');
    }catch(e){
      message = '';
    }
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: widget.image!.isEmpty
                    ? CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(widget.image!),
                      ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                width: screenwidth * 0.42,
                height: screenheight * 0.18,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(18),
                        topLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18)),
                    image: DecorationImage(
                        image: NetworkImage(message),
                        fit: BoxFit.fill)),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 60,
                ),
                child: Text(
                  "06:25 PM",
                  style: TextStyle(
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  sentReplyTextToText(DocumentSnapshot doc) {

    String message = '';
    String reply = '';
    try{
      message = doc.get('message');
    }catch(e){
      message = '';
    }

    try{
      reply = doc.get('reply');
    }catch(e){
      reply = '';
    }


    return Container(
      margin: EdgeInsets.only(right: 20, top: 5, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 66, top: 5),
                child: Text(
                  "You replied to ${widget.name}",
                  style: TextStyle(
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: screenheight * 0.006,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(left: 0),
                width: screenwidth * 0.4,
                // height: screenheight * 0.06,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      topLeft: Radius.circular(18),
                    ),
                    color: AppColors.greychat),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    reply,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                ),
                child: Container(
                  width: 1,
                  height: 50,
                  color: Color(0xff918F8F),
                ),
              ),
            ],
          ),
          SizedBox(
            height: screenheight * 0.003,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(left: 17),
                width: screenwidth * 0.43,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      topLeft: Radius.circular(18),
                    ),
                    color: Colors.black),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  "04:35 PM",
                  style: TextStyle(
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  receivedReplyTextToText(DocumentSnapshot doc) {
     String message = '';
    String reply = '';
    try{
      message = doc.get('message');
    }catch(e){
      message = '';
    }

    try{
      reply = doc.get('reply');
    }catch(e){
      reply = '';
    }

    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 66, top: 5),
                child: Text(
                  "Replied to you ",
                  style: TextStyle(
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: screenheight * 0.006,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 65, right: 10),
                child: Container(
                  width: 1,
                  height: 50,
                  color: Color(0xff918F8F),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 0),
                width: screenwidth * 0.4,
                // height: screenheight * 0.06,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      topLeft: Radius.circular(18),
                    ),
                    color: Colors.black),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    reply,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: screenheight * 0.003,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: widget.image!.isEmpty
                    ? CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(widget.image!),
                      ),
              ),
              Container(
                margin: EdgeInsets.only(left: 17),
                width: screenwidth * 0.43,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      topLeft: Radius.circular(18),
                    ),
                    color: AppColors.greychat),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 73, top: 2),
                child: Text(
                  "04:35 PM",
                  style: TextStyle(
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void openMediaDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Choose'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    Navigator.pop(context);


                dataController!.isMessageSending(true);

                 String imageUrl = await  dataController!.uploadImageToFirebase(File(image.path));

                  Map<String,dynamic> data = {
                    'type': 'iSentImage',
                    'message': imageUrl,
                    'timeStamp': DateTime.now(),
                    'uid': myUid
                  };


                  dataController!.sendMessageToFirebase(data: data,grouid: widget.groupId,lastMessage: 'Image');

                  }
                },
                child: Icon(
                  Icons.camera_alt,
                  size: 30,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () async {
                    final ImagePicker _picker = ImagePicker();
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                     Navigator.pop(context);
                     dataController!.isMessageSending(true);

                 String imageUrl = await  dataController!.uploadImageToFirebase(File(image.path));

                  Map<String,dynamic> data = {
                    'type': 'iSentImage',
                    'message': imageUrl,
                    'timeStamp': DateTime.now(),
                    'uid': myUid
                  };


                  dataController!.sendMessageToFirebase(data: data,grouid: widget.groupId,lastMessage: 'Image');

                  }
                },
                child: Image.asset(
                  'assets/gallary.png',
                  width: 25,
                  height: 25,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
