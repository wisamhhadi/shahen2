import 'dart:io';

import 'package:almandobUAE/Models/Country.dart';
import 'package:almandobUAE/Models/Province.dart';
import 'package:almandobUAE/Models/Specialty.dart';
import 'package:almandobUAE/Services/links.dart';
import 'package:almandobUAE/Services/network.dart';
import 'package:almandobUAE/Views/Auth/otp.dart';
import 'package:almandobUAE/Views/Auth/signup.dart';
import 'package:almandobUAE/Views/Carrier/carrier.dart';
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

class AddCarrier extends StatefulWidget {
  const AddCarrier({super.key});

  @override
  State<AddCarrier> createState() => _AddCarrierState();
}

class _AddCarrierState extends State<AddCarrier> {
  var net = Network(auth: false);
  int? selectedCountryId;
  int? selectedProvinceId;
  int? selectedspeId;
  BiometricCardData? scannedData;
  File? FrontlocationCardImage;
  File? backlocationCardImage;
  File? certificateIncorporation;
  TextEditingController fullname = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController town = TextEditingController();
  TextEditingController location = TextEditingController();
  bool isLoading = false;
  TextEditingController phone = TextEditingController();
  late Future<List<Country>> country;
  late Future<List<Province>> province;
  late Future<List<Specialty>> specialty;
  @override
  void initState() {
    super.initState();
    country = net.list(Links.country, Country()).then((value) => List<Country>.from(value));
    province = net.list(Links.province, Province()).then((value) => List<Province>.from(value));
    specialty = net.list(Links.specialty, Specialty()).then((value) => List<Specialty>.from(value));
  }

  @override
  Widget build(BuildContext context) {
    Future<void> scan() async {
      scannedData = await scanBiometricCardWithApiKey('YOUR_GOOGLE_API_KEY');
      setState(() {
        // fullname.text = "${scannedData!.fullName} ${scannedData!.fatherName} ${scannedData!.grandFatherName}";
      });
    }

    Future<void> locationCardfront() async {
      FrontlocationCardImage = await anypick(fromCamera: true);
      if (FrontlocationCardImage != null) {
        print("📷 تم حفظ الصورة في: \${FrontlocationCardImage!.path}");
        setState(() {});
      }
    }

    Future<void> locationCardback() async {
      backlocationCardImage = await anypick(fromCamera: true);
      if (backlocationCardImage != null) {
        print("📷 تم حفظ الصورة في: \${FrontlocationCardImage!.path}");
        setState(() {});
      }
    }

    Future<void> getCertificate() async {
      certificateIncorporation = await anypick(fromCamera: true);
      if (certificateIncorporation != null) {
        print("📷 تم حفظ الصورة في: \${FrontlocationCardImage!.path}");
        setState(() {});
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "اضافة ناقل",
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
          SizedBox(
            height: 18,
          ),

          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 5),
              child: bodytext(text: "اسم الشركة"),
            ),
          ),
          TextBoxCustom(
            hintText: "اسم الشركة",
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
          buildDropdownFuture<Specialty>(specialty, selectedspeId, (val) => setState(() => selectedspeId = val)),
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
          //البطاقات@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
              child: bodytext(text: "شهادة التاسيس"),
            ),
          ),
          InkWell(
            onTap: getCertificate,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: Get.height * 0.2,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 222, 222, 222),
                borderRadius: BorderRadius.circular(12),
                image: (certificateIncorporation != null && File(certificateIncorporation!.path).existsSync())
                    ? DecorationImage(
                        image: FileImage(certificateIncorporation!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Center(
                child: (certificateIncorporation == null || !File(certificateIncorporation!.path).existsSync()) ? Image.asset("icons/camera.png") : SizedBox.shrink(),
              ),
            ),
          ),

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
            onTap: locationCardfront,
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
            onTap: locationCardback,
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

          // Align(
          //   alignment: Alignment.topRight,
          //   child: Padding(
          //     padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
          //     child: bodytext(text: "عدد السيارات المتوقعة"),
          //   ),
          // ),
          // TextBoxCustom(hintText: "من"),
          // Align(
          //   alignment: Alignment.topRight,
          //   child: Padding(
          //     padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
          //     child: bodytext(text: "عدد السيارات المتوقعة"),
          //   ),
          // ),
          // TextBoxCustom(hintText: "الى"),

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
                var status = await net.create(Links.deliveryCompany, {
                  'name': fullname.text,
                  'location': "${location.text}",
                  "city": town.text,
                  'phone': phone.text,
                  'country': selectedCountryId,
                  'province': selectedProvinceId,
                  'specialty': selectedspeId,
                  "is_active": true,
                  'password': password.text,
                  if (certificateIncorporation != null) 'company_doc1': certificateIncorporation!,
                  if (scannedData?.frontImageFile != null) 'id_doc1': scannedData!.frontImageFile,
                  if (scannedData?.backImageFile != null) 'id_doc2': scannedData!.backImageFile,
                  if (FrontlocationCardImage != null) 'resident_doc1': FrontlocationCardImage!,
                  if (backlocationCardImage != null) 'resident_doc2': backlocationCardImage!,
                });
                if (status == 200 || status == 201) {
                  Get.to(Home());
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
                    iconColor: Colors.red,
                  );
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
