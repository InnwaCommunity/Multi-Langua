import 'package:dict/ui/pages/dashboard/translate_page.dart';
import 'package:dict/ui/pages/listening/listening_page.dart';
import 'package:flutter/material.dart';
part 'mixin/home_page_mixin.dart';

class MyHomePage extends StatefulWidget {
  static const String route = '/';
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with _HomePageMixin, TickerProviderStateMixin {
      
  @override
  void initState() {
    _tabController = TabController(length: myTabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: myTabs.length,
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                unselectedLabelColor: const Color(0xFF8B8B8B),
                labelColor: const Color(0xFF00B8E9),
                labelPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                indicatorColor: const Color(0xFF00B8E9),
                tabs: myTabs,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    TranslatePage(),
                    ListeningPage(),
                    TranslatePage(),
                    ListeningPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}