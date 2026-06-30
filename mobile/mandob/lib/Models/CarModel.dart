import 'package:almandobUAE/Services/interface.dart';

class CarModel extends ModelInterface {
  int? id;
  String? name;
  bool? isActive;
  String? updated;
  String? created;
  Null? carCompany;
  Null? employee;

  CarModel({this.id, this.name, this.isActive, this.updated, this.created, this.carCompany, this.employee});

  dynamic fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      name: json['name'],
      isActive: json['is_active'],
      updated: json['updated'],
      created: json['created'],
      carCompany: json['car_company'],
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
    data['car_company'] = this.carCompany;
    data['employee'] = this.employee;
    return data;
  }
}
