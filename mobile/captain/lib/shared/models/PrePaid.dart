import 'interface.dart';

class PrePaid extends ModelInterface{
  int? id;
  String? userType;
  String? code;
  int? amount;
  bool? isActive;
  String? updated;
  String? created;
  int? user;
  int? company;
  int? captain;
  int? mandob;
  int? employee;

  PrePaid(
      {this.id,
        this.userType,
        this.code,
        this.amount,
        this.isActive,
        this.updated,
        this.created,
        this.user,
        this.company,
        this.captain,
        this.mandob,
        this.employee});

  @override
  dynamic fromJson(Map<String, dynamic> json) {
    return PrePaid(
        id : json['id'],
        userType : json['user_type'],
        code : json['code'],
    amount : json['amount'],
    isActive : json['is_active'],
    updated : json['updated'],
    created : json['created'],
    user : json['user'],
    company : json['company'],
    captain : json['captain'],
    mandob : json['mandob'],
        employee : json['employee'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_type'] = this.userType;
    data['code'] = this.code;
    data['amount'] = this.amount;
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