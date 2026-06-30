import 'interface.dart';

class Notification extends ModelInterface{
  int? id;
  String? userType;
  String? title;
  String? text;
  bool? isActive;
  String? updated;
  String? created;
  int? user;
  int? company;
  int? captain;
  int? mandob;
  int? employee;

  Notification(
      {this.id,
        this.userType,
        this.title,
        this.text,
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
    return Notification(
        id : json['id'],
        userType : json['user_type'],
        title : json['title'],
    text : json['text'],
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
    data['title'] = this.title;
    data['text'] = this.text;
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