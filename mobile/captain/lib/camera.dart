import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:shahenco_captain/core/constants/api_keys.dart';
import 'package:shahenco_captain/shared/widgets/app_bar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:shahenco_captain/shared/widgets/dialogs.dart';

class CameraPage extends StatefulWidget {
  String docType;
  CameraPage({super.key, required this.docType});


  @override
  _RectangleCameraPageState createState() => _RectangleCameraPageState();
}

class _RectangleCameraPageState extends State<CameraPage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  static String GOOGLE_VISION_API_KEY = APIKeys.googleVisionApiKey;
  // String docType = "carFront";
  XFile? photo;



  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras.first,
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _cameraController!.initialize();

        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }


  Future<String> sendToGoogleVision(String base64Image) async {
    final url = 'https://vision.googleapis.com/v1/images:annotate?key=$GOOGLE_VISION_API_KEY';

    final body = {
      'requests': [
        {
          'image': {'content': base64Image},
          'features': [
            {'type': 'TEXT_DETECTION', 'maxResults': 10}
          ]
        }
      ]
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['responses'] != null &&
          data['responses'].isNotEmpty &&
          data['responses'][0]['textAnnotations'] != null) {

        final text = data['responses'][0]['textAnnotations'][0]['description'];
        return text;
      } else {
        return 'لم يتم العثور على نص في الصورة';
      }
    } else {
      throw Exception('API Error: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: mainAppBar(
            InkWell(
                onTap: (){Get.back();},
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Icon(Icons.arrow_back_ios,color: Colors.white,),
                )),
            context),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Full screen camera preview (background)
            if (_isCameraInitialized && _cameraController != null)
              Positioned.fill(
                child: AspectRatio(
                  aspectRatio: _cameraController!.value.aspectRatio,
                  child: CameraPreview(_cameraController!),
                ),
              )
            else
              Container(
                color: Colors.black,
                child: Center(
                  child: CircularProgressIndicator(color: Get.theme.primaryColor),
                ),
              ),

            Positioned.fill(
              child: ClipPath(
                clipper: ViewfinderClipper(),
                child: Container(
                  color: Colors.white,
                ),
              ),
            ),

            Positioned.fill(
              child: CustomPaint(
                painter: ViewfinderBorderPainter(),
              ),
            ),

            Positioned(
              top: Get.height * 0.2,
              left: 20,
              right: 20,
              child: Text(
                'ضع ${getLabel(widget.docType)} في المنتصف',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Simple capture button
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _isProcessing ? null : captureImage,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isProcessing ? Colors.grey : Get.theme.primaryColor,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: _isProcessing
                        ? CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    )
                        : Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  void showConfirmation(List labels , Map data){
    String message = "";
    data['image'] = photo;
    for(int x=0;x<labels.length;x++){
      message += "${labels[x]} : ${data.values.elementAt(x)} \n";
    }
    CustomDialog.showSuccess(
      title: "تآكيد",
      subtitle: "هل انت متآكد من صحة المعلومات المذكورة ؟",
      message: message,
      primaryButtonText: "نعم",
      secondaryButtonText: "لا",
      onPrimaryPressed: () {
        Get.back();
        Get.back(result: data);

      },
      onSecondaryPressed: (){
        Get.back();
      }
    );
  }


  void extractIdFront(String text){
    var data = {};
    var labels = ["الاسم","الاب","الجد","الام","اللقب"];
    for(var obj in text.split("\n")){
      var value = obj.split(":").last;
      if(obj.contains("الاسم") || obj.contains("ناو")){data['first_name'] = value;}
      if(obj.contains("الاب") || obj.contains("باوك")){data['second_name'] = value;}
      if(obj.contains("الجد") || obj.contains("بابير")){data['last_name'] = value;}
      if(obj.contains("الام") || obj.contains("دايك")){data['mother_name'] = value;}
      if(obj.contains("اللقب") || obj.contains("نازناو")){data['nick_name'] = value;}
    }
    if(data.keys.length == 5){
      showConfirmation(labels, data);
    }else{
      Get.snackbar("خطآ", "يرجى اعادة التقاط الصورة مرة اخرى");
    }
  }
  void extractIdBack(String text){
    var data = {};
    var labels = ["تاريخ الاصدار","تاريخ النفاذ","تاريخ الولادة","الرقم العائلي"];
    for(var obj in text.split("\n")){
      var value = obj.split(":").last;
      if(obj.contains("تاريخ الاصدار")){data['issueDate'] = value;}
      if(obj.contains("تاريخ النفاذ")){data['expireDate'] = value;}
      if(obj.contains("تاريخ الولادة")){data['birthDay'] = value;}
      if(obj.contains("الرقم العائلي")){data['familyNumber'] = value;}
    }
    if(data.keys.length == 4){
      showConfirmation(labels, data);
    }else{
      Get.snackbar("خطآ", "يرجى اعادة التقاط الصورة مرة اخرى");
    }
  }

  void extractLocationFront(String text){}
  void extractLocationBack(String text){}


  void extractDrivingFront(String text){
    var data = {};
    var labels = ["تاريخ الاصدار","تاريخ النفاذ"];
    for(var obj in text.split("\n")){
      if(obj.contains("4a")){data['issueDate'] = obj.split("4a").last;}
      if(obj.contains("4b")){data['expireDate'] = obj.split("4b").last;}
    }
    if(data.keys.length == 2){
      showConfirmation(labels, data);
    }else{
      Get.snackbar("خطآ", "يرجى اعادة التقاط الصورة مرة اخرى");
    }
  }
  void extractDrivingBack(String text){}


  void extractCarIdFront(String text){
    var data = {};
    var labels = ["تاريخ الاصدار","تاريخ النفاذ"];
    RegExp dateReg = RegExp(r'\b\d{1,2}\.\d{1,2}\.\d{4}\b');
    var dates = dateReg.allMatches(text);
    dates.forEach((item){
      print(item.group(0));
    });
    data['issueDate'] = dates.first.group(0);
    data['expireDate'] = dates.elementAt(1).group(0);
    if(data.keys.length == 2){
      showConfirmation(labels, data);
    }else{
      Get.snackbar("خطآ", "يرجى اعادة التقاط الصورة مرة اخرى");
    }
  }

  void extractCarIdBack(String text){}


  Future<void> captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    setState(() {
      _isProcessing = true;
    });
    try {
      photo = await _cameraController!.takePicture();
      final bytes = await File(photo!.path).readAsBytes();
      final base64Image = base64Encode(bytes);
      final result = await sendToGoogleVision(base64Image);
      switch (widget.docType){
        case "idFront": extractIdFront(result);
        case "idBack": extractIdBack(result);
        case "locationFront": extractLocationFront(result);
        case "locationBack": extractLocationBack(result);
        case "drivingFront": extractDrivingFront(result);
        case "drivingBack": extractDrivingBack(result);
        case "carFront": extractCarIdFront(result);
        case "carBack": extractCarIdBack(result);
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في تحليل الصورة: $e',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  String getLabel(String label){
    switch (label){
      case "idFront": return "وجه الهوية";
      case "idBack": return "ظهر الهوية";
      case "locationFront": return "وجه بطاقة السكن";
      case "locationBack": return "ظهر بطاقة السكن";
      case "drivingFront": return "وجه اجازة السوق";
      case "drivingBack": return "ظهر اجازة السوق";
      case "carFront": return "وجه السنوية";
      case "carBack": return "ظهر السنوية";
      default : return "";
    }
  }
}





class ViewfinderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    double viewfinderWidth = size.width * 0.8;  // 80% of screen width
    double viewfinderHeight = size.height * 0.3; // 40% of screen height
    double left = (size.width - viewfinderWidth) / 2;
    double top = (size.height - viewfinderHeight) / 2;

    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, viewfinderWidth, viewfinderHeight),
        Radius.circular(15),
      ),
    );

    path.fillType = PathFillType.evenOdd;

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ViewfinderBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double viewfinderWidth = size.width * 0.8;
    double viewfinderHeight = size.height * 0.3;
    double left = (size.width - viewfinderWidth) / 2;
    double top = (size.height - viewfinderHeight) / 2;

    Paint borderPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, viewfinderWidth, viewfinderHeight),
        Radius.circular(15),
      ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}