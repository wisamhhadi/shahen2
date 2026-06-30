import 'interface.dart';

class Blog extends ModelInterface{
  int? id;
  String? title;
  String? body;
  String? image;
  bool? isActive;
  String? updated;
  String? created;
  int? employee;

  Blog(
      {this.id,
        this.title,
        this.body,
        this.image,
        this.isActive,
        this.updated,
        this.created,
        this.employee});

  @override
  dynamic fromJson(Map<String, dynamic> json) {
    return Blog(
        id : json['id'],
        title : json['title'],
        body : json['body'],
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
    data['title'] = this.title;
    data['body'] = this.body;
    data['image'] = this.image;
    data['is_active'] = this.isActive;
    data['updated'] = this.updated;
    data['created'] = this.created;
    data['employee'] = this.employee;
    return data;
  }
}