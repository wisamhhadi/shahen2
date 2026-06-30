import 'dart:convert';
import 'dart:io';

import 'package:almandobUAE/Models/Country.dart';
import 'package:almandobUAE/Models/Languages.dart';
import 'package:almandobUAE/Models/Province.dart';
import 'package:almandobUAE/Services/links.dart';
import 'package:almandobUAE/Services/network.dart';
import 'package:almandobUAE/Views/Auth/language.dart';
import 'package:almandobUAE/Views/Auth/otp.dart';
import 'package:almandobUAE/Views/Driver/add_driver_car.dart';
import 'package:almandobUAE/Views/home.dart';
import 'package:almandobUAE/Widgets/appbar.dart';
import 'package:almandobUAE/Widgets/biometric_card.dart';
import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/dialgoCustom.dart';
import 'package:almandobUAE/Widgets/drobdownWidget.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:almandobUAE/Widgets/loading.dart';
import 'package:almandobUAE/Widgets/textbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

class AddDriver extends StatefulWidget {
  const AddDriver({super.key});

  @override
  State<AddDriver> createState() => _AddDriverState();
}

class _AddDriverState extends State<AddDriver> {
  late Future<List<Country>> country;
  late Future<List<Languages>> lang;
  late Future<List<Province>> prove;
  @override
  void initState() {
    super.initState();
    country = net.list(Links.country, Country()).then((value) => List<Country>.from(value));
    lang = net.list(Links.language, Languages()).then((value) => List<Languages>.from(value));
    prove = net.list(Links.province, Province()).then((value) => List<Province>.from(value));
  }

  int? selectedCountryId;
  int? selectedLang;
  int? selectedProve;
  BiometricCardData? scannedData;
  File? profileImage;
  File? FrontlocationCardImage;
  File? backlocationCardImage;
  File? frontDrivercard;
  File? backDrivercard;
  var net = Network(auth: false);

  TextEditingController fullname = TextEditingController();
  bool? isLoading = false;
  TextEditingController password = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController town = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController id_cardnumber = TextEditingController();
  TextEditingController dateExpire = TextEditingController();
  Future<void> scan() async {
    scannedData = await scanBiometricCardWithApiKey('YOUR_GOOGLE_API_KEY');
    setState(() {
      fullname.text = "${scannedData!.fullName} ${scannedData!.fatherName} ${scannedData!.grandFatherName}";

      id_cardnumber.text = scannedData!.cardNumber;
    });
  }

  Future<void> profileImagescan() async {
    profileImage = await anypick(fromCamera: true);
    if (profileImage != null) {
      print("📷 تم حفظ الصورة في: \${profileImage!.path}");
      setState(() {});
    }
  }

  //بطاقات السكن دوال
  Future<void> locationCard() async {
    FrontlocationCardImage = await anypick(fromCamera: true);
    if (FrontlocationCardImage != null) {
      print("📷 تم حفظ الصورة في: \${FrontlocationCardImage!.path}");
      setState(() {});
    }
  }

  Future<void> backlocationCard() async {
    backlocationCardImage = await anypick(fromCamera: true);
    if (backlocationCardImage != null) {
      print("📷 تم حفظ الصورة في: \${backlocationCardImage!.path}");
      setState(() {});
    }
  }

  Future<void> getfrontDrivercard() async {
    frontDrivercard = await anypick(fromCamera: true);
    if (frontDrivercard != null) {
      print("📷 تم حفظ الصورة في: \${FrontlocationCardImage!.path}");
      setState(() {});
    }
  }

