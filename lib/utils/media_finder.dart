import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io' as io;

class MediaFinder {
  static var dir;
  static Future getDocumentsDirectory() async {
    dir = await getApplicationDocumentsDirectory();
  }

  static bool getSound(String name) {
    bool _isLocal;

    String filePath = dir.path + '/sounds/' + name;
    print(filePath);

    if (io.File(filePath).existsSync()) {
      _isLocal = true;
    } else {
      _isLocal = false;
    }
    return _isLocal;
  }

  static Widget getImage(String name) {
    Widget image;

    String filePath = dir.path + '/images/' + name;

    if (io.File(filePath).existsSync()) {
      //print("image found");
      image = Image.file(
        File(filePath),
        errorBuilder: (context, error, stackTrace) {
          //print("error : $error");
          //print("can not load image");
          return Container(
            width: 150,
            height: 100,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '😢',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                    color: Colors.blue,
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
          );
        },
      );
    } else {
      image = Image.asset(
        'assets/images/$name',
        errorBuilder: (context, error, stackTrace) {
          //print(stackTrace);
          return Container(
            width: 150,
            height: 100,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.red,
                  ),
                  textDirection: TextDirection.ltr,
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.error,
                  size: 30,
                  color: Colors.red,
                ),
              ],
            ),
          );
        },
      );
    }

    return image;
  }

  /* static getVideoPlayerController(String name) {
    VideoPlayerController controller;
    String filePath = dir.path + '/videos/' + name;

    if (io.File(filePath).existsSync()) {
      controller = VideoPlayerController.file(File(filePath));
    } else {
      controller = VideoPlayerController.asset('assets/videos/$name');
    }
    return controller;
  } */
}
