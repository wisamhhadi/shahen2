import 'package:almandobUAE/Models/Info.dart';
import 'package:almandobUAE/Services/links.dart';
import 'package:almandobUAE/Services/network.dart';
import 'package:almandobUAE/Views/Settings/about_us.dart';
import 'package:almandobUAE/Views/Settings/privcy.dart';
import 'package:almandobUAE/Views/Settings/support.dart';
import 'package:almandobUAE/Views/account.dart';
import 'package:almandobUAE/Views/notification.dart';
import 'package:almandobUAE/Widgets/appbar.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:almandobUAE/Widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    var net = Network(auth: false);

    return Scaffold(
      appBar: CustomAppBar(
        title: "الاعدادات",
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
          InkWell(
              onTap: () {
                Get.to(Account(), transition: Transition.fade);
              },
              child: _settingsCart("حسابي", Icons.person_outlined)),
          InkWell(
              onTap: () {
                Get.to(Notifications(), transition: Transition.fade);
              },
              child: _settingsCart("الاشعارات", Icons.notifications_outlined)),
          InkWell(
              onTap: () {
                Get.to(AboutUs(), transition: Transition.fade);
              },
              child: _settingsCart("من نحن ؟ ", Icons.info_outline)),
          InkWell(
              onTap: () {
                Get.to(Privcy(), transition: Transition.fade);
              },
              child: _settingsCart("سياسة الخصوصية", Icons.privacy_tip_outlined)),
          InkWell(
              onTap: () {
                Get.to(Support(), transition: Transition.fade);
              },
              child: _settingsCart("الدعم الفني", Icons.support_agent_outlined)),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Divider(),
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

                return Column(
                  children: [
                    _settingsCartImage("فيسبوك", "icons/facebook.png", "${data.facebook}"),
                    _settingsCartImage("انستغرام", "icons/insta.png", "${data.instagram}"),
                    _settingsCartImage("تيك توك", "icons/tiktok.png", "${data.tiktok}"),
                    _settingsCartImage("واتساب", "icons/whats.png", "${data.whatsapp}"),
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

Widget _settingsCart(String title, IconData icon) {
  return Container(
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
      trailing: Icon(icon),
    ),
  );
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
