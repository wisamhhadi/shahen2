import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:almandobUAE/Models/Mandob.dart';
import 'package:almandobUAE/Models/Questions.dart';
import 'package:almandobUAE/Services/links.dart';
import 'package:almandobUAE/Services/network.dart';
import 'package:almandobUAE/Widgets/appbar.dart';
import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:almandobUAE/Widgets/loading.dart';
import 'package:almandobUAE/Widgets/report_question.dart';
import 'package:almandobUAE/Widgets/textbox.dart';
import 'package:intl/intl.dart';

class MonthReport extends StatefulWidget {
  final String reportType;

  const MonthReport({required this.reportType, Key? key})
      : super(key: key);

  @override
  State<MonthReport> createState() => _MonthReportState();
}

class _MonthReportState extends State<MonthReport> {
  final GetStorage storage = GetStorage();
  final Network net = Network(auth: false);

  List<Questions> allQuestions = [];
  List<Questions> filteredQuestions = [];
  List<TextEditingController> answerControllers = [];
  List<bool?> radioValues = [];
  List<TextEditingController> notesControllers = [];
  List<List<File>> questionImages = [];
  List<File> reportImages = [];

  String? mandobLat2;
  String? mandobLang2;
  bool isLoading = false;
  bool hasSubmittedToday = false;

