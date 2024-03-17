import 'package:dict/model/listening_question.dart';
import 'package:flutter/material.dart';
part 'mixin/listen_result_page_mixin.dart';
class ListenResultPage extends StatefulWidget {
  final List<ListenQuest> listenQuestlist;
  static const route='listenResult';
  const ListenResultPage({required this.listenQuestlist, super.key});

  @override
  State<ListenResultPage> createState() => _ListenResultPageState();
}

class _ListenResultPageState extends State<ListenResultPage> with _ListenResultPageMixin{
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result'),),
      body: all != null && correct != null && incorrect != null ?  
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Container(
                height: 30,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: const Center(child: Text('All',style: TextStyle(color: Colors.white,fontSize: 17),))),
              Text( all!.toString())
            ],
          ),
          Column(
            children: [
              Container(
                height: 30,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: const Center(child: Text('Correct',style: TextStyle(color: Colors.white,fontSize: 17),))),
              
              Text(correct!.toString()),
            ],
          ),
          Column(
            children: [
              Container(
                height: 30,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: const Center(child: Text('Incorrect',style: TextStyle(color: Colors.white,fontSize: 17),))),
              
              Text(incorrect!.toString())
            ],
          ),
          Column(
            children: [
              Container(
                height: 30,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: const Center(child: Text('%',style: TextStyle(color: Colors.white,fontSize: 17),))),
              
              Text('${percentage!.toString()}%')
            ],
          )
        ],
      )
      // Column(
      //   children: [
      //     const Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         Text(
      //           'Total'
      //         ),
      //         Text('Correct'),
      //         Text('Incorrect')
      //       ],
      //     ),
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         Text(
      //           all!.toString()
      //         ),
      //         Text(correct!.toString()),
      //         Text(incorrect!.toString())
      //       ],
      //     )
      //   ],
      // )
       : Container(),
    );
  }
}