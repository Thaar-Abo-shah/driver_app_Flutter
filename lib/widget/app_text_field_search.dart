import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../value/colors.dart';


class AppTextFieldSearch extends StatelessWidget {
  final TextInputType keyboardType;
  final String hint;
  final int? maxLength;
  final TextEditingController controller;
  final bool obscureText;

  const AppTextFieldSearch({
    Key? key,
    this.keyboardType = TextInputType.text,
    required this.hint,
    this.maxLength,
    this.obscureText = false,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      obscureText: obscureText,
      keyboardType: keyboardType,
      cursorColor: AppColors.appColor,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon
            : InkWell(onTap: (){
          // Get.to(SearchResult());
        },
              child: Icon(
          Icons.search,
          color: AppColors.appColor,
        ),
            ),
        labelStyle: GoogleFonts.cairo(
          color: AppColors.black,
          // letterSpacing: letterSpacing,
          // wordSpacing: wordSpacing,
          fontWeight: FontWeight.w400,
          fontSize: 10.sp,
          // decoration: TextDeo,
          // height: height
        ),
        counterText: '',
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintStyle: GoogleFonts.cairo(
          color: AppColors.black,
          // letterSpacing: letterSpacing,
          // wordSpacing: wordSpacing,
          fontWeight: FontWeight.w400,
          fontSize: 10.sp,
          height: 0.5
          // decoration: TextDeo,
          // height: height
        ),
      ),
    );
  }

// OutlineInputBorder get border => OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10),
//       borderSide: BorderSide(
//         width: 1,
//         color: Colors.grey.shade400,
//       ),
//     );
}
