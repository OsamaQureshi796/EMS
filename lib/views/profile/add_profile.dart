import 'dart:io';

import 'package:ems/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/app_color.dart';
import '../../widgets/my_widgets.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(1950),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      dob.text = '${picked.day}-${picked.month}-${picked.year}';
    }
  }

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController dob = TextEditingController();

  imagePickDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Choose Image Source'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image =
                  await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    profileImage = File(image.path);
                    setState(() {});
                    Navigator.pop(context);
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
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    profileImage = File(image.path);
                    setState(() {});
                    Navigator.pop(context);
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

  File? profileImage;

  void setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  int selectedRadio = 0;

  AuthController? authController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authController = Get.find<AuthController>();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: Get.width * 0.1,
                ),
                InkWell(
                  onTap: () {
                    imagePickDialog();
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    margin: EdgeInsets.only(top: 35),
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(70),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff7DDCFB),
                          Color(0xffBC67F2),
                          Color(0xffACF6AF),
                          Color(0xffF95549),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(70),
                          ),
                          child: profileImage == null
                              ? CircleAvatar(
                            radius: 56,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.blue,
                              size: 50,
                            ),
                          )
                              : CircleAvatar(
                            radius: 56,
                            backgroundColor: Colors.white,
                            backgroundImage: FileImage(
                              profileImage!,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.width * 0.1,
                ),
                textField(
                    text: 'First Name',
                    controller: firstNameController,
                    validator: (String input) {
                      if (firstNameController.text.isEmpty) {
                        Get.snackbar('Warning', 'First Name is required.',
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }
                    }),
                textField(
                    text: 'Last Name',
                    controller: lastNameController,
                    validator: (String input) {
                      if (lastNameController.text.isEmpty) {
                        Get.snackbar('Warning', 'Last Name is required.',
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }
                    }),
                textField(
                    text: 'Mobile Number',
                    inputType: TextInputType.phone,
                    controller: mobileNumberController,
                    validator: (String input) {
                      if (mobileNumberController.text.isEmpty) {
                        Get.snackbar('Warning', 'First Name is required.',
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }

                      if (mobileNumberController.text.length < 10) {
                        Get.snackbar('Warning', 'Enter valid phone number.',
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }
                    }),
                Container(
                  height: 48,
                  child: TextField(
                    controller: dob,
                    // enabled: false,
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());

                      _selectDate(context);
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 10, left: 10),
                      suffixIcon: Image.asset(
                        'assets/calender.png',
                        cacheHeight: 20,
                      ),
                      hintText: 'Date Of Birht',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                          // alignment: Alignment.topLeft,
                          // width: 150,
                          child: RadioListTile(
                            title: Text(
                              'Male',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w400,
                                color: AppColors.genderTextColor,
                              ),
                            ),
                            value: 0,
                            groupValue: selectedRadio,
                            onChanged: (int? val) {
                              setSelectedRadio(val!);
                            },
                          ),
                        )),
                    Expanded(
                      child: Container(
                        child: RadioListTile(
                          title: Text(
                            'Female',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w400,
                              color: AppColors.genderTextColor,
                            ),
                          ),
                          value: 1,
                          groupValue: selectedRadio,
                          onChanged: (int? val) {
                            setSelectedRadio(val!);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Obx(()=> authController!.isProfileInformationLoading.value? Center(child: CircularProgressIndicator(),) :Container(
                  height: 50,
                  margin: EdgeInsets.only(top: Get.height * 0.02),
                  width: Get.width,
                  child: elevatedButton(
                    text: 'Save',
                    onpress: () async{
                      if (dob.text.isEmpty) {
                        Get.snackbar(
                            'Warning', "Date of birth is required.",
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }

                      if (!formKey.currentState!.validate()) {
                        return null;
                      }

                      if(profileImage == null){
                        Get.snackbar(
                            'Warning', "Image is required.",
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return null;
                      }


                      authController!.isProfileInformationLoading(true);

                      String imageUrl = await authController!.uploadImageToFirebaseStorage(profileImage!);

                      authController!.uploadProfileData(imageUrl, firstNameController.text.trim(), lastNameController.text.trim(), mobileNumberController.text.trim(), dob.text.trim(), selectedRadio ==0 ? "Male": "Female");

                    },
                  ),
                )),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                Container(
                    width: Get.width * 0.8,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: 'By signing up, you agree our ',
                            style: TextStyle(
                                color: Color(0xff262628), fontSize: 12)),
                        TextSpan(
                            text: 'terms, Data policy and cookies policy',
                            style: TextStyle(
                                color: Color(0xff262628),
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ]),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}