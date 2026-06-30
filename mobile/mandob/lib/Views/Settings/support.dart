import 'package:almandobUAE/Models/Info.dart';
import 'package:almandobUAE/Services/links.dart';
import 'package:almandobUAE/Views/Auth/otp.dart';
import 'package:almandobUAE/Widgets/appbar.dart';
import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/frame.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:almandobUAE/Widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class Support extends StatefulWidget {
  const Support({super.key});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "الدعم الفني",
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
          Image(image: AssetImage("images/support.jpg")),
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

                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        _launchUrl(data.whatsapp.toString());
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              CustomColors.secendory,
                              CustomColors.primary,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white, // لون داخل الحاوية
                              borderRadius: BorderRadius.circular(12), // نفس الشكل لكن أقل قليلاً
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: HeadingText(text: " الاتصال بالادارة"),
                                ))),
                      ),
                    )
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

Widget _settingsCartImage(String title, String image, String url) {
  return InkWell(
    onTap: () {
      _launchUrl(url);
    },
    child: Container(
      margin: EdgeInsets.only(top: 12, left: 18, right: 18),
      height: 60,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ListTile(
        title: bodytext(text: "$title"),
        trailing: Image(
          image: AssetImage("$image"),
          width: 35,
        ),
      ),
    ),
  );
}

Future<void> _launchUrl(String urls) async {
  Uri url = Uri.parse(urls);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
