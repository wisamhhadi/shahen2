



import 'package:almandobUAE/Models/CustomReport.dart';
import 'package:almandobUAE/Services/links.dart';
import 'package:almandobUAE/Services/network.dart';
import 'package:almandobUAE/Views/Reports/survey_report.dart';
import 'package:almandobUAE/Widgets/appbar.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:almandobUAE/Widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CustomReports extends StatefulWidget {
  const CustomReports({super.key});

  @override
  State<CustomReports> createState() => _CustomReportsState();
}

class _CustomReportsState extends State<CustomReports> {
  @override
  var net   = Network(auth: true) ; 
  
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar: CustomAppBar(title: "تقارير استبيانية", leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),),
      body:FutureBuilder(
        future: net.list(Links.customReport, CustomReport()),
    
        builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                child: ProfessionalLoadingWidget(),
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text(
                "لاتوجد بيانات",
                style: TextStyle(color: Colors.blueAccent),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "لايوجد بيانات",
              ),
            );
          } else
          return ListView.builder(
  itemCount: snapshot.data.length,
  itemBuilder: (BuildContext context, int index) {
    print(index);
    var data = snapshot.data[index] as CustomReport;
    print(data);
      // print(GetStorage().read('id')) ;
    print(data.mandob);

        if (data.mandob == GetStorage().read('id') || data.mandob == null)
      
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          title: bodytext(text: "${data.title}"),
         onTap: () {
  Get.to(() => SurveyReport( reportType: 'custom',) , arguments: data);
},
        ),
      ),
    );
  },
);
        },
      ),
    );
  }
}