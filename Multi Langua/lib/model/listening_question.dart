class ListenQuest {
  String? v1;
  String? v2;
  String? v3;
  double? p1;
  double? p2;
  double? p3;
  Answers? answers;
  String? result;
  bool? qstatus;
  ListenQuest(
      {this.v1, this.v2, this.v3, this.p1, this.p2, this.p3, this.answers,this.result,this.qstatus});

  ListenQuest.fromJson(Map<String, dynamic> json) {
    v1 = json['V1'];
    v2 = json['V2'];
    v3 = json['V3'];
    p1 = json['P1'];
    p2 = json['P2'];
    p3 = json['P3'];
    answers = Answers.fromJson(json['Answer']);
  }
}

class Answers {
  String? a;
  String? b;
  String? c;
  String? d;
  String? ca;
  Answers({this.a, this.b, this.c, this.d, this.ca});
  Answers.fromJson(Map<String, dynamic> json) {
    a = json['A'];
    b = json['B'];
    c = json['C'];
    d = json['D'];
    ca = json['CA'];
  }
}
