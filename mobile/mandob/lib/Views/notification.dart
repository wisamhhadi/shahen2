import 'package:almandobUAE/Models/Notificationss.dart';
import 'package:almandobUAE/Services/links.dart';
import 'package:almandobUAE/Services/network.dart';
import 'package:almandobUAE/Views/Driver/add_driver.dart';
import 'package:almandobUAE/Widgets/appbar.dart';
import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:almandobUAE/Widgets/loading.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<Notificationss> notificationsList = [];
   var net = Network(auth: false);
 

  void initState() {
    super.initState();


    // أول تحميل لقائمة الاشعارات
    loadNotifications();
  }

  void loadNotifications() async {
  var data = await net.list(Links.notification, Notificationss());
  if (!mounted) return;  // ← هنا نتحقق لو الـ State موجود

  setState(() {
    notificationsList = data.cast<Notificationss>();
  });
}

  void refreshNotifications() {
    loadNotifications();
    // أو يمكنك إضافة العنصر الذي جاء في الرسالة مباشرة
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: CustomAppBar(
        title: "الاشعارات",
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: net.list(Links.notification, Notificationss()),
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
                var noti = snapshot.data[index] as Notificationss;
                final dateTime = DateTime.parse(noti.created!);
                final dataCreated = DateTime.parse(noti.created!);
                int hour = dateTime.hour;
                String minute = dateTime.minute.toString().padLeft(2, '0');
                String period = hour >= 12 ? "مساءً" : "صباحًا";

// تحويل الساعة إلى تنسيق 12 ساعة
                hour = hour % 12 == 0 ? 12 : hour % 12;

                final timeOnly = "$hour:$minute $period";
                print(noti.userType);
                if (noti.userType == 'مندوب')
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10)),
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          ListTile(
                            title: bodytext(text: "${noti.title}"),
                            subtitle: bodytext(text: "${noti.text}"),
                            trailing: bodytext(text: timeOnly),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Row(
                              textDirection: TextDirection.ltr,
                              children: [
                                bodytext(text: "${noti.created!.substring(0,10)}")
                              ],
                            ),
                          )
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
