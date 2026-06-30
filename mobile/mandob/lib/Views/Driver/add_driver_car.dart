import 'dart:io';

import 'package:almandobUAE/Models/CarCompany.dart';
import 'package:almandobUAE/Models/CarModel.dart';
import 'package:almandobUAE/Models/Seller.dart';
import 'package:almandobUAE/Services/links.dart';
import 'package:almandobUAE/Services/network.dart';

import 'package:almandobUAE/Views/Auth/signup.dart';
import 'package:almandobUAE/Views/Driver/driver.dart';
import 'package:almandobUAE/Views/home.dart';

import 'package:almandobUAE/Widgets/appbar.dart';
import 'package:almandobUAE/Widgets/biometric_card.dart';
import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/dialgoCustom.dart';
import 'package:almandobUAE/Widgets/drobdownWidget.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';

import 'package:almandobUAE/Widgets/textbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AddDriverCar extends StatefulWidget {
  const AddDriverCar({super.key});

  @override
  State<AddDriverCar> createState() => _AddDriverCarState();
}

class _AddDriverCarState extends State<AddDriverCar> {
  final Map<String, dynamic> args = Get.arguments;
  final int captainId = Get.arguments["captain_id"];
  int? selectedCarcompany;
  int? selectedCarcolor;
  int? selectedCarmodel;
  int? selectedCaryear;
  int? selectedCartype;
  int? selectedCarsize;
  File? carimage;
  File? carNumber;
  File? wekalaImage;
  TextEditingController car_number = TextEditingController();
  bool isLoading = false;
  final net = Network(auth: false);
  late Future<List<CarCompany>> carCompaniesFuture;
  late Future<List<CarModel>> carModelsFuture;
  late Future<List<CarCompany>> carColorsFuture; // مؤقتًا نفس CarCompany
  late Future<List<CarCompany>> carCategory; // مؤقتًا نفس CarCompany
  late Future<List<CarCompany>> carSize; // مؤقتًا نفس CarCompany

  @override
  void initState() {
    super.initState();
    carCompaniesFuture = net.list(Links.carCompany, CarCompany()).then((value) => List<CarCompany>.from(value));
    carModelsFuture = net.list(Links.carModel, CarModel()).then((value) => List<CarModel>.from(value));
    carColorsFuture = net.list(Links.carColor, CarCompany()).then((value) => List<CarCompany>.from(value));
    carCategory = net.list(Links.carCategory, CarCompany()).then((value) => List<CarCompany>.from(value));
    carSize = net.list(Links.carSize, CarCompany()).then((value) => List<CarCompany>.from(value));
  }

  Future<void> scan() async {
    scannedData = await scanBiometricCardWithApiKey('YOUR_GOOGLE_API_KEY');
    setState(() {
      car_number.text = scannedData!.carNumber;
    });
  }

  Future<void> carimage1() async {
    carimage = await anypick(fromCamera: true);
    if (carimage != null) {
      print("📷 تم حفظ الصورة في: \${profileImage!.path}");
      setState(() {});
    }
  }

  Future<void> wakalaImage() async {
    wekalaImage = await anypick(fromCamera: true);
    if (wekalaImage != null) {
      print("📷 تم حفظ الصورة في: \${profileImage!.path}");
      setState(() {});
    }
  }

