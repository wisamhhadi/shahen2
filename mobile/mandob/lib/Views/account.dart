import 'package:almandobUAE/Services/interface.dart';
import 'package:almandobUAE/Services/links.dart';
import 'package:almandobUAE/Services/network.dart';
import 'package:almandobUAE/Models/mandob.dart'; // تأكد أنك أنشأت موديل Mandob هنا
import 'package:almandobUAE/Widgets/appbar.dart';
import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/dialgoCustom.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:almandobUAE/Widgets/loading.dart';
import 'package:almandobUAE/Widgets/textbox.dart';
import 'package:almandobUAE/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  var net = Network(auth: true);

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController town = TextEditingController();
  TextEditingController location = TextEditingController();

  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    loadMandobProfile();
  }

  bool isLoading = false;
  Future<void> loadMandobProfile() async {
    try {
      var result = await net.list(Links.patchMandob(GetStorage().read('id')), Mandob() as ModelInterface);

      if (result.isNotEmpty) {
        Mandob mandob = result.first as Mandob;
        name.text = mandob.name.toString();
        // city.text = mandob.city.toString();

        // town.text = mandob.admin ?? '';
        city.text = mandob.city.toString();
        location.text = mandob.location ?? '';
        phone.text = mandob.phone.toString() ?? '';
        imageUrl = mandob.image ?? '';

        setState(() {}); // لتحديث صورة الحساب فقط
      } else {
        print("لم يتم العثور على بيانات المندوب");
      }
    } catch (e) {
      print("خطأ في تحميل بيانات المندوب: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "حسابي",
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 222, 222, 222),
              maxRadius: 80,
              backgroundImage: imageUrl.isNotEmpty ? NetworkImage("${imageUrl}") : null,
              child: imageUrl.isEmpty ? const Icon(Icons.person, size: 50) : null,
            ),
          ),
          const SizedBox(height: 18),
          buildLabel("الاسم الثلاثي"),
          TextBoxCustom(
            hintText: "الاسم",
            controller: name,
            readOnly: true,
          ),
          buildLabel("المنطقة"),
          TextBoxCustom(
            hintText: "المنطقة",
            controller: city,
            readOnly: true,
          ),
          buildLabel("العنوان"),
          TextBoxCustom(
            hintText: "العنوان",
            controller: location,
            readOnly: true,
          ),
          buildLabel("رقم الهاتف"),
          TextBoxCustom(
            hintText: "رقم الهاتف",
            controller: phone,
            readOnly: true,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  /// ويدجيت مساعد لعرض عنوان الحقول
  Widget buildLabel(String text) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
        child: bodytext(text: text),
      ),
    );
  }
}
