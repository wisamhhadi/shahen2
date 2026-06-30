import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

String base = "https://uae-django.onrender.com/api/v1/core/";
String baseLogin = "https://uae-django.onrender.com/api/v1/";
String baseMandob = "https://uae-django.onrender.com/api/v1/mandob/";
String websocketBase = "wss://uae-django.onrender.com/ws/";
String? id;
String idd = GetStorage().read('id');

class Links {
  static String mandobLogin = "${baseLogin}MandobLogin";

  static String notification = "${base}Notification";
  static String info = "${base}Info/1";

  static String deliveryCompany = "${baseLogin}deliverycompany/DeliveryCompany";
  static String user = "${baseLogin}user/User";
  static String createUser = "${baseLogin}user/User";
  static String driver = "${baseLogin}captain/Captain";

  static String country = "${base}Country";
  static String language = "${base}Language";
  static String carCompany = "${base}CarCompany";
  static String carColor = "${base}CarColor";
  static String carModel = "${base}CarModel";
  static String createCar = "${base}Car";
  static String carCategory = "${base}CarCategory";
  static String carSize = "${base}CarSize";
  static String province = "${base}Province";
  static String specialty = "${base}Specialty";
  static String activityType = "${base}ActivityType";
  static String payHistory = "${base}Pay";

  //mandob base
  static String createMandob = "${baseMandob}Mandob";
  static String report = "${baseMandob}Report";
  static String question = "${baseMandob}Question";
  static String questionChoice = "${baseMandob}QuestionChoice";
  static String answer = "${baseMandob}Answer";
  static String history = "${baseMandob}History";
  static String orderReport = "${baseMandob}OrderReport";
  static String orderReportItem = "${baseMandob}OrderReportItem";
  static String attendence = "${baseMandob}Attendance";
  static String customReport = "${baseMandob}CustomReport";
  static String customAnswer = "${baseMandob}CustomAnswer";

  static String? driverPatch;

  static String patchDriver(int id) {
    return driverPatch = "${baseLogin}captain/Captain/$id";
  }
  static String? mandobPatch;
  static String patchMandob(int id) {
    return mandobPatch = "${baseMandob}Mandob/$id";
  }
}
