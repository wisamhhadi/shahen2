import 'interface.dart';

class Car extends ModelInterface{
  int? id;
  String? carNumber;
  int? carManuYear;
  String? carDoc1;
  String? carDoc2;
  String? image1;
  String? image2;
  String? image3;
  String? carIdName;
  String? carIdNumber;
  String? carIdVin;
  String? carIdIssue;
  String? carIdExpire;
  String? barcode;
  String? barcodeImage;
  int? balance;
  int? maxBalance;
  bool? isActive;
  String? updated;
  String? created;
  int? captain;
  int? company;
  int? country;
  int? province;
  int? carLetter;
  int? carCategory;
  int? trailer;
  int? carCompany;
  int? carModel;
  int? carColor;
  int? employee;

  Car(
      {this.id,
        this.carNumber,
        this.carManuYear,
        this.carDoc1,
        this.carDoc2,
        this.image1,
        this.image2,
        this.image3,
        this.carIdName,
        this.carIdNumber,
        this.carIdVin,
        this.carIdIssue,
        this.carIdExpire,
        this.barcode,
        this.barcodeImage,
        this.balance,
        this.maxBalance,
        this.isActive,
        this.updated,
        this.created,
        this.captain,
        this.company,
        this.country,
        this.province,
        this.carLetter,
        this.carCategory,
        this.trailer,
        this.carCompany,
        this.carModel,
        this.carColor,
        this.employee});

  @override
  dynamic fromJson(Map<String, dynamic> json) {
    return Car(
        id : json['id'],
        carNumber : json['car_number'],
        carManuYear : json['car_manu_year'],
        carDoc1 : json['car_doc1'],
        carDoc2 : json['car_doc2'],
        image1 : json['image1'],
        image2 : json['image2'],
        image3 : json['image3'],
        carIdName : json['car_id_name'],
        carIdNumber : json['car_id_number'],
        carIdVin : json['car_id_vin'],
        carIdIssue : json['car_id_issue'],
        carIdExpire : json['car_id_expire'],
    barcode : json['barcode'],
    barcodeImage : json['barcode_image'],
    balance : json['balance'],
    maxBalance : json['max_balance'],
    isActive : json['is_active'],
    updated : json['updated'],
    created : json['created'],
    captain : json['captain'],
    company : json['company'],
    country : json['country'],
    province : json['province'],
    carLetter : json['car_letter'],
    carCategory : json['car_category'],
    trailer : json['trailer'],
    carCompany : json['car_company'],
    carModel : json['car_model'],
    carColor : json['car_color'],
    employee : json['employee'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['car_number'] = this.carNumber;
    data['car_manu_year'] = this.carManuYear;
    data['car_doc1'] = this.carDoc1;
    data['car_doc2'] = this.carDoc2;
    data['image1'] = this.image1;
    data['image2'] = this.image2;
    data['image3'] = this.image3;
    data['car_id_name'] = this.carIdName;
    data['car_id_number'] = this.carIdNumber;
    data['car_id_vin'] = this.carIdVin;
    data['car_id_issue'] = this.carIdIssue;
    data['car_id_expire'] = this.carIdExpire;
    data['barcode'] = this.barcode;
    data['barcode_image'] = this.barcodeImage;
    data['balance'] = this.balance;
    data['max_balance'] = this.maxBalance;
    data['is_active'] = this.isActive;
    data['updated'] = this.updated;
    data['created'] = this.created;
    data['captain'] = this.captain;
    data['company'] = this.company;
    data['country'] = this.country;
    data['province'] = this.province;
    data['car_letter'] = this.carLetter;
    data['car_category'] = this.carCategory;
    data['trailer'] = this.trailer;
    data['car_company'] = this.carCompany;
    data['car_model'] = this.carModel;
    data['car_color'] = this.carColor;
    data['employee'] = this.employee;
    return data;
  }
}