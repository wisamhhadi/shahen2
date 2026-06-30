import 'package:almandobUAE/Services/interface.dart';

class Goods extends ModelInterface {
  String? name;
  bool? isActive;
  Null? employee;

  Goods({this.name, this.isActive, this.employee});

  dynamic fromJson(Map<String, dynamic> json) {
    return Goods(
      name: json['name'],
      isActive: json['is_active'],
      employee: json['employee'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = this.name;
    data['is_active'] = this.isActive;
    data['employee'] = this.employee;
    return data;
  }
}
