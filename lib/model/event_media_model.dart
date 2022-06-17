import 'dart:io';

import 'dart:typed_data';

class EventMediaModel{

  File? image;
  File? video;
  bool? isVideo;
  Uint8List? thumbnail;
  EventMediaModel({this.image,this.video,this.isVideo,this.thumbnail});


}