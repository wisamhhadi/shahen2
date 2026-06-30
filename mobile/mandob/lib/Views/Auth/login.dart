import 'package:almandobUAE/Models/Mandob.dart';
import 'package:almandobUAE/Services/links.dart';
import 'package:almandobUAE/Services/network.dart';
import 'package:almandobUAE/Views/Auth/otp.dart';
import 'package:almandobUAE/Views/Auth/signup.dart';
import 'package:almandobUAE/Views/Settings/support.dart';
import 'package:almandobUAE/Views/home.dart';
import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/dialgoCustom.dart';
import 'package:almandobUAE/Widgets/frame.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:almandobUAE/Widgets/loading.dart';
import 'package:almandobUAE/Widgets/textbox.dart';
import 'package:almandobUAE/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool ishidden = false;
  bool isLoading = false;

  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var net = Network(auth: false);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: ListView(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: Get.height * 0.08,
          ),
          CircleAvatar(
            maxRadius: 150,
            backgroundImage: AssetImage("icons/UAElogo.png"),
          ),

          TextBoxCustom(hintText: "رقم الهاتف", controller: phone),

          TextBoxCustom(
            hintText: "كلمة المرور",
            obscureText: !ishidden,
            controller: password,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: bodytext(text: "اظهار كلمة المرور"),
              trailing: Checkbox.adaptive(
                value: ishidden,
                onChanged: (val) {
                  setState(() {
                    ishidden = val ?? false;
                  });
                },
                activeColor: Colors.green,
              ),
            ),
          ),

          /// زر تسجيل الدخول
          InkWell(
            onTap: () async {
              setState(() => isLoading = true);

              try {
                var status = await net.login(Links.mandobLogin, {
                  'phone': phone.text,
                  'password': password.text,
                });

                if (status == 200 || status == 201) {
                  int? id = GetStorage().read('id');
                  Mandob mandob = await net.retrieveUser(
                      Links.createMandob, id!, Mandob()) as Mandob;

                  if (mandob.isLogged == true) {
                    Get.snackbar("الادارة",
                        "لايمكن تسجيل الدخول باكثر من جهاز على نفس الحساب !");
                    net.logout();
                    print(GetStorage().read('id'));
                  } else {
                    var res = await net.patchHttp(
                        Links.patchMandob(GetStorage().read('id')),
                        {'is_logged': "true"});
                    showCustomAwesomeDialog(
                        context: context,
                        title: "ادارة التطبيق",
                        message: "تم تسجيل الدخول بنجاح",
                        iconHeader: Icons.check_outlined,
                        iconColor: Colors.green);
                    await Future.delayed(Duration(seconds: 4));
                    Get.offAll(CheckPage(), transition: Transition.upToDown);
                  }
                } else if (status == 403) {
                  showCustomAwesomeDialog(
                      context: context,
                      title: "ادارة التطبيق",
                      message:
                          "المستخدم غير مفعل حسابه او حالة المستخدم غير مقبولة !",
                      iconHeader: Icons.close_outlined,
                      iconColor: Colors.red);
                } else {
                  showCustomAwesomeDialog(
                      context: context,
                      title: "ادارة التطبيق",
                      message: "حدث خطأ أثناء عملية تسجيل الدخول",
                      iconHeader: Icons.close_outlined,
                      iconColor: Colors.red);
                }
              } catch (e) {
                Get.snackbar("هنالك خطا بالاتصال", "$e");
              } finally {
                setState(() {
                  isLoading = false;
                });
                dispose() {
                  isLoading;
                }
              }
            },
            child: isLoading
                ? Center(child: ProfessionalLoadingWidget())
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: CustomColors.primary),
                    height: Get.height * 0.06,
                    child: Center(
                      child: bodytext(
                        fontWeight: FontWeight.w400,
                        text: "تسجيل الدخول",
                        textColor: Colors.white,
                      ),
                    ),
                  ),
          ),

          InkWell(
            onTap: () {
              Get.to(SignUp(), transition: Transition.rightToLeft);
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CustomColors.primary),
              height: Get.height * 0.06,
              child: Center(
                child: bodytext(
                  fontWeight: FontWeight.w400,
                  text: "إنشاء حساب",
                  textColor: Colors.white,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20, left: 10),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: InkWell(
                onTap: () {
                  Get.to(Support());
                },
                child: CircleAvatar(
                  backgroundColor: CustomColors.primary,
                  child: Icon(Icons.headphones_outlined, color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
