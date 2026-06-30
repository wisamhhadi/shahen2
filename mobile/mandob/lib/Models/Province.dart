import 'package:almandobUAE/Services/interface.dart';

class Province extends ModelInterface {
  int? id;
  String? name;
  double? fromPrec;
  double? toPrec;
  int? innerRideStartPrice;
  int? outerRideStartPrice;
  double? companyPrec;
  bool? isActive;
  String? updated;
  String? created;
  int? country;
  int? employee;

  Province({this.id, this.name, this.fromPrec, this.toPrec, this.innerRideStartPrice, this.outerRideStartPrice, this.companyPrec, this.isActive, this.updated, this.created, this.country, this.employee});

  dynamic fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['id'],
      name: json['name'],
      fromPrec: json['from_prec'],
      toPrec: json['to_prec'],
      innerRideStartPrice: json['inner_ride_start_price'],
      outerRideStartPrice: json['outer_ride_start_price'],
      companyPrec: json['company_prec'],
      isActive: json['is_active'],
      updated: json['updated'],
      created: json['created'],
      country: json['country'],
      employee: json['employee'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['name'] = this.name;
    data['from_prec'] = this.fromPrec;
    data['to_prec'] = this.toPrec;
    data['inner_ride_start_price'] = this.innerRideStartPrice;
    data['outer_ride_start_price'] = this.outerRideStartPrice;
    data['company_prec'] = this.companyPrec;
    data['is_active'] = this.isActive;
    data['updated'] = this.updated;
    data['created'] = this.created;
    data['country'] = this.country;
    data['employee'] = this.employee;
    return data;
  }
}
