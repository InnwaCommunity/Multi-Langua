part of '../listening_page.dart';
mixin _ListeningPageMixin on State<ListeningPage> {

  List<ListenQuest>? listenQust;
  TtsState ttsState = TtsState.stopped;
  late FlutterTts flutterTts;
  
  double volume = 0.5;
  double rate = 0.5;
  bool play=false;
  
  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;
  
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  @override
  void initState() {
    super.initState();
    loadListenQuest();
    initTts();
  }
  
  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    flutterTts.setStartHandler(() {
      setState(() {
        log("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          log("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        log("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        log("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        log("Paused");
        ttsState = TtsState.paused;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        log("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        log("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<void> loadListenQuest() async{
      String data = await rootBundle.loadString('assets/json_file/listen_data.json');
      var jsonResult = jsonDecode(data);
      listenQust=(jsonResult as List).map((e) => ListenQuest.fromJson(e)).toList();
      setState(() {});
  }
  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }
  Future<void> _speak(String data,double pi) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pi);

      if (data.isNotEmpty) {
        await flutterTts.speak(data);
      }
  }
  
  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }
}