  Future<void> carnumber() async {
    carNumber = await anypick(fromCamera: true);
    if (carNumber != null) {
      print("📷 تم حفظ الصورة في: \${profileImage!.path}");
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "اضافة مركبة",
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(height: 18),
          InkWell(
            onTap: () {
              print(scannedData!.carNumber);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 5),
              child: bodytext(text: "الشركة المصنعة"),
            ),
          ),
          buildDropdownFuture<CarCompany>(carCompaniesFuture, selectedCarcompany, (val) => setState(() => selectedCarcompany = val)),
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
            child: bodytext(text: "الموديل"),
          ),
          buildDropdownFuture<CarModel>(carModelsFuture, selectedCarmodel, (val) => setState(() => selectedCarmodel = val)),
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
            child: bodytext(text: "اللون"),
          ),
          buildDropdownFuture<CarCompany>(carColorsFuture, selectedCarcolor, (val) => setState(() => selectedCarcolor = val)),
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
            child: bodytext(text: "نوع القاطرة"),
          ),
          buildDropdownFuture<CarCompany>(carCategory, selectedCartype, (val) => setState(() => selectedCartype = val)),
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
            child: bodytext(text: "حجم القاطرة"),
          ),
          buildDropdownFuture<CarCompany>(carSize, selectedCarsize, (val) => setState(() => selectedCarsize = val)),
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
            child: bodytext(text: "سنة الصنع"),
          ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                CustomColors.secendory,
                CustomColors.primary
              ]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropdownButtonFormField<int>(
                  value: selectedCaryear, // <-- هنا أضف القيمة المختارة
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.date_range, color: Colors.black),
                    border: InputBorder.none,
                  ),
                  hint: bodytext(
                    text: "سنة الصنع",
                  ),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                  style: TextStyle(
                    fontFamily: "font",
                    color: Colors.black,
                  ),
                  items: [
                    1980,
                    1981,
                    1982,
                    1983,
                    1984,
                    1985,
                    1986,
                    1987,
                    1988,
                    1989,
                    1990,
                    1991,
                    1992,
                    1993,
                    1994,
                    1995,
                    1996,
                    1997,
                    1998,
                    1999,
                    2000,
                    2001,
                    2002,
                    2003,
                    2004,
                    2005,
                    2006,
                    2007,
                    2008,
                    2009,
                    2010,
                    2011,
                    2012,
                    2013,
                    2014,
                    2015,
                    2016,
                    2017,
                    2018,
                    2019,
                    2020,
                    2021,
                    2022,
                    2023,
                    2024,
                    2025
                  ].map((year) {
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => selectedCaryear = value),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
            child: bodytext(text: "سنة الصنع"),
          ),
          TextBoxCustom(
            hintText: "رقم السيارة",
            controller: car_number,
          ),
          //البطاقات@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
              child: bodytext(text: "السنوية"),
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
              child: bodytext(text: "الوكالة"),
            ),
          ),

          InkWell(
            onTap: wakalaImage,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: Get.height * 0.2,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 222, 222, 222),
                borderRadius: BorderRadius.circular(12),
                image: (wekalaImage != null && File(wekalaImage!.path).existsSync())
                    ? DecorationImage(
                        image: FileImage(wekalaImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Center(
                child: (wekalaImage == null || !File(wekalaImage!.path).existsSync()) ? Image.asset("icons/camera.png") : SizedBox.shrink(),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),

          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
              child: bodytext(text: "صورة المركبة"),
            ),
          ),
          InkWell(
            onTap: carimage1,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: Get.height * 0.2,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 222, 222, 222),
                borderRadius: BorderRadius.circular(12),
                image: (carimage != null && File(carimage!.path).existsSync())
                    ? DecorationImage(
                        image: FileImage(carimage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Center(
                child: (carimage == null || !File(carimage!.path).existsSync()) ? Image.asset("icons/camera.png") : SizedBox.shrink(),
              ),
            ),
          ),

          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 5, top: 10),
              child: bodytext(text: "رقم المركبة"),
            ),
          ),

          InkWell(
            onTap: carnumber,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: Get.height * 0.2,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 222, 222, 222),
                borderRadius: BorderRadius.circular(12),
                image: (carNumber != null && File(carNumber!.path).existsSync())
                    ? DecorationImage(
                        image: FileImage(carNumber!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Center(
                child: (carNumber == null || !File(carNumber!.path).existsSync()) ? Image.asset("icons/camera.png") : SizedBox.shrink(),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),

          //البطاقات@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

          InkWell(
            onTap: () async {
              setState(() {
                isLoading = true;
              });
              try {
                var status = await net.createRet(Links.createCar, {
                  "car_number": car_number.text,
                  "car_manu_year": selectedCaryear,
                  "car_doc1": scannedData?.frontImageFile ?? null,
                  "car_doc2": scannedData?.backImageFile ?? null,
                  "image1": carimage,
                  "image2": carNumber,
                  "image3": wekalaImage,
                  "is_active": true,
                  "captain": captainId,
                  "car_letter": null,
                  "car_category": selectedCartype ?? null,
                  "car_company": selectedCarcompany ?? null,
                  "car_model": selectedCarmodel ?? null,
                  "car_color": selectedCarcolor ?? null,
                  "car_size": selectedCarsize ?? null,
                });
                if (status is Map && status['data']["id"] != null) {
                  int carid = status['data']["id"];
                  showCustomAwesomeDialog(
                    context: context,
                    title: "ادارة التطبيق",
                    message: "تم انشاء الحساب بنجاح",
                    iconHeader: Icons.check_outlined,
                    iconColor: Colors.green,
                  );
                  var updateCaptin = await net.patchHttp(
                    Links.patchDriver(captainId), // تأكد أن الرابط صحيح مثلاً: "drivers/$captainId/"
                    {
                      'car': "$carid",
                    },
                  );

                  if (updateCaptin.statusCode == 200 || updateCaptin.statusCode == 201) {
                    print("✅ تم تحديث الكابتن وربطه بالسيارة بنجاح");
                  } else {
                    print("❌ فشل تحديث الكابتن");
                    print(updateCaptin.statusCode);
                  }

                  Get.to(
                    () => Home(),
                  );
                } else {
                  showCustomAwesomeDialog(
                    context: context,
                    title: "ادارة التطبيق",
                    message: "لم يتم انشاء الحساب",
                    iconHeader: Icons.error_outline,
                    iconColor: Colors.red,
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
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              height: Get.height * 0.06,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: CustomColors.primary),
              child: Center(
                child: bodytext(fontWeight: FontWeight.w400, text: "التالي", textColor: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
