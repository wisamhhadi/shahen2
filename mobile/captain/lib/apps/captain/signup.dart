import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shahenco_captain/apps/captain/login.dart';
import '../../core/constants/links.dart';
import '../../core/services/network.dart';
import '../../shared/widgets/app_bar.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/main_btn.dart';
import 'home_page.dart';



class Signup extends StatelessWidget {
  Signup({super.key});
  var net = Network(auth: false);
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();

  void _login(){
    Get.offAll(()=>Login());
  }

  void _signUp()async{
    try{
      var req = await net.createRet(Links.captain, {
        'phone':phone.text.toString(),
        'password':password.text.toString(),
        'name':name.text.toString(),
      });

      if(req.statusCode == 201){
        var statusCode = await net.login(Links.login, {
          'phone':phone.text.toString(),
          'password':password.text.toString(),
        });

        if(statusCode == 200){
          Get.offAll(()=>CaptainHome());
        }else{
          Get.snackbar("خطآ", "خطآ في رقم الهاتف او الرمز السري");
        }
      }else{
        Get.snackbar("خطآ", "قد يكون رقم الهاتف موجود مسبقا");
      }
    }catch (e){
      Get.snackbar("error", "$e");
    }
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


              CustomTextBox(
                controller: name,
                title: "الاسم الكامل",
                subtitle: "يرجى ادخال اسمك الكامل",
                icon: Icons.abc,
              ),

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
              mainButton(_signUp, "تسجيل"),
              SizedBox(height: 20),
              mainButton(_login, "تسجيل دخول"),

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