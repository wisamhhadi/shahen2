import 'package:almandobUAE/Services/interface.dart';

class CustomReport extends ModelInterface{
  int? id;
  String? targetType;
  String? title;
  bool? isActive;
  String? updated;
  String? created;
  int? mandob;
  

  CustomReport(
      {this.id,
      this.targetType,
      this.title,
      this.isActive,
      this.updated,
      this.created,
      this.mandob});

  dynamic fromJson(Map<String, dynamic> json) {
    return CustomReport(
      id : json['id'],
    targetType : json['target_type'],
    title : json['title'],
    isActive : json['is_active'],
    updated : json['updated'],
    created : json['created'],
    mandob : json['mandob'],
    ) ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['target_type'] = this.targetType;
    data['title'] = this.title;
    data['is_active'] = this.isActive;
    data['updated'] = this.updated;
    data['created'] = this.created;
    data['mandob'] = this.mandob;
    return data;
  }
}
