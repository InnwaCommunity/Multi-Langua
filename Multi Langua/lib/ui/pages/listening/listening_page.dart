import 'package:flutter/material.dart';
part 'mixin/listening_page_mixin.dart';

class ListeningPage extends StatefulWidget {
  const ListeningPage({super.key});

  @override
  State<ListeningPage> createState() => _ListeningPageState();
}

class _ListeningPageState extends State<ListeningPage> with _ListeningPageMixin{
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Listening'),
    );
  }
}