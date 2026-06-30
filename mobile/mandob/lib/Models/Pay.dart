import 'package:almandobUAE/Services/interface.dart';

class Pay extends ModelInterface {
  int? id;
  String? userType;
  String? payType;
  int? amount;
  String? note;
  bool? isActive;
  String? updated;
  String? created;
  int? user;
  int? company;
  int? captain;
  int? mandob;
  int? employee;

  Pay({this.id, this.userType, this.payType, this.amount, this.note, this.isActive, this.updated, this.created, this.user, this.company, this.captain, this.mandob, this.employee});

  dynamic fromJson(Map<String, dynamic> json) {
    return Pay(
      id: json['id'],
      userType: json['user_type'],
      payType: json['pay_type'],
      amount: json['amount'],
      note: json['note'],
      isActive: json['is_active'],
      updated: json['updated'],
      created: json['created'],
      user: json['user'],
      company: json['company'],
      captain: json['captain'],
      mandob: json['mandob'],
      employee: json['employee'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['user_type'] = this.userType;
    data['pay_type'] = this.payType;
    data['amount'] = this.amount;
    data['note'] = this.note;
    data['is_active'] = this.isActive;
    data['updated'] = this.updated;
    data['created'] = this.created;
    data['user'] = this.user;
    data['company'] = this.company;
    data['captain'] = this.captain;
    data['mandob'] = this.mandob;
    data['employee'] = this.employee;
    return data;
  }
}
