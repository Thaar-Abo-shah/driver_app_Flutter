import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../value/colors.dart';
import 'app_style_text.dart';
import 'custom_image.dart';

class CardTemplateBlack extends StatelessWidget {
  final String title;
  final Color colorFont;
  final TextEditingController controller;
  final IconData? suffix;
  final String? prefix;

  const CardTemplateBlack(
      {Key? key,
      required this.title,
      required this.controller,
      this.suffix,
      this.colorFont =AppColors.white,
      this.prefix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 53.h,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        elevation: 0,
        // elevation: 5.r,
        child: TextField(

          controller: controller,
          cursorColor: AppColors.appColor,
          decoration: InputDecoration(
            enabled: false,
            suffixIcon: Icon(
              suffix,
              color: AppColors.white,
              size: 16.r,
            ),
            prefixIconConstraints: BoxConstraints.tight(Size(25.w, 16.h)),
            prefixIcon: CustomSvgImage(
              imageName: prefix,
              color: AppColors.white,
            ),

            enabledBorder: InputBorder.none,
            focusedBorder:InputBorder.none,
            labelStyle: const TextStyle(color: Colors.white),
            fillColor: Colors.white,
            label: AppTextStyle(
              name: title,
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: colorFont,
            ),
          ),
        ),
        // shape: RoundedRectangleBorder(
        //     // side: BorderSide(
        //     //   color: AppColors.grey,
        //     //
        //     // ),
        //     borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }
}
