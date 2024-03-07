part of '../my_home_page.dart';

mixin _HomePageMixin on State<MyHomePage> {
  TextEditingController inpoutText=TextEditingController();
  final TranslateData _translateData= TranslateData(inputData: '', outputData: '');
  late FlutterTts flutterTtsoutput;
  Timer? debounce;
  bool editing=false;
  String fromLanguage = '';
  String toLanguage = '';
  TtsState ttsState = TtsState.stopped;
  String? outputlanguage;
  String? inputlanguage;
  String? engine;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;



  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;
  
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  
  @override
  void initState() {
    NotificationController.createNewNotification();
    initData();
    initTts();
    super.initState();
  }
  
  initTts() {
    flutterTtsoutput = FlutterTts();

    _setAwaitOptions();

    flutterTtsoutput.setStartHandler(() {
      setState(() {
        log("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTtsoutput.setInitHandler(() {
        setState(() {
          log("TTS Initialized");
        });
      });
    }

    flutterTtsoutput.setCompletionHandler(() {
      setState(() {
        log("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTtsoutput.setCancelHandler(() {
      setState(() {
        log("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    flutterTtsoutput.setPauseHandler(() {
      setState(() {
        log("Paused");
        ttsState = TtsState.paused;
      });
    });

    flutterTtsoutput.setContinueHandler(() {
      setState(() {
        log("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTtsoutput.setErrorHandler((msg) {
      setState(() {
        log("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }
  Future _translateoutput(String text) async {
    await flutterTtsoutput.setVolume(volume);
    await flutterTtsoutput.setSpeechRate(rate);
    await flutterTtsoutput.setPitch(pitch);

      if (text.isNotEmpty) {
        await flutterTtsoutput.speak(text);
      }
  }
  
  Future _setAwaitOptions() async {
    await flutterTtsoutput.awaitSpeakCompletion(true);
  }
  Future<void> initData() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String? from = shared.getString(SharedPrefKey.inputTranslateCountry);
    String? to = shared.getString(SharedPrefKey.translateCountry);
    glotran.from = from != null ? from.split(',')[0] : 'en';
    glotran.to = to != null ? to.split(',')[0] : 'my';
    fromLanguage = from != null ? from.split(',')[1] : '';
    toLanguage = to != null ? to.split(',')[1] : '';
    dynamic supportLan = await flutterTtsoutput.getLanguages;
    String? selectedType;
    String? selectInType;
    for (var sup in supportLan) {
      if (sup.toString().toLowerCase().startsWith(glotran.to)) {
        selectedType = sup;
      }
    }
    if (selectedType != null) {
      outputlanguage = selectedType;
      flutterTtsoutput.setLanguage(outputlanguage!);
    }
    for (var sup in supportLan) {
      if (sup.toString().toLowerCase().startsWith(glotran.from)) {
        selectInType = sup;
      }
    }
    if (selectInType != null) {
      outputlanguage = selectInType;
    }
    setState(() {});
  }
}