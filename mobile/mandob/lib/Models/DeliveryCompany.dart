import 'dart:io';

import 'package:almandobUAE/Services/interface.dart';

class DeliveryCompany extends ModelInterface {
  int? id;
  String? password;
  Null? lastLogin;
  bool? isSuperuser;
  String? name;
  int? phone;
  String? city;
  String? location;
  String? image;
  String? idDoc1;
  String? idDoc2;
  String? residentDoc1;
  String? residentDoc2;
  String? companyRegistration;
  String? companyDoc1;
  String? companyDoc2;
  String? companyDoc3;
  String? companyDoc4;
  String? companyDoc5;
  String? barcode;
  String? barcodeImage;
  String? latitude;
  String? longitude;
  int? balance;
  bool? isActive;
  String? updated;
  String? created;
  int? country;
  int? province;
  int? specialty;
  int? employee;

  DeliveryCompany({this.id, this.password, this.lastLogin, this.isSuperuser, this.name, this.phone, this.city, this.location, this.image, this.idDoc1, this.idDoc2, this.residentDoc1, this.residentDoc2, this.companyRegistration, this.companyDoc1, this.companyDoc2, this.companyDoc3, this.companyDoc4, this.companyDoc5, this.barcode, this.barcodeImage, this.latitude, this.longitude, this.balance, this.isActive, this.updated, this.created, this.country, this.province, this.specialty, this.employee});

  dynamic fromJson(Map<String, dynamic> json) {
    return DeliveryCompany(
      id: json['id'],
      password: json['password'],
      lastLogin: json['last_login'],
      isSuperuser: json['is_superuser'],
      name: json['name'],
      phone: json['phone'],
      city: json['city'],
      location: json['location'],
      image: json['image'],
      idDoc1: json['id_doc1'],
      idDoc2: json['id_doc2'],
      residentDoc1: json['resident_doc1'],
      residentDoc2: json['resident_doc2'],
      companyRegistration: json['company_registration'],
      companyDoc1: json['company_doc1'],
      companyDoc2: json['company_doc2'],
      companyDoc3: json['company_doc3'],
      companyDoc4: json['company_doc4'],
      companyDoc5: json['company_doc5'],
      barcode: json['barcode'],
      barcodeImage: json['barcode_image'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      balance: json['balance'],
      isActive: json['is_active'],
      updated: json['updated'],
      created: json['created'],
      country: json['country'],
      province: json['province'],
      specialty: json['specialty'],
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
    data['image'] = this.image;
    data['id_doc1'] = this.idDoc1;
    data['id_doc2'] = this.idDoc2;
    data['resident_doc1'] = this.residentDoc1;
    data['resident_doc2'] = this.residentDoc2;
    data['company_registration'] = this.companyRegistration;
    data['company_doc1'] = this.companyDoc1;
    data['company_doc2'] = this.companyDoc2;
    data['company_doc3'] = this.companyDoc3;
    data['company_doc4'] = this.companyDoc4;
    data['company_doc5'] = this.companyDoc5;
    data['barcode'] = this.barcode;
    data['barcode_image'] = this.barcodeImage;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['balance'] = this.balance;
    data['is_active'] = this.isActive;
    data['updated'] = this.updated;
    data['created'] = this.created;
    data['country'] = this.country;
    data['province'] = this.province;
    data['specialty'] = this.specialty;
    data['employee'] = this.employee;
    return data;
  }
}
