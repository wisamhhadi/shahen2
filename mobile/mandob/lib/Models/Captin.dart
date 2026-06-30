import 'package:almandobUAE/Services/interface.dart';

class Captain extends ModelInterface {
  int? id;
  String? password;
  Null? lastLogin;
  bool? isSuperuser;
  String? name;
  int? phone;
  String? idNumber;
  String? city;
  String? location;
  String? note;
  String? image;
  String? personalIdDoc1;
  String? personalIdDoc2;
  String? carIdDoc1;
  String? carIdDoc2;
  String? agencyDoc;
  String? residentDoc1;
  String? residentDoc2;
  String? barcode;
  String? barcodeImage;
  String? latitude;
  String? longitude;
  String? status;
  bool? isActive;
  String? updated;
  String? created;
  int? company;
  int? car;
  int? country;
  int? province;
  String? appLanguage;
  String? employee;
  List<int>? languages;

  Captain({this.id, this.password, this.lastLogin, this.isSuperuser, this.name, this.phone, this.idNumber, this.city, this.location, this.note, this.image, this.personalIdDoc1, this.personalIdDoc2, this.carIdDoc1, this.carIdDoc2, this.agencyDoc, this.residentDoc1, this.residentDoc2, this.barcode, this.barcodeImage, this.latitude, this.longitude, this.status, this.isActive, this.updated, this.created, this.company, this.car, this.country, this.province, this.appLanguage, this.employee, this.languages});

  dynamic fromJson(Map<String, dynamic> json) {
    return Captain(
      id: json['id'],
      password: json['password'],
      lastLogin: json['last_login'],
      isSuperuser: json['is_superuser'],
      name: json['name'],
      phone: json['phone'],
      idNumber: json['id_number'],
      city: json['city'],
      location: json['location'],
      note: json['note'],
      image: json['image'],
      personalIdDoc1: json['personal_id_doc1'],
      personalIdDoc2: json['personal_id_doc2'],
      carIdDoc1: json['car_id_doc1'],
      carIdDoc2: json['car_id_doc2'],
      agencyDoc: json['agency_doc'],
      residentDoc1: json['resident_doc1'],
      residentDoc2: json['resident_doc2'],
      barcode: json['barcode'],
      barcodeImage: json['barcode_image'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      status: json['status'],
      isActive: json['is_active'],
      updated: json['updated'],
      created: json['created'],
      company: json['company'],
      car: json['car'],
      country: json['country'],
      province: json['province'],
      appLanguage: json['app_language'],
      employee: json['employee'],
      languages: (json['languages'] as List?)?.map((e) => e as int).toList(),
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
    data['id_number'] = this.idNumber;
    data['city'] = this.city;
    data['location'] = this.location;
    data['note'] = this.note;
    data['image'] = this.image;
    data['personal_id_doc1'] = this.personalIdDoc1;
    data['personal_id_doc2'] = this.personalIdDoc2;
    data['car_id_doc1'] = this.carIdDoc1;
    data['car_id_doc2'] = this.carIdDoc2;
    data['agency_doc'] = this.agencyDoc;
    data['resident_doc1'] = this.residentDoc1;
    data['resident_doc2'] = this.residentDoc2;
    data['barcode'] = this.barcode;
    data['barcode_image'] = this.barcodeImage;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['status'] = this.status;
    data['is_active'] = this.isActive;
    data['updated'] = this.updated;
    data['created'] = this.created;
    data['company'] = this.company;
    data['car'] = this.car;
    data['country'] = this.country;
    data['province'] = this.province;
    data['app_language'] = this.appLanguage;
    data['employee'] = this.employee;
    data['languages'] = this.languages;
    return data;
  }
}
