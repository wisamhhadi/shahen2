import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shahenco_captain/apps/captain/home_page.dart';
import 'package:shahenco_captain/apps/captain/login.dart';
import 'package:shahenco_captain/core/services/network.dart';

import '../../apps/captain/account.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(GetStorage().read('image').runtimeType);
    return Drawer(
      backgroundColor: Colors.grey[50],
      child: Column(
        children: [
          // Header with profile
          Container(
            padding: EdgeInsets.only(top: 60, bottom: 30),
            child: Column(
              children: [
                // Profile Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: GetStorage().read('image') != null && GetStorage().read('image') != "null" ? NetworkImage('${GetStorage().read('image')}') : AssetImage("assets/small-logo.png"),
                      fit: BoxFit.contain,
                    ),
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green,
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),

                // Welcome Text with Hand Wave
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text(
                      'مرحباً ${GetStorage().read('name')}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(width: 8),


                    Text(
                      '👋',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                InkWell(
                  onTap:(){
                    Get.offAll(()=>CaptainHome());
                  },
                  child: _buildMenuItem(
                    icon: Icons.home,
                    title: 'الصفحة الرئيسية',
                    isSelected: true,
                  ),
                ),
                InkWell(
                  onTap: (){
                    Get.to(()=>AccountPage());
                  },
                  child: _buildMenuItem(
                    icon: Icons.person,
                    title: 'حسابي',
                  ),
                ),
                _buildMenuItem(
                  icon: Icons.folder,
                  title: 'المحفظة',
                ),
                _buildMenuItem(
                  icon: Icons.shopping_bag,
                  title: 'الطلبات',
                ),
                _buildMenuItem(
                  icon: Icons.local_offer_outlined,
                  title: 'عروض',
                ),
                _buildMenuItem(
                  icon: Icons.fire_truck_rounded,
                  title: 'رحلاتي',
                ),
                _buildMenuItem(
                  icon: Icons.archive_outlined,
                  title: 'الارشيف',
                ),
                _buildMenuItem(
                  icon: Icons.qr_code,
                  title: 'مسح QR',
                ),
                _buildMenuItem(
                  icon: Icons.support_agent_rounded,
                  title: 'الدعم الفني',
                ),

                _buildMenuItem(
                  icon: Icons.info_outline,
                  title: 'حول التطبيق',
                ),

                InkWell(
                  onTap: (){
                    var net = Network(auth: false);
                    net.logout();
                    Get.offAll(()=>Login());
                  },
                  child: _buildMenuItem(
                    icon: Icons.exit_to_app,
                    title: 'تسجيل الخروج',
                    isLogout: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    bool isSelected = false,
    bool isLogout = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isLogout
                        ? Colors.red[500]
                        : isSelected
                        ? Colors.green[600]
                        : Colors.green[500],
                    boxShadow: [
                      BoxShadow(
                        color: (isLogout ? Colors.red[500]! : Colors.green[500]!).withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 18,
                  ),
                ),

                SizedBox(width: 15),


                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isLogout ? Colors.red[600] : Colors.grey[700],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableMenuItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Expand/Collapse Arrow
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey[600],
                  size: 20,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green[500],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green[500]!.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}