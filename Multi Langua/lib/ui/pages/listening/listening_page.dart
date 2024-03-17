import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dict/config/context_ext.dart';
import 'package:dict/model/listening_question.dart';
import 'package:dict/ui/pages/dashboard/translate_page.dart';
import 'package:dict/ui/pages/listen_result_page/listen_result_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:developer';
part 'mixin/listening_page_mixin.dart';

class ListeningPage extends StatefulWidget {
  const ListeningPage({super.key});

  @override
  State<ListeningPage> createState() => _ListeningPageState();
}

class _ListeningPageState extends State<ListeningPage> with _ListeningPageMixin{
  

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: const BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
      ),
      child: listenQust != null && listenQust!.isNotEmpty ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                color: Colors.red,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: IconButton(onPressed: () async{
                  if (play) {
                    return;
                  }
                  await flutterTts.setLanguage('en-GB');
                  await flutterTts.setVolume(volume);
                  await flutterTts.setSpeechRate(rate);
                    
                  play=!play;
                  int i=0;
                  while (i < listenQust!.length) {
                    await flutterTts.setVoice({'name': 'en-us-x-sfg#male_1-local', 'locale': 'en-US'});
                                await flutterTts.setPitch(listenQust![i].p1!);
                                if (listenQust![i].v1!.isNotEmpty) {
                                  await flutterTts.speak(listenQust![i].v1!);
                                }
                                await Future.delayed(
                                    const Duration(seconds: 1));
                                await flutterTts.setVoice({'name': 'en-us-x-sfg#female_1-local', 'locale': 'en-US'});
                                await flutterTts.setPitch(listenQust![i].p2!);
                                if (listenQust![i].v2!.isNotEmpty) {
                                  await flutterTts.speak(listenQust![i].v2!);
                                }
                                await Future.delayed(
                                    const Duration(seconds: 1));
                                await flutterTts.setVoice({'name':  'en-us-x-sfg#male_1-local', 'locale': 'en-US'});
                                await flutterTts.setPitch(listenQust![i].p3!);
                                if (listenQust![i].v3!.isNotEmpty) {
                                  await flutterTts.speak(listenQust![i].v3!);
                                }
                                if (i == listenQust!.length - 1) {
                                  break;
                                }
                                await Future.delayed(
                                    const Duration(seconds: 5));
                                i++;
                              }
                  setState(() {
                    play=!play;
                  });
                }, icon: play ? const Icon(Icons.pause) : const Icon(Icons.play_arrow)),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: listenQust!.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 5,);
              },
              itemBuilder: (BuildContext context,index){
              
                    return Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 10,),
                    const Text('A',style: TextStyle(fontSize: 17),),
                    RadioMenuButton(
                              value: listenQust![index].answers!.a!,
                              groupValue: listenQust![index].result,
                              onChanged: (value) {
                                listenQust![index].result=value;
                                setState(() {});
                              },
                               child: Text(listenQust![index].answers!.a!),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 10,),
                    const Text('B',style: TextStyle(fontSize: 17),),
                    RadioMenuButton(
                              value: listenQust![index].answers!.b!,
                              groupValue: listenQust![index].result,
                              onChanged: (value) {
                                listenQust![index].result=value;
                                setState(() {});
                              },
                              child: Text(listenQust![index].answers!.b!)),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 10,),
                    const Text('C',style: TextStyle(fontSize: 17),),
                    RadioMenuButton(
                              value: listenQust![index].answers!.c!,
                              groupValue: listenQust![index].result,
                              onChanged: (value) {
                                listenQust![index].result=value;
                                setState(() {});
                              },
                              child: Text(listenQust![index].answers!.c!)),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 10,),
                    const Text('D',style: TextStyle(fontSize: 17),),
                    RadioMenuButton(
                              value: listenQust![index].answers!.d!,
                              groupValue: listenQust![index].result,
                              onChanged: (value) {
                                listenQust![index].result=value;
                                setState(() {});
                              },
                              child: Text(listenQust![index].answers!.d!)
                              ),
                  ],
                )
              ],
            ),
                    );
                  }),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(onPressed: (){
              context.toName(ListenResultPage.route, arguments: listenQust);
            }, child: const Text('Submit')),
          )
        ],
      ) : Container()
    );
  }
}