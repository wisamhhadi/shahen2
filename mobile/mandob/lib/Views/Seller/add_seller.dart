import 'dart:io';

import 'package:almandobUAE/Models/Country.dart';
import 'package:almandobUAE/Models/Languages.dart';
import 'package:almandobUAE/Models/Province.dart';
import 'package:almandobUAE/Models/Specialty.dart';
import 'package:almandobUAE/Services/links.dart';
import 'package:almandobUAE/Services/network.dart';
import 'package:almandobUAE/Views/Auth/otp.dart';
import 'package:almandobUAE/Views/Driver/add_driver_car.dart';
import 'package:almandobUAE/Views/Seller/seller.dart';
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

class AddSeller extends StatefulWidget {
  const AddSeller({super.key});

  @override
  State<AddSeller> createState() => _AddSellerState();
}

class _AddSellerState extends State<AddSeller> {
  int? selectedCountryId;
  int? selectedProvinceId;
  int? selectedlangId;
  int? selectActivityType;
  int? selectSpece;
  late Future<List<Country>> country;
  late Future<List<Province>> province;
  late Future<List<Languages>> lang;
  late Future<List<Languages>> activityType;
  late Future<List<Specialty>> spec;
  BiometricCardData? scannedData;
  File? profileImage;
  File? companyDoc;
  var net = Network(auth: false);
  TextEditingController fullname = TextEditingController();
  TextEditingController companyName = TextEditingController();
  void initState() {
    super.initState();
    country = net.list(Links.country, Country()).then((value) => List<Country>.from(value));
    province = net.list(Links.province, Province()).then((value) => List<Province>.from(value));
    lang = net.list(Links.language, Languages()).then((value) => List<Languages>.from(value));
    activityType = net.list(Links.activityType, Languages()).then((value) => List<Languages>.from(value));
    spec = net.list(Links.specialty, Specialty()).then((value) => List<Specialty>.from(value));
  }

  bool isLoading = false;
  TextEditingController password = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController town = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController workType = TextEditingController();
  TextEditingController dateExpire = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Future<void> scan() async {
      scannedData = await scanBiometricCardWithApiKey('YOUR_GOOGLE_API_KEY');
      setState(() {
        fullname.text = "${scannedData!.fullName} ${scannedData!.fatherName} ${scannedData!.grandFatherName}";
      });
    }

    Future<void> profileImagescan() async {
      profileImage = await anypick(fromCamera: true);
      if (profileImage != null) {
        print("📷 تم حفظ الصورة في: \${profileImage!.path}");
        setState(() {});
      }
    }

    Future<void> company_document() async {
      companyDoc = await anypick(fromCamera: true);
      if (companyDoc != null) {
        print("📷 تم حفظ الصورة في: \${companyDoc!.path}");
        setState(() {});
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "اضافة تاجر",
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
          // Align(
          //   alignment: Alignment.topRight,
          //   child: Padding(
          //     padding: const EdgeInsets.only(right: 20, bottom: 5),
          //     child: bodytext(text: "نوع العمل"),
          //   ),
          // ),
          // TextBoxCustom(
          //   hintText: "نوع العمل",
          //   controller: workType,
          // ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 5),
              child: bodytext(text: "الاسم الثلاثي"),
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
              child: bodytext(text: "المحافظة"),
            ),
          ),
          buildDropdownFuture<Province>(province, selectedProvinceId, (val) => setState(() => selectedProvinceId = val)),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
              child: bodytext(text: "التخصص"),
            ),
          ),
          buildDropdownFuture<Specialty>(spec, selectSpece, (val) => setState(() => selectSpece = val)),

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
              child: bodytext(text: "اسم الشركة"),
            ),
          ),
          TextBoxCustom(
            hintText: "اسم الشركة",
            controller: companyName,
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
              child: bodytext(text: "نوع النشاط"),
            ),
          ),
          buildDropdownFuture<Languages>(activityType, selectActivityType, (val) => setState(() => selectActivityType = val)),
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
              child: bodytext(text: "شهادة التاسيس"),
            ),
          ),
          InkWell(
            onTap: company_document,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: Get.height * 0.2,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 222, 222, 222),
                borderRadius: BorderRadius.circular(12),
                image: (companyDoc != null && companyDoc!.path.isNotEmpty && File(companyDoc!.path).existsSync())
                    ? DecorationImage(
                        image: FileImage(File(companyDoc!.path)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Center(
                child: (companyDoc == null || companyDoc!.path.isEmpty || !File(companyDoc!.path).existsSync()) ? Image.asset("icons/camera.png") : SizedBox.shrink(),
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
            onTap: () async {
              setState(() {
                isLoading = true;
              });
              try {
                var status = await net.create(Links.createUser, {
                  'name': fullname.text,
                  'location': "${location.text}",
                  'phone': phone.text,
                  'password': password.text,
                  "city": town.text,
                  "language": selectedlangId,
                  "province": selectedProvinceId,
                  "country": selectedCountryId,
                  'type': "company",
                  "company_doc": companyDoc,
                  "company_name": companyName.text,
                  "activity_type": selectActivityType,

                  'is_active': true,
                  if (profileImage != null) 'image': profileImage!,
                  if (scannedData?.frontImageFile != null) 'id_doc1': scannedData!.frontImageFile,
                  // if (scannedData?.backImageFile != null) 'id_doc2': scannedData!.backImageFile,
                });

                if (status == 200 || status == 201) {
                  Get.to(Home(), transition: Transition.upToDown);
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
                    message: "حدث خلل ما يرجى التاكد من الحقول",
                    iconHeader: Icons.close,
                    iconColor: Colors.red,
                  );
                  print(" حصل خطا ما @@@@@@@@@@@@@@@@@@@@@");
                  print(status);
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
            child: isLoading
                ? ProfessionalLoadingWidget()
                : Container(
                    margin: EdgeInsets.only(left: 15, right: 15, top: 20),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: CustomColors.primary),
                    height: Get.height * 0.06,
                    child: Center(
                      child: bodytext(
                        fontWeight: FontWeight.w400,
                        text: "انشاء",
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
