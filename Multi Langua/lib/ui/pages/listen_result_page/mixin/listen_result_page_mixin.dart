part of '../listen_result_page.dart';

mixin _ListenResultPageMixin on State<ListenResultPage> {
  int? all;
  int? correct=0;
  int? incorrect=0;
  double? percentage;
  @override
  void initState() {
    super.initState();
    all=widget.listenQuestlist.length;
    for (var i = 0; i < widget.listenQuestlist.length; i++) {
      if (widget.listenQuestlist[i].result != null &&
          widget.listenQuestlist[i].result ==
              widget.listenQuestlist[i].answers!.ca!) {
        correct = correct! + 1;
      } else {
        incorrect = incorrect! + 1;
      }
    }
    correct ??= 0;
    incorrect ??= 0;
    percentage = (correct!/all!) * 100;
  }

}