import 'interface.dart';

class CarSize extends ModelInterface{
  int? id;
  String? name;
  String? maxLoad;
  bool? isActive;
  String? updated;
  String? created;
  int? employee;

  CarSize(
      {this.id,
        this.name,
        this.maxLoad,
        this.isActive,
        this.updated,
        this.created,
        this.employee});

  @override
  dynamic fromJson(Map<String, dynamic> json) {
    return CarSize(
        id : json['id'],
        name : json['name'],
        maxLoad : json['max_load'],
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
    data['max_load'] = this.maxLoad;
    data['is_active'] = this.isActive;
    data['updated'] = this.updated;
    data['created'] = this.created;
    data['employee'] = this.employee;
    return data;
  }
}