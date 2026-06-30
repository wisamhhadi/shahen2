import 'interface.dart';

class CaptainMessage extends ModelInterface{
  int? id;
  String? message;
  bool? isActive;
  String? updated;
  String? created;
  int? room;
  int? captain;
  int? admin;

  CaptainMessage(
      {this.id,
        this.message,
        this.isActive,
        this.updated,
        this.created,
        this.room,
        this.captain,
        this.admin});

  @override
  dynamic fromJson(Map<String, dynamic> json) {
    return CaptainMessage(
        id : json['id'],
        message : json['message'],
        isActive : json['is_active'],
    updated : json['updated'],
    created : json['created'],
    room : json['room'],
    captain : json['captain'],
    admin : json['admin'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['is_active'] = this.isActive;
    data['updated'] = this.updated;
    data['created'] = this.created;
    data['room'] = this.room;
    data['captain'] = this.captain;
    data['admin'] = this.admin;
    return data;
  }
}