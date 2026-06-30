import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as latLng;
import '../../shared/widgets/drawer.dart';

class CaptainHome extends StatefulWidget {
  CaptainHome({super.key});

  @override
  State<CaptainHome> createState() => _CaptainHomeState();
}

class _CaptainHomeState extends State<CaptainHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final flutterMap.MapController _mapController = flutterMap.MapController();

  latLng.LatLng _currentLocation = latLng.LatLng(24.7136, 46.6753);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(),
        body: Stack(
          children: [

            flutterMap.FlutterMap(
              mapController: _mapController,
              options: flutterMap.MapOptions(
                initialCenter: _currentLocation,
                initialZoom: 13.0,
                minZoom: 3.0,
                maxZoom: 18.0,
                onTap: (tapPosition, point) {
                  setState(() {
                    _currentLocation = point;
                  });
                },
              ),
              children: [
                // OpenStreetMap tile layer
                flutterMap.TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.captain.smartapp',
                  maxZoom: 19,
                ),

                // Marker layer
                flutterMap.MarkerLayer(
                  markers: [
                    flutterMap.Marker(
                      point: _currentLocation,
                      child: Container(
                        child: Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),

                // Circle layer (optional)
                flutterMap.CircleLayer(
                  circles: [
                    flutterMap.CircleMarker(
                      point: _currentLocation,
                      radius: 100, // radius in meters
                      color: Colors.blue.withOpacity(0.3),
                      borderColor: Colors.blue,
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
              ],
            ),


            Positioned(
              width: Get.width,
              height: 250,
              top: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Get.width,
                    height: 250,
                    child: CustomPaint(
                      painter: MainContainerBackground(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: Get.height * 0.07),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap:(){
                                    _scaffoldKey.currentState?.openDrawer();
                                  },
                                  child: Icon(
                                    Icons.menu,
                                    color: Color(0xFFFAF6E9),
                                    size: 35,
                                    shadows: [
                                      BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.15),
                                        blurRadius: 2.6,
                                        spreadRadius: 0,
                                        offset: Offset(
                                          1.95,
                                          1.95,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: Get.width * 0.6,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Color(0xffA4D08C),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(50, 50, 93, 0.25),
                                          blurRadius: 27,
                                          spreadRadius: -5,
                                          offset: Offset(
                                            0,
                                            13,
                                          ),
                                        ),
                                        BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.3),
                                          blurRadius: 16,
                                          spreadRadius: -8,
                                          offset: Offset(
                                            0,
                                            8,
                                          ),
                                        ),
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(40),
                                          ),
                                        ),
                                        Text(
                                          "زين العابدين",
                                          style: Get.theme.textTheme.bodyLarge!
                                              .copyWith(
                                              color: Colors.white,
                                              fontSize: 22),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.notifications,
                                  color: Color(0xFFFAF6E9),
                                  size: 35,
                                  shadows: [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.15),
                                      blurRadius: 2.6,
                                      spreadRadius: 0,
                                      offset: Offset(
                                        1.95,
                                        1.95,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 15,),
                          Container(
                            // height: 100,
                            width: Get.width * 0.9,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Color(0xffA4D08C),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(50, 50, 93, 0.25),
                                    blurRadius: 27,
                                    spreadRadius: -5,
                                    offset: Offset(
                                      0,
                                      13,
                                    ),
                                  ),
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.3),
                                    blurRadius: 16,
                                    spreadRadius: -8,
                                    offset: Offset(
                                      0,
                                      8,
                                    ),
                                  ),
                                ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildInfo(Icons.wallet,"250,000"),
                                _buildInfo(Icons.local_shipping,"3"),
                                _buildInfo(Icons.local_offer,"5"),
                                _buildInfo(Icons.circle,"متصل",color: Colors.green),


                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ),
    );
  }

  Widget _buildInfo(IconData icon,String title,{Color? color}){
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Icon(icon,color:color ?? Colors.white,size: 28,),
          Text(title,style: TextStyle(color: Colors.white ,fontSize: 18,fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}

class MainContainerBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = Colors.green;

    Path path1 = Path();
    path1.moveTo(0, 0);
    path1.lineTo(0, size.height);
    path1.lineTo(size.width, size.height);
    path1.lineTo(size.width, 0);
    path1.close();
    canvas.drawPath(path1, paint1);

    Paint paint2 = Paint()
      ..color = const Color(0xFFFDC322)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path2 = Path();
    path2.moveTo(size.width * 0.5, 0);
    path2.quadraticBezierTo(size.width * 0.6, size.height * 0.18,
        size.width * 0.81, size.height * 0.25);
    path2.quadraticBezierTo(size.width * 0.9377167, size.height * 0.2727857,
        size.width * 0.9988083, size.height * 0.5364714);
    path2.lineTo(size.width * 1.0004250, size.height * 0.5364429);
    path2.lineTo(size.width * 0.9983333, size.height * 0.0014286);

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
