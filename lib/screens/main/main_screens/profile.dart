import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_app/screens/welcom/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../../value/colors.dart';
import '../../../widget/app_button.dart';
import '../../../widget/app_style_text.dart';
import '../../../widget/card_template.dart';
import '../../../widget/component.dart';
import '../../../widget/custom_image.dart';
import '../../../widget/row_edit.dart';
import '../../Auth/sing_in.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TapGestureRecognizer _recognizer = TapGestureRecognizer()
    ..onTap = () => onTapRecognizer();

  void onTapRecognizer() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignIn()));
  }

  @override
  void initState() {
    // TODO: implement initState
    user = _auth.currentUser;
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: AppColors.appColor));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: AppColors.appColor));
    super.dispose();
  }

  FirebaseStorage storage = FirebaseStorage.instance;

  File? _photo;
  String? name;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        name = pickedFile.name;
        uploadFile(name);
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        name = pickedFile.name;
        uploadFile(name);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile(String? name) async {
    if (_photo == null) return;
    final fileName = name;
    final destination = 'DriverApp_Images';

    try {
      final ref =
          FirebaseStorage.instance.ref(destination).child(name.toString());
      await ref.putFile(_photo!);
      ref.getDownloadURL().then((value) => {
            FirebaseFirestore.instance
                .collection("drivers")
                .doc(_auth.currentUser!.uid)
                .update({'Img': value})
                .then((value) => {})
                .onError((error, stackTrace) => {}),
          });
    } catch (e) {
      print('error occured');
    }
    setState(() {});
  }

  final _auth = FirebaseAuth.instance;
  User? user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackGrey.withOpacity(.70),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.appColor,
        leadingWidth: 100.w,
        leading: TextButton.icon(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
              size: 25.r,
            ),
            label: AppTextStyle(
              name: 'رجوع',
              fontSize: 10.sp,
            )),
        actions: [],
      ),
      body: ListView(
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('drivers')
                .doc(_auth.currentUser!.uid)
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 40.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10.r),
                                  bottomRight: Radius.circular(10.r)),
                              color: AppColors.appColor),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 70.h,
                            width: 70.w,
                            padding: EdgeInsets.all(3.r),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                shape: BoxShape.circle,
                                color: Colors.white),
                            child: SizedBox(
                              height: 28.h,
                              width: 28.w,
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration:
                                    BoxDecoration(shape: BoxShape.circle),
                                child: GestureDetector(
                                  onTap: () {
                                    _showPicker(context);
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: '${data['Img']}',
                                    // buildContext: context,
                                    height: 72.h,
                                    width: 72.w,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        shimmerCarDes(context),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        // shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),

                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppTextStyle(
                                name: "${data['Name']}",
                                fontSize: 11.sp,
                                color: AppColors.white,
                                isMarai: false,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialog(
                                            context, 'تعديل الاسم', 'Name'),
                                  );
                                },
                                child: CustomSvgImage(
                                  imageName: 'edit',
                                  height: 15.h,
                                  width: 15.h,
                                  color: AppColors.white,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 28.h,
                          ),
                          Divider(
                            height: 15.h,
                            color: AppColors.greyC,
                          ),
                          RowEdit(
                            title: 'رقم الهاتف',
                            hint: data['Phone'],
                            onPress: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialog(
                                        context, 'تعديل رقم الهاتف', 'Phone'),
                              );
                            },
                          ),
                          Divider(
                            height: 5.h,
                            color: AppColors.greyC,
                          ),
                          RowEdit(
                            title: 'العنوان',
                            hint:
                                '${data['StreetNumber']} - ${data['CityName']}',
                            onPress: () {},
                            visible: false,
                          ),
                          Divider(
                            height: 5.h,
                            color: AppColors.greyC,
                          ),
                          RowEdit(
                            title: 'عدد الطلبات',
                            hint: '17 طلب',
                            visible: false,
                            onPress: () {},
                          ),
                          Divider(
                            height: 5.h,
                            color: AppColors.greyC,
                          ),
                          RowEdit(
                            title: 'رقم الهوية',
                            hint: data['NID'],
                            visible: true,
                            onPress: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialog(
                                        context, 'تعديل رقم الهوية', 'NID'),
                              );
                            },
                          ),
                          Divider(
                            height: 5.h,
                            color: AppColors.greyC,
                          ),
                          RowEdit(
                            title: 'نوع المركبة',
                            hint: data['CarType'],
                            onPress: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialog(context,
                                        'تعديل نوع المركبة', 'CarType'),
                              );
                            },
                          ),
                          Divider(
                            height: 5.h,
                            color: AppColors.greyC,
                          ),
                          RowEdit(
                            title: 'رقم المركبة',
                            hint: data['CarNumber'],
                            onPress: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialog(context,
                                        'تعديل رقم المركبة', 'CarNumber'),
                              );
                            },
                          ),
                          Divider(
                            height: 5.h,
                            color: AppColors.greyC,
                          ),
                          RowEdit(
                            title: 'موديل المركبة',
                            hint: data['CarModel'],
                            onPress: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialog(context,
                                        'تعديل موديل السيارة', 'CarModel'),
                              );
                            },
                          ),
                          Divider(
                            height: 5.h,
                            color: AppColors.greyC,
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 130.w,
                                child: AppButton(
                                  title: 'تسجيل خروج',
                                  onPressed: () {
                                    _auth
                                        .signOut()
                                        .then((value) => {
                                              print('Logout User'),
                                              Get.to(SplashScreen(),
                                                  transition: Transition.fade,
                                                  duration: Duration(
                                                      milliseconds: 1000))
                                            })
                                        .onError((error, stackTrace) =>
                                            {print('Something is wrong')});
                                  },
                                  fontSize: 10.sp,
                                  color: AppColors.appColor,
                                  height: 26.h,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return Align(
                alignment: Alignment.center,
                child: SpinKitThreeBounce(
                  color: Colors.white,
                  size: 50.0,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildPopupDialog(BuildContext context, String title, String doc) {
    final _text = TextEditingController();
    final RoundedLoadingButtonController _btnController2 =
        RoundedLoadingButtonController();
    return AlertDialog(
      backgroundColor: AppColors.backgroundBlueColor,
      title: AppTextStyle(
        name: title,
        color: AppColors.black,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: _text,
            cursorColor: AppColors.appColor,
            decoration: InputDecoration(
              prefixIconConstraints: BoxConstraints.tight(Size(40.w, 16.h)),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.orangeLogo),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.orangeLogo),
              ),
              labelStyle: const TextStyle(color: Colors.white),
              fillColor: Colors.white,
              label: AppTextStyle(
                name: title,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.greyC,
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: RoundedLoadingButton(
            color: AppColors.appColor,
            successColor: AppColors.green,
            controller: _btnController2,
            onPressed: () {
              FirebaseFirestore.instance
                  .collection("drivers")
                  .doc(_auth.currentUser!.uid)
                  .update({doc: _text.text})
                  .then((value) => {
                        _btnController2.success(),
                      })
                  .onError((error, stackTrace) => {
                        _btnController2.error(),
                      });

              setState(() {});
            },
            valueColor: Colors.white,
            borderRadius: 10,
            child: AppTextStyle(name: 'حفظ'),
          ),
        )
      ],
    );
  }
}
