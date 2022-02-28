

import 'package:flutter/widgets.dart';

import 'videojs_stub.dart'
    if(dart.library.io) 'package:videoplayerpkg/videoplayerPackage/mobile_videojs_finder.dart'
    if(dart.library.html) 'package:videoplayerpkg/videoplayerPackage/web_videojs_finder.dart';

abstract class VideosJsController{

  Widget getVideoWidget(BuildContext context, String url){
    return Container();
  }

  factory VideosJsController() => getVideosJsController();

}