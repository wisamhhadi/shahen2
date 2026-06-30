import 'interface.dart';

class Language extends ModelInterface{
  int? id;
  String? name;
  bool? isActive;
  String? updated;
  String? created;
  int? employee;

  Language(
      {this.id,
        this.name,
        this.isActive,
        this.updated,
        this.created,
        this.employee});

  @override
  dynamic fromJson(Map<String, dynamic> json) {
    return Language(
        id : json['id'],
        name : json['name'],
        isActive : json['is_active'],
    updated : json['updated'],
    created : json['created'],
    employee : json['employee'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['is_active'] = this.isActive;
    data['updated'] = this.updated;
    data['created'] = this.created;
    data['employee'] = this.employee;
    return data;
  }
}