import 'package:almandobUAE/Models/History.dart';
import 'package:almandobUAE/Models/Mandob.dart';
import 'package:almandobUAE/Services/links.dart';
import 'package:almandobUAE/Services/network.dart';
import 'package:almandobUAE/Widgets/appbar.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AdditionSalary extends StatefulWidget {
  const AdditionSalary({super.key});

  @override
  State<AdditionSalary> createState() => _AdditionSalaryState();
}

class _AdditionSalaryState extends State<AdditionSalary> {
  final net = Network(auth: true);

  int todayCaptainCount = 0;
  int todayDeilvryCount = 0;
  int todayCompanyCount = 0;
  int todayUserCount = 0;

  int captainGoal = 0;
  int deilveryGoal = 0;
  int companyGoal = 0;
  int userGoal = 0;

  // أجور تسجيل ثابتة لكل صنف (قيم افتراضية)

  int userWage = 0;

  // المجموع الكلي للأجور
  int totalWage = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: prepareData(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: CustomAppBar(
            title: "الاجور الاضافية",
            leading: InkWell(
              onTap: () => Get.back(),
              child: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
          ),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 10),

              // صف 1: السائقين
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildUserBox("السائقين"),
                    buildStatBox("عدد", todayCaptainCount, Colors.orange),
                    buildStatBox("أجر التسجيل", userWage, Colors.green),
                    buildStatBox("المجموع", todayCaptainCount * userWage, Colors.orange),
                  ],
                ),
              ),

              // صف 2: الناقلين
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildUserBox("الناقلين"),
                    buildStatBox("عدد", todayDeilvryCount, Colors.orange),
                    buildStatBox("أجر التسجيل", userWage, Colors.green),
                    buildStatBox("المجموع", todayDeilvryCount * userWage, Colors.orange),
                  ],
                ),
              ),

              // صف 3: التجار
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildUserBox("التجار"),
                    buildStatBox("عدد", todayCompanyCount, Colors.orange),
                    buildStatBox("أجر التسجيل", userWage, Colors.green),
                    buildStatBox("المجموع", todayCompanyCount * userWage, Colors.orange),
                  ],
                ),
              ),

              // صف 4: المستخدمين
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildUserBox("المستخدمين"),
                    buildStatBox("عدد", todayUserCount, Colors.orange),
                    buildStatBox("أجر التسجيل", userWage, Colors.green),
                    buildStatBox("المجموع", todayUserCount * userWage, Colors.orange),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // عرض المجموع الكلي للأجور
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: bodytext(
                    text: "الإجمالي الكلي للأجور: $totalWage دينار",
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> prepareData() async {
    await fetchGoals();

    todayCaptainCount = await fetchTodayCount("captain");
    todayDeilvryCount = await fetchTodayCount("deliverycompany");
    todayCompanyCount = await fetchTodayCount("company");
    todayUserCount = await fetchTodayCount("user");

    // حساب المجموع الكلي للأجور
    totalWage = (todayCaptainCount * userWage) + (todayDeilvryCount * userWage) + (todayCompanyCount * userWage) + (todayUserCount * userWage);
  }

  Future<void> fetchGoals() async {
    try {
      var result = await net.list(Links.patchMandob(GetStorage().read('id')), Mandob());
      if (result.isNotEmpty) {
        Mandob mandob = result.first as Mandob;
        captainGoal = mandob.captain_goal ?? 0;
        deilveryGoal = mandob.delivery_company_goal ?? 0;
        companyGoal = mandob.company_goal ?? 0;
        userGoal = mandob.user_goal ?? 0;
        userWage = mandob.registrationFee ?? 0;
      }
    } catch (e) {
      print("Error in fetchGoals: $e");
    }
  }

  Future<int> fetchTodayCount(String type) async {
    try {
      var rawList = await net.list(Links.history, History());
      DateTime today = DateTime.now();
      int count = 0;

      for (var e in rawList) {
        History user = e is History ? e : History().fromJson(e as Map<String, dynamic>);
        if (user.created != null) {
          DateTime createdDate = DateTime.parse(user.created!).toLocal();
          if (user.type == type && user.mandob.toString() == GetStorage().read('id').toString() && createdDate.year == today.year && createdDate.month == today.month && createdDate.day == today.day) {
            count++;
          }
        }
      }

      return count;
    } catch (e) {
      print("Error in fetchTodayCount: $e");
      return 0;
    }
  }

  Widget buildUserBox(String title) {
    return Container(
      width: 100,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: bodytext(
        text: title,
      ),
    );
  }

  Widget buildStatBox(String label, int value, Color borderColor) {
    return Column(
      children: [
        bodytext(
          text: label,
        ),
        const SizedBox(height: 4),
        Container(
          width: 70,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: bodytext(
            text: value.toString(),
          ),
        ),
      ],
    );
  }
}
