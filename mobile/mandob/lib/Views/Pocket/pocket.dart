import 'package:almandobUAE/Models/Mandob.dart';
import 'package:almandobUAE/Models/Pay.dart';
import 'package:almandobUAE/Services/links.dart';
import 'package:almandobUAE/Services/network.dart';
import 'package:almandobUAE/Views/Pocket/add_money.dart';
import 'package:almandobUAE/Widgets/appbar.dart';
import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:almandobUAE/Widgets/home_widgets.dart';
import 'package:almandobUAE/Widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Pocket extends StatefulWidget {
  const Pocket({super.key});

  @override
  State<Pocket> createState() => _PocketState();
}

String? mandobBalance;

class _PocketState extends State<Pocket> {
  var net = Network(auth: true);
  Future<void> loadBalanceOnly() async {
    try {
      var result = await net.list(Links.patchMandob(GetStorage().read('id')), Mandob());

      if (result.isNotEmpty) {
        Mandob mandob = result.first as Mandob;
        setState(() {
          mandobBalance = mandob.balance.toString();
        });
        print("Balance: $mandobBalance");
      } else {
        print("لم يتم العثور على بيانات المندوب");
      }
    } catch (e) {
      print("خطأ في تحميل الرصيد: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadBalanceOnly();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "المحفظة",
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            margin: EdgeInsets.all(10),
            height: Get.height * 0.3,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: CustomColors.primary),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15, right: 10),
                  child: HeadingText(
                    text: "المحفظة",
                    textColor: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: Get.height * 0.05),
                  child: Center(
                    child: HeadingText(
                      text: "${mandobBalance} IQD",
                      textColor: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  title: bodytext(
                    text: "الاسم :",
                    textColor: Colors.white,
                  ),
                  trailing: bodytext(
                    text: "رقم الحساب :",
                    textColor: Colors.white,
                  ),
                ),
                ListTile(
                  title: bodytext(
                    text: "${GetStorage().read('name')}",
                    textColor: Colors.white,
                  ),
                  trailing: bodytext(
                    text: "547896145632",
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: HeadingText(text: "سجل الحركات"),
            trailing: Icon(Icons.history_outlined),
          ),
          Wrap(
              alignment: WrapAlignment.spaceAround, // لتوزيع العناصر بشكل متساوٍ
              spacing: 10, // المسافة الأفقية بين العناصر
              runSpacing: 10, // المسافة العمودية بين الصفوف
              children: [
                bodytext(text: "التاريخ"),
                bodytext(text: "المال"),
                bodytext(text: "الوقت"),
              ]),
          FutureBuilder(
            future: net.list(Links.payHistory, Pay()),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SizedBox(
                    child: ProfessionalLoadingWidget(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("حدث خطأ أثناء تحميل البيانات"),
                );
              } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: bodytext(
                      text: "لا توجد بيانات",
                    ),
                  ),
                );
              } else {
                // ✅ فلترة البيانات فقط إذا mandob == 25
                List<Pay> pays = snapshot.data.cast<Pay>().where((pay) => pay.mandob == GetStorage().read('id')).toList();

                if (pays.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: bodytext(text: "لا توجد نتائج لهذا المستخدم"),
                    ),
                  );
                }

                return GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: pays.length * 3, // 3 عناصر لكل سجل
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    int payIndex = index ~/ 3; // السجل الحالي
                    int fieldIndex = index % 3; // 0 = التاريخ، 1 = المبلغ، 2 = الوقت

                    Pay pay = pays[payIndex];

                    IconData icon;
                    String label;

                    if (fieldIndex == 0) {
                      icon = Icons.date_range_outlined;
                      label = pay.updated?.substring(0, 10) ?? "—";
                    } else if (fieldIndex == 1) {
                      icon = Icons.attach_money;
                      label = pay.amount?.toString() ?? "—";
                    } else {
                      icon = Icons.alarm;
                      label = pay.updated?.substring(11, 19) ?? "—";
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            maxRadius: 25,
                            backgroundColor: CustomColors.primary,
                            child: Icon(icon, color: Colors.white),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: bodytext(text: label),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
          // InkWell(
          //   onTap: () {
          //     Get.to(AddMoney());
          //   },
          //   child: Container(
          //     margin: EdgeInsets.only(left: 15, right: 15, top: 8),
          //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: CustomColors.primary),
          //     height: Get.height * 0.06,
          //     child: Center(
          //       child: bodytext(
          //         fontWeight: FontWeight.w400,
          //         text: "تعبئة الرصيد",
          //         textColor: Colors.white,
          //       ),
          //     ),
          //   ),
          // ),
          // Container(
          //   margin: EdgeInsets.only(left: 15, right: 15, top: 8),
          //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: CustomColors.primary),
          //   height: Get.height * 0.06,
          //   child: Center(
          //     child: bodytext(
          //       fontWeight: FontWeight.w400,
          //       text: "كشف حساب",
          //       textColor: Colors.white,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
