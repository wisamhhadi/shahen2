import 'dart:io';
import 'dart:convert';
import 'package:almandobUAE/Models/QuestionChoies.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:almandobUAE/Models/Mandob.dart';
import 'package:almandobUAE/Models/Questions.dart';
import 'package:almandobUAE/Models/CustomReport.dart'; // أضف موديل CustomReport هنا
import 'package:almandobUAE/Services/links.dart';
import 'package:almandobUAE/Services/network.dart';
import 'package:almandobUAE/Widgets/appbar.dart';
import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:almandobUAE/Widgets/loading.dart';
import 'package:almandobUAE/Widgets/report_question.dart';
import 'package:almandobUAE/Widgets/textbox.dart';

class SurveyReport extends StatefulWidget {
  final String reportType;
  const SurveyReport({required this.reportType, Key? key}) : super(key: key);

  @override
  State<SurveyReport> createState() => _SurveyReportState();
}

class _SurveyReportState extends State<SurveyReport> {
  final GetStorage storage = GetStorage();
  final Network net = Network(auth: false);

  List<Questions> allQuestions = [];
  List<Questions> filteredQuestions = [];
  List<CustomReport> customReports = [];

  List<TextEditingController> answerControllers = [];
  List<bool?> radioValues = [];
  List<TextEditingController> notesControllers = [];
  List<List<File>> questionImages = [];
  List<File> reportImages = [];
  List<List<QuestionChose>> questionChoices = [];
  List<int?> selectedChoices = [];
TextEditingController titlereport = TextEditingController() ; 
  String? mandobLat2;
  String? mandobLang2;
  String? reportCustomId;
  bool isLoading = false;
  late CustomReport report;

