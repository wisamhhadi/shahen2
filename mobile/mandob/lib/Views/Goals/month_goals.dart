import 'package:almandobUAE/Models/History.dart';
import 'package:almandobUAE/Models/Mandob.dart';
import 'package:almandobUAE/Services/links.dart';
import 'package:almandobUAE/Services/network.dart';
import 'package:almandobUAE/Widgets/appbar.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MonthGoals extends StatefulWidget {
  const MonthGoals({super.key});

  @override
  State<MonthGoals> createState() => _MonthGoalsState();
}

class _MonthGoalsState extends State<MonthGoals> {
  final net = Network(auth: true);
  int todayCaptainCount = 0;
  int todayDeilvryCount = 0;
  int todayCompanyCount = 0;
  int todayUserCount = 0;
  int captainGoal = 0;
  int deilveryGoal = 0;
  int companyGoal = 0;
  int userGoal = 0;

  //total digram
  int totalGoal = 0;
  int totalDone = 0;
  int totalExtra = 0;
  int totalRemain = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: prepareData(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: CustomAppBar(
            title: "الاهداف الشهرية",
            leading: InkWell(
              onTap: () => Get.back(),
              child: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
          ),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 10),

              /// ✅ صف 1: السائقين
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildUserBox("السائقين"),
                    buildStatBox("الهدف", captainGoal, Colors.orange),
                    buildStatBox("المتبقي", (captainGoal - todayCaptainCount).clamp(0, captainGoal), Colors.green),
                    buildStatBox("الإضافي", (todayCaptainCount - captainGoal).clamp(0, todayCaptainCount), Colors.orange),
                  ],
                ),
              ),

              /// ✅ صف 2: الناقلين
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildUserBox("الناقلين"),
                    buildStatBox("الهدف", deilveryGoal, Colors.orange),
                    buildStatBox("المتبقي", (deilveryGoal - todayDeilvryCount).clamp(0, deilveryGoal), Colors.green),
                    buildStatBox("الإضافي", (todayDeilvryCount - deilveryGoal).clamp(0, todayDeilvryCount), Colors.orange),
                  ],
                ),
              ),

              /// ✅ صف 3: التجار
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildUserBox("التجار"),
                    buildStatBox("الهدف", companyGoal, Colors.orange),
                    buildStatBox("المتبقي", (companyGoal - todayCompanyCount).clamp(0, companyGoal), Colors.green),
                    buildStatBox("الإضافي", (todayCompanyCount - companyGoal).clamp(0, todayCompanyCount), Colors.orange),
                  ],
                ),
              ),

              /// ✅ صف 4: المستخدمين
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildUserBox("المستخدمين"),
                    buildStatBox("الهدف", userGoal, Colors.orange),
                    buildStatBox("المتبقي", (userGoal - todayUserCount).clamp(0, userGoal), Colors.green),
                    buildStatBox("الإضافي", (todayUserCount - userGoal).clamp(0, todayUserCount), Colors.orange),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// ✳️ الرسم البياني
              Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      bodytext(text: 'رسم بياني حول التسجيل'),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: Divider(),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 300,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 100,
                            barTouchData: BarTouchData(enabled: false),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    switch (value.toInt()) {
                                      case 0:
                                        return bodytext(text: 'الاضافي');
                                      case 1:
                                        return bodytext(text: 'المتبقي');
                                      case 2:
                                        return bodytext(text: 'الهدف');
                                      default:
                                        return bodytext(text: '');
                                    }
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Text('${value.toInt()}%');
                                  },
                                  reservedSize: 40,
                                ),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: Colors.grey.withOpacity(0.3),
                                  strokeWidth: 1,
                                );
                              },
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [
                                  BarChartRodData(
                                    toY: totalExtra > 0 && totalGoal > 0 ? (totalExtra / totalGoal * 100).clamp(0, 100) : 0,
                                    color: Colors.blue,
                                    width: 30,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 1,
                                barRods: [
                                  BarChartRodData(
                                    toY: totalRemain > 0 && totalGoal > 0 ? (totalRemain / totalGoal * 100).clamp(0, 100) : 0,
                                    color: Colors.orange,
                                    width: 30,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 2,
                                barRods: [
                                  BarChartRodData(
                                    toY: 100,
                                    color: Colors.green,
                                    width: 30,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
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
    totalGoal = captainGoal + deilveryGoal + companyGoal + userGoal;
    totalDone = todayCaptainCount + todayDeilvryCount + todayCompanyCount + todayUserCount;
    totalRemain = (totalGoal - totalDone).clamp(0, totalGoal);
    totalExtra = (totalDone - totalGoal).clamp(0, totalDone);
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
