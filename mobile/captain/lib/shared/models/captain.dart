import 'interface.dart';
class Captain extends ModelInterface{
  int? id;
  String? password;
  String? lastLogin;
  bool? isSuperuser;
  String? name;
  int? phone;
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
  String? latitudeBase;
  String? longitudeBase;
  String? latitude;
  String? longitude;
  String? status;
  String? pin;
  String? deviceId;
  bool? isLogged;
  String? idNumber;
  String? idIssueCity;
  String? idIssueDate;
  String? idExpireDate;
  String? idBirthDate;
  String? houseIdIssuer;
  String? houseIdHouseNumber;
  String? houseIdHouseStreet;
  String? houseIdHouseCity;
  String? drivingIdExpire;
  bool? isActive;
  String? updated;
  String? updatedtime;
  String? created;
  int? company;
  int? car;
  int? country;
  int? province;
  int? appLanguage;
  int? employee;
  List<int>? languages;

  Captain(
      {this.id,
        this.password,
        this.lastLogin,
        this.isSuperuser,
        this.name,
        this.phone,
        this.city,
        this.location,
        this.note,
        this.image,
        this.personalIdDoc1,
        this.personalIdDoc2,
        this.carIdDoc1,
        this.carIdDoc2,
        this.agencyDoc,
        this.residentDoc1,
        this.residentDoc2,
        this.barcode,
        this.barcodeImage,
        this.latitudeBase,
        this.longitudeBase,
        this.latitude,
        this.longitude,
        this.status,
        this.pin,
        this.deviceId,
        this.isLogged,
        this.idNumber,
        this.idIssueCity,
        this.idIssueDate,
        this.idExpireDate,
        this.idBirthDate,
        this.houseIdIssuer,
        this.houseIdHouseNumber,
        this.houseIdHouseStreet,
        this.houseIdHouseCity,
        this.drivingIdExpire,
        this.isActive,
        this.updated,
        this.updatedtime,
        this.created,
        this.company,
        this.car,
        this.country,
        this.province,
        this.appLanguage,
        this.employee,
        this.languages});

  @override
  dynamic fromJson(Map<String, dynamic> json) {
    return Captain(
        id : json['id'],
        password : json['password'],
        lastLogin : json['last_login'],
        isSuperuser : json['is_superuser'],
        name : json['name'],
        phone : json['phone'],
        city : json['city'],
        location : json['location'],
        note : json['note'],
        image : json['image'],
        personalIdDoc1 : json['personal_id_doc1'],
        personalIdDoc2 : json['personal_id_doc2'],
        carIdDoc1 : json['car_id_doc1'],
    carIdDoc2 : json['car_id_doc2'],
    agencyDoc : json['agency_doc'],
    residentDoc1 : json['resident_doc1'],
    residentDoc2 : json['resident_doc2'],
    barcode : json['barcode'],
    barcodeImage : json['barcode_image'],
    latitudeBase : json['latitude_base'],
    longitudeBase : json['longitude_base'],
    latitude : json['latitude'],
    longitude : json['longitude'],
    status : json['status'],
    pin : json['pin'],
    deviceId : json['device_id'],
    isLogged : json['is_logged'],
    idNumber : json['id_number'],
    idIssueCity : json['id_issue_city'],
    idIssueDate : json['id_issue_date'],
    idExpireDate : json['id_expire_date'],
    idBirthDate : json['id_birth_date'],
    houseIdIssuer : json['house_id_issuer'],
    houseIdHouseNumber : json['house_id_house_number'],
    houseIdHouseStreet : json['house_id_house_street'],
    houseIdHouseCity : json['house_id_house_city'],
    drivingIdExpire : json['driving_id_expire'],
    isActive : json['is_active'],
    updated : json['updated'],
    updatedtime : json['updatedtime'],
    created : json['created'],
    company : json['company'],
    car : json['car'],
    country : json['country'],
    province : json['province'],
    appLanguage : json['app_language'],
    employee : json['employee'],
    languages : json['languages'].cast<int>(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['password'] = this.password;
    data['last_login'] = this.lastLogin;
    data['is_superuser'] = this.isSuperuser;
    data['name'] = this.name;
    data['phone'] = this.phone;
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
    data['latitude_base'] = this.latitudeBase;
    data['longitude_base'] = this.longitudeBase;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['status'] = this.status;
    data['pin'] = this.pin;
    data['device_id'] = this.deviceId;
    data['is_logged'] = this.isLogged;
    data['id_number'] = this.idNumber;
    data['id_issue_city'] = this.idIssueCity;
    data['id_issue_date'] = this.idIssueDate;
    data['id_expire_date'] = this.idExpireDate;
    data['id_birth_date'] = this.idBirthDate;
    data['house_id_issuer'] = this.houseIdIssuer;
    data['house_id_house_number'] = this.houseIdHouseNumber;
    data['house_id_house_street'] = this.houseIdHouseStreet;
    data['house_id_house_city'] = this.houseIdHouseCity;
    data['driving_id_expire'] = this.drivingIdExpire;
    data['is_active'] = this.isActive;
    data['updated'] = this.updated;
    data['updatedtime'] = this.updatedtime;
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