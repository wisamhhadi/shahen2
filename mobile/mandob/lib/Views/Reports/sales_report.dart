import 'dart:io';
import 'package:almandobUAE/Models/Mandob.dart';
import 'package:almandobUAE/Services/network.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:almandobUAE/Widgets/appbar.dart';
import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:almandobUAE/Widgets/textbox.dart';
import 'package:almandobUAE/Services/links.dart';

class MaterialItem {
  TextEditingController name = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController count = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController paid = TextEditingController();
  TextEditingController lest = TextEditingController();
  TextEditingController totalPrice = TextEditingController();
  TextEditingController remaining = TextEditingController();
  String? selectedType;

  List<PlatformFile> attachedFiles = [];

  MaterialItem() {
    paid.addListener(updateRemaining);
    totalPrice.addListener(updateRemaining);
    count.addListener(updateTotal);
    price.addListener(updateTotal);
  }

  void updateRemaining() {
    double total = double.tryParse(totalPrice.text) ?? 0;
    double p = double.tryParse(paid.text) ?? 0;
    remaining.text = (total - p).toStringAsFixed(2);
  }

  void updateTotal() {
    double unitPrice = double.tryParse(price.text) ?? 0;
    double qty = double.tryParse(count.text) ?? 0;
    totalPrice.text = (unitPrice * qty).toStringAsFixed(2);
    updateRemaining();
  }

  Map<String, String> toMap(int reportId) {
    return {
      'name': name.text,
      'category': category.text,
      'count': count.text,
      'paid': paid.text,
      'price': price.text,
      'total_price': totalPrice.text,
      'remaining': remaining.text,
      'type': selectedType ?? '',
      'order': reportId.toString(),
      'is_active': 'true',
    };
  }
}

class SalesReport extends StatefulWidget {
  const SalesReport({super.key});

  @override
  State<SalesReport> createState() => _SalesReportState();
}

class _SalesReportState extends State<SalesReport> {
  TextEditingController siteLocation = TextEditingController();
  TextEditingController orderName = TextEditingController();
  String? mandobLat2;
  String? mandobLang2;
  List<PlatformFile> reportFiles = [];
  @override
  void initState() {
    super.initState();
    loadlatlangOnly();
  }

  double calculateTotalPaid() {
    double total = 0;
    for (var item in materials) {
      total += double.tryParse(item.paid.text) ?? 0;
    }
    return total;
  }

  double calculateTotalLest() {
    double total = 0;
    for (var item in materials) {
      total += double.tryParse(item.lest.text) ?? 0;
    }
    return total;
  }

  List<MaterialItem> materials = [
    MaterialItem()
  ];
  var net = Network(auth: true);
  Map<String, String> operationTypes = {
    'بيع': 'sell',
    'شراء': 'buy',
    'صيانة': 'maintain',
    'خدمة': 'service',
  };
  Future<void> loadlatlangOnly() async {
    try {
      print(GetStorage().read('id'));
      var result = await net.list(Links.patchMandob(GetStorage().read('id')), Mandob());

      if (result.isNotEmpty) {
        Mandob mandob = result.first as Mandob;
        if (!mounted) return;

        setState(() {
          mandobLat2 = mandob.latitude2.toString() ?? '0';
          mandobLang2 = mandob.longitude2?.toString() ?? "0";
        });
      }
      print("${mandobLat2}");
      print("${mandobLang2}");
    } catch (e) {
      print("${mandobLang2}");
      print("${mandobLang2}");
      print("خطأ في تحميل الرصيد: $e");
    }
  }

  // دالة إرسال multipart مع ملفات بأسماء حقول file1, file2, ...
  Future<Map<String, dynamic>> sendMultipartRequest(
    String url,
    Map<String, String> fields,
    List<File> files,
  ) async {
    var uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri);

    // أضف حقول البيانات
    request.fields.addAll(fields);

