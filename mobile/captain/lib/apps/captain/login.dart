import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shahenco_captain/apps/captain/home_page.dart';
import 'package:shahenco_captain/apps/captain/signup.dart';
import 'package:shahenco_captain/core/constants/links.dart';
import '../../core/services/network.dart';
import '../../shared/widgets/app_bar.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/main_btn.dart';



class Login extends StatelessWidget {
  Login({super.key});
  var net = Network(auth: false);
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();

  void _login()async{
    try{
      var statusCode = await net.login(Links.login, {
        'phone':phone.text.toString(),
        'password':password.text.toString(),
      });

      if(statusCode == 200){
        Get.offAll(()=>CaptainHome());
      }else{
        Get.snackbar("خطآ", "خطآ في رقم الهاتف او الرمز السري");
      }
    }catch (e){
      Get.snackbar("خطآ", "يرجى ملآ جميع الحقول");
    }
  }

  void _signUp(){
    Get.offAll(()=>Signup());
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: customAppBar(null, context),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 30),

              SizedBox(height: 20),

              CustomTextBox(
                controller: phone,
                title: "رقم الهاتف",
                subtitle: "يرجى ادخال رقم الهاتف مثل ********78",
                icon: Icons.numbers,

              ),


              SizedBox(height: 20),
              PasswordTextBox(
                controller: password,
                title: "الرمز السري",
              ),



              SizedBox(height: 30),

              // Next Button
              mainButton(_login, "تسجيل دخول"),
              SizedBox(height: 20),
              mainButton(_signUp, "انشاء حساب جديد"),

              SizedBox(height: 20),
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