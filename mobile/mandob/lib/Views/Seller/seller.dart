import 'package:almandobUAE/Models/User.dart';
import 'package:almandobUAE/Services/links.dart';
import 'package:almandobUAE/Services/network.dart';
import 'package:almandobUAE/Views/Driver/add_driver.dart';
import 'package:almandobUAE/Views/Seller/add_seller.dart';
import 'package:almandobUAE/Views/User/add_user.dart';
import 'package:almandobUAE/Widgets/appbar.dart';
import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:almandobUAE/Widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Seller extends StatefulWidget {
  const Seller({super.key});

  @override
  State<Seller> createState() => _SellerState();
}

class _SellerState extends State<Seller> {
  @override
  Widget build(BuildContext context) {
    var net = Network(auth: false);
    return Scaffold(
      appBar: CustomAppBar(
        title: "التجار",
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Get.to(AddSeller(), transition: Transition.rightToLeft);
        },
        child: CircleAvatar(
          maxRadius: 35,
          backgroundColor: CustomColors.primary,
          child: Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: net.list(Links.user, Users()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                child: ProfessionalLoadingWidget(),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("حدث خطأ أثناء جلب البيانات"),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text("لا توجد بيانات"),
            );
          } else {
            // تصفية البيانات لعرض فقط الشركات
            var companies = snapshot.data.where((item) => item.type == "company").toList();

            if (companies.isEmpty) {
              return Center(child: bodytext(text: "لاتوجد بيانات"));
            }

            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: companies.length,
              itemBuilder: (BuildContext context, int index) {
                var data = companies[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          title: bodytext(text: "${data.name}"),
                          trailing: bodytext(text: "${data.created?.substring(0, 10) ?? ''}"),
                        ),
                        ListTile(
                          title: bodytext(text: "${data.city}"),
                          trailing: bodytext(text: "${data.location}"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
