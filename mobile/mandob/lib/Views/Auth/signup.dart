import 'dart:io';

import 'package:almandobUAE/Services/links.dart';
import 'package:almandobUAE/Services/network.dart';
import 'package:almandobUAE/Views/Auth/otp.dart';
import 'package:almandobUAE/Widgets/biometric_card.dart';
import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/dialgoCustom.dart';
import 'package:almandobUAE/Widgets/drobdownWidget.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:almandobUAE/Widgets/loading.dart';
import 'package:almandobUAE/Widgets/textbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Models/Country.dart';
import '../../Models/Province.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

BiometricCardData? scannedData;
int? selectedCountryId;
int? selectedProvinceId;
File? profileImage;
bool isLoading = false;
File? FrontlocationCardImage;
File? backlocationCardImage;
late Future<List<Country>> country;
late Future<List<Province>> province;
TextEditingController fullname = TextEditingController();

TextEditingController password = TextEditingController();

TextEditingController town = TextEditingController();
TextEditingController location = TextEditingController();
TextEditingController phone = TextEditingController();

class _SignUpState extends State<SignUp> {
  var net = Network(auth: false);
  Future<void> scan() async {
    scannedData = await scanBiometricCardWithApiKey('YOUR_GOOGLE_API_KEY');
    setState(() {
      fullname.text = "${scannedData!.fullName} ${scannedData!.fatherName} ${scannedData!.grandFatherName}";
    });
  }

  @override
  void initState() {
    super.initState();
    country = net.list(Links.country, Country()).then((value) => List<Country>.from(value));
    province = net.list(Links.province, Province()).then((value) => List<Province>.from(value));
  }

  Future<void> profileImagescan() async {
    profileImage = await anypick(fromCamera: true);
    if (profileImage != null) {
      print("📷 تم حفظ الصورة في: \${profileImage!.path}");
      setState(() {});
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: ListView(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            height: 250,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('icons/frameUAE.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: Get.width,
                    height: Get.height * 0.3,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: Get.width * 0.3,
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
              ],
            ),
          ),

          SizedBox(height: 18),

          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Align(alignment: Alignment.topRight, child: bodytext(text: "الاسم الثلاثي")),
          ),
          TextBoxCustom(hintText: "الاسم الثلاثي", controller: fullname),

          Padding(
            padding: const EdgeInsets.only(right: 20, top: 10),
            child: Align(alignment: Alignment.topRight, child: bodytext(text: "الدولة")),
          ),
          buildDropdownFuture<Country>(country, selectedCountryId, (val) => setState(() => selectedCountryId = val)),

          Padding(
            padding: const EdgeInsets.only(right: 20, top: 10),
            child: Align(alignment: Alignment.topRight, child: bodytext(text: "المحافظة")),
          ),
          buildDropdownFuture<Province>(province, selectedProvinceId, (val) => setState(() => selectedProvinceId = val)),

          Padding(
            padding: const EdgeInsets.only(right: 20, top: 10),
            child: Align(alignment: Alignment.topRight, child: bodytext(text: "المنطقة")),
          ),
          TextBoxCustom(hintText: "المنطقة", controller: town),

          Padding(
            padding: const EdgeInsets.only(right: 20, top: 10),
            child: Align(alignment: Alignment.topRight, child: bodytext(text: "العنوان")),
          ),
          TextBoxCustom(hintText: "العنوان", controller: location),

          // ... باقي الحقول بنفس الشكل ...

          // عرض صور البطاقة البايومترية
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

          // عرض صور بطاقة السكن
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
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 10),
            child: Align(alignment: Alignment.topRight, child: bodytext(text: "رقم الهاتف")),
          ),
          TextBoxCustom(hintText: "رقم الهاتف", controller: phone),

          Padding(
            padding: const EdgeInsets.only(right: 20, top: 10),
            child: Align(alignment: Alignment.topRight, child: bodytext(text: "كلمة المرور")),
          ),
          TextBoxCustom(hintText: "كلمة المرور", controller: password),

          InkWell(
            onTap: () async {
              setState(() {
                isLoading = true;
              });
              try {
                var status = await net.create(Links.createMandob, {
                  'name': fullname.text,
                  'location': "${location.text}",
                  'phone': phone.text,
                  'password': password.text,
                  'city': town.text,
                  "country": selectedCountryId,
                  "is_active": true,
                  "province": selectedProvinceId,
                  if (profileImage != null) 'image': profileImage!,
                  if (scannedData?.frontImageFile != null) 'id_doc1': scannedData!.frontImageFile,
                  if (scannedData?.backImageFile != null) 'id_doc2': scannedData!.backImageFile,
                  if (FrontlocationCardImage != null) 'resident_doc1': FrontlocationCardImage!,
                  if (backlocationCardImage != null) 'resident_doc2': backlocationCardImage!,
                });

                if (status == 200 || status == 201) {
                  Get.to(() => Otp(), transition: Transition.upToDown, arguments: phone.text);
                  Future.delayed(Duration(milliseconds: 500), () {
                    showCustomAwesomeDialog(
                      context: context,
                      title: "ادارة التطبيق",
                      message: "تم انشاء الحساب بنجاح",
                      iconHeader: Icons.check_outlined,
                      iconColor: Colors.green,
                    );
                  });
                } else {
                  showCustomAwesomeDialog(
                    context: context,
                    title: "ادارة التطبيق",
                    message: "حدث خطا اثناء عملية انشاء الحساب",
                    iconHeader: Icons.close_outlined,
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
                ? Center(child: ProfessionalLoadingWidget())
                : Container(
                    margin: EdgeInsets.only(
                      top: 10,
                      left: 15,
                      bottom: 5,
                      right: 15,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: CustomColors.primary,
                    ),
                    height: Get.height * 0.06,
                    child: Center(
                      child: bodytext(
                        fontWeight: FontWeight.w400,
                        text: "انشئ الحساب",
                        textColor: Colors.white,
                      ),
                    ),
                  ),
          ),

          InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              margin: EdgeInsets.only(
                top: 5,
                left: 15,
                right: 15,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CustomColors.primary,
              ),
              height: Get.height * 0.06,
              child: Center(
                child: bodytext(
                  fontWeight: FontWeight.w400,
                  text: "رجوع",
                  textColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
