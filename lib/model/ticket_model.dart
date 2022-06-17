import 'package:flutter/cupertino.dart';

class Messagedetail {
  String image, name, desc, click;
  Messagedetail({
    required this.image,
    required this.name,
    required this.desc,
    required this.click,
  });
}

class AustinYogaWork {
  String? rangeText;
  String? title;

  AustinYogaWork({
    this.rangeText,
    this.title,
  });
}

class Ticketdetail {
  Color? color;
  String name,
      img1,
      img2,
      img3,
      img4,
      img5,
      img6,
      heart,
      rate,
      message,
      count,
      share,
      date,
      range;

  Ticketdetail({
    this.color,
    required this.range,
    required this.date,
    required this.name,
    required this.img1,
    required this.img2,
    required this.img3,
    required this.img4,
    required this.img5,
    required this.img6,
    required this.heart,
    required this.rate,
    required this.message,
    required this.count,
    required this.share,
  });
}

class Storycircle {
  String image;
  Storycircle({required this.image});
}

class Inviteperson {
  String image, name;
  Inviteperson({required this.image, required this.name});
}

class CommunityModel {
  String? imagePath,
      imageTitle,
      imagePath1,
      imageTitle1,
      imagePath2,
      imageTitle2,
      centerImage,
      lastTitle;
  String? imagePathFor2,
      imageTitleFor2,
      imagePath1For2,
      imageTitle1For2,
      imagePath2For2,
      imageTitle2For2,
      centerImageFor2,
      lastTitleFor2;
  String? imagePathFor3,
      imageTitleFor3,
      imagePath1For3,
      imageTitle1For3,
      imagePath2For3,
      imageTitle2For3,
      centerImageFor3,
      lastTitleFor3;
  CommunityModel({
    this.centerImage,
    this.imagePath,
    this.imagePath1,
    this.imagePath2,
    this.imageTitle,
    this.imageTitle1,
    this.imageTitle2,
    this.lastTitle,
    this.centerImageFor2,
    this.imagePathFor2,
    this.imagePath1For2,
    this.imagePath2For2,
    this.imageTitleFor2,
    this.imageTitle1For2,
    this.imageTitle2For2,
    this.lastTitleFor2,
    this.centerImageFor3,
    this.imagePathFor3,
    this.imagePath1For3,
    this.imagePath2For3,
    this.imageTitleFor3,
    this.imageTitle1For3,
    this.imageTitle2For3,
    this.lastTitleFor3,
  });
}