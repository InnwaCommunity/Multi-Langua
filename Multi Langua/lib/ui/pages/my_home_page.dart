import 'dart:async';

import 'package:dict/config/context_ext.dart';
import 'package:dict/config/text_style.dart';
import 'package:dict/constant/sharedpref_key.dart';
import 'package:dict/controller/notification_controller.dart';
import 'package:dict/main.dart';
import 'package:dict/model/translate_data_model.dart';
import 'package:dict/ui/pages/language_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:developer';
part 'mixin/home_page_mixin.dart';
enum TtsState { playing, stopped, paused, continued }
class MyHomePage extends StatefulWidget {
  static const String route = '/';
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with _HomePageMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi Langua'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.deepPurple)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    TextField(
                      spellCheckConfiguration: const SpellCheckConfiguration(),
                      controller: inpoutText,
                      style: DTextStyle.translateData.copyWith(color: Colors.black),
                      decoration:
                          const InputDecoration(hintText: 'Enter Some Datas'),
                      maxLines: 6,
                      onChanged: (value) {
                        editing = true;
                        setState(() {});
                        if (debounce?.isActive ?? false) {
                          debounce!.cancel();
                        }
                        debounce = Timer(const Duration(milliseconds: 500), () async {
                          if (inpoutText.text.isNotEmpty) {
                            final translator = GoogleTranslator();
                            _translateData.inputData = inpoutText.text;
                            var translation = await translator.translate(
                                inpoutText.text,
                                from: glotran.from,
                                to: glotran.to);
                            _translateData.outputData = translation.toString();
                          }else{
                            _translateData.outputData='';
                          }
                          editing = false;
                          setState(() {});
                        });
                      },
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: 40,
                        child: ListView(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      inpoutText.text = '';
                                      _translateData.outputData = '';
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.close)),
                                Visibility(
                                  visible: inputlanguage != null
                                      ? inputlanguage!
                                          .toLowerCase()
                                          .startsWith(glotran.from)
                                      : false,
                                  child: IconButton(
                                      icon: const Icon(Icons.volume_up),
                                      onPressed: () => {
                                            flutterTtsoutput
                                                .setLanguage(inputlanguage!),
                                            _translateoutput(inpoutText.text)
                                          }),
                                ),
                                IconButton(
                                    onPressed: () {
                                      Clipboard.setData(
                                          ClipboardData(text: inpoutText.text));
                                    },
                                    icon: const Icon(Icons.copy)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      context
                          .toName(LanguageListPage.route,arguments: glotran.from)
                          .then((value) async {
                        if (value != null) {
                          final pref = await SharedPreferences.getInstance();
                          pref.setString(SharedPrefKey.inputTranslateCountry,
                              value.toString());
                          glotran.from = value.toString().split(',')[0];
                          fromLanguage =value.toString().split(',')[1];
                          NotificationController.createNewNotification();
                          inpoutText.text='';
                          _translateData.outputData = '';
                          dynamic supportLan =await flutterTtsoutput.getLanguages;
                          String? selectedType;
                          for (var sup in supportLan) {
                            if (sup.toString().toLowerCase().startsWith(value.toString().split(',')[0])) {
                              selectedType=sup;
                            }
                          }
                          if (selectedType != null) {
                            inputlanguage = selectedType;
                          }
                          setState(() {});
                        }
                      });
                    },
                    child: Text(
                      fromLanguage,
                      style: DTextStyle.translateCountryName,
                    )),
                IconButton(
                  onPressed: () async {
                    String tempfromData = '${glotran.from},$fromLanguage';
                    String temptoData = '${glotran.to},$toLanguage';
                    final pref = await SharedPreferences.getInstance();
                    pref.setString(
                        SharedPrefKey.inputTranslateCountry, temptoData);
                    pref.setString(
                        SharedPrefKey.translateCountry, tempfromData);
                    glotran.from = temptoData.split(',')[0];
                    glotran.to = tempfromData.split(',')[0];
                    fromLanguage = temptoData.split(',')[1];
                    toLanguage = tempfromData.split(',')[1];
                    if (_translateData.outputData != null &&
                        _translateData.outputData!.isNotEmpty) {
                      inpoutText.text = _translateData.outputData!;
                      final translator = GoogleTranslator();
                      var translation = await translator.translate(
                          inpoutText.text,
                          from: glotran.from,
                          to: glotran.to);
                      _translateData.outputData = translation.toString();
                    }

                    dynamic supportLan = await flutterTtsoutput.getLanguages;
                    String? selectedType;
                    String? selectInType;
                    for (var sup in supportLan) {
                      if (sup.toString().toLowerCase().startsWith(glotran.to)) {
                        selectedType = sup;
                      }
                    }
                    for (var sup in supportLan) {
                      if (sup.toString().toLowerCase().startsWith(glotran.from)) {
                        selectInType = sup;
                      }
                    }
                    if (selectInType != null) {
                      inputlanguage=selectInType;
                    }
                    if (selectedType != null) {
                      outputlanguage = selectedType;
                    }
                    NotificationController.createNewNotification();
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.forward_rounded,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      context
                          .toName(LanguageListPage.route,arguments: glotran.to)
                          .then((value) async {
                        if (value != null) {
                          final pref = await SharedPreferences.getInstance();
                          pref.setString(
                              SharedPrefKey.translateCountry, value.toString());
                          glotran.to = value.toString().split(',')[0];
                          toLanguage = value.toString().split(',')[1];
                          dynamic supportLan =await flutterTtsoutput.getLanguages;
                          String? selectedType;
                          for (var sup in supportLan) {
                            if (sup.toString().toLowerCase().startsWith(value.toString().split(',')[0])) {
                              selectedType=sup;
                            }
                          }
                          if (selectedType != null) {
                            outputlanguage = selectedType;
                            flutterTtsoutput.setLanguage(outputlanguage!);
                            if (inpoutText.text.isNotEmpty) {
                            final translator = GoogleTranslator();
                          var translation = await translator.translate(
                            inpoutText.text,
                            from: glotran.from,
                            to: glotran.to);
                        _translateData.outputData = translation.toString();
                          }
                          }
                          NotificationController.createNewNotification();
                          setState(() {});
                        }
                      });
                    },
                    child: Text(
                      toLanguage,
                      style: DTextStyle.translateCountryName,
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 8, 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(0),
              fixedSize: Size(MediaQuery.of(context).size.width - 30,  MediaQuery.of(context).size.height * 0.15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))
                ),
                onPressed: (){},
                child: Stack(
                    children: [
                      editing
                          ? Text(
                              'Editing...',
                              style: DTextStyle.translateData,
                            )
                          : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.17,
                            width: MediaQuery.of(context).size.width,
                            child: ListView(
                              children: [
                                Text(
                                    _translateData.outputData!,
                                    style: DTextStyle.translateData,
                                  ),
                              ],
                            ),
                          ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Visibility(
                            visible: outputlanguage != null
                                ? outputlanguage!
                                    .toLowerCase()
                                    .startsWith(glotran.to)
                                : false,
                            child: IconButton(
                                icon: const Icon(Icons.volume_up),
                                onPressed: () => {
                                      flutterTtsoutput
                                          .setLanguage(outputlanguage!),
                                      _translateoutput(
                                          _translateData.outputData!)
                                    }),
                          ),
                            IconButton(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(
                                      text: _translateData.outputData!));
                                },
                                icon: const Icon(Icons.copy)),
                          ],
                        ),
                      )
                    ],
                  ),
              ),
            ),
            // Container(
            //   margin: const EdgeInsets.all(10),
            //   height: MediaQuery.of(context).size.height * 0.15,
            //   width: MediaQuery.of(context).size.width,
            //   decoration: BoxDecoration(
            //       color: Colors.blue,
            //       borderRadius: BorderRadius.circular(30),
            //       border: Border.all(color: Colors.deepPurple)),
            //   child: 
            // ),
            const Column(
              children: [Text('History')],
            ),
          ],
        ),
      ),
    );
  }
}
