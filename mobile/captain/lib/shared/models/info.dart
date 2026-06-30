import 'interface.dart';

class Info extends ModelInterface{
  int? id;
  String? whatsapp;
  String? facebook;
  String? instagram;
  String? tiktok;
  String? about;
  String? privacy;
  int? offerTime;
  bool? isActive;
  String? updated;
  String? created;
  int? employee;

  Info(
      {this.id,
        this.whatsapp,
        this.facebook,
        this.instagram,
        this.tiktok,
        this.about,
        this.privacy,
        this.offerTime,
        this.isActive,
        this.updated,
        this.created,
        this.employee});

  @override
  dynamic fromJson(Map<String, dynamic> json) {
    return Info(
        id : json['id'],
        whatsapp : json['whatsapp'],
        facebook : json['facebook'],
    instagram : json['instagram'],
    tiktok : json['tiktok'],
    about : json['about'],
    privacy : json['privacy'],
    offerTime : json['offer_time'],
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
    data['whatsapp'] = this.whatsapp;
    data['facebook'] = this.facebook;
    data['instagram'] = this.instagram;
    data['tiktok'] = this.tiktok;
    data['about'] = this.about;
    data['privacy'] = this.privacy;
    data['offer_time'] = this.offerTime;
    data['is_active'] = this.isActive;
    data['updated'] = this.updated;
    data['created'] = this.created;
    data['employee'] = this.employee;
    return data;
  }
}