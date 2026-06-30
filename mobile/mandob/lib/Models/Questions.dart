import 'package:almandobUAE/Services/interface.dart';

class Questions extends ModelInterface {
  int? id;
  String? title;
  String? type;
  String? Answertype;

  bool? isActive;
  String? updated;
  String? created;
  int? customReport;

  Questions({this.id, this.customReport , this.title, this.type, this.Answertype, this.isActive, this.updated, this.created});

  dynamic fromJson(Map<String, dynamic> json) {
    return Questions(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      Answertype: json['answer_type'],
      isActive: json['is_active'],
      customReport: json['custom_report'],
      updated: json['updated'],
      created: json['created'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['title'] = this.title;
    data['type'] = this.type;
    data['answer_type'] = this.Answertype;
    data['is_active'] = this.isActive;
    data['custom_report'] = this.customReport;
    data['updated'] = this.updated;
    data['created'] = this.created;
    return data;
  }
}
