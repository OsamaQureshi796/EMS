import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as Path;
class DataController extends GetxController{


  FirebaseAuth auth = FirebaseAuth.instance;

  DocumentSnapshot? myDocument;



  var allUsers  = <DocumentSnapshot>[].obs;
  var allEvents = <DocumentSnapshot>[].obs;

  var isEventsLoading = false.obs;

  getMyDocument(){
    FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid)
        .snapshots().listen((event) {
          myDocument = event;
    });
  }
  
 Future<String> uploadImageToFirebase(File file)async{
    String fileUrl = '';
    String fileName = Path.basename(file.path);
    var reference = FirebaseStorage.instance.ref().child('myfiles/$fileName');
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then((value) {
      fileUrl = value;
    });
    print("Url $fileUrl");
    return fileUrl;
  }

 Future<String> uploadThumbnailToFirebase(Uint8List file)async{
   String fileUrl = '';
   String fileName = DateTime.now().millisecondsSinceEpoch.toString();
   var reference = FirebaseStorage.instance.ref().child('myfiles/$fileName.jpg');
   UploadTask uploadTask = reference.putData(file);
   TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
   await taskSnapshot.ref.getDownloadURL().then((value) {
     fileUrl = value;
   });


   print("Thumbnail $fileUrl");

   return fileUrl;
 }

 Future<bool> createEvent(Map<String,dynamic> eventData)async{
   bool isCompleted = false;

   await FirebaseFirestore.instance.collection('events')
   .add(eventData)
   .then((value) {
     isCompleted = true;
     Get.snackbar('Event Uploaded', 'Event is uploaded successfully.',
         colorText: Colors.white,backgroundColor: Colors.blue);
   }).catchError((e){
     isCompleted = false;
   });


   return isCompleted;
 }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getMyDocument();
    getUsers();
    getEvents();
  }


  getUsers(){
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      allUsers.value = event.docs;
     });
  }


  getEvents(){
    isEventsLoading(true);

    FirebaseFirestore.instance.collection('events').snapshots().listen((event) {
      allEvents.assignAll(event.docs);
      isEventsLoading(false);
     });


  }




}