    // أضف الملفات مع أسماء حقول منفصلة file1, file2, ...
    for (int i = 0; i < files.length; i++) {
      var multipartFile = await http.MultipartFile.fromPath('file${i + 1}', files[i].path);
      request.files.add(multipartFile);
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return {
        'status': response.statusCode,
        'data': jsonDecode(responseBody),
      };
    } else {
      return {
        'status': response.statusCode,
        'data': responseBody,
      };
    }
  }

  List<Widget> buildMaterialsWidgets() {
    return List.generate(materials.length, (index) {
      final item = materials[index];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(thickness: 1),
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 15),
            child: bodytext(text: "المادة رقم ${index + 1}"),
          ),
          Row(
            children: [
              Expanded(child: TextBoxCustom(hintText: "اسم المادة", controller: item.name)),
              SizedBox(width: 10),
              Expanded(child: TextBoxCustom(hintText: "صنف المادة", controller: item.category)),
            ],
          ),
          Row(
            children: [
              Expanded(child: TextBoxCustom(hintText: "الّاجل", controller: item.lest)),
            ],
          ),
          Row(
            children: [
              Expanded(child: TextBoxCustom(hintText: "العدد", controller: item.count)),
              SizedBox(width: 10),
              Expanded(child: TextBoxCustom(hintText: "السعر", controller: item.price)),
            ],
          ),
          Row(
            children: [
              Expanded(child: TextBoxCustom(hintText: "نقد", controller: item.paid)),
              SizedBox(width: 10),
              Expanded(child: TextBoxCustom(hintText: "المجموع", controller: item.totalPrice)),
              SizedBox(width: 10),
              Expanded(child: TextBoxCustom(hintText: "المتبقي", controller: item.remaining, readOnly: true)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: DropdownButtonFormField<String>(
              focusColor: Colors.black,
              decoration: InputDecoration(
                labelText: "نوع العملية",
                labelStyle: TextStyle(fontFamily: "font"),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              items: operationTypes.keys.map((String label) {
                return DropdownMenuItem<String>(
                  value: label,
                  child: bodytext(text: label),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  item.selectedType = operationTypes[value!]!;
                });
              },
              value: operationTypes.entries
                      .firstWhere(
                        (e) => e.value == item.selectedType,
                        orElse: () => MapEntry('', ''),
                      )
                      .key
                      .isEmpty
                  ? null
                  : operationTypes.entries.firstWhere((e) => e.value == item.selectedType).key,
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.any);
              if (result != null) {
                setState(() {
                  item.attachedFiles.addAll(result.files);
                });
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CustomColors.secendory,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: bodytext(text: "➕ إرفاق ملفات للمادة", textColor: Colors.black),
              ),
            ),
          ),
          if (item.attachedFiles.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: item.attachedFiles.map((file) => Text("- ${file.name}", style: TextStyle(fontSize: 12, color: Colors.grey[700]))).toList(),
              ),
            ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "تقرير مبيعات",
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(10),
        children: [
          bodytext(text: "موقع العمل"),
          TextBoxCustom(hintText: "موقع العمل", controller: siteLocation),
          bodytext(text: "اسم التقرير"),
          TextBoxCustom(hintText: "اسم التقرير", controller: orderName),
          bodytext(text: "تفاصيل المواد"),
          ...buildMaterialsWidgets(),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                materials.add(MaterialItem());
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CustomColors.secendory,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: bodytext(text: "➕ إضافة مادة أخرى", textColor: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 15),
          GestureDetector(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.any);
              if (result != null) {
                setState(() {
                  reportFiles.addAll(result.files);
                });
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CustomColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: bodytext(
                  text: reportFiles.isEmpty ? "📎 إرفاق ملفات للتقرير" : "📎 تم إرفاق (${reportFiles.length}) ملفات",
                  textColor: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (reportFiles.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: reportFiles.map((file) => Text("- ${file.name}", style: TextStyle(fontSize: 12, color: Colors.grey[700]))).toList(),
              ),
            ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              if (orderName.text.trim().isEmpty || siteLocation.text.trim().isEmpty) {
                Get.snackbar("خطأ", "يرجى تعبئة اسم التقرير وموقع العمل", backgroundColor: Colors.red, colorText: Colors.white);
                return;
              }

              Map<String, String> reportFormData = {
                'name': orderName.text,
                'location': siteLocation.text,
                'latitude': mandobLat2!,
                'longitude': mandobLang2!,
                'is_active': 'true',
                'paid': calculateTotalPaid().toStringAsFixed(2),
                'last': calculateTotalLest().toStringAsFixed(2), // مجموع الآجل
                'mandob': GetStorage().read('id').toString(),
              };

              try {
                // ملفات التقرير فقط
                List<File> reportFilesList = reportFiles.map((pf) => File(pf.path!)).toList();

                var response = await sendMultipartRequest(Links.orderReport, reportFormData, reportFilesList);

                if (response['status'] == 200 || response['status'] == 201 || response['status'] == 204) {
                  int reportId = response['data']['id'];
                  bool allSuccess = true;

                  // إرسال المواد بدون ملفات (أو يمكن تعديلها لإرسال الملفات لو تريد)
                  for (int i = 0; i < materials.length; i++) {
                    MaterialItem item = materials[i];
                    Map<String, String> itemFormData = item.toMap(reportId);
                    // إذا تريد إرسال ملفات المواد أيضًا، استخدم هذا السطر:
                    // List<File> itemFiles = item.attachedFiles.map((pf) => File(pf.path!)).toList();
                    // وإذا لا تريد، أرسل قائمة فارغة:
                    List<File> itemFiles = item.attachedFiles.map((pf) => File(pf.path!)).toList();

                    var itemResponse = await sendMultipartRequest(Links.orderReportItem, itemFormData, itemFiles);

                    if (itemResponse['status'] != 200 && itemResponse['status'] != 201) {
                      allSuccess = false;
                      print("فشل في إرسال المادة رقم ${i + 1}");
                      print("استجابة المادة: ${itemResponse['status']} - ${itemResponse['data']}");
                    }
                  }

                  if (allSuccess) {
                    Get.snackbar(
                      "نجاح",
                      "تم إرسال التقرير وجميع المواد بنجاح",
                      backgroundColor: CustomColors.primary,
                      colorText: Colors.white,
                      titleText: bodytext(
                        text: "نجاح",
                        textColor: Colors.white,
                      ),
                      messageText: bodytext(
                        text: "تم إرسال التقرير وجميع المواد بنجاح",
                        textColor: Colors.white,
                      ),
                    );

                    await Future.delayed(Duration(seconds: 1));
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  } else {
                    Get.snackbar("خطأ", "تم إرسال التقرير لكن فشل إرسال بعض المواد", backgroundColor: Colors.orange, colorText: Colors.white);
                  }
                } else {
                  Get.snackbar("خطأ", "فشل في إرسال التقرير", backgroundColor: Colors.red, colorText: Colors.white);
                }
              } catch (e) {
                Get.snackbar("خطأ", "حدث خطأ أثناء الإرسال: $e", backgroundColor: Colors.red, colorText: Colors.white);
                print(e);
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: CustomColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: bodytext(text: "إرسال", textColor: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