  @override
  void dispose() {
    for (var c in answerControllers) c.dispose();
    for (var c in notesControllers) c.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool submitted = await checkDailyReport();
      if (mounted) {
        setState(() => hasSubmittedToday = submitted);
        if (!submitted) {
          await Future.wait([fetchQuestions(), loadLocation()]);
        }
      }
    });
  }

  Future<void> fetchQuestions() async {
    var response = await net.list(Links.question, Questions());
    if (response != null && mounted) {
      setState(() {
        allQuestions = List<Questions>.from(response);
        applyFilter();
      });
    }
  }

  void applyFilter() {
    filteredQuestions =
        allQuestions.where((q) => q.type == widget.reportType).toList();
    answerControllers =
        List.generate(filteredQuestions.length, (_) => TextEditingController());
    radioValues = List.generate(filteredQuestions.length, (_) => null);
    notesControllers =
        List.generate(filteredQuestions.length, (_) => TextEditingController());
    questionImages = List.generate(filteredQuestions.length, (_) => []);
    setState(() {});
  }

  Future<void> loadLocation() async {
    var result =
        await net.list(Links.patchMandob(storage.read('id')), Mandob());
    if (result.isNotEmpty && mounted) {
      Mandob mandob = result.first as Mandob;
      setState(() {
        mandobLat2 = mandob.latitude2?.toString() ?? '0';
        mandobLang2 = mandob.longitude2?.toString() ?? '0';
      });
    }
  }

  Future<bool> checkDailyReport() async {
    try {
      String todayDate = DateTime.now().toIso8601String().substring(0, 10);
      String mandobId = storage.read('id').toString();

      final res = await http.get(Uri.parse(Links.report));
      if (res.statusCode == 200) {
        List<dynamic> data = json.decode(res.body);
        for (var item in data) {
          String createdDate =
              item['created']?.toString().substring(0, 10) ?? '';
          String answerMandobId = item['mandob']?.toString() ?? '';
          if (answerMandobId == mandobId &&
              createdDate == todayDate &&
              item['type'] == widget.reportType) {
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

Future<void> _submitReport() async {
  if (filteredQuestions.isEmpty) return;

  for (int i = 0; i < filteredQuestions.length; i++) {
    if (filteredQuestions[i].Answertype == 'text' &&
        answerControllers[i].text.isEmpty) {
      Get.snackbar("خطأ", "أجب على السؤال: ${filteredQuestions[i].title}",
          colorText: Colors.white, backgroundColor: Colors.red);
      return;
    } else if (filteredQuestions[i].Answertype == 'bool' &&
        radioValues[i] == null) {
      Get.snackbar("خطأ", "أجب على السؤال: ${filteredQuestions[i].title}",
          colorText: Colors.white, backgroundColor: Colors.red);
      return;
    }
  }

  setState(() => isLoading = true);

  try {
    String todayDate = DateTime.now().toIso8601String().substring(0, 10);

    // 1. انشاء طلب MultipartRequest
    var request = http.MultipartRequest('POST', Uri.parse(Links.report));

    // 2. اضافة الحقول العادية
    request.fields['type'] = widget.reportType;
    request.fields['day'] = todayDate;
    request.fields['latitude'] = mandobLat2 ?? '0';
    request.fields['longitude'] = mandobLang2 ?? '0';
    request.fields['is_active'] = 'true';
    request.fields['mandob'] = storage.read('id').toString();

    // 3. اضافة صور التقرير مع تحديد حقل 'file1'...'file5'
    for (int i = 0; i < reportImages.length && i < 5; i++) {
      var file = await http.MultipartFile.fromPath('file${i + 1}', reportImages[i].path);
      request.files.add(file);
    }

    // 4. ارسال الطلب (StreamedResponse)
    var streamedResponse = await request.send();

    // 5. قراءة الاستجابة بشكل كامل (Response)
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = json.decode(response.body);
      int reportId = data['id'];

      // 6. ارسال الاجوبة منفصلة لكل سؤال مع الصور (كما لديك)
      for (int i = 0; i < filteredQuestions.length; i++) {
        var answerRequest =
            http.MultipartRequest('POST', Uri.parse(Links.answer));
        answerRequest.fields.addAll({
          'question': filteredQuestions[i].title.toString(),
          'report': reportId.toString(),
          'answer': filteredQuestions[i].Answertype == 'text'
              ? answerControllers[i].text
              : (radioValues[i]! ? "نعم" : "لا"),
          'answer_type': filteredQuestions[i].Answertype!,
          'note': notesControllers[i].text,
          'is_active': 'true',
          'mandob': storage.read('id').toString(),
        });

        for (int j = 0; j < questionImages[i].length && j < 5; j++) {
          var file = await http.MultipartFile.fromPath('file${j + 1}', questionImages[i][j].path);
          answerRequest.files.add(file);
        }

        var ansStreamedResp = await answerRequest.send();
        var ansResponse = await http.Response.fromStream(ansStreamedResp);

        if (ansResponse.statusCode != 200 && ansResponse.statusCode != 201) {
          Get.snackbar("خطأ", "فشل إرسال جواب السؤال: ${filteredQuestions[i].title}",
              colorText: Colors.white, backgroundColor: Colors.red);
          setState(() => isLoading = false);
          return;
        }
      }

      setState(() => hasSubmittedToday = true);
      Get.back();
      Get.snackbar("نجاح", "تم إرسال التقرير",
          colorText: Colors.white, backgroundColor: Colors.green);
    } else {
      Get.snackbar("خطأ",
          "فشل إرسال التقرير. رمز الخطأ: ${response.statusCode}",
          colorText: Colors.white, backgroundColor: Colors.red);
    }
  } catch (e, stack) {
    print("Exception during submit: $e");
    print(stack);
    Get.snackbar("خطأ", e.toString(),
        colorText: Colors.white, backgroundColor: Colors.red);
  } finally {
    setState(() => isLoading = false);
  }
}



  Future<List<File>> anypickMulti() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (result != null) {
      return result.paths.map((path) => File(path!)).toList();
    } else {
      return [];
    }
  }

  Future<void> pickImages(int index) async {
    List<File>? picked = await anypickMulti();
    if (picked != null) {
      setState(() => questionImages[index].addAll(picked));
    }
  }

  Future<void> pickReportImages() async {
    List<File>? picked = await anypickMulti();
    if (picked != null) {
      setState(() => reportImages.addAll(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeadingText(text: "التقارير الاسبوعية", textColor: Colors.white,),
        centerTitle: true,
      ),
      body: hasSubmittedToday
          ? Center(child: bodytext(text: "تم إرسال التقرير مسبقاً"))
          : ListView(
              padding: EdgeInsets.all(12),
              children: [
                ...List.generate(
                  filteredQuestions.length,
                  (i) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      bodytext(
                          text: filteredQuestions[i].title ?? "",
                          fontWeight: FontWeight.bold),
                      SizedBox(height: 8),
                      if (filteredQuestions[i].Answertype == 'text')
                        ReportQuestion("", "", answerControllers[i])
                      else
                        Row(children: [
                          Radio(
                            value: true,
                            groupValue: radioValues[i],
                            onChanged: (val) =>
                                setState(() => radioValues[i] = val),
                          ),
                          bodytext(text: "نعم"),
                          Radio(
                            value: false,
                            groupValue: radioValues[i],
                            onChanged: (val) =>
                                setState(() => radioValues[i] = val),
                          ),
                          bodytext(text: "لا"),
                        ]),
                      TextBoxCustom(
                          hintText: "ملاحظات", controller: notesControllers[i]),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () => pickImages(i),
                          child: Center(child: bodytext(text: "إرفاق صور للسؤال" ,textColor: Colors.white,)),
                        ),
                      ),
                      Wrap(
                        children: questionImages[i]
                            .map((img) => Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Image.file(img, width: 80, height: 80),
                                ))
                            .toList(),
                      ),
                      Divider(),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: pickReportImages,
                  child: bodytext(text: "إرفاق صور للتقرير" , textColor: Colors.white,),
                ),
                Wrap(
                  children: reportImages
                      .map((img) => Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.file(img, width: 80, height: 80),
                          ))
                      .toList(),
                ),
                isLoading
                    ? ProfessionalLoadingWidget()
                    : ElevatedButton(
                        onPressed: _submitReport,
                        child: bodytext(text: "إرسال" , textColor: Colors.white,),
                      )
              ],
            ),
    );
  }
}
