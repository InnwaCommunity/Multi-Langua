part of '../my_home_page.dart';

mixin _HomePageMixin on State<MyHomePage> {
 
  late TabController _tabController;

  final List<Tab> myTabs = const [
    Tab(child: Text('Translate')),
    Tab(child: Text('Listening')),
    Tab(child: Text('Reading'),),
    Tab(child: Text('Speaking'),)
  ];


}