import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shahenco_captain/apps/captain/home_page.dart';
import 'package:shahenco_captain/apps/captain/signup.dart';
import 'package:shahenco_captain/core/constants/links.dart';
import '../../../core/services/network.dart';
import '../../../shared/widgets/inputs.dart';



class BasicInfoPage extends StatelessWidget {
  BasicInfoPage({super.key});
  var net = Network(auth: false);
  TextEditingController phone = TextEditingController();
  TextEditingController name = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('المعلومات الاساسية'),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Center(
                child:Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor:Get.theme.primaryColor.withOpacity(0.3),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Get.theme.primaryColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("الصورة الشخصية"),
                  ],
                ),
              ),
              SizedBox(height: 30),


              CustomTextBox(
                controller: name,
                title: "الاسم الكامل",
                icon: Icons.abc,

              ),
              SizedBox(height: 20),


              CustomTextBox(
                controller: phone,
                title: "رقم الهاتف",
                icon: Icons.numbers,
              ),

              SizedBox(height: 20),

              CustomComboBox(
                title: 'الدولة',
                items: [],
                icon: Icons.circle,

              ),

              SizedBox(height: 20),

              CustomComboBox(
                title: 'المحافظة',
                items: [],
                icon: Icons.location_city,

              ),

              SizedBox(height: 20),

              CustomComboBox(
                title: 'لغة التطبيق',
                items: [],
                icon: Icons.language,

              ),


              SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                    onPressed: (){},
                    child: Text("حفظ")
                ),
              ),






              SizedBox(height: 100),

            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){},
          backgroundColor: Colors.green,
          shape: CircleBorder(),
          child: Icon(Icons.headphones,color: Colors.white,size: 30,),
        ),
      ),
    );
  }
}