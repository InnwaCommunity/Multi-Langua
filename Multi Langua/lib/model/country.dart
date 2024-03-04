class CountryModel {
  String? languageName;
  String? languageCode;
  // String? countryImage;
  CountryModel(this.languageName, this.languageCode);

  CountryModel.fromJson(Map<String, dynamic> json) {
    languageName = json['language'];
    languageCode = json['code'];
  }
}
