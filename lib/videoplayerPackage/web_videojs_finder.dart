import 'package:flutter/cupertino.dart';
import 'package:videoplayerpkg/video_js.dart';

import 'videojs_controller.dart';

class WebVideoJsFinder implements VideosJsController {
  @override
  Widget getVideoWidget(BuildContext context, String url) {
    final videoJsController = VideoJsController("videoId",
        videoJsOptions: VideoJsOptions(
            controls: true,
            loop: false,
            muted: false,
            fluid: true,
            liveui: false,
            notSupportedMessage: 'this movie type not supported',
            playbackRates: [1, 2, 3],
            preferFullWindow: false,
            responsive: false,
            sources: [Source(url, url.contains('m3u8') ? "application/x-mpegURL" : 'video/mp4')],
            suppressNotSupportedError: false));
    return VideoJsWidget(
        height: MediaQuery.of(context).size.height,
        // height: 500,
        width: MediaQuery.of(context).size.width,
        videoJsController: videoJsController);
  }

}

VideosJsController getVideosJsController() => WebVideoJsFinder();
