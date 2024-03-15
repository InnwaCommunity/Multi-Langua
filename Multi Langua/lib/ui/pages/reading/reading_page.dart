import 'package:flutter/material.dart';
part 'mixin/reading_page_mixin.dart';

class ReadingPage extends StatefulWidget {
  const ReadingPage({super.key});

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> with _ReadingPageMixin{
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Speaking'),
    );
  }
}