import 'dart:convert';

import 'package:dict/model/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'mixin/language_list_page_mixin.dart';

class LanguageListPage extends StatefulWidget {
  static const String route='languageListPage';
  final String selectedCode;
  const LanguageListPage({required this.selectedCode, super.key});

  @override
  State<LanguageListPage> createState() => _LanguageListPageState();
}

class _LanguageListPageState extends State<LanguageListPage>
    with _CountryListPageMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Country List'),
      //   actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      // ),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              // backGround(),
              Expanded(
                child: ListView.builder(
                  controller: countryListView,
                    itemCount: countryModel.length,
                    itemBuilder: (context, index) {
                      return _countryListUi(index);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget backGround(){
    return Column(
      children: [
        Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _countryListUi(int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Opacity(
        opacity: widget.selectedCode == countryModel[index].languageCode ? 0.3 : 1.0 ,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(0),
            fixedSize: Size(MediaQuery.of(context).size.width * 0.01, 57),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))
          ),
          onPressed: (){
            if (widget.selectedCode == countryModel[index].languageCode) {
              return;
            }
            Navigator.of(context).pop(
                '${countryModel[index].languageCode!},${countryModel[index].languageName!}');
        }, child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 10,),
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue,
                      width: 2.5,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(48),
                      child: Center(
                        child: Text((index + 1).toString()),
                      ),
                    ),
                  ),
                ),
                // SizedBox(
                //   width: MediaQuery.of(context).size.width * 0.03,
                // ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                ),
                Text(countryModel[index].languageName!),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [Text(countryModel[index].languageCode!),
                SizedBox(width: MediaQuery.of(context).size.width * 0.03,),],
            ),
          ],
        ),),
        // child: GestureDetector(
        //   onTap: () {
            
        //   },
        //   child: 
        // ),
      ),
    );
  }
}
