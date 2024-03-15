import 'package:flutter/material.dart';
part 'mixin/speaking_page_mixin.dart';

class SpeakingPage extends StatefulWidget {
  const SpeakingPage({super.key});

  @override
  State<SpeakingPage> createState() => _SpeakingPageState();
}

class _SpeakingPageState extends State<SpeakingPage> with _SpeakingPageMixin{
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Speaking'),
    );
  }
}