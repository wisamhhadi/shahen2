import 'package:almandobUAE/Services/interface.dart';

class Info extends ModelInterface {
  String? whatsapp;
  String? facebook;

  String? instagram;
  String? tiktok;
  String? about;
  String? privacy;
  int? offerTime;
  bool? isActive;
  Null? employee;

  Info({this.whatsapp, this.facebook, this.instagram, this.tiktok, this.about, this.privacy, this.offerTime, this.isActive, this.employee});

  dynamic fromJson(Map<String, dynamic> json) {
    return Info(
      whatsapp: json['whatsapp'],
      facebook: json['facebook'],
      instagram: json['instagram'],
      tiktok: json['tiktok'],
      about: json['about'],
      privacy: json['privacy'],
      offerTime: json['offer_time'],
      isActive: json['is_active'],
      employee: json['employee'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['whatsapp'] = this.whatsapp;
    data['facebook'] = this.facebook;
    data['instagram'] = this.instagram;
    data['tiktok'] = this.tiktok;
    data['about'] = this.about;
    data['privacy'] = this.privacy;
    data['offer_time'] = this.offerTime;
    data['is_active'] = this.isActive;
    data['employee'] = this.employee;
    return data;
  }
}
