import 'interface.dart';

class GoodsType extends ModelInterface{
  int? id;
  String? name;
  bool? isActive;
  String? updated;
  String? created;
  int? carCompany;
  int? employee;

  GoodsType(
      {this.id,
        this.name,
        this.isActive,
        this.updated,
        this.created,
        this.carCompany,
        this.employee});

  @override
  dynamic fromJson(Map<String, dynamic> json) {
    return GoodsType(
        id : json['id'],
        name : json['name'],
        isActive : json['is_active'],
    updated : json['updated'],
    created : json['created'],
    carCompany : json['car_company'],
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
    data['car_company'] = this.carCompany;
    data['employee'] = this.employee;
    return data;
  }
}