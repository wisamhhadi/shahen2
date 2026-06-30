import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:almandobUAE/Widgets/loading.dart';
import 'package:flutter/material.dart';

Widget buildDropdownFuture<T>(Future<List<T>> future, int? selectedValue, Function(int?) onChanged) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    padding: EdgeInsets.all(2),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [
        CustomColors.secendory,
        CustomColors.primary
      ]),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: FutureBuilder<List<T>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: ProfessionalLoadingWidget());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text("لا توجد بيانات", style: TextStyle(color: Colors.red)));
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: DropdownButtonFormField<int>(
                value: selectedValue,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.language_outlined, color: Colors.black),
                  border: InputBorder.none,
                ),
                hint: bodytext(text: "اختر"),
                icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                style: TextStyle(fontFamily: "font", color: Colors.black),
                items: snapshot.data!.map((item) {
                  dynamic id = (item as dynamic).id;
                  dynamic name = (item as dynamic).name;
                  return DropdownMenuItem<int>(
                    value: id,
                    child: Text(name.toString()),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            );
          }
        },
      ),
    ),
  );
}
