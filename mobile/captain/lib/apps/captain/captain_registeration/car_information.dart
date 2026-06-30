import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shahenco_captain/apps/captain/home_page.dart';
import 'package:shahenco_captain/apps/captain/signup.dart';
import 'package:shahenco_captain/core/constants/links.dart';
import '../../../core/services/network.dart';
import '../../../shared/widgets/inputs.dart';



class CarInformationPage extends StatelessWidget {
  CarInformationPage({super.key});
  var net = Network(auth: false);
  TextEditingController phone = TextEditingController();
  TextEditingController name = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('معلومات المركبة'),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


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

              CustomTextBox(
                controller: name,
                title: "رقم المركبة",
                icon: Icons.abc,

              ),
              SizedBox(height: 20),


              CustomComboBox(
                title: 'حرف المركبة',
                items: [],
                icon: Icons.location_city,
              ),

              SizedBox(height: 20),

              CustomComboBox(
                title: 'فئة المركبة',
                items: [],
                icon: Icons.location_city,
              ),


              SizedBox(height: 20),

              CustomComboBox(
                title: 'نوع المقطورة',
                items: [],
                icon: Icons.language,
              ),

              SizedBox(height: 20),

              CustomComboBox(
                title: 'شركة المركبة',
                items: [],
                icon: Icons.language,
              ),


              SizedBox(height: 20),

              CustomComboBox(
                title: 'موديل المركبة',
                items: [],
                icon: Icons.language,
              ),


              SizedBox(height: 20),

              CustomComboBox(
                title: 'لون المركبة',
                items: [],
                icon: Icons.language,
              ),


              SizedBox(height: 20),

              CustomComboBox(
                title: 'هل انت مالك المركبة ؟',
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