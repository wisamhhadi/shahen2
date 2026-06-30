import 'package:almandobUAE/Services/interface.dart';

class Report extends ModelInterface {
  int? id;
  String? day;
  String? time;
  String? type;
  bool? isActive;
  String? updated;
  String? created;
  int? mandob;

  Report({this.id, this.day, this.time, this.type, this.isActive, this.updated, this.created, this.mandob});

  dynamic fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      day: json['day'],
      time: json['time'],
      type: json['type'],
      isActive: json['is_active'],
      updated: json['updated'],
      created: json['created'],
      mandob: json['mandob'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['day'] = this.day;
    data['time'] = this.time;
    data['type'] = this.type;
    data['is_active'] = this.isActive;
    data['updated'] = this.updated;
    data['created'] = this.created;
    data['mandob'] = this.mandob;
    return data;
  }
}
