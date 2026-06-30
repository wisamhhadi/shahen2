import 'package:almandobUAE/Services/interface.dart';

class QuestionChose extends ModelInterface {
  int? id;
  String? choiceText;
  int? order;
  bool? isActive;
  String? updated;
  String? created;
  int? question;

  QuestionChose(
      {this.id,
      this.choiceText,
      this.order,
      this.isActive,
      this.updated,
      this.created,
      this.question});

  dynamic fromJson(Map<String, dynamic> json) {
    return QuestionChose(
      id: json['id'],
      choiceText: json['choice_text'],
      order: json['order'],
      isActive: json['is_active'],
      updated: json['updated'],
      created: json['created'],
      question: json['question'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['choice_text'] = this.choiceText;
    data['order'] = this.order;
    data['is_active'] = this.isActive;
    data['updated'] = this.updated;
    data['created'] = this.created;
    data['question'] = this.question;
    return data;
  }
}
