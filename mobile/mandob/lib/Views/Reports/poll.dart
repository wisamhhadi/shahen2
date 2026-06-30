// الكود كامل بعد إزالة التحقق من إرسال تقرير اليوم
import 'dart:io';
import 'dart:convert';

import 'package:almandobUAE/Models/Mandob.dart';
import 'package:almandobUAE/Models/Questions.dart';
import 'package:almandobUAE/Models/Report.dart';
import 'package:almandobUAE/Services/links.dart';
import 'package:almandobUAE/Services/network.dart';
import 'package:almandobUAE/Widgets/appbar.dart';
import 'package:almandobUAE/Widgets/biometric_card.dart';
import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:almandobUAE/Widgets/loading.dart';
import 'package:almandobUAE/Widgets/report_question.dart';
import 'package:almandobUAE/Widgets/textbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class Poll extends StatefulWidget {
  const Poll({super.key});

  @override
  State<Poll> createState() => _PollState();
}

class _PollState extends State<Poll> {
  final GetStorage storage = GetStorage();
  final Network net = Network(auth: false);

  List<Questions> allQuestions = [];
  List<Questions> filteredQuestions = [];
  List<TextEditingController> answerControllers = [];
  List<bool?> radioValues = [];
  List<TextEditingController> notesControllers = [];
  List<File?> images = [];

  String? selectedValue;
  String? mandobLat2;
  String? mandobLang2;
  bool isLoading = false;

  final Map<String, String> options = {
    "يومي": 'day',
    "اسبوعي": 'week',
    "شهري": 'month',
    "سنوي": 'year',
    "مخصص": 'custom', 
  };

