import 'package:almandobUAE/Services/interface.dart';

class History extends ModelInterface {
  int? id;
  String? type;
  String? barcode;
  bool? isActive;
  String? updated;
  String? created;
  int? mandob;

  History({this.id, this.type, this.barcode, this.isActive, this.updated, this.created, this.mandob});

  dynamic fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'],
      type: json['type'],
      barcode: json['barcode'],
      isActive: json['is_active'],
      updated: json['updated'],
      created: json['created'],
      mandob: json['mandob'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['type'] = this.type;
    data['barcode'] = this.barcode;
    data['is_active'] = this.isActive;
    data['updated'] = this.updated;
    data['created'] = this.created;
    data['mandob'] = this.mandob;
    return data;
  }
}