  Future<void> getbackDrivercard() async {
    backDrivercard = await anypick(fromCamera: true);
    if (backDrivercard != null) {
      print("📷 تم حفظ الصورة في: \${backlocationCardImage!.path}");
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "اضافة سائق",
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
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: InkWell(
              onTap: profileImagescan,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: const Color.fromARGB(255, 222, 222, 222),
                backgroundImage: (profileImage != null && File(profileImage!.path).existsSync()) ? FileImage(profileImage!) : null,
                child: (profileImage == null || !File(profileImage!.path).existsSync()) ? Image.asset("icons/camera.png") : null,
              ),
            ),
          ),
          SizedBox(
            height: 18,
          ),
          InkWell(
            onTap: () {
              print(scannedData!.cardNumber);
            },
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 5),
                child: bodytext(text: "الاسم الثلاثي"),
              ),
            ),
          ),
          TextBoxCustom(
            hintText: "الاسم الثلاثي",
            controller: fullname,
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
              child: bodytext(text: "الدولة"),
            ),
          ),

          buildDropdownFuture<Country>(country, selectedCountryId, (val) => setState(() => selectedCountryId = val)),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
              child: bodytext(text: "اللغة"),
            ),
          ),

          buildDropdownFuture<Languages>(lang, selectedLang, (val) => setState(() => selectedLang = val)),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
              child: bodytext(
                text: "المحافظة",
              ),
            ),
          ),
          buildDropdownFuture<Province>(prove, selectedProve, (val) => setState(() => selectedProve = val)),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
              child: bodytext(text: "المنطقة"),
            ),
          ),
          TextBoxCustom(
            hintText: "المنطقة",
            controller: town,
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
              child: bodytext(text: "العنوان"),
            ),
          ),
          TextBoxCustom(
            hintText: "العنوان",
            controller: location,
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
              child: bodytext(text: "رقم البطاقة الوطنية"),
            ),
          ),
          TextBoxCustom(
            hintText: "رقم البطاقة الوطنية",
            controller: id_cardnumber,
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
              child: bodytext(text: "تاريخ نفاذ الاجازة"),
            ),
          ),
          TextBoxCustom(
            hintText: "تاريخ نفاذ الاجازة",
            controller: dateExpire,
          ),
          //البطاقات@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
              child: bodytext(text: "البطاقة الموحدة"),
            ),
          ),
          InkWell(
            onTap: scan,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: Get.height * 0.2,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 222, 222, 222),
                borderRadius: BorderRadius.circular(12),
                image: (scannedData != null && scannedData!.frontImageFile.path.isNotEmpty && File(scannedData!.frontImageFile.path).existsSync())
                    ? DecorationImage(
                        image: FileImage(File(scannedData!.frontImageFile.path)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Center(
                child: (scannedData == null || scannedData!.frontImageFile.path.isEmpty || !File(scannedData!.frontImageFile.path).existsSync()) ? Image.asset("icons/camera.png") : SizedBox.shrink(),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: Get.height * 0.2,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 222, 222, 222),
              borderRadius: BorderRadius.circular(12),
              image: (scannedData != null && scannedData!.backImageFile.path.isNotEmpty && File(scannedData!.backImageFile.path).existsSync())
                  ? DecorationImage(
                      image: FileImage(File(scannedData!.backImageFile.path)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Center(
              child: (scannedData == null || scannedData!.backImageFile.path.isEmpty || !File(scannedData!.backImageFile.path).existsSync()) ? Image.asset("icons/camera.png") : SizedBox.shrink(),
            ),
          ),

          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
              child: bodytext(text: "بطاقة السكن"),
            ),
          ),
          InkWell(
            onTap: locationCard,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: Get.height * 0.2,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 222, 222, 222),
                borderRadius: BorderRadius.circular(12),
                image: (FrontlocationCardImage != null && File(FrontlocationCardImage!.path).existsSync())
                    ? DecorationImage(
                        image: FileImage(FrontlocationCardImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Center(
                child: (FrontlocationCardImage == null || !File(FrontlocationCardImage!.path).existsSync()) ? Image.asset("icons/camera.png") : SizedBox.shrink(),
              ),
            ),
          ),

          InkWell(
            onTap: backlocationCard,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: Get.height * 0.2,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 222, 222, 222),
                borderRadius: BorderRadius.circular(12),
                image: (backlocationCardImage != null && File(backlocationCardImage!.path).existsSync())
                    ? DecorationImage(
                        image: FileImage(backlocationCardImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Center(
                child: (backlocationCardImage == null || !File(backlocationCardImage!.path).existsSync()) ? Image.asset("icons/camera.png") : SizedBox.shrink(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
              child: bodytext(text: "اجازة السوق"),
            ),
          ),

          InkWell(
            onTap: getfrontDrivercard,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: Get.height * 0.2,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 222, 222, 222),
                borderRadius: BorderRadius.circular(12),
                image: (frontDrivercard != null && File(frontDrivercard!.path).existsSync())
                    ? DecorationImage(
                        image: FileImage(frontDrivercard!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Center(
                child: (frontDrivercard == null || !File(frontDrivercard!.path).existsSync()) ? Image.asset("icons/camera.png") : SizedBox.shrink(),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: getbackDrivercard,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: Get.height * 0.2,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 222, 222, 222),
                borderRadius: BorderRadius.circular(12),
                image: (backDrivercard != null && File(backDrivercard!.path).existsSync())
                    ? DecorationImage(
                        image: FileImage(backDrivercard!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Center(
                child: (backDrivercard == null || !File(backDrivercard!.path).existsSync()) ? Image.asset("icons/camera.png") : SizedBox.shrink(),
              ),
            ),
          ),
          //البطاقات@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
              child: bodytext(text: "رقم الهاتف"),
            ),
          ),
          TextBoxCustom(
            hintText: "رقم الهاتف",
            controller: phone,
          ),

          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
              child: bodytext(text: "كلمة المرور"),
            ),
          ),
          TextBoxCustom(
            hintText: "كلمة المرور",
            controller: password,
          ),

          InkWell(
            onTap: () {
              showCustomAwesomeDialog(
                  context: context,
                  title: "ادارة التطبيق",
                  message: "هل تريد تسجيل مركبة للسائق ؟ ",
                  iconHeader: Icons.question_mark_outlined,
                  iconColor: Colors.green,
                  cancelText: "تخطي",
                  okText: "نعم",
                  onOkPressed: () async {
                    try {
                      var response = await net.createRet(Links.driver, {
                        'name': fullname.text,
                        'location': "${location.text}",
                        'phone': phone.text,
                        'country': selectedCountryId,
                        "province": selectedProve,
                        'city': town.text,
                        "is_active": true,
                        "id_number": id_cardnumber.text,
                        'password': password.text,
                        'languages': selectedLang,
                        "car_id_doc1": frontDrivercard,
                        "car_id_doc2": backDrivercard,
                        "car_id_expire": dateExpire.text,
                        if (profileImage != null) 'image': profileImage!,
                        if (scannedData?.frontImageFile != null) 'personal_id_doc1': scannedData!.frontImageFile,
                        if (scannedData?.backImageFile != null) 'personal_id_doc2': scannedData!.backImageFile,
                        if (FrontlocationCardImage != null) 'resident_doc1': FrontlocationCardImage!,
                        if (backlocationCardImage != null) 'resident_doc2': backlocationCardImage!,
                      });

                      if (response is Map && response['data']["id"] != null) {
                        int captainId = response['data']["id"];

                        showCustomAwesomeDialog(
                          context: context,
                          title: "ادارة التطبيق",
                          message: "تم انشاء الحساب بنجاح",
                          iconHeader: Icons.check_outlined,
                          iconColor: Colors.green,
                        );

                        Get.to(() => AddDriverCar(), arguments: {
                          "captain_id": captainId
                        });
                      } else {
                        showCustomAwesomeDialog(
                          context: context,
                          title: "ادارة التطبيق",
                          message: "لم يتم انشاء الحساب",
                          iconHeader: Icons.error_outline,
                          iconColor: Colors.red,
                        );
                        // print("الرد الكامل: $response");
                        print(response['data']["id"]);
                      }
                    } catch (e) {
                      Get.snackbar("هنالك خطا بالاتصال", "$e");
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                      dispose() {
                        isLoading;
                      }
                    }
                  },
                  onCancelPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      var status = await net.create(Links.driver, {
                        'name': fullname.text,
                        'location': "${location.text}",
                        'phone': phone.text,
                        'country': selectedCountryId,
                        'city': town.text,
                        "is_active": true,
                        "id_number": id_cardnumber.text,
                        'password': password.text,
                        'languages': selectedLang,
                        "car_id_doc1": frontDrivercard,
                        "car_id_doc2": backDrivercard,
                        "car_id_expire": dateExpire.text,
                        if (profileImage != null) 'image': profileImage!,
                        if (scannedData?.frontImageFile != null) 'personal_id_doc1': scannedData!.frontImageFile,
                        if (scannedData?.backImageFile != null) 'personal_id_doc2': scannedData!.backImageFile,
                        if (FrontlocationCardImage != null) 'resident_doc1': FrontlocationCardImage!,
                        if (backlocationCardImage != null) 'resident_doc2': backlocationCardImage!,
                      });

                      if (status == 200 || status == 201) {
                        Get.to(() => Home());
                        showCustomAwesomeDialog(
                          context: context,
                          title: "ادارة التطبيق",
                          message: "تم انشاء الحساب بنجاح",
                          iconHeader: Icons.check_outlined,
                          iconColor: Colors.white,
                        );
                      } else {
                        showCustomAwesomeDialog(
                          context: context,
                          title: "ادارة التطبيق",
                          message: "لم يتم انشاء الحساب",
                          iconHeader: Icons.error_outline,
                          iconColor: Colors.white,
                        );
                        print("الرد الكامل: $status");
                      }
                    } catch (e) {
                      Get.snackbar("هنالك خطا بالاتصال", "$e");
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                      dispose() {
                        isLoading;
                      }
                    }
                  });
            },
            child: isLoading!
                ? Center(
                    child: ProfessionalLoadingWidget(),
                  )
                : Container(
                    margin: EdgeInsets.only(left: 15, right: 15, top: 20),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: CustomColors.primary),
                    height: Get.height * 0.06,
                    child: Center(
                      child: bodytext(
                        fontWeight: FontWeight.w400,
                        text: "التالي",
                        textColor: Colors.white,
                      ),
                    ),
                  ),
          ),

          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
