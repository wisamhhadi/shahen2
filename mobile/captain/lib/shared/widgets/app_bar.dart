import 'package:flutter/material.dart';

AppBar mainAppBar(Widget? leadingWidget,BuildContext context){
  return AppBar(
    toolbarHeight: 80,
    elevation: 0,
    backgroundColor: Colors.transparent,
    flexibleSpace: CustomPaint(
      painter: CurvedBackgroundPainter(),
      size: Size(double.infinity, 80),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset("assets/small-logo.png",height: 50,width: 100,fit: BoxFit.contain,),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03,)
            ],
          ),
        ),
      ),
    ),
    leading: leadingWidget,
  );
}


AppBar customAppBar(Widget? leadingWidget,BuildContext context){
  return AppBar(
    toolbarHeight: 200,
    elevation: 0,
    backgroundColor: Colors.transparent,
    flexibleSpace: CustomPaint(
      painter: CurvedBackgroundPainterLarge(),
      size: Size(double.infinity, 200),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset("assets/large-logo.png",height: 200,width: 200,fit: BoxFit.contain,),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03,)
            ],
          ),
        ),
      ),
    ),
    leading: leadingWidget,
  );
}

class CurvedBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = Colors.green;
    final paint2 = Paint()..color = Color(0xFFFDC322);

    Path path2 = Path();
    path2.moveTo(size.width / 2, 0);
    path2.quadraticBezierTo(size.width * 0.5, size.height, size.width, size.height);
    path2.lineTo(size.width, 0);
    canvas.drawPath(path2, paint2);

    Path path1 = Path();
    path1.moveTo(0, 0);
    path1.lineTo(0, 50);
    path1.quadraticBezierTo(size.width / 2, size.height * 1.6,size.width, 50);
    path1.lineTo(size.width,0);
    path1.close();
    canvas.drawPath(path1, paint1);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CurvedBackgroundPainterLarge extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = Colors.green;
    final paint2 = Paint()..color = Color(0xFFFDC322);

    Path path2 = Path();
    path2.moveTo(size.width / 2, 0);
    path2.quadraticBezierTo(size.width * 0.5, size.height, size.width, size.height);
    path2.lineTo(size.width, 0);
    canvas.drawPath(path2, paint2);

    Path path1 = Path();
    path1.moveTo(0, 0);
    path1.lineTo(0, 120);
    path1.quadraticBezierTo(size.width / 2, size.height * 1.3 ,size.width, 120);
    path1.lineTo(size.width,0);
    path1.close();
    canvas.drawPath(path1, paint1);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}