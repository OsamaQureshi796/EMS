import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:ems/model/event_media_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../utils/app_color.dart';
import '../../widgets/my_widgets.dart';

class CreateEventView extends StatefulWidget {
  const CreateEventView({Key? key}) : super(key: key);

  @override
  _CreateEventViewState createState() => _CreateEventViewState();
}

class _CreateEventViewState extends State<CreateEventView> {
  // Initial Selected Value
  String dropdownvalue = 'Open';

  // List of items in our dropdown menu
  var items = [
    'Open',
    'Closed',

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              iconWithTitle(text: 'Create Event'),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Container(
                height: Get.width * 0.6,
                width: Get.width * 0.9,
                decoration: BoxDecoration(
                    color: Color(0xffC4C4C4).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8)),
                child: DottedBorder(
                  color: Colors.grey,
                  strokeWidth: 1.5,
                  dashPattern: [6, 6],
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: Get.height * 0.1,
                        ),
                        Container(
                          width: Get.width*0.1,
                          height: Get.width*0.1,
                          child: Image.asset('assets/uploadIcon.png'),
                        ),
                        myText(
                          text: 'Click and upload image/video',
                          style: GoogleFonts.poppins(
                            color: AppColors.blue,
                            fontSize: 19,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        elevatedButton(onpress: () {
                          mediaDialog(context);
                        }, text: 'Upload')
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),

              Container(
                width: double.infinity,
                height: 120,
                child: ListView.builder(itemBuilder: (ctx,i){
                  return Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                image: FileImage(media[i].image!),
                                fit: BoxFit.fill
                            )
                        ),
                        child: media[i].isVideo!? Center(child: Icon(Icons.play_arrow,color: Colors.black,size: 30,),) : Container(),
                      ),
                      Positioned(
                        top: 10,
                        right: 5,
                        child: InkWell(
                          onTap: (){
                            media.removeAt(i);
                            setState(() {

                            });
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.close,color: Colors.black,),
                          ),
                        ),
                      )
                    ],
                  );
                },itemCount: media.length,scrollDirection: Axis.horizontal,),
              ),

              SizedBox(
                height: 20,
              ),
              myTextField(
                bool: false,
                icon: 'assets/4DotIcon.png',
                text: 'Event Name',
              ),
              Container(
                margin: EdgeInsets.only(left: 5, top: 5),
                alignment: Alignment.topLeft,
                child: Text(
                  '*3 words max',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: AppColors.blue,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              myTextField(
                bool: false,
                icon: 'assets/location.png',
                text: 'Location',
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  iconTitleContainer(path: 'assets/Frame1.png', text: 'Date'),
                  iconTitleContainer(path: 'assets/#.png', text: 'Max Entries'),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              myTextField(
                bool: false,
                icon: 'assets/repeat.png',
                text: 'Frequecy of event',
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  iconTitleContainer(
                      path: 'assets/time.png', text: 'Start Time'),
                  iconTitleContainer(path: 'assets/time.png', text: 'End Time'),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  myText(
                      text: 'Description/Instruction',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(top: 20, left: 10, right: 10),
                    hintStyle: TextStyle(
                      color: AppColors.genderTextColor,
                    ),
                    hintText:
                        'Write a summurry and any details your invitee should know about the event...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  myText(
                      text: 'Who can invite',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: Get.width * 0.3,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.genderTextColor, width: 1)),
                    child: DropdownButton(
                      // Initial Value
                      value: dropdownvalue,
                      underline: Container(),

                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),
                      isExpanded: true,
                      // Array list of items
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      },
                    ),
                  ),
                  iconTitleContainer(
                      path: 'assets/dollarLogo.png', text: 'Price'),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Text("Create Event",style: TextStyle(color: Colors.white),),
                color: AppColors.blue,
                height: 50,
                minWidth: double.infinity,
              )
            ],
          ),
        ),
      ),
    );
  }


  List<EventMediaModel> media = [];

  // List<File> media = [];
  // List thumbnail = [];
  // List<bool> isImage = [];


  getImageDialog(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(
      source: source,
    );

    if (image != null) {

      media.add(EventMediaModel(
        image: File(image.path),
        video: null,
        isVideo: false
      ));

      // media.add(File(image.path));
      // thumbnail.add(File(image.path));
      // isImage.add(true);
    }

    setState(() {});
    Navigator.pop(context);
  }

  getVideoDialog(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickVideo(
      source: source,
    );

    if (image != null) {



      // media.add(File(image.path));

      Uint8List? uint8list = await VideoThumbnail.thumbnailData(
        video: image.path,
        imageFormat: ImageFormat.JPEG,
        quality: 75,
      );

      media.add(EventMediaModel(
          image: File.fromRawPath(uint8list!),
          isVideo: true,
          video: File(image.path)
      ));


      // thumbnail.add(uint8list!);
      //
      // isImage.add(false);
    }

    // print(thumbnail.first.path);
    setState(() {});

    Navigator.pop(context);
  }

  void mediaDialog(BuildContext context) {
    showDialog(
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Select Media Type"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      imageDialog(context, true);
                    },
                    icon: Icon(Icons.image)),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      imageDialog(context, false);
                    },
                    icon: Icon(Icons.slow_motion_video_outlined)),
              ],
            ),
          );
        },
        context: context);
  }

  void imageDialog(BuildContext context, bool image) {
    showDialog(
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Media Source"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      if (image) {
                        getImageDialog(ImageSource.gallery);
                      } else {
                        getVideoDialog(ImageSource.gallery);
                      }
                    },
                    icon: Icon(Icons.image)),
                IconButton(
                    onPressed: () {
                      if (image) {
                        getImageDialog(ImageSource.camera);
                      } else {
                        getVideoDialog(ImageSource.camera);
                      }
                    },
                    icon: Icon(Icons.camera_alt)),
              ],
            ),
          );
        },
        context: context);
  }

}