  @override
  void dispose() {
    for (var c in answerControllers) {
      c.dispose();
    }
    for (var c in notesControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> fetchQuestions() async {
    try {
      var response = await net.list(Links.question, Questions());
      if (response != null && mounted) {
        setState(() {
          allQuestions = List<Questions>.from(response);
          applyFilter();
        });
      }
    } catch (e) {
      print("Error fetching questions: $e");
    }
  }

  void applyFilter() {
    if (selectedValue == null) {
      filteredQuestions = [];
    } else {
      filteredQuestions = allQuestions.where((q) => q.type == selectedValue).toList();
    }

    answerControllers = List.generate(filteredQuestions.length, (_) => TextEditingController());
    radioValues = List.generate(filteredQuestions.length, (_) => null);
    notesControllers = List.generate(filteredQuestions.length, (_) => TextEditingController());
    images = List.generate(filteredQuestions.length, (_) => null);

    if (mounted) setState(() {});
  }

  Future<void> loadLocation() async {
    try {
      var result = await net.list(Links.patchMandob(storage.read('id')), Mandob());
      if (result.isNotEmpty && mounted) {
        Mandob mandob = result.first as Mandob;
        setState(() {
          mandobLat2 = mandob.latitude2?.toString() ?? '0';
          mandobLang2 = mandob.longitude2?.toString() ?? '0';
        });
      }
    } catch (e) {
      print("Error loading location: $e");
    }
  }

  Future<void> pickImage(int index) async {
    try {
      File? picked = await anypick(fromCamera: false);
      if (picked != null && mounted) {
        setState(() {
          images[index] = picked;
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> sendSurveyAnswer({
    required int questionId,
    required int reportId,
    required String answerText,
    required bool answerBool,
    required String answerType,
    required String note,
    required File? image,
  }) async {
    try {
      var uri = Uri.parse(Links.answer);
      var request = http.MultipartRequest('POST', uri);

      request.fields.addAll({
        'question': questionId.toString(),
        'report': reportId.toString(),
        'answer': answerText.isNotEmpty ? answerText : (answerBool ? "نعم" : "لا"),
        'answer_type': answerType,
        'is_active': 'true',
        'note': note,
        'mandob': storage.read('id').toString(),
      });

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', image.path, filename: 'question_$questionId.jpg'),
        );
      }

      var response = await request.send();
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to send answer');
      }
    } catch (e) {
      print('Error sending answer: $e');
      rethrow;
    }
  }

 @override
void initState() {
  super.initState();
  selectedValue = 'custom'; // مباشرة نوع التقرير مخصص
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await Future.wait([
      fetchQuestions(),
      loadLocation(),
    ]);
  });
}

  Future<void> _submitReport() async {
    if (selectedValue == null) {
      Get.snackbar("خطأ", "الرجاء اختيار نوع التقرير", colorText: Colors.white, backgroundColor: Colors.red);
      return;
    }

    for (int i = 0; i < filteredQuestions.length; i++) {
      if (filteredQuestions[i].Answertype == 'text' && answerControllers[i].text.isEmpty) {
        Get.snackbar("خطأ", "الرجاء إدخال إجابة للسؤال ${filteredQuestions[i].title}", colorText: Colors.white, backgroundColor: Colors.red);
        return;
      } else if (filteredQuestions[i].Answertype == 'bool' && radioValues[i] == null) {
        Get.snackbar("خطأ", "الرجاء اختيار إجابة للسؤال ${filteredQuestions[i].title}", colorText: Colors.white, backgroundColor: Colors.red);
        return;
      }
    }

    setState(() => isLoading = true);

    try {
      String todayDate = DateTime.now().toIso8601String().substring(0, 10);
      var response = await net.createRet(Links.report, {
        'type': selectedValue,
        "day": todayDate,
        "latitude": mandobLat2 ?? '0',
        "longitude": mandobLang2 ?? '0',
        "is_active": 'true',
        'mandob': storage.read('id'),
      });

      if (response == null || !(response['status'] == 200 || response['status'] == 201 || response['status'] == 204)) {
        print("فشل في إنشاء التقرير");
        setState(() => isLoading = false);
        return;
      }

      int reportId = response['data']['id'];
      for (int i = 0; i < filteredQuestions.length; i++) {
        await sendSurveyAnswer(
          reportId: reportId,
          questionId: filteredQuestions[i].id!,
          answerText: filteredQuestions[i].Answertype == 'text' ? answerControllers[i].text : '',
          answerBool: filteredQuestions[i].Answertype == 'bool' ? (radioValues[i] ?? false) : false,
          answerType: filteredQuestions[i].Answertype!,
          note: notesControllers[i].text,
          image: images[i],
        );
      }

      Get.back();
      Get.snackbar("نجاح", "تم إرسال التقرير بنجاح", colorText: Colors.white, backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("خطأ", e.toString(), colorText: Colors.white, backgroundColor: Colors.red);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "تقرير استبياني",
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: _buildReportForm(),
    );
  }

  Widget _buildReportForm() {
    return ListView(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [
      
        if (filteredQuestions.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: bodytext(text: "لا توجد أسئلة لهذا النوع"),
            ),
          )
        else
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: filteredQuestions.length,
            itemBuilder: (context, index) {
              final question = filteredQuestions[index];
              return _buildQuestionItem(question, index);
            },
          ),
        isLoading ? ProfessionalLoadingWidget() : _buildSubmitButton(),
      ],
    );
  }

  Widget _buildTypeDropdown() {
    return Column(
      children: [
        SizedBox(height: 16),
        Center(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade700, width: 1),
            ),
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              dropdownColor: Colors.green[300],
              hint: bodytext(text: 'اختر نوع التقرير', textColor: Colors.white),
              iconEnabledColor: Colors.white,
              style: TextStyle(color: Colors.white, fontFamily: "font"),
              items: options.keys.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  selectedValue = options[newVal!];
                  applyFilter();
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionItem(Questions question, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bodytext(text: question.title ?? "", fontWeight: FontWeight.bold),
          SizedBox(height: 8),
          if (question.Answertype == 'text')
            ReportQuestion("", "", answerControllers[index])
          else if (question.Answertype == 'bool')
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: bodytext(text: "نعم"),
                    leading: Radio<bool>(
                      value: true,
                      groupValue: radioValues[index],
                      onChanged: (val) => setState(() => radioValues[index] = val),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: bodytext(text: "لا"),
                    leading: Radio<bool>(
                      value: false,
                      groupValue: radioValues[index],
                      onChanged: (val) => setState(() => radioValues[index] = val),
                    ),
                  ),
                ),
              ],
            ),
          Divider(thickness: 1, color: Colors.grey[300]),
          TextBoxCustom(hintText: "الملاحظات", controller: notesControllers[index]),
          SizedBox(height: 8),
          _buildImageUploadButton(index),
          if (images.length > index && images[index] != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Image.file(images[index]!, height: 120),
            ),
          Divider(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildImageUploadButton(int index) {
    return InkWell(
      onTap: () => pickImage(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          height: Get.height * 0.05,
          decoration: BoxDecoration(
            color: CustomColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: bodytext(
              text: "ارفاق ملف للسؤال",
              textColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: Get.height * 0.01),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: CustomColors.primary,
      ),
      height: Get.height * 0.06,
      child: InkWell(
        onTap: _submitReport,
        child: Center(
          child: bodytext(
            fontWeight: FontWeight.bold,
            text: "ارسال",
            textColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
