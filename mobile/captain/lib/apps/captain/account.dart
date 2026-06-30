import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shahenco_captain/camera.dart';

import 'captain_registeration/basic_information.dart';
import 'captain_registeration/car_information.dart';
import 'done_page.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text('حسابي'),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Header
              InkWell(
                onTap: (){
                  Get.to(()=>BasicInfoPage());
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor:Get.theme.primaryColor.withOpacity(0.3),
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Get.theme.primaryColor,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${GetStorage().read('name')}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '964${GetStorage().read('phone')}+',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.edit,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Account Information Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Account Information

                    _buildDivider(),

                    // ID Information
                    InkWell(
                      onTap: (){
                        Get.to(()=>CameraPage(docType: "idFront",));
                      },

                      child: _buildListTile(
                        icon: Icons.badge,
                        iconColor: Colors.green,
                        title: 'معلومات الهوية',
                        subtitle: 'بيانات الهوية الوطنية والجواز',
                        onTap: () {
                          Get.to(()=>DonePage(
                            title: "معلومات الهوية",
                            message: "تم الانتهاء من هذه الخطوة",
                          ));
                        },
                        isDone: true
                      ),
                    ),

                    _buildDivider(),

                    // Resident Information
                    _buildListTile(
                      icon: Icons.home,
                      iconColor: Colors.orange,
                      title: 'بطاقة السكن',
                      subtitle: 'صور بطاقة السكن',
                      onTap: () {
                      },
                    ),

                    _buildDivider(),

                    // Driving License Information
                    _buildListTile(
                      icon: Icons.credit_card,
                      iconColor: Colors.purple,
                      title: 'معلومات رخصة القيادة',
                      subtitle: 'بيانات رخصة القيادة وتاريخ الانتهاء',
                      onTap: () {
                      },
                    ),

                    _buildDivider(),

                    InkWell(
                      onTap: (){
                        print("asd");
                        Get.to(()=>CarInformationPage());
                      },
                      child: _buildListTile(
                        icon: Icons.directions_car,
                        iconColor: Colors.red,
                        title: 'معلومات المركبة',
                        subtitle: 'بيانات المركبة ورقم اللوحة',
                        onTap: () {
                        },
                        // isLast: true,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),



            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isLast = false,
    bool isDone = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 24,
        ),
      ),
      title: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(width: 10,),
          if(isDone == false)
            Icon(Icons.error,color: Colors.red,)
        ],
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey[400],
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.only(left: 80),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey[200],
      ),
    );
  }


  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تسجيل الخروج'),
          content: Text('هل أنت متأكد من أنك تريد تسجيل الخروج؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add logout logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم تسجيل الخروج بنجاح')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('تسجيل الخروج'),
            ),
          ],
        );
      },
    );
  }
}
