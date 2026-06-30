import 'package:almandobUAE/Models/Captin.dart';
import 'package:almandobUAE/Models/User.dart';
import 'package:almandobUAE/Services/links.dart';
import 'package:almandobUAE/Services/network.dart';
import 'package:almandobUAE/Views/Driver/add_driver.dart';
import 'package:almandobUAE/Widgets/appbar.dart';
import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:almandobUAE/Widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Drivers extends StatefulWidget {
  const Drivers({super.key});

  @override
  State<Drivers> createState() => _DriversState();
}

class _DriversState extends State<Drivers> {
  @override
  var net = Network(auth: false);
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "السائقين",
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
            Get.to(AddDriver(), transition: Transition.rightToLeft);
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
            future: net.list(Links.driver, Captain()),
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
                    var data = snapshot.data[index] as Captain;
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
            }));
  }
}
