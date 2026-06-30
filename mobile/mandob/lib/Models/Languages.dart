import 'package:almandobUAE/Services/interface.dart';

class Languages extends ModelInterface {
  int? id;
  String? name;
  bool? isActive;
  String? updated;
  String? created;
  Null? employee;

  Languages({this.id, this.name, this.isActive, this.updated, this.created, this.employee});

  dynamic fromJson(Map<String, dynamic> json) {
    return Languages(
      id: json['id'],
      name: json['name'],
      isActive: json['is_active'],
      updated: json['updated'],
      created: json['created'],
      employee: json['employee'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['name'] = this.name;
    data['is_active'] = this.isActive;
    data['updated'] = this.updated;
    data['created'] = this.created;
    data['employee'] = this.employee;
    return data;
  }
}
