import 'package:almandobUAE/Models/Info.dart';
import 'package:almandobUAE/Services/links.dart';
import 'package:almandobUAE/Services/network.dart';
import 'package:almandobUAE/Widgets/appbar.dart';
import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:almandobUAE/Widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Privcy extends StatefulWidget {
  const Privcy({super.key});

  @override
  State<Privcy> createState() => _PrivcyState();
}

class _PrivcyState extends State<Privcy> {
  @override
  Widget build(BuildContext context) {
    var net = Network(auth: false);
    return Scaffold(
      appBar: CustomAppBar(
        title: "سياسة الخصوصية",
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("icons/UAElogo.png") ), color: CustomColors.primary, borderRadius: BorderRadius.circular(80)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: HeadingText(text: "سياسة الخصوصية : "),
          ),
          FutureBuilder(
            future: net.list(Links.info, Info()),
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
                  child: Text(
                    "لا توجد بيانات",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                );
              } else {
                var data = snapshot.data.first as Info;

                return Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: bodytext(text: "${data.privacy ?? "لا توجد سياسة خصوصية حالياً."}"),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
