import 'package:almandobUAE/Models/DeliveryCompany.dart';
import 'package:almandobUAE/Services/links.dart';
import 'package:almandobUAE/Services/network.dart';
import 'package:almandobUAE/Views/Carrier/add_carrier.dart';
import 'package:almandobUAE/Views/Driver/add_driver.dart';

import 'package:almandobUAE/Widgets/appbar.dart';
import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:almandobUAE/Widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Carrier extends StatefulWidget {
  const Carrier({super.key});

  @override
  State<Carrier> createState() => _CarrierState();
}

class _CarrierState extends State<Carrier> {
  @override
  Widget build(BuildContext context) {
    var net = Network(auth: false);
    return Scaffold(
      appBar: CustomAppBar(
        title: "الناقلين",
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
          Get.to(AddCarrier(), transition: Transition.rightToLeft);
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
        future: net.list(Links.deliveryCompany, DeliveryCompany()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                child: ProfessionalLoadingWidget(),
              ),
            );
          } else if (!snapshot.hasData == null) {
            return Center(
              child: Text(
                "لاتوجد بيانات",
                style: TextStyle(color: Colors.blueAccent),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "لايوجد بيانات",
              ),
            );
          } else
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                var data = snapshot.data[index] as DeliveryCompany;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(10)),
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          title: bodytext(text: "${data.name}"),
                          trailing: bodytext(text: "${data.created!.substring(0, 10)}"),
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
        },
      ),
    );
  }
}
