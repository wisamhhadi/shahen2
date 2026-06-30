import 'dart:io';

import 'package:almandobUAE/Services/interface.dart';

class Users extends ModelInterface {
  int? id;
  String? password;
  String? lastLogin;
  bool? isSuperuser;
  String? name;
  int? phone;
  String? city;
  String? location;
  int? maxDebt;
  String? image;
  String? idDoc1;
  String? barcode;
  String? barcodeImage;
  String? latitude;
  String? longitude;
  String? type;
  bool? isActive;
  String? updated;
  String? created;
  int? language;
  int? country;
  int? province;
  String? employee;

  Users({this.id, this.password, this.lastLogin, this.isSuperuser, this.name, this.phone, this.city, this.location, this.maxDebt, this.image, this.idDoc1, this.barcode, this.barcodeImage, this.latitude, this.longitude, this.type, this.isActive, this.updated, this.created, this.language, this.country, this.province, this.employee});

  dynamic fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      password: json['password'],
      lastLogin: json['last_login'],
      isSuperuser: json['is_superuser'],
      name: json['name'],
      phone: json['phone'],
      city: json['city'],
      location: json['location'],
      maxDebt: json['max_debt'],
      image: json['image'],
      idDoc1: json['id_doc1'],
      barcode: json['barcode'],
      barcodeImage: json['barcode_image'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      type: json['type'],
      isActive: json['is_active'],
      updated: json['updated'],
      created: json['created'],
      language: json['language'],
      country: json['country'],
      province: json['province'],
      employee: json['employee'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['password'] = this.password;
    data['last_login'] = this.lastLogin;
    data['is_superuser'] = this.isSuperuser;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['city'] = this.city;
    data['location'] = this.location;
    data['max_debt'] = this.maxDebt;
    data['image'] = this.image;
    data['id_doc1'] = this.idDoc1;
    data['barcode'] = this.barcode;
    data['barcode_image'] = this.barcodeImage;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['type'] = this.type;
    data['is_active'] = this.isActive;
    data['updated'] = this.updated;
    data['created'] = this.created;
    data['language'] = this.language;
    data['country'] = this.country;
    data['province'] = this.province;
    data['employee'] = this.employee;
    return data;
  }
}
