part of '../language_list_page.dart';

mixin _CountryListPageMixin on State<LanguageListPage>{
  List<CountryModel> countryModel=[];
  ScrollController countryListView=ScrollController();
  @override
  void initState() {
    loadCountry();
    super.initState();
  }

  Future<void> loadCountry() async{
      String data = await rootBundle.loadString('assets/json_file/language.json');
      var jsonResult = jsonDecode(data);
      countryModel=(jsonResult as List).map((e) => CountryModel.fromJson(e)).toList();
      setState(() {});
  }
}