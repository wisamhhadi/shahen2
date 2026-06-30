import 'interface.dart';
class Trailer extends ModelInterface{
  int? id;
  String? name;
  int? kmPrice;
  int? workerPrec;
  int? weightPrec;
  int? companyPrec;
  bool? canOrderWorkers;
  int? carHourPrice;
  int? workerHourPrice;
  int? innerRideStartPrice;
  int? outerRideStartPrice;
  int? captainPrize;
  int? mandobPrize;
  int? lateLoadingPrice;
  int? lateLoadingDays;
  int? lateDeliveringPrice;
  int? lateDeliveringDays;
  String? image1;
  String? image2;
  String? image3;
  String? mapIcon;
  String? orderIcon;
  bool? isActive;
  String? updated;
  String? created;
  int? carCategory;
  int? carSize;
  int? employee;
  List<int>? goodsType;

  Trailer(
      {this.id,
        this.name,
        this.kmPrice,
        this.workerPrec,
        this.weightPrec,
        this.companyPrec,
        this.canOrderWorkers,
        this.carHourPrice,
        this.workerHourPrice,
        this.innerRideStartPrice,
        this.outerRideStartPrice,
        this.captainPrize,
        this.mandobPrize,
        this.lateLoadingPrice,
        this.lateLoadingDays,
        this.lateDeliveringPrice,
        this.lateDeliveringDays,
        this.image1,
        this.image2,
        this.image3,
        this.mapIcon,
        this.orderIcon,
        this.isActive,
        this.updated,
        this.created,
        this.carCategory,
        this.carSize,
        this.employee,
        this.goodsType});

  @override
  dynamic fromJson(Map<String, dynamic> json) {
    return Trailer(
        id : json['id'],
        name : json['name'],
        kmPrice : json['km_price'],
        workerPrec : json['worker_prec'],
        weightPrec : json['weight_prec'],
        companyPrec : json['company_prec'],
        canOrderWorkers : json['can_order_workers'],
        carHourPrice : json['car_hour_price'],
        workerHourPrice : json['worker_hour_price'],
        innerRideStartPrice : json['inner_ride_start_price'],
        outerRideStartPrice : json['outer_ride_start_price'],
        captainPrize : json['captain_prize'],
        mandobPrize : json['mandob_prize'],
    lateLoadingPrice : json['late_loading_price'],
    lateLoadingDays : json['late_loading_days'],
    lateDeliveringPrice : json['late_delivering_price'],
    lateDeliveringDays : json['late_delivering_days'],
    image1 : json['image1'],
    image2 : json['image2'],
    image3 : json['image3'],
    mapIcon : json['map_icon'],
    orderIcon : json['order_icon'],
    isActive : json['is_active'],
    updated : json['updated'],
    created : json['created'],
    carCategory : json['car_category'],
    carSize : json['car_size'],
    employee : json['employee'],
    goodsType : json['goods_type'].cast<int>(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['km_price'] = this.kmPrice;
    data['worker_prec'] = this.workerPrec;
    data['weight_prec'] = this.weightPrec;
    data['company_prec'] = this.companyPrec;
    data['can_order_workers'] = this.canOrderWorkers;
    data['car_hour_price'] = this.carHourPrice;
    data['worker_hour_price'] = this.workerHourPrice;
    data['inner_ride_start_price'] = this.innerRideStartPrice;
    data['outer_ride_start_price'] = this.outerRideStartPrice;
    data['captain_prize'] = this.captainPrize;
    data['mandob_prize'] = this.mandobPrize;
    data['late_loading_price'] = this.lateLoadingPrice;
    data['late_loading_days'] = this.lateLoadingDays;
    data['late_delivering_price'] = this.lateDeliveringPrice;
    data['late_delivering_days'] = this.lateDeliveringDays;
    data['image1'] = this.image1;
    data['image2'] = this.image2;
    data['image3'] = this.image3;
    data['map_icon'] = this.mapIcon;
    data['order_icon'] = this.orderIcon;
    data['is_active'] = this.isActive;
    data['updated'] = this.updated;
    data['created'] = this.created;
    data['car_category'] = this.carCategory;
    data['car_size'] = this.carSize;
    data['employee'] = this.employee;
    data['goods_type'] = this.goodsType;
    return data;
  }
}
