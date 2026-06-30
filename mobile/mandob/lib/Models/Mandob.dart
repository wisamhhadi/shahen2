import 'package:almandobUAE/Services/interface.dart';

class Mandob extends ModelInterface {
  int? id;
  String? password;
  Null? lastLogin;
  bool? isSuperuser;
  int? phone;
  String? name;
  String? location;
  int? registrationFee;
  int? salary;
  String? note;
  String? shiftStart;
  String? shiftStop;
  String? latitude;
  String? longitude;
  String? latitude2;
  String? longitude2;
  String? city;
  int? radius;
  String? image;
  int? captain_goal;
  int? user_goal;
  int? company_goal;
  int? delivery_company_goal;
  int? car_goal;

  String? idDoc1;
  String? idDoc2;
  String? residentDoc1;
  String? residentDoc2;
  String? attachment1;
  String? attachment2;
  String? status;
  int? balance;
  bool? isActive;
  bool? isfree;
  bool? isLogged;
  String? updated;
  String? created;
  int? admin;
  int? appLanguage;
  int? employee;

  Mandob({this.id, this.password, this.isLogged , this.lastLogin, this.isfree , this.isSuperuser, this.car_goal, this.phone, this.name, this.location, this.registrationFee, this.salary, this.note, this.shiftStart, this.captain_goal, this.company_goal, this.delivery_company_goal, this.user_goal, this.shiftStop, this.latitude, this.longitude, this.latitude2, this.longitude2, this.radius, this.image, this.idDoc1, this.idDoc2, this.residentDoc1, this.residentDoc2, this.attachment1, this.attachment2, this.status, this.balance, this.isActive, this.updated, this.created, this.admin, this.appLanguage, this.employee, this.city});

  dynamic fromJson(Map<String, dynamic> json) {
    return Mandob(
      id: json['id'],
      password: json['password'],
      lastLogin: json['last_login'],
      isSuperuser: json['is_superuser'],
      phone: json['phone'],
      name: json['name'],
      location: json['location'],
      registrationFee: json['registration_fee'],
      salary: json['salary'],
      note: json['note'],
      shiftStart: json['shift_start'],
      shiftStop: json['shift_stop'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      latitude2: json['latitude2'],
      longitude2: json['longitude2'],
      city: json['city'],
      radius: json['radius'],
      image: json['image'],
      captain_goal: json['captain_goal'],
      user_goal: json['user_goal'],
      company_goal: json['company_goal'],
      delivery_company_goal: json['delivery_company_goal'],
      car_goal: json['car_goal'],
      idDoc1: json['id_doc1'],
      idDoc2: json['id_doc2'],
      residentDoc1: json['resident_doc1'],
      residentDoc2: json['resident_doc2'],
      attachment1: json['attachment1'],
      attachment2: json['attachment2'],
      status: json['status'],
      balance: json['balance'],
      isActive: json['is_active'],
      isfree: json['is_free'],
      isLogged: json['is_logged'],
      updated: json['updated'],
      created: json['created'],
      admin: json['admin'],
      appLanguage: json['app_language'],
      employee: json['employee'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['password'] = this.password;
    data['last_login'] = this.lastLogin;
    data['is_superuser'] = this.isSuperuser;
    data['phone'] = this.phone;
    data['name'] = this.name;

    data['location'] = this.location;
    data['registration_fee'] = this.registrationFee;
    data['salary'] = this.salary;
    data['note'] = this.note;
    data['shift_start'] = this.shiftStart;
    data['shift_stop'] = this.shiftStop;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['latitude2'] = this.latitude2;
    data['longitude2'] = this.longitude2;
    data['city'] = this.city;
    data['radius'] = this.radius;
    data['image'] = this.image;

    data['captain_goal'] = this.captain_goal;
    data['user_goal'] = this.user_goal;
    data['company_goal'] = this.company_goal;
    data['delivery_company_goal'] = this.delivery_company_goal;
    data['car_goal'] = this.car_goal;

    data['id_doc1'] = this.idDoc1;
    data['id_doc2'] = this.idDoc2;
    data['resident_doc1'] = this.residentDoc1;
    data['resident_doc2'] = this.residentDoc2;
    data['attachment1'] = this.attachment1;
    data['attachment2'] = this.attachment2;
    data['status'] = this.status;
    data['balance'] = this.balance;
    data['is_active'] = this.isActive;
    data['is_free'] = this.isfree;
    data['is_logged'] = this.isLogged;
    data['updated'] = this.updated;
    data['created'] = this.created;
    data['admin'] = this.admin;
    data['app_language'] = this.appLanguage;
    data['employee'] = this.employee;
    return data;
  }
}
