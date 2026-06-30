import 'interface.dart';

class Banner extends ModelInterface {
  int? id;
  String? image;
  bool? isActive;
  String? updated;
  String? created;
  int? employee;

  Banner(
      {this.id,
        this.image,
        this.isActive,
        this.updated,
        this.created,
        this.employee});

  @override
  dynamic fromJson(Map<String, dynamic> json) {
    return Banner(
        id : json['id'],
        image : json['image'],
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
    data['image'] = this.image;
    data['is_active'] = this.isActive;
    data['updated'] = this.updated;
    data['created'] = this.created;
    data['employee'] = this.employee;
    return data;
  }
}