  @override
  void dispose() {
    for (var c in answerControllers) c.dispose();
    for (var c in notesControllers) c.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    report = Get.arguments as CustomReport;
    
    titlereport.text = report.title ?? "";
    reportCustomId = report.id.toString() ?? "";
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchCustomReports();
      await Future.wait([fetchQuestions(), loadLocation()]);
    });
  }

  Future<void> fetchCustomReports() async {
    final mandobId = storage.read('id');
    var response = await net.list(
        '${Links.customReport}?mandob=$mandobId', CustomReport());
    if (response != null && mounted) {
      setState(() {
        customReports = List<CustomReport>.from(response);
      });
    }
  }

  Future<void> fetchQuestions() async {
    var response = await net.list(Links.question, Questions());
    if (response != null && mounted) {
      setState(() {
        allQuestions = List<Questions>.from(response);
      });
      applyFilter();
    }
  }

  void applyFilter() {
  // تأكد أن المعرف ليس فارغًا
  if (reportCustomId == null) return;

  // تصفية الأسئلة حسب التقرير المخصص فقط
  filteredQuestions = allQuestions
      .where((q) => q.customReport != null && q.customReport.toString() == reportCustomId)
      .toList();

  answerControllers =
      List.generate(filteredQuestions.length, (_) => TextEditingController());
  radioValues = List.generate(filteredQuestions.length, (_) => null);
  notesControllers =
      List.generate(filteredQuestions.length, (_) => TextEditingController());
  questionImages = List.generate(filteredQuestions.length, (_) => []);
  questionChoices = List.generate(filteredQuestions.length, (_) => []);
  selectedChoices = List.generate(filteredQuestions.length, (_) => null);

  for (int i = 0; i < filteredQuestions.length; i++) {
    if (filteredQuestions[i].Answertype == 'choice') {
      fetchQuestionChoices(filteredQuestions[i].id!, i);
    }
  }

  setState(() {});
}

  Future<void> fetchQuestionChoices(int questionId, int index) async {
    try {
      var response = await net.list(
          '${Links.questionChoice}?question=$questionId', QuestionChose());
      if (response != null && mounted) {
        setState(() {
          questionChoices[index] = List<QuestionChose>.from(response);
        });
      }
    } catch (e) {
      print('Error fetching choices for question $questionId: $e');
    }
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

 Future<void> _submitReport() async {
  if (filteredQuestions.isEmpty) return;

  for (int i = 0; i < filteredQuestions.length; i++) {
    final question = filteredQuestions[i];
    if (question.Answertype == 'text' && answerControllers[i].text.isEmpty) {
      Get.snackbar("خطأ", "أجب على السؤال: ${question.title}",
          colorText: Colors.white, backgroundColor: Colors.red);
      return;
    } else if (question.Answertype == 'bool' && radioValues[i] == null) {
      Get.snackbar("خطأ", "أجب على السؤال: ${question.title}",
          colorText: Colors.white, backgroundColor: Colors.red);
      return;
    } else if (question.Answertype == 'choice' && selectedChoices[i] == null) {
      Get.snackbar("خطأ", "أجب على السؤال: ${question.title}",
          colorText: Colors.white, backgroundColor: Colors.red);
      return;
    }
  }

  setState(() => isLoading = true);

  try {
    final mandobId = storage.read('id')?.toString();

    if (mandobId == null) {
      Get.snackbar("خطأ", "لا يوجد معرف للمندوب",
          colorText: Colors.white, backgroundColor: Colors.red);
      setState(() => isLoading = false);
      return;
    }

    for (int i = 0; i < filteredQuestions.length; i++) {
      final question = filteredQuestions[i];

      String answer = '';
      if (question.Answertype == 'text') {
        answer = answerControllers[i].text;
      } else if (question.Answertype == 'bool') {
        answer = radioValues[i]! ? "نعم" : "لا";
      } else if (question.Answertype == 'choice') {
        final selectedChoice = questionChoices[i].firstWhere(
          (choice) => choice.id == selectedChoices[i],
          orElse: () => QuestionChose(choiceText: 'غير محدد'),
        );
        answer = selectedChoice.choiceText ?? 'غير محدد';
      }

      var answerRequest = http.MultipartRequest('POST', Uri.parse(Links.customAnswer));
      answerRequest.fields.addAll({
        'question': question.title.toString(),
        'custom_report': reportCustomId ?? '', // استخدم معرف التقرير مباشرة
        'answer': answer,
        'answer_type': question.Answertype ?? '',
        'note': notesControllers[i].text,
        'is_active': 'true',
        'mandob': mandobId,
      });

      for (int j = 0; j < questionImages[i].length && j < 5; j++) {
        File file = questionImages[i][j];
        if (file.existsSync()) {
          answerRequest.files.add(await http.MultipartFile.fromPath('file${j + 1}', file.path));
        }
      }

      var ansResponse = await answerRequest.send();
      var finalResponse = await http.Response.fromStream(ansResponse);

      print("Answer for Q${question.id} => ${finalResponse.statusCode}");
      print("Answer Body: ${finalResponse.body}");

      if (finalResponse.statusCode != 200 && finalResponse.statusCode != 201) {
        Get.snackbar("خطأ", "فشل إرسال جواب السؤال: ${question.title}",
            colorText: Colors.white, backgroundColor: Colors.red);
        setState(() => isLoading = false);
        return;
      }
    }

    Get.back();
    Get.snackbar("نجاح", "تم إرسال الأجوبة بنجاح",
        colorText: Colors.white, backgroundColor: Colors.green);
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

  Widget _buildQuestionInput(int index) {
    final question = filteredQuestions[index];
    if (question.Answertype == 'text') {
      return ReportQuestion("", "", answerControllers[index]);
    } else if (question.Answertype == 'bool') {
      return Row(children: [
        Radio(
            value: true,
            groupValue: radioValues[index],
            onChanged: (val) => setState(() => radioValues[index] = val)),
        bodytext(text: "نعم"),
        Radio(
            value: false,
            groupValue: radioValues[index],
            onChanged: (val) => setState(() => radioValues[index] = val)),
        bodytext(text: "لا"),
      ]);
    } else if (question.Answertype == 'choice') {
      return Column(
        children: questionChoices[index]
            .map((choice) => RadioListTile<int>(
                  title: bodytext(text: choice.choiceText ?? ''),
                  value: choice.id!,
                  groupValue: selectedChoices[index],
                  onChanged: (value) =>
                      setState(() => selectedChoices[index] = value),
                ))
            .toList(),
      );
    } else {
      return bodytext(text: "نوع سؤال غير معروف");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: CustomAppBar(title: "تقارير استبيانية" ,  leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextBoxCustom(hintText: "عنوان التقرير"   , controller: titlereport,readOnly: true,),
          ) , 
          Divider() ,
          ...List.generate(
              filteredQuestions.length,
              (i) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      bodytext(
                          text: filteredQuestions[i].title ?? "",
                          fontWeight: FontWeight.bold),
                      SizedBox(height: 8),
                      _buildQuestionInput(i),
                      TextBoxCustom(
                          hintText: "ملاحظات", controller: notesControllers[i]),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () => pickImages(i),
                          child: Center(
                              child: bodytext(
                                  text: "إرفاق صور للسؤال",
                                  textColor: Colors.white)),
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
                  )),
          // ElevatedButton(
          //   onPressed: pickReportImages,
          //   child: bodytext(text: "إرفاق صور للتقرير", textColor: Colors.white),
          // ),
          // Wrap(
          //   children: reportImages
          //       .map((img) => Padding(
          //             padding: const EdgeInsets.all(4.0),
          //             child: Image.file(img, width: 80, height: 80),
          //           ))
          //       .toList(),
          // ),
          isLoading
              ? ProfessionalLoadingWidget()
              : ElevatedButton(
                  onPressed: _submitReport,
                  child: bodytext(text: "إرسال", textColor: Colors.white),
                )  , 
                SizedBox(height: 20,)
        ],
      ),
    );
  }
}
