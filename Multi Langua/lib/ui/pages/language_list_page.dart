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
      appBar: AppBar(
        title: const Text('Country List'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: SafeArea(
        child: Column(
          children: [
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
    );
  }

  Widget _countryListUi(int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
      child: Opacity(
        opacity: widget.selectedCode == countryModel[index].languageCode ? 0.3 : 1.0 ,
        child: GestureDetector(
          onTap: () {
            if (widget.selectedCode == countryModel[index].languageCode) {
              return;
            }
            Navigator.of(context).pop(
                '${countryModel[index].languageCode!},${countryModel[index].languageName!}');
          },
          child: Container(
            height: 45,
            width: MediaQuery.of(context).size.width * 0.01,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.03,),
                    // Image.network(countryModel[index].countryImage!,
                    // ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.2,),
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
            ),
          ),
        ),
      ),
    );
  }
}
