

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:videoplayerpkg/videoplayerPackage/videojs_controller.dart';

class MobileVideoJsFinder implements VideosJsController{
  @override
  Widget getVideoWidget(BuildContext context, String url) {
    return Container();
  }

}

VideosJsController getVideosJsController() => MobileVideoJsFinder();
