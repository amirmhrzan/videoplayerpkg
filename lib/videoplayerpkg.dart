library videoplayerpkg;


import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'videoplayerPackage/videojs_controller.dart';


final isMobileWebProvider = FutureProvider<bool>((ref) async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  // replace this with other isWebMobile check
  WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
  if (!kIsWeb) {
    return false;
  } else {
    print('Running on ${webBrowserInfo.userAgent}');
    if (webBrowserInfo.userAgent != null) {
      return (webBrowserInfo.userAgent!.contains("iPhone") ||
          webBrowserInfo.userAgent!.contains("iPad") ||
          (webBrowserInfo.userAgent!.contains("Mac OS X") &&
              !webBrowserInfo.userAgent!.contains("Chrome") &&
              !webBrowserInfo.userAgent!.contains("Firefox")));
    } else {
      return false;
    }
  }
  // final browser = Browser.detectOrNull(); // return null if not on web platform
  // if (browser != null && browser.browserAgent == BrowserAgent.Safari) {
  //   print(browser.browserAgent.toString());
  //   return true;
  // } else {
  //   print("Not Safari");
  //   return false;
  // }
});


class CompatibleVideoPlayer extends ConsumerWidget {
  const CompatibleVideoPlayer({
    Key? key,
    this.title = 'Session Replay',
    this.url = '',
    this.sessionId = '',
  }) : super(key: key);

  final String sessionId;
  final String title;
  final String? url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSafariFuture = ref.watch(isMobileWebProvider);

    final isSafari = isSafariFuture.asData?.value ?? true;
    VideosJsController videoController = VideosJsController();

    return kIsWeb ? Scaffold(
      appBar: AppBar(
          leading: BackButton(
            color: Colors.white,
          )),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
              child: isSafari
                  ? HtmlWidget('''
                    <iframe id="inlineFrameExample"
                          allow="fullscreen; autoplay"
                          title="Workout"
                          width=400
                          frameborder="0" allowFullScreen webkitallowfullscreen="true" mozallowfullscreen="true" 
                          src="$url">
                  </iframe>
        ''', webViewMediaPlaybackAlwaysAllow: true, webView: true)
                  : Center(
                child: videoController.getVideoWidget(
                    context, url!),
              ),
            ),
          ],
        ),
      ),
    ) : !Platform.isIOS
        ? AndroidVideoPlayer(key: key, url: url!,)
        : Expanded(
        child: WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted));
  }
}

class AndroidVideoPlayer extends StatefulHookConsumerWidget {
  const AndroidVideoPlayer({
    Key? key,
    this.title = 'Session Replay',
    this.sessionId,
    this.url = '',
  }) : super(key: key);

  final String title;
  final String url;
  final String? sessionId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _VideoPlayerState();
  }
}

class _VideoPlayerState extends ConsumerState<AndroidVideoPlayer> {
  // TargetPlatform? _platform;
  late VideoPlayerController _videoPlayerController1;

  // late VideoPlayerController _videoPlayerController2;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    // _videoPlayerController2.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController1 = VideoPlayerController.network(
      (widget.url != '')
          ? widget.url
      // TODO: MAKE SURE TO CHANGE THIS TO SOMETHING ALIGNED TO THE COACH'S VIDEO
          : '',
    );
    await Future.wait([
      _videoPlayerController1.initialize(),
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      // fullScreenByDefault: true,
      showControlsOnInitialize: true,
      allowFullScreen: kIsWeb ? false : true,
      // startAt: const Duration(seconds: 2),
      overlay: Container(),
      autoPlay: true,
      looping: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.black,
        child: Stack(children: [
          Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: _chewieController != null &&
                      _chewieController!
                          .videoPlayerController.value.isInitialized
                      ? Chewie(
                    controller: _chewieController!,
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text('Loading',),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const PositionedDirectional(
            top: 8,
            start: 8,
            child: BackButton(
              color: Colors.white,
            ),
          )
        ]),
      ),
    );
    // );
  }